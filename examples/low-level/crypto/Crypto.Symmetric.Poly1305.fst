(* Implementation of Poly1305 based on the rfc7539 *)
module Crypto.Symmetric.Poly1305

open FStar.Mul
open FStar.Ghost
open FStar.Seq
(** Machine integers *)
open FStar.UInt8
open FStar.UInt64
open FStar.Int.Cast
(** Effects and memory layout *)
open FStar.HyperStack
open FStar.HST
(** Buffers *)
open FStar.Buffer
(** Mathematical definitions *)
open Math.Axioms
open Math.Lib
open Math.Lemmas
(** Helper functions for buffers *)
open Buffer.Utils
open FStar.Buffer.Quantifiers

open Crypto.Symmetric.Poly1305.Spec 
open Crypto.Symmetric.Poly1305.Parameters
open Crypto.Symmetric.Poly1305.Bigint
open Crypto.Symmetric.Poly1305.Bignum
open Crypto.Symmetric.Poly1305.Lemmas

module U8 = FStar.UInt8
module U32 = FStar.UInt32
module U64 = FStar.UInt64
module HS = FStar.HyperStack

// we may separate field operations, so that we don't 
// need to open the bignum modules elsewhere

//#set-options "--lax"

(* * *********************************************)
(* *            Representation type              *)
(* * *********************************************)

type elemB = bigint        // Mutable big integer representation (5 64-bit limbs)

type wordB = b:bytes{length b <= 16}  // Concrete (mutable) representation of words
type wordB_16 = b:bytes{length b = 16}  // Concrete (mutable) representation of words

(* * *********************************************)
(* *  Mappings from stateful types to pure types *)
(* * *********************************************)

(* From the current memory state, returns the word corresponding to a wordB *)
let sel_word (h:mem) (b:wordB{live h b}) : GTot word = as_seq h b
val esel_word:h:mem -> b:wordB{live h b} -> Tot (erased word)
let esel_word h b = hide (sel_word h b)

val esel_word_16:h:mem -> b:wordB_16{live h b} -> Tot (erased word_16)
let esel_word_16 h b = hide (sel_word h b)


// when ideal, we use the actual contents
assume val read_word: b:wordB_16 -> ST word_16 
  (requires (fun h0 -> live h0 b))
  (ensures (fun h0 r h1 -> modifies Set.empty h0 h1 /\ live h1 b /\ Seq.equal r (sel_word h1 b)))

(* From the current memory state, returns the field element corresponding to a elemB *)
let sel_elem (h:mem) (b:elemB{live h b}) : GTot elem
  = eval h b norm_length % p_1305 

(* From the current memory state, returns the integer corresponding to a elemB, (before
   computing the modulo) *)
let sel_int (h:mem) (b:elemB{live h b}) : GTot nat
  = eval h b norm_length


(*** Poly1305 Field Operations ***)

(* * ******************************************** *)
(* *        Polynomial computation step           *)
(* * ******************************************** *)

(** 
    Runs "Acc = ((Acc+block)*r) % p." on the accumulator, the well formatted block of the message
    and the clamped part of the key 
    *)
val add_and_multiply: acc:elemB -> block:elemB{disjoint acc block} -> r:elemB{disjoint acc r /\ disjoint block r} -> STL unit
  (requires (fun h -> norm h acc /\ norm h block /\ norm h r))
  (ensures (fun h0 _ h1 -> norm h0 acc /\ norm h0 block /\ norm h0 r
    /\ norm h1 acc // the accumulation is back in a workable states
    /\ modifies_1 acc h0 h1 // It was the only thing modified
    /\ sel_elem h1 acc = (sel_elem h0 acc +@ sel_elem h0 block) *@ sel_elem h0 r // Functional
    						// specification of the operation at that step
    ))
let add_and_multiply acc block r =
  let hinit = HST.get() in
  push_frame();
  let h0 = HST.get() in
  let tmp = create 0UL (U32.mul 2ul nlength-|1ul) in
  let h1 = HST.get() in
  assert(modifies_0 h0 h1);
     (* TODO *)
     assume (norm h1 acc /\ norm h1 block);
  fsum' acc block;
  let h2 = HST.get() in
  assert(modifies_2_1 acc h0 h2);
    (* TODO *)
    assume (norm h2 r);
    assume (bound27 h2 acc);
  multiplication tmp acc r;
  let h3 = HST.get() in
  assert(modifies_2_1 acc h0 h3);
    (* TODO *)
    assume (live h3 tmp /\ satisfiesModuloConstraints h3 tmp);
  modulo tmp;
  let h4 = HST.get() in
  assert(modifies_2_1 acc h0 h4);
    (* TODO *)
    assume (live h4 tmp /\ live h4 acc);
  blit tmp 0ul acc 0ul nlength;
  let h5 = HST.get() in
  pop_frame();
  let hfin = HST.get() in
  assert(modifies_1 acc hinit hfin);
    (* TODO *)
    assume (norm hfin acc);
    assume (sel_elem hfin acc = (sel_elem hinit acc +@ sel_elem hinit block) *@ sel_elem hinit r)

//#reset-options "--initial_fuel 0 --max_fuel 0 --z3timeout 20"

(**
   Sets an element to the value '0' 
   *)
val zeroB: a:elemB -> STL unit
  (requires (fun h -> live h a))
  (ensures  (fun h0 _ h1 -> norm h1 a /\ modifies_1 a h0 h1
    /\ sel_elem h1 a = 0 ))
let zeroB a =
  upd a 0ul 0UL;
  upd a 1ul 0UL;
  upd a 2ul 0UL;
  upd a 3ul 0UL;
  upd a 4ul 0UL;
  let h = HST.get() in
  Crypto.Symmetric.Poly1305.Bigint.eval_null h a norm_length


(* * *********************************************)
(* *            Encoding functions               *)
(* * *********************************************)

(* Formats a wordB into an elemB *)
val toField: a:elemB -> b:wordB_16{disjoint a b} -> STL unit
  (requires (fun h -> live h a /\ live h b))
  (ensures  (fun h0 _ h1 ->
    live h0 b /\         // initial post condition
    modifies_1 a h0 h1 /\ // only a was modified
    norm h1 a /\         // a is in a 'workable' state
    sel_int h1 a = little_endian (sel_word h0 b) /\ // functional correctness
    v (get h1 a 4) < pow2 24 // necessary for adding 2^128 with no overflow
    ))

private let mk_mask (nbits:FStar.UInt32.t{FStar.UInt32.v nbits < 64}) :
  Tot (z:U64.t{v z = pow2 (FStar.UInt32.v nbits) - 1})
  = Math.Lib.pow2_increases_lemma 64 (FStar.UInt32.v nbits);
    U64 ((1uL <<^ nbits) -^ 1uL)

let toField b s =
  let h0 = HST.get() in
  let mask_26 = mk_mask 26ul in
  let s0 = sub s 0ul  4ul in
  let s1 = sub s 4ul  4ul in
  let s2 = sub s 8ul  4ul in
  let s3 = sub s 12ul 4ul in
  let n0 = (uint32_of_bytes s0) in
  let n1 = (uint32_of_bytes s1) in
  let n2 = (uint32_of_bytes s2) in
  let n3 = (uint32_of_bytes s3) in
  let n0 = Int.Cast.uint32_to_uint64 n0 in
  let n1 = Int.Cast.uint32_to_uint64 n1 in
  let n2 = Int.Cast.uint32_to_uint64 n2 in
  let n3 = Int.Cast.uint32_to_uint64 n3 in
  (* TODO *)
  assume (v n0 + pow2 32 * v n1 + pow2 64 * v n2 + pow2 96 * v n3 = little_endian (sel_word h0 s));
  let n0' = n0 &^ mask_26 in
  let n1' = (n0 >>^ 26ul) |^ ((n1 <<^ 6ul) &^ mask_26) in
  let n2' = (n1 >>^ 20ul) |^ ((n2 <<^ 12ul) &^ mask_26) in
  let n3' = (n2 >>^ 14ul) |^ ((n3 <<^ 18ul) &^ mask_26) in
  let n4' = (n3 >>^ 8ul) in
  (* TODO *)
  assume (v n0' + pow2 26 * v n1' + pow2 52 * v n2' + pow2 78 * v n3' + pow2 104 * v n4'
    = little_endian (sel_word h0 s));
  upd b 0ul n0';
  upd b 1ul n1';
  upd b 2ul n2';
  upd b 3ul n3';
  upd b 4ul n4';
  let h1 = HST.get() in
  (* TODO *)
  assume (sel_int h1 b = little_endian (sel_word h0 s));
  assume (v (get h1 b 4) < pow2 24);
  assume (norm h1 b)

(* (\* Formats a wordB into an elemB *\) *)
(* val toField: a:elemB -> b:wordB{length b = 16 /\ disjoint a b} -> STL unit *)
(*   (requires (fun h -> live h a /\ live h b)) *)
(*   (ensures  (fun h0 _ h1 -> *)
(*     live h0 b /\ // Initial post condition *)
(*     norm h1 a /\ // the elemB 'a' is in a 'workable' state *)
(*     modifies_1 a h0 h1 /\ // Only a was modified *)
(*     sel_int h1 a = little_endian (sel_word h0 b) /\ // Functional correctness *)
(*     v (get h1 a 4) < pow2 24 // Necesary to be allowed to add 2^128 *)
(*     )) *)
(* let toField b s = *)
(*   admit(); // TODO *)
(*   let h0 = HST.get() in *)
(*   (\* Math.Lib.pow2_increases_lemma 64 26; *\) *)
(*   (\* Math.Lib.pow2_increases_lemma 64 32; *\) *)
(*   (\* Math.Lib.pow2_increases_lemma 26 24; *\) *)
(*   let mask_26 = U64.sub (1UL <<^ 26ul) 1UL in *)
(*   (\* cut (v mask_26 = v 1UL * pow2 26 - v 1UL /\ v 1UL = 1); *\) *)
(*   (\* cut (v mask_26 = pow2 26 - 1); *\) *)
(*   let s0 = sub s 0ul  4ul in *)
(*   let s1 = sub s 4ul  4ul in *)
(*   let s2 = sub s 8ul  4ul in *)
(*   let s3 = sub s 12ul 4ul in *)
(*   let n0 = (uint32_of_bytes s0) in *)
(*   let n1 = (uint32_of_bytes s1) in *)
(*   let n2 = (uint32_of_bytes s2) in *)
(*   let n3 = (uint32_of_bytes s3) in *)
(*   let n0 = Int.Cast.uint32_to_uint64 n0 in *)
(*   let n1 = Int.Cast.uint32_to_uint64 n1 in *)
(*   let n2 = Int.Cast.uint32_to_uint64 n2 in *)
(*   let n3 = Int.Cast.uint32_to_uint64 n3 in *)
(*   (\* ulogand_lemma_4 #63 n0 26 mask_26; *\) *)
(*   (\* ulogand_lemma_4 #63 (n1 <<^ 6) 26 mask_26; *\) *)
(*   (\* ulogand_lemma_4 #63 (n2 <<^ 12) 26 mask_26; *\) *)
(*   (\* ulogand_lemma_4 #63 (n3 <<^ 18) 26 mask_26; *\) *)
(*   (\* aux_lemma n0 n1 26; *\) *)
(*   (\* aux_lemma n1 n2 20; *\) *)
(*   (\* aux_lemma n2 n3 14; *\) *)
(*   (\* aux_lemma_1 n3; *\) *)
(*   let n0' = n0 &^ mask_26 in *)
(*   let n1' = (n0 >>^ 26ul) |^ ((n1 <<^ 6ul) &^ mask_26) in *)
(*   let n2' = (n1 >>^ 20ul) |^ ((n2 <<^ 12ul) &^ mask_26) in *)
(*   let n3' = (n2 >>^ 14ul) |^ ((n3 <<^ 18ul) &^ mask_26) in *)
(*   let n4' = (n3 >>^ 8ul) in *)
(*   upd b 0ul n0'; *)
(*   upd b 1ul n1'; *)
(*   upd b 2ul n2'; *)
(*   upd b 3ul n3'; *)
(*   upd b 4ul n4'; *)
(*   let h1 = HST.get() in *)
(*   () *)
(*   (\* assume (v (get h b 4) < pow2 24); *\) *)
(*   (\* assume (norm h b) *\) *)


//TMP#reset-options "--initial_fuel 6 --max_fuel 6"

let lemma_bitweight_values (u:unit) : Lemma (bitweight templ 0 = 0 /\ bitweight templ 1 = 26
  /\ bitweight templ 2 = 52 /\ bitweight templ 3 = 78 /\ bitweight templ 4 = 104)
  = ()

//TMP#reset-options "--initial_fuel 1 --max_fuel 1"

val lemma_toField_plus_2_128_0: ha:mem -> a:elemB{live ha a} -> Lemma
  (requires (True))
  (ensures  (sel_int ha a =
    v (get ha a 0) + pow2 26 * v (get ha a 1) + pow2 52 * v (get ha a 2) + pow2 78 * v (get ha a 3)
    + pow2 104 * v (get ha a 4)))
let lemma_toField_plus_2_128_0 ha a =
  lemma_bitweight_values ();
  assert(sel_int ha a = pow2 104 * v (get ha a 4) + eval ha a 4);
  assert(eval ha a 4 = pow2 78 * v (get ha a 3) + eval ha a 3);
  assert(eval ha a 3 = pow2 52 * v (get ha a 2) + eval ha a 2);
  assert(eval ha a 2 = pow2 26 * v (get ha a 1) + eval ha a 1);
  assert(eval ha a 1 = pow2 0 * v (get ha a 0) + eval ha a 0);
  assert(pow2 0 * v (get ha a 0) = v (get ha a 0) /\ eval ha a 0 = 0)

val lemma_toField_plus_2_128_1: unit -> Lemma
  (ensures  (v (1uL <<^ 24ul) = pow2 24))
let lemma_toField_plus_2_128_1 () =
  Math.Lib.pow2_increases_lemma 64 24

//TMP#reset-options "--initial_fuel 0 --max_fuel 0 --z3timeout 20"

val lemma_toField_plus_2_128: ha:mem -> a:elemB -> hb:mem -> b:elemB -> Lemma
  (requires (norm ha a /\ norm hb b /\ v (get hb b 4) < pow2 24
    /\ v (get ha a 4) = v (get hb b 4) + pow2 24
    /\ v (get ha a 3) = v (get hb b 3) /\ v (get ha a 2) = v (get hb b 2)
    /\ v (get ha a 1) = v (get hb b 1) /\ v (get ha a 0) = v (get hb b 0)
    ))
  (ensures  (norm ha a /\ norm hb b /\ sel_int ha a = pow2 128 + sel_int hb b))
let lemma_toField_plus_2_128 ha a hb b =
  Math.Lib.pow2_increases_lemma 26 25;
  Math.Lib.pow2_increases_lemma 25 24;
  lemma_toField_plus_2_128_0 ha a;
  lemma_toField_plus_2_128_0 hb b;
  Math.Lemmas.distributivity_add_right (pow2 104) (v (get hb b 4)) (pow2 24);
  Math.Lib.pow2_exp_lemma 104 24;
  ()

let add_2_24 (x:t{v x < pow2 24}) : Tot (z:t{v z = v x + pow2 24 /\ v z < pow2 26})
  = lemma_toField_plus_2_128_1 ();
    Math.Lemmas.pow2_double_sum 24;
    Math.Lemmas.pow2_double_sum 25;
    Math.Lib.pow2_increases_lemma 64 24;
    Math.Lib.pow2_increases_lemma 64 25;
    x +^ (1uL <<^ 24ul)

//TMP#reset-options "--z3timeout 50"

(* Formats a wordB into an elemB *)
val toField_plus_2_128: a:elemB -> b:wordB{length b = 16 /\ disjoint a b} -> STL unit
  (requires (fun h -> live h a /\ live h b /\ disjoint a b))
  (ensures  (fun h0 _ h1 ->
    live h0 b /\ // Initial post condition
    norm h1 a /\ // the elemB 'a' is in a 'workable' state
    modifies_1 a h0 h1 /\ // Only a was modified
    sel_int h1 a = pow2 128 + little_endian (sel_word h0 b) // Expressed arithmetically
    ))
let toField_plus_2_128 b s =
  toField b s;
  let h0 = HST.get() in
  let b4 = b.(4ul) in
  let b4' = add_2_24 b4 in
  b.(4ul) <- b4';
  let h1 = HST.get() in
  lemma_upd_quantifiers h0 h1 b 4ul b4';
  lemma_toField_plus_2_128 h1 b h0 b

//TMP#reset-options

val trunc1305: a:elemB -> b:wordB{disjoint a b} -> STL unit
  (requires (fun h -> norm h a /\ live h b /\ disjoint a b))
  (ensures  (fun h0 _ h1 -> live h1 b /\ norm h0 a /\ modifies_1 b h0 h1
    /\ sel_elem h0 a % pow2 128 = little_endian (sel_word h1 b) ))
let trunc1305 b s =
  let h0 = HST.get() in
  (* Full reduction of b:
     - before finalization sel_int h b < pow2 130
     - after finalization sel_int h b = sel_elem h b *)
  finalize b;
  let h1 = HST.get() in
  (* TODO *)
  assume (sel_elem h1 b = sel_elem h0 b /\ sel_elem h1 b = sel_int h1 b);
  (* Copy of the 128 first bits of b into s *)
  let b0 = index b 0ul in
  let b1 = index b 1ul in
  let b2 = index b 2ul in
  let b3 = index b 3ul in
  let b4 = index b 4ul in
  (* JK: some bitvector theory would simplify a lot the rest of the proof *)
  admit(); // TODO
  let s0 = uint64_to_uint8 b0 in
  let s1 = uint64_to_uint8 (b0 >>^ 8ul) in
  let s2 = uint64_to_uint8 (b0 >>^ 16ul) in
  let s3 = uint64_to_uint8 ((b0 >>^ 24ul) +^ (b1 <<^ 2ul)) in
  let s4 = uint64_to_uint8 (b1 >>^ 6ul) in
  let s5 = uint64_to_uint8 (b1 >>^ 14ul) in
  let s6 = uint64_to_uint8 ((b1 >>^ 22ul) +^ (b2 <<^ 4ul)) in
  let s7 = uint64_to_uint8 (b2 >>^ 4ul) in
  let s8 = uint64_to_uint8 (b2 >>^ 12ul) in
  let s9 = uint64_to_uint8 ((b2 >>^ 20ul) +^ (b3 <<^ 6ul)) in
  let s10 = uint64_to_uint8 (b3 >>^ 2ul) in
  let s11 = uint64_to_uint8 (b3 >>^ 10ul) in
  let s12 = uint64_to_uint8 (b3 >>^ 18ul) in
  let s13 = uint64_to_uint8 (b4) in
  let s14 = uint64_to_uint8 (b4 >>^ 8ul) in
  let s15 = uint64_to_uint8 (b4 >>^ 16ul) in
  (* * *)
  upd s 0ul s0;
  upd s 1ul s1;
  upd s 2ul s2;
  upd s 3ul s3;
  upd s 4ul s4;
  upd s 5ul s5;
  upd s 6ul s6;
  upd s 7ul s7;
  upd s 8ul s8;
  upd s 9ul s9;
  upd s 10ul s10;
  upd s 11ul s11;
  upd s 12ul s12;
  upd s 13ul s13;
  upd s 14ul s14;
  upd s 15ul s15;
  ()

(* Clamps the key, see RFC 
   we clear 22 bits out of 128 (where does it help?)
*)
val clamp: r:wordB{length r = 16} -> STL unit
  (requires (fun h -> live h r))
  (ensures (fun h0 _ h1 -> live h1 r /\ modifies_1 r h0 h1))

let clamp r =
  let fix i mask = upd r i (U8 (index r i &^ mask)) in
  fix  3ul  15uy; // 0000****
  fix  7ul  15uy;
  fix 11ul  15uy;
  fix 15ul  15uy;
  fix  4ul 252uy; // ******00  
  fix  8ul 252uy;
  fix 12ul 252uy;
  ()


(* * *********************************************)
(* *          Encoding-related lemmas            *)
(* * *********************************************)

//TMP#reset-options "--initial_fuel 0 --max_fuel 0"

val lemma_eucl_div_bound: a:nat -> b:nat -> q:pos -> Lemma
  (requires (a < q))
  (ensures  (a + q * b < q * (b+1)))
let lemma_eucl_div_bound a b q = ()

//TMP#reset-options "--initial_fuel 1 --max_fuel 1"

val lemma_bitweight_templ_values: n:nat -> Lemma
  (requires (True))
  (ensures  (bitweight templ n = 26 * n))
let rec lemma_bitweight_templ_values n =
  if n = 0 then ()
  else lemma_bitweight_templ_values (n-1)

//TMP#reset-options "--initial_fuel 0 --max_fuel 0"

val lemma_mult_ineq: a:pos -> b:pos -> c:pos -> Lemma
  (requires (b <= c))
  (ensures  (a * b <= a * c))
let lemma_mult_ineq a b c = ()

//TMP#reset-options "--initial_fuel 1 --max_fuel 1 --z3timeout 50"

val lemma_eval_norm_is_bounded: ha:mem -> a:elemB -> len:nat{len <= norm_length} -> Lemma
  (requires (norm ha a))
  (ensures  (norm ha a /\ eval ha a len < pow2 (26 * len) ))
let rec lemma_eval_norm_is_bounded ha a len =
  if len = 0 then (
    eval_def ha a len
  )
  else (
    cut (len >= 1);
    eval_def ha a len;
    lemma_bitweight_templ_values (len-1);
    lemma_eval_norm_is_bounded ha a (len-1);
    assert(eval ha a (len-1) < pow2 (26 * (len-1)));
    assert(pow2 (bitweight templ (len-1)) = pow2 (26 * (len-1)));
    lemma_eucl_div_bound (eval ha a (len-1)) (v (get ha a (len-1))) (pow2 (bitweight templ (len-1)));
    assert(eval ha a len < pow2 (26 * (len-1)) * (v (get ha a (len-1)) + 1));
    lemma_mult_ineq (pow2 (26 * (len-1))) (v (get ha a (len-1))+1) (pow2 26);
    assert(eval ha a len < pow2 (26 * (len-1)) * pow2 26);
    Math.Lib.pow2_exp_lemma (26 * (len-1)) 26)

//#reset-options "--initial_fuel 1 --max_fuel 1"

val lemma_elemB_equality: ha:mem -> hb:mem -> a:elemB -> b:elemB -> len:pos{len<=norm_length} -> Lemma
  (requires (live ha a /\ live hb b
    /\ Seq.slice (as_seq ha a) 0 (len-1) == Seq.slice (as_seq hb b) 0 (len-1)
    /\ get ha a (len-1) = get hb b (len-1)))
  (ensures  (live ha a /\ live hb b /\ Seq.slice (as_seq ha a) 0 len == Seq.slice (as_seq hb b) 0 len))
let lemma_elemB_equality ha hb a b len =
  Seq.lemma_eq_intro (Seq.slice (as_seq ha a) 0 len) 
		     ((Seq.slice (as_seq ha a) 0 (len-1)) @| Seq.create 1 (get ha a (len-1)));
  Seq.lemma_eq_intro (Seq.slice (as_seq hb b) 0 len) 
		     ((Seq.slice (as_seq hb b) 0 (len-1)) @| Seq.create 1 (get hb b (len-1)))

//TMP#reset-options "--initial_fuel 1 --max_fuel 1 --z3timeout 20"

val lemma_toField_is_injective_0: ha:mem -> hb:mem -> a:elemB -> b:elemB -> len:nat{len <= norm_length} -> Lemma
  (requires (norm ha a /\ norm hb b /\ eval ha a len = eval hb b len))
  (ensures  (norm ha a /\ norm hb b
    /\ Seq.length (as_seq ha a) >= len /\ Seq.length (as_seq hb b) >= len
    /\ Seq.slice (as_seq ha a) 0 len == Seq.slice (as_seq hb b) 0 len))
let rec lemma_toField_is_injective_0 ha hb a b len =
  if len = 0 then (
    admit();
    Seq.lemma_eq_intro (Seq.slice (as_seq ha a) 0 len) (Seq.slice (as_seq hb b) 0 len)
  )
  else (
    eval_def ha a len; eval_def hb b len;
    lemma_eval_norm_is_bounded ha a (len-1);
    lemma_eval_norm_is_bounded hb b (len-1);
    let z = pow2 (26 * (len-1)) in
    let r = eval ha a (len-1) in
    let r' = eval hb b (len-1) in
    let q = v (get ha a (len-1)) in
    let q' = v (get hb b (len-1)) in
    lemma_bitweight_templ_values (len-1);
    lemma_little_endian_is_injective_1 z q r q' r';
    assert(r = r' /\ q = q');
    assert(get ha a (len-1) = get hb b (len-1));
    lemma_toField_is_injective_0 ha hb a b (len-1);
    lemma_elemB_equality ha hb a b len)

//TMP#reset-options "--initial_fuel 0 --max_fuel 0"

val lemma_toField_is_injective: ha:mem -> hb:mem -> a:elemB -> b:elemB ->
  Lemma (requires (norm ha a /\ norm hb b /\ sel_int ha a = sel_int hb b
    /\ length a = norm_length /\ length b = norm_length ))
	(ensures  (norm ha a /\ norm hb b /\ as_seq ha a == as_seq hb b))
let lemma_toField_is_injective ha hb a b =
  lemma_toField_is_injective_0 ha hb a b norm_length;
  assert(Seq.length (as_seq ha a) = norm_length);
  assert(Seq.length (as_seq hb b) = norm_length);
  Seq.lemma_eq_intro (Seq.slice (as_seq ha a) 0 norm_length) (as_seq ha a);
  Seq.lemma_eq_intro (Seq.slice (as_seq hb b) 0 norm_length) (as_seq hb b)


//TMP#reset-options "--initial_fuel 0 --max_fuel 0 --z3timeout 20"

(* Initialization function:
   - clamps the first half of the key
   - stores the well-formatted first half of the key in 'r' *)

// we now separate initialization of the accumulator, 
// as in principle several accumulations are allowed. 

val poly1305_init: 
  r:elemB  -> //out: first half of the key, ready for polynomial evaluation
  s:wordB_16 {disjoint r s}-> //out: second half of the key, ready for masking
  key:bytes{length key >= 32 /\ disjoint r key /\ disjoint s key} -> //in: raw key
  STL unit
  (requires (fun h -> live h r /\ live h s /\ live h key))
  (ensures  (fun h0 log h1 -> modifies_2 r s h0 h1 /\ norm h1 r))

let poly1305_init r s key =
  let hinit = HST.get() in
  push_frame();
  (* Format the keys *)
  (* Make a copy of the first half of the key to clamp it *)
  let r_16 = create 0uy 16ul in
  blit key 0ul r_16 0ul 16ul; 
  blit key 16ul s 0ul 16ul;
  (* Clamp r *)
  clamp r_16;
  (* Format r to elemB *)
  toField r r_16;
  pop_frame();
  let hfin = HST.get() in
  (* TODO *)
  assume (norm hfin r);
  assume (modifies_2 r s hinit hfin);
  assume (equal_domains hinit hfin);
  ()

val poly1305_start: 
  acc:elemB -> // Accumulator
  STL unit
  (requires (fun h -> live h acc))
  (ensures  (fun h0 _ h1 -> modifies_1 acc h0 h1 
    /\ norm h1 acc 
    /\ sel_elem h1 acc = 0 ))

let poly1305_start a = zeroB a


//#reset-options "--initial_fuel 0 --max_fuel 0"

(* WIP *)

(**
   Update function:
   - takes a ghost log
   - takes a message block, appends '1' to it and formats it to bigint format
   - runs acc = ((acc*block)+r) % p 
   *)

//CF note the log now consists of eleme
//CF we'll need a simpler, field-only update---not the one below.

val poly1305_update:
  current_log:erased text ->
  msg:wordB_16 ->
  acc:elemB{disjoint msg acc} ->
  r:elemB{disjoint msg r /\ disjoint acc r} -> STL (erased text)
    (requires (fun h -> live h msg /\ norm h acc /\ norm h r
      /\ poly (reveal current_log) (sel_elem h r) = sel_elem h acc // Incremental step of poly
      ))
    (ensures (fun h0 updated_log h1 -> norm h1 acc /\ norm h0 r /\ live h0 msg
      /\ modifies_1 acc h0 h1
      /\ Seq.length (sel_word h0 msg) = 16 // Required in the 'log' invariant
      ///\ reveal updated_log == (reveal current_log) @| Seq.create 1 (sel_word h0 msg)
      /\ sel_elem h1 acc = poly (reveal updated_log) (sel_elem h0 r) ))
let poly1305_update log msg acc r =
  push_frame();
  let n = sub msg 0ul 16ul in // Select the message to update
  (* TODO: pass the buffer for the block rather that create a fresh one to avoid
     too many copies *)
  let block = create 0UL nlength in
  (* let h' = HST.get() in *)
  toField_plus_2_128 block n;
  add_and_multiply acc block r;
  let h = HST.get() in
  let msg = esel_word_16 h msg in
  //let updated_log = SeqProperties.snoc log (encode_16 msg) in // JK: doesn't lax typecheck
  let updated_log = log in // JK: dummy
  pop_frame();
  updated_log

(* Loop over Poly1305_update; could go below MAC *)
val poly1305_loop: current_log:erased text -> msg:bytes -> acc:elemB{disjoint msg acc} ->
  r:elemB{disjoint msg r /\ disjoint acc r} -> ctr:u32{length msg >= 16 * w ctr} ->
  STL (erased text)
    (requires (fun h -> live h msg /\ norm h acc /\ norm h r))
    (ensures (fun h0 _ h1 -> live h1 msg /\ norm h1 acc /\ norm h1 r
      /\ modifies_1 acc h0 h1))
let rec poly1305_loop log msg acc r ctr =
  if U32.eq ctr 0ul then log
  else begin
    let updated_log = poly1305_update log msg acc r in
    let msg = offset msg 16ul in
    let h = HST.get() in
    let word = esel_word h msg in
    poly1305_loop updated_log msg acc r (ctr-|1ul)
  end

(**
   Performs the last step if there is an incomplete block 
   NB: Not relevant for AEAD-ChachaPoly which only uses complete blocks of 16 bytes, hence
       only the 'update' and 'loop' functions are necessary there
   *)
val poly1305_last: msg:wordB -> acc:elemB{disjoint msg acc} ->
  r:elemB{disjoint msg r /\ disjoint acc r} -> len:u32{w len <= length msg} ->
  STL unit
    (requires (fun h -> live h msg /\ norm h acc /\ norm h r))
    (ensures (fun h0 _ h1 -> live h1 msg /\ norm h1 acc /\ norm h1 r
      /\ modifies_1 acc h0 h1))
let poly1305_last msg acc r len =
  push_frame();
  let h0 = HST.get() in
  if U32.eq len 0ul then ()
  else (
    let n = create 0uy 16ul in
    blit msg 0ul n 0ul len;
    upd n len 1uy;
    let block = create 0UL nlength in
    toField block n;
    add_and_multiply acc block r);
  pop_frame()


(* TODO: certainly a more efficient, better implementation of that *)
private val add_word: a:wordB_16 -> b:wordB_16 -> STL unit
  (requires (fun h -> live h a /\ live h b))
  (ensures  (fun h0 _ h1 -> live h1 a /\ modifies_1 a h0 h1
    /\ little_endian (sel_word h1 a) =
	(little_endian (sel_word h0 a) + little_endian (sel_word h0 b)) % pow2 128 ))
let add_word a b =
  let carry = 0ul in
  let a04:u64 = let (x:u32) = uint32_of_bytes a in uint32_to_uint64 x  in
  let a48:u64 = let (x:u32) = uint32_of_bytes (offset a 4ul) in uint32_to_uint64 x in
  let a812:u64 = let (x:u32) = uint32_of_bytes (offset a 8ul) in uint32_to_uint64 x in
  let a1216:u64 = let (x:u32) = uint32_of_bytes (offset a 12ul) in uint32_to_uint64 x in
  let b04:u64 = let (x:u32) = uint32_of_bytes b in uint32_to_uint64 x  in
  let b48:u64 = let (x:u32) = uint32_of_bytes (offset b 4ul) in uint32_to_uint64 x in
  let b812:u64 = let (x:u32) = uint32_of_bytes (offset b 8ul) in uint32_to_uint64 x in
  let b1216:u64 = let (x:u32) = uint32_of_bytes (offset b 12ul) in uint32_to_uint64 x in
  let open FStar.UInt64 in
  let z0 = a04 +^ b04 in
  let z1 = a48 +^ b48 +^ (z0 >>^ 32ul) in
  let z2 = a812 +^ b812 +^ (z1 >>^ 32ul) in
  let z3 = a1216 +^ b1216 +^ (z2 >>^ 32ul) in
  bytes_of_uint32 (Buffer.sub a 0ul 4ul) (uint64_to_uint32 z0);
  bytes_of_uint32 (Buffer.sub a 4ul 4ul) (uint64_to_uint32 z1);
  bytes_of_uint32 (Buffer.sub a 8ul 4ul) (uint64_to_uint32 z2);
  bytes_of_uint32 (Buffer.sub a 12ul 4ul) (uint64_to_uint32 z3)


(* Finish function, with final accumulator value *)
val poly1305_finish: 
  tag:wordB_16 -> acc:elemB -> s:wordB_16 -> STL unit
  (requires (fun h -> live h tag /\ live h acc /\ live h s 
    /\ disjoint tag acc /\ disjoint tag s /\ disjoint acc s))
  (ensures  (fun h0 _ h1 -> modifies_2 tag acc h0 h1 /\ live h1 acc /\ live h1 tag
    // TODO: add some functional correctness
  ))
let poly1305_finish tag acc s =  
  trunc1305 acc tag;
  add_word tag s

(**
   Computes the poly1305 mac function on a buffer
   *)
val poly1305_mac: tag:wordB{length tag >= 16} -> msg:bytes{disjoint tag msg} ->
  len:u32{w len <= length msg} -> key:bytes{length key = 32 /\ disjoint msg key /\ disjoint tag key} ->
  STL unit
    (requires (fun h -> live h msg /\ live h key /\ live h tag))
    (ensures (fun h0 _ h1 -> live h1 tag /\ modifies_1 tag h0 h1))
let poly1305_mac tag msg len key =
  push_frame();
  (* Create buffers for the 2 parts of the key and the accumulator *)
  let tmp = create 0UL 10ul in
  let acc = sub tmp 0ul 5ul in
  let r   = sub tmp 5ul 5ul in
  let s   = create 0uy 16ul in 
  (* Initializes the accumulator and the keys values *)
  let () = poly1305_init r s key in
  let _ = poly1305_start acc in
  (* Compute the number of 'plain' blocks *)
  let ctr = U32.div len 16ul in
  let rest = U32.rem len 16ul in 
  (* Run the poly1305_update function ctr times *)
  let l = hide Seq.createEmpty in 
  let l = poly1305_loop l msg acc r ctr in
  (* Run the poly1305_update function one more time on the incomplete block *)
  let last_block = sub msg (FStar.UInt32 (ctr *^ 16ul)) rest in
  poly1305_last last_block acc r rest;
  (* Finish *)
  poly1305_finish tag acc (sub key 16ul 16ul);
  pop_frame()
