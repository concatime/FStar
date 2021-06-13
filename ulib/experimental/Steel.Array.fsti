(*
   Copyright 2021 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)

module Steel.Array
include Steel.CStdInt
open Steel.Memory
open Steel.FractionalPermission
open Steel.Effect
open FStar.Ghost
open Steel.Effect.Atomic

module P = Steel.Pointer

/// A library for arrays in Steel, with fractional permissions.

/// Abstract datatype for a Steel array of type [t]
val array (t:Type u#0) : Type u#0

/// Returns the length of the array. Usable for specification and proof purposes,
/// as modeled by the GTot effect
val len (#t: Type) (a: array t) : GTot size_t
let length (#t: Type) (a: array t) : GTot nat = size_v (len a)

/// The null array (if malloc fails)
///
val null (t: Type) : Pure (array t)
  (requires True)
  (ensures (fun y -> length y == 0))

val g_is_null (#t: Type) (a: array t) : Ghost bool
  (requires True)
  (ensures (fun y -> y == true <==> a == null t))

/// Separation logic predicate indicating the validity of the array in the current memory
val is_array (#a:Type0) (r:array a) (p: perm) : slprop u#1

/// Selector for Steel arrays. It returns the contents in memory of the array.
/// The contents of an array of type [t] is a sequence of values of type [t]
/// whose length is the length of the array
val array_sel (#a:Type0) (r:array a) (p: perm) : selector (Seq.lseq a (length r)) (is_array r p)

/// Combining the elements above to create an array vprop
[@@ __steel_reduce__]
let varray' #a r p : vprop' =
  {hp = is_array r p;
   t = Seq.lseq a (length r);
   sel = array_sel r p}

[@@ __steel_reduce__]
let varrayp r p = VUnit (varray' r p)

[@@ __steel_reduce__; __reduce__]
let varray r = VUnit (varray' r full_perm)

/// A wrapper to access an array selector more easily.
/// Ensuring that the corresponding array vprop is in the context is done by
/// calling a variant of the framing tactic, as defined in Steel.Effect.Common
[@@ __steel_reduce__]
let asel (#a:Type) (#p:vprop) (r:array a)
  (h:rmem p{FStar.Tactics.with_tactic selector_tactic (can_be_split p (varray r) /\ True)})
: GTot (Seq.lseq a (length r))
  = h (varray r)

/// Managing the null array
val varrayp_not_null
  (#opened: _)
  (#t: Type)
  (a: array t)
  (p: perm)
: SteelGhost unit opened
    (varrayp a p)
    (fun _ -> varrayp a p)
    (fun _ -> True)
    (fun h _ h' ->
      g_is_null a == false /\
      h' (varrayp a p) == h (varrayp a p)
    )

let varrayp_or_null (#t: Type) (a: array t) (p: perm) : Tot vprop =
  if g_is_null a then emp else varrayp a p

val is_null
  (#opened: _)
  (#a: Type)
  (x: array a)
  (r: perm)
: SteelAtomic bool opened
    (varrayp_or_null x r)
    (fun _ -> varrayp_or_null x r)
    (fun _ -> True)
    (fun h res h' ->
      h' (varrayp_or_null x r) == h (varrayp_or_null x r) /\
      res == g_is_null x
    )

let assert_null
  (#opened: _)
  (#a: Type)
  (x: array a)
  (r: perm)
: SteelGhost unit opened
    (varrayp_or_null x r)
    (fun _ -> emp)
    (fun _ -> g_is_null x == true)
    (fun _ _ _ -> True)
=
  change_equal_slprop
    (varrayp_or_null x r)
    emp

let assert_not_null
  (#opened: _)
  (#a: Type)
  (x: array a)
  (r: perm)
: SteelGhost unit opened
    (varrayp_or_null x r)
    (fun _ -> varrayp x r)
    (fun _ -> g_is_null x == false)
    (fun h _ h' ->
      g_is_null x == false /\
      h' (varrayp x r) == h (varrayp_or_null x r)
    )
=
  assert (g_is_null x == false);
  change_equal_slprop
    (varrayp_or_null x r)
    (varrayp x r)


/// Splitting an array into subarrays

val adjacent
  (#t: Type)
  (r1 r2: array t)
: Tot prop

val merge
  (#t: Type)
  (r1 r2: array t)
: Ghost (array t)
  (requires (adjacent r1 r2))
  (ensures (fun r -> length r == length r1 + length r2))

let merge_into
  (#t: Type)
  (r1 r2 r3: array t)
: Tot prop
= adjacent r1 r2 /\
  merge r1 r2 == r3

val merge_assoc
  (#t: Type)
  (r1 r2 r3: array t)
: Lemma
  (requires (adjacent r1 r2 /\ adjacent r2 r3))
  (ensures (
    adjacent r1 r2 /\ adjacent r2 r3 /\
    begin
      let r12 = merge r1 r2 in
      let r23 = merge r2 r3 in
      adjacent r1 r23 /\ adjacent r12 r3 /\
      merge r1 r23 == merge r12 r3
    end
  ))
  [SMTPat (merge (merge r1 r2) r3)]

val gsplit
  (#t: Type)
  (r: array t)
  (i: size_t)
: Ghost (array t & array t)
  (requires (size_v i <= length r))
  (ensures (fun (rl, rr) ->
    merge_into rl rr r /\
    length rl == size_v i
  ))

val splitp (#opened: _) (#t:Type) (a:array t) (p: perm) (i:size_t)
  : SteelAtomic (array t & array t) opened
          (varrayp a p)
          (fun res -> varrayp (fst res) p `star` varrayp (snd res) p)
          (fun _ -> size_v i <= length a)
          (fun h res h' ->
            let s = h (varrayp a p) in
            let sl = h' (varrayp (fst res) p) in
            let sr = h' (varrayp (snd res) p) in
            size_v i <= length a /\
            res == gsplit a i /\
            sl == Seq.slice s 0 (size_v i) /\
            sr == Seq.slice s (size_v i) (length a) /\
            s == sl `Seq.append` sr
          )

inline_for_extraction
let split (#opened: _) (#t:Type) (a:array t) (i:size_t)
  : SteelAtomic (array t & array t) opened
          (varray a)
          (fun res -> varray (fst res) `star` varray (snd res))
          (fun _ -> size_v i <= length a)
          (fun h res h' ->
            let s = h (varray a) in
            let sl = h' (varray (fst res)) in
            let sr = h' (varray (snd res)) in
            size_v i <= length a /\
            res == gsplit a i /\
            sl == Seq.slice s 0 (size_v i) /\
            sr == Seq.slice s (size_v i) (length a) /\
            s == sl `Seq.append` sr
          )
=
  splitp _ _ i

val joinp (#opened: _) (#t:Type) (al ar:array t)
  (p: perm)
  : SteelAtomic (array t) opened
          (varrayp al p `star` varrayp ar p)
          (fun a -> varrayp a p)
          (fun _ -> adjacent al ar)
          (fun h a h' ->
            let s = h' (varrayp a p) in
            s == (h (varrayp al p) `Seq.append` h (varrayp ar p)) /\
            merge_into al ar a
          )

inline_for_extraction
let join (#opened: _) (#t:Type) (al ar:array t)
  : SteelAtomic (array t) opened
          (varray al `star` varray ar)
          (fun a -> varray a)
          (fun _ -> adjacent al ar)
          (fun h a h' ->
            let s = h' (varray a) in
            s == (h (varray al) `Seq.append` h (varray ar)) /\
            merge_into al ar a
          )
=
  joinp _ _ _

/// A property telling that an array "is a full allocation unit"
/// that can be freed all at once (as opposed to a strict subarray of
/// some other array)
val freeable (#t: Type) (a: array t) : Tot prop

/// Allocates an array of length n, where all elements of the array initially are [x]
val malloc (#t:Type) (x:t) (n:size_t)
  : Steel (array t)
             emp
             (fun r -> varrayp_or_null r full_perm)
             (requires fun _ -> size_v n > 0)
             (ensures fun _ r h1 ->
               if g_is_null r
               then True
               else
                 len r == n /\
                 (h1 (varrayp r full_perm) <: Seq.seq t) == Seq.create (size_v n) x /\
               freeable r
             )

/// Accesses index [i] in array [r], as long as [i] is in bounds and the array
/// is currently valid in memory

val indexp (#t:Type) (r:array t) (p: perm) (i:size_t)
  : Steel t
             (varrayp r p)
             (fun _ -> varrayp r p)
             (requires fun _ -> size_v i < length r)
             (ensures fun h0 x h1 ->
               let s = h1 (varrayp r p) in
               size_v i < length r /\
               h0 (varrayp r p) == s /\
               x == Seq.index s (size_v i))

inline_for_extraction
let index (#t:Type) (r:array t) (i:size_t)
  : Steel t
             (varray r)
             (fun _ -> varray r)
             (requires fun _ -> size_v i < length r)
             (ensures fun h0 x h1 ->
               let s = asel r h1 in
               size_v i < length r /\
               asel r h0 == s /\
               x == Seq.index s (size_v i))
=
  indexp _ _ i

/// Updates index [i] in array [r] with value [x], as long as [i]
/// is in bounds and the array is currently valid in memory
val upd (#t:Type) (r:array t) (i:size_t) (x:t)
  : Steel unit
             (varray r)
             (fun _ -> varray r)
             (requires fun h -> size_v i < length r)
             (ensures fun h0 _ h1 ->
               size_v i < length r /\
               asel r h1 == Seq.upd (asel r h0) (size_v i) x)

/// Frees array [r], as long as it initially was a valid array in memory
val free (#t:Type) (r:array t)
  : Steel unit
             (varray r)
             (fun _ -> emp)
             (requires fun _ -> freeable r)
             (ensures fun _ _ _ -> True)

val share (#t:Type) (#uses:_) (a:array t) (p: perm)
  : SteelGhost perm uses
           (varrayp a p)
           (fun res -> varrayp a res `star` varrayp a res)
           (fun _ -> True)
           (fun h res h' ->
             h' (varrayp a res) == h (varrayp a p) /\
             res == half_perm p
           )

val gather (#t:Type) (#uses:_) (a:array t) (p1 p2: perm)
  : SteelGhost perm uses
           (varrayp a p1 `star` varrayp a p2)
           (fun res -> varrayp a res)
           (fun _ -> True)
           (fun h res h' ->
             h' (varrayp a res) == h (varrayp a p1) /\
             h' (varrayp a res) == h (varrayp a p2) /\
             res == p1 `sum_perm` p2
           )

(* Entering (resp. exiting) abstraction from (resp. to) a pointer *)

val g_get_pointer
  (#t: Type)
  (a: array t)
: GTot (P.t t)

val get_range
  (#t: Type)
  (a: array t)
  (p: perm)
: Tot P.range

val get_pointer
  (#opened: _)
  (#t: Type)
  (a: array t)
  (p: perm)
: SteelAtomic (P.t t) opened
    (varrayp a p)
    (fun _ -> varrayp a p)
    (fun _ -> True)
    (fun h res h' ->
      h' (varrayp a p) == h (varrayp a p) /\
      res == g_get_pointer a
    )

val enter
  (#opened: _)
  (#t: Type)
  (p: P.t t)
  (r: P.range)
: SteelAtomic (array t) opened
    (P.vptr_range p r)
    (fun res -> varrayp res r.P.range_write_perm)
    (fun _ -> r.P.range_from == 0)
    (fun h res h' ->
      (h' (varrayp res r.P.range_write_perm) <: Seq.seq t) == h (P.vptr_range p r) /\
      g_get_pointer res == p /\
      get_range res r.P.range_write_perm == r
    )

val exit'
  (#opened: _)
  (#t: Type)
  (a: array t)
  (p: perm)
: SteelGhost unit opened
    (varrayp a p)
    (fun _ -> P.vptr_range (g_get_pointer a) (get_range a p))
    (fun _ -> True)
    (fun h res h' ->
      (h' (P.vptr_range (g_get_pointer a) (get_range a p)) <: Seq.seq t) == h (varrayp a p)
    )

let exit
  (#opened: _)
  (#t: Type)
  (a: array t)
  (p: perm)
  (ptr: P.t t)
  (r: P.range)
: SteelAtomic unit opened
    (varrayp a p)
    (fun _ -> P.vptr_range ptr r)
    (fun _ ->
      ptr == g_get_pointer a /\
      r == get_range a p
    )
    (fun h _ h' ->
      (h' (P.vptr_range ptr r) <: Seq.seq t) == h (varrayp a p)
    )
=
  exit' a p;
  change_equal_slprop
    (P.vptr_range (g_get_pointer a) (get_range a p))
    (P.vptr_range ptr r)

(* The only non-ghost part in an array is its pointer. *)

val reveal
  (#opened: _)
  (#t: Type)
  (r: P.t t)
  (a: Ghost.erased (array t))
  (p: perm)
: SteelAtomic (array t) opened
    (varrayp a p)
    (fun res -> varrayp res p)
    (fun _ -> g_get_pointer a == r)
    (fun h res h' ->
      res == Ghost.reveal a /\
      h' (varrayp res p) == h (varrayp a p)
    )

val get_pointer_gsplit
  (#t: Type)
  (r: array t)
  (i: size_t)
: Lemma
  (requires (size_v i <= length r))
  (ensures (
    g_get_pointer (fst (gsplit r i)) == g_get_pointer r
  ))
