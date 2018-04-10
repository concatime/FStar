open Prims
type vops_t =
  {
  next_major: unit -> FStar_Syntax_Syntax.version ;
  next_minor: unit -> FStar_Syntax_Syntax.version }[@@deriving show]
let (__proj__Mkvops_t__item__next_major :
  vops_t -> unit -> FStar_Syntax_Syntax.version) =
  fun projectee  ->
    match projectee with
    | { next_major = __fname__next_major; next_minor = __fname__next_minor;_}
        -> __fname__next_major
  
let (__proj__Mkvops_t__item__next_minor :
  vops_t -> unit -> FStar_Syntax_Syntax.version) =
  fun projectee  ->
    match projectee with
    | { next_major = __fname__next_major; next_minor = __fname__next_minor;_}
        -> __fname__next_minor
  
let (vops : vops_t) =
  let major = FStar_Util.mk_ref (Prims.parse_int "0")  in
  let minor = FStar_Util.mk_ref (Prims.parse_int "0")  in
  let next_major uu____67 =
    let uu____68 = FStar_ST.op_Colon_Equals minor (Prims.parse_int "0")  in
    let uu____114 =
      let uu____115 = FStar_Util.incr major  in FStar_ST.op_Bang major  in
    {
      FStar_Syntax_Syntax.major = uu____114;
      FStar_Syntax_Syntax.minor = (Prims.parse_int "0")
    }  in
  let next_minor uu____198 =
    let uu____199 = FStar_ST.op_Bang major  in
    let uu____245 =
      let uu____246 = FStar_Util.incr minor  in FStar_ST.op_Bang minor  in
    {
      FStar_Syntax_Syntax.major = uu____199;
      FStar_Syntax_Syntax.minor = uu____245
    }  in
  { next_major; next_minor } 
type tgraph =
  FStar_Syntax_Syntax.term FStar_Pervasives_Native.option FStar_Unionfind.puf
[@@deriving show]
type ugraph =
  FStar_Syntax_Syntax.universe FStar_Pervasives_Native.option
    FStar_Unionfind.puf[@@deriving show]
type uf =
  {
  term_graph: tgraph ;
  univ_graph: ugraph ;
  version: FStar_Syntax_Syntax.version }[@@deriving show]
let (__proj__Mkuf__item__term_graph : uf -> tgraph) =
  fun projectee  ->
    match projectee with
    | { term_graph = __fname__term_graph; univ_graph = __fname__univ_graph;
        version = __fname__version;_} -> __fname__term_graph
  
let (__proj__Mkuf__item__univ_graph : uf -> ugraph) =
  fun projectee  ->
    match projectee with
    | { term_graph = __fname__term_graph; univ_graph = __fname__univ_graph;
        version = __fname__version;_} -> __fname__univ_graph
  
let (__proj__Mkuf__item__version : uf -> FStar_Syntax_Syntax.version) =
  fun projectee  ->
    match projectee with
    | { term_graph = __fname__term_graph; univ_graph = __fname__univ_graph;
        version = __fname__version;_} -> __fname__version
  
let (empty : FStar_Syntax_Syntax.version -> uf) =
  fun v1  ->
    let uu____374 = FStar_Unionfind.puf_empty ()  in
    let uu____377 = FStar_Unionfind.puf_empty ()  in
    { term_graph = uu____374; univ_graph = uu____377; version = v1 }
  
let (version_to_string : FStar_Syntax_Syntax.version -> Prims.string) =
  fun v1  ->
    let uu____385 = FStar_Util.string_of_int v1.FStar_Syntax_Syntax.major  in
    let uu____386 = FStar_Util.string_of_int v1.FStar_Syntax_Syntax.minor  in
    FStar_Util.format2 "%s.%s" uu____385 uu____386
  
let (state : uf FStar_ST.ref) =
  let uu____400 = let uu____401 = vops.next_major ()  in empty uu____401  in
  FStar_Util.mk_ref uu____400 
type tx =
  | TX of uf [@@deriving show]
let (uu___is_TX : tx -> Prims.bool) = fun projectee  -> true 
let (__proj__TX__item___0 : tx -> uf) =
  fun projectee  -> match projectee with | TX _0 -> _0 
let (get : unit -> uf) = fun uu____421  -> FStar_ST.op_Bang state 
let (set : uf -> unit) = fun u  -> FStar_ST.op_Colon_Equals state u 
let (reset : unit -> unit) =
  fun uu____477  ->
    let v1 = vops.next_major ()  in
    let uu____479 = empty v1  in set uu____479
  
let (new_transaction : unit -> tx) =
  fun uu____484  ->
    let tx = let uu____486 = get ()  in TX uu____486  in
    let uu____487 =
      let uu____488 =
        let uu___25_489 = get ()  in
        let uu____490 = vops.next_minor ()  in
        {
          term_graph = (uu___25_489.term_graph);
          univ_graph = (uu___25_489.univ_graph);
          version = uu____490
        }  in
      set uu____488  in
    tx
  
let (commit : tx -> unit) = fun tx  -> () 
let (rollback : tx -> unit) =
  fun uu____500  -> match uu____500 with | TX uf -> set uf 
let update_in_tx : 'a . 'a FStar_ST.ref -> 'a -> unit =
  fun r  -> fun x  -> () 
let (get_term_graph : unit -> tgraph) =
  fun uu____560  -> let uu____561 = get ()  in uu____561.term_graph 
let (get_version : unit -> FStar_Syntax_Syntax.version) =
  fun uu____566  -> let uu____567 = get ()  in uu____567.version 
let (set_term_graph : tgraph -> unit) =
  fun tg  ->
    let uu____573 =
      let uu___26_574 = get ()  in
      {
        term_graph = tg;
        univ_graph = (uu___26_574.univ_graph);
        version = (uu___26_574.version)
      }  in
    set uu____573
  
let chk_v :
  'Auu____579 .
    ('Auu____579,FStar_Syntax_Syntax.version) FStar_Pervasives_Native.tuple2
      -> 'Auu____579
  =
  fun uu____588  ->
    match uu____588 with
    | (u,v1) ->
        let expected = get_version ()  in
        if
          (v1.FStar_Syntax_Syntax.major = expected.FStar_Syntax_Syntax.major)
            &&
            (v1.FStar_Syntax_Syntax.minor <=
               expected.FStar_Syntax_Syntax.minor)
        then u
        else
          (let uu____597 =
             let uu____598 = version_to_string expected  in
             let uu____599 = version_to_string v1  in
             FStar_Util.format2
               "Incompatible version for unification variable: current version is %s; got version %s"
               uu____598 uu____599
              in
           failwith uu____597)
  
let (uvar_id : FStar_Syntax_Syntax.uvar -> Prims.int) =
  fun u  ->
    let uu____605 = get_term_graph ()  in
    let uu____610 = chk_v u  in FStar_Unionfind.puf_id uu____605 uu____610
  
let (from_id : Prims.int -> FStar_Syntax_Syntax.uvar) =
  fun n1  ->
    let uu____628 =
      let uu____633 = get_term_graph ()  in
      FStar_Unionfind.puf_fromid uu____633 n1  in
    let uu____640 = get_version ()  in (uu____628, uu____640)
  
let (fresh : unit -> FStar_Syntax_Syntax.uvar) =
  fun uu____649  ->
    let uu____650 =
      let uu____655 = get_term_graph ()  in
      FStar_Unionfind.puf_fresh uu____655 FStar_Pervasives_Native.None  in
    let uu____662 = get_version ()  in (uu____650, uu____662)
  
let (find :
  FStar_Syntax_Syntax.uvar ->
    FStar_Syntax_Syntax.term FStar_Pervasives_Native.option)
  =
  fun u  ->
    let uu____674 = get_term_graph ()  in
    let uu____679 = chk_v u  in FStar_Unionfind.puf_find uu____674 uu____679
  
let (change : FStar_Syntax_Syntax.uvar -> FStar_Syntax_Syntax.term -> unit) =
  fun u  ->
    fun t  ->
      let uu____702 =
        let uu____703 = get_term_graph ()  in
        let uu____708 = chk_v u  in
        FStar_Unionfind.puf_change uu____703 uu____708
          (FStar_Pervasives_Native.Some t)
         in
      set_term_graph uu____702
  
let (equiv :
  FStar_Syntax_Syntax.uvar -> FStar_Syntax_Syntax.uvar -> Prims.bool) =
  fun u  ->
    fun v1  ->
      let uu____731 = get_term_graph ()  in
      let uu____736 = chk_v u  in
      let uu____747 = chk_v v1  in
      FStar_Unionfind.puf_equivalent uu____731 uu____736 uu____747
  
let (union : FStar_Syntax_Syntax.uvar -> FStar_Syntax_Syntax.uvar -> unit) =
  fun u  ->
    fun v1  ->
      let uu____770 =
        let uu____771 = get_term_graph ()  in
        let uu____776 = chk_v u  in
        let uu____787 = chk_v v1  in
        FStar_Unionfind.puf_union uu____771 uu____776 uu____787  in
      set_term_graph uu____770
  
let (get_univ_graph : unit -> ugraph) =
  fun uu____804  -> let uu____805 = get ()  in uu____805.univ_graph 
let (set_univ_graph : ugraph -> unit) =
  fun ug  ->
    let uu____811 =
      let uu___27_812 = get ()  in
      {
        term_graph = (uu___27_812.term_graph);
        univ_graph = ug;
        version = (uu___27_812.version)
      }  in
    set uu____811
  
let (univ_uvar_id : FStar_Syntax_Syntax.universe_uvar -> Prims.int) =
  fun u  ->
    let uu____818 = get_univ_graph ()  in
    let uu____823 = chk_v u  in FStar_Unionfind.puf_id uu____818 uu____823
  
let (univ_from_id : Prims.int -> FStar_Syntax_Syntax.universe_uvar) =
  fun n1  ->
    let uu____839 =
      let uu____844 = get_univ_graph ()  in
      FStar_Unionfind.puf_fromid uu____844 n1  in
    let uu____851 = get_version ()  in (uu____839, uu____851)
  
let (univ_fresh : unit -> FStar_Syntax_Syntax.universe_uvar) =
  fun uu____860  ->
    let uu____861 =
      let uu____866 = get_univ_graph ()  in
      FStar_Unionfind.puf_fresh uu____866 FStar_Pervasives_Native.None  in
    let uu____873 = get_version ()  in (uu____861, uu____873)
  
let (univ_find :
  FStar_Syntax_Syntax.universe_uvar ->
    FStar_Syntax_Syntax.universe FStar_Pervasives_Native.option)
  =
  fun u  ->
    let uu____885 = get_univ_graph ()  in
    let uu____890 = chk_v u  in FStar_Unionfind.puf_find uu____885 uu____890
  
let (univ_change :
  FStar_Syntax_Syntax.universe_uvar -> FStar_Syntax_Syntax.universe -> unit)
  =
  fun u  ->
    fun t  ->
      let uu____911 =
        let uu____912 = get_univ_graph ()  in
        let uu____917 = chk_v u  in
        FStar_Unionfind.puf_change uu____912 uu____917
          (FStar_Pervasives_Native.Some t)
         in
      set_univ_graph uu____911
  
let (univ_equiv :
  FStar_Syntax_Syntax.universe_uvar ->
    FStar_Syntax_Syntax.universe_uvar -> Prims.bool)
  =
  fun u  ->
    fun v1  ->
      let uu____938 = get_univ_graph ()  in
      let uu____943 = chk_v u  in
      let uu____952 = chk_v v1  in
      FStar_Unionfind.puf_equivalent uu____938 uu____943 uu____952
  
let (univ_union :
  FStar_Syntax_Syntax.universe_uvar ->
    FStar_Syntax_Syntax.universe_uvar -> unit)
  =
  fun u  ->
    fun v1  ->
      let uu____973 =
        let uu____974 = get_univ_graph ()  in
        let uu____979 = chk_v u  in
        let uu____988 = chk_v v1  in
        FStar_Unionfind.puf_union uu____974 uu____979 uu____988  in
      set_univ_graph uu____973
  