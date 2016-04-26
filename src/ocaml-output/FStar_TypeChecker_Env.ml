
open Prims
# 28 "FStar.TypeChecker.Env.fst"
type binding =
| Binding_var of FStar_Syntax_Syntax.bv
| Binding_lid of (FStar_Ident.lident * FStar_Syntax_Syntax.tscheme)
| Binding_sig of (FStar_Ident.lident Prims.list * FStar_Syntax_Syntax.sigelt)
| Binding_univ of FStar_Syntax_Syntax.univ_name
| Binding_sig_inst of (FStar_Ident.lident Prims.list * FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universes)

# 31 "FStar.TypeChecker.Env.fst"
let is_Binding_var = (fun _discr_ -> (match (_discr_) with
| Binding_var (_) -> begin
true
end
| _ -> begin
false
end))

# 32 "FStar.TypeChecker.Env.fst"
let is_Binding_lid = (fun _discr_ -> (match (_discr_) with
| Binding_lid (_) -> begin
true
end
| _ -> begin
false
end))

# 33 "FStar.TypeChecker.Env.fst"
let is_Binding_sig = (fun _discr_ -> (match (_discr_) with
| Binding_sig (_) -> begin
true
end
| _ -> begin
false
end))

# 34 "FStar.TypeChecker.Env.fst"
let is_Binding_univ = (fun _discr_ -> (match (_discr_) with
| Binding_univ (_) -> begin
true
end
| _ -> begin
false
end))

# 35 "FStar.TypeChecker.Env.fst"
let is_Binding_sig_inst = (fun _discr_ -> (match (_discr_) with
| Binding_sig_inst (_) -> begin
true
end
| _ -> begin
false
end))

# 31 "FStar.TypeChecker.Env.fst"
let ___Binding_var____0 = (fun projectee -> (match (projectee) with
| Binding_var (_52_15) -> begin
_52_15
end))

# 32 "FStar.TypeChecker.Env.fst"
let ___Binding_lid____0 = (fun projectee -> (match (projectee) with
| Binding_lid (_52_18) -> begin
_52_18
end))

# 33 "FStar.TypeChecker.Env.fst"
let ___Binding_sig____0 = (fun projectee -> (match (projectee) with
| Binding_sig (_52_21) -> begin
_52_21
end))

# 34 "FStar.TypeChecker.Env.fst"
let ___Binding_univ____0 = (fun projectee -> (match (projectee) with
| Binding_univ (_52_24) -> begin
_52_24
end))

# 35 "FStar.TypeChecker.Env.fst"
let ___Binding_sig_inst____0 = (fun projectee -> (match (projectee) with
| Binding_sig_inst (_52_27) -> begin
_52_27
end))

# 35 "FStar.TypeChecker.Env.fst"
type delta_level =
| NoDelta
| OnlyInline
| Unfold of FStar_Syntax_Syntax.delta_depth

# 38 "FStar.TypeChecker.Env.fst"
let is_NoDelta = (fun _discr_ -> (match (_discr_) with
| NoDelta (_) -> begin
true
end
| _ -> begin
false
end))

# 39 "FStar.TypeChecker.Env.fst"
let is_OnlyInline = (fun _discr_ -> (match (_discr_) with
| OnlyInline (_) -> begin
true
end
| _ -> begin
false
end))

# 40 "FStar.TypeChecker.Env.fst"
let is_Unfold = (fun _discr_ -> (match (_discr_) with
| Unfold (_) -> begin
true
end
| _ -> begin
false
end))

# 40 "FStar.TypeChecker.Env.fst"
let ___Unfold____0 = (fun projectee -> (match (projectee) with
| Unfold (_52_30) -> begin
_52_30
end))

# 40 "FStar.TypeChecker.Env.fst"
type mlift =
FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ

# 42 "FStar.TypeChecker.Env.fst"
type edge =
{msource : FStar_Ident.lident; mtarget : FStar_Ident.lident; mlift : FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.typ}

# 44 "FStar.TypeChecker.Env.fst"
let is_Mkedge : edge  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkedge"))))

# 48 "FStar.TypeChecker.Env.fst"
type effects =
{decls : FStar_Syntax_Syntax.eff_decl Prims.list; order : edge Prims.list; joins : (FStar_Ident.lident * FStar_Ident.lident * FStar_Ident.lident * mlift * mlift) Prims.list}

# 49 "FStar.TypeChecker.Env.fst"
let is_Mkeffects : effects  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkeffects"))))

# 53 "FStar.TypeChecker.Env.fst"
type cached_elt =
((FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ), (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universes Prims.option)) FStar_Util.either

# 54 "FStar.TypeChecker.Env.fst"
type env =
{solver : solver_t; range : FStar_Range.range; curmodule : FStar_Ident.lident; gamma : binding Prims.list; gamma_cache : cached_elt FStar_Util.smap; modules : FStar_Syntax_Syntax.modul Prims.list; expected_typ : FStar_Syntax_Syntax.typ Prims.option; sigtab : FStar_Syntax_Syntax.sigelt FStar_Util.smap Prims.list; is_pattern : Prims.bool; instantiate_imp : Prims.bool; effects : effects; generalize : Prims.bool; letrecs : (FStar_Syntax_Syntax.lbname * FStar_Syntax_Syntax.typ) Prims.list; top_level : Prims.bool; check_uvars : Prims.bool; use_eq : Prims.bool; is_iface : Prims.bool; admit : Prims.bool; type_of : env  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ * guard_t); universe_of : env  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.universe; use_bv_sorts : Prims.bool} 
 and solver_t =
{init : env  ->  Prims.unit; push : Prims.string  ->  Prims.unit; pop : Prims.string  ->  Prims.unit; mark : Prims.string  ->  Prims.unit; reset_mark : Prims.string  ->  Prims.unit; commit_mark : Prims.string  ->  Prims.unit; encode_modul : env  ->  FStar_Syntax_Syntax.modul  ->  Prims.unit; encode_sig : env  ->  FStar_Syntax_Syntax.sigelt  ->  Prims.unit; solve : (Prims.unit  ->  Prims.string) Prims.option  ->  env  ->  FStar_Syntax_Syntax.typ  ->  Prims.unit; is_trivial : env  ->  FStar_Syntax_Syntax.typ  ->  Prims.bool; finish : Prims.unit  ->  Prims.unit; refresh : Prims.unit  ->  Prims.unit} 
 and guard_t =
{guard_f : FStar_TypeChecker_Common.guard_formula; deferred : FStar_TypeChecker_Common.deferred; univ_ineqs : FStar_TypeChecker_Common.univ_ineq Prims.list; implicits : (Prims.string * env * FStar_Syntax_Syntax.uvar * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ * FStar_Range.range) Prims.list}

# 55 "FStar.TypeChecker.Env.fst"
let is_Mkenv : env  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkenv"))))

# 78 "FStar.TypeChecker.Env.fst"
let is_Mksolver_t : solver_t  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mksolver_t"))))

# 92 "FStar.TypeChecker.Env.fst"
let is_Mkguard_t : guard_t  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkguard_t"))))

# 97 "FStar.TypeChecker.Env.fst"
type env_t =
env

# 98 "FStar.TypeChecker.Env.fst"
type implicits =
(env * FStar_Syntax_Syntax.uvar * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ * FStar_Range.range) Prims.list

# 99 "FStar.TypeChecker.Env.fst"
type sigtable =
FStar_Syntax_Syntax.sigelt FStar_Util.smap

# 161 "FStar.TypeChecker.Env.fst"
let visible_at : delta_level  ->  FStar_Syntax_Syntax.qualifier  ->  Prims.bool = (fun d q -> (match ((d, q)) with
| ((NoDelta, _)) | ((OnlyInline, FStar_Syntax_Syntax.Inline)) | ((Unfold (_), FStar_Syntax_Syntax.Inline)) | ((Unfold (_), FStar_Syntax_Syntax.Unfoldable)) -> begin
true
end
| _52_100 -> begin
false
end))

# 168 "FStar.TypeChecker.Env.fst"
let glb_delta : delta_level  ->  delta_level  ->  delta_level = (fun d1 d2 -> (match ((d1, d2)) with
| ((NoDelta, _)) | ((_, NoDelta)) -> begin
NoDelta
end
| ((OnlyInline, _)) | ((_, OnlyInline)) -> begin
OnlyInline
end
| (Unfold (l1), Unfold (l2)) -> begin
(
# 176 "FStar.TypeChecker.Env.fst"
let rec aux = (fun l1 l2 -> (match ((l1, l2)) with
| ((FStar_Syntax_Syntax.Delta_constant, _)) | ((_, FStar_Syntax_Syntax.Delta_constant)) -> begin
FStar_Syntax_Syntax.Delta_constant
end
| ((FStar_Syntax_Syntax.Delta_equational, l)) | ((l, FStar_Syntax_Syntax.Delta_equational)) -> begin
l
end
| (FStar_Syntax_Syntax.Delta_unfoldable (i), FStar_Syntax_Syntax.Delta_unfoldable (j)) -> begin
(
# 182 "FStar.TypeChecker.Env.fst"
let k = if (i < j) then begin
i
end else begin
j
end
in FStar_Syntax_Syntax.Delta_unfoldable (k))
end
| (FStar_Syntax_Syntax.Delta_abstract (l1), _52_149) -> begin
(aux l1 l2)
end
| (_52_152, FStar_Syntax_Syntax.Delta_abstract (l2)) -> begin
(aux l1 l2)
end))
in (let _141_387 = (aux l1 l2)
in Unfold (_141_387)))
end))

# 186 "FStar.TypeChecker.Env.fst"
let default_table_size : Prims.int = 200

# 188 "FStar.TypeChecker.Env.fst"
let new_sigtab = (fun _52_156 -> (match (()) with
| () -> begin
(FStar_Util.smap_create default_table_size)
end))

# 189 "FStar.TypeChecker.Env.fst"
let initial_env : (env  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ * guard_t))  ->  solver_t  ->  FStar_Ident.lident  ->  env = (fun tc solver module_lid -> (let _141_409 = (FStar_Util.smap_create 100)
in (let _141_408 = (let _141_405 = (new_sigtab ())
in (_141_405)::[])
in {solver = solver; range = FStar_Range.dummyRange; curmodule = module_lid; gamma = []; gamma_cache = _141_409; modules = []; expected_typ = None; sigtab = _141_408; is_pattern = false; instantiate_imp = true; effects = {decls = []; order = []; joins = []}; generalize = true; letrecs = []; top_level = false; check_uvars = false; use_eq = false; is_iface = false; admit = false; type_of = tc; universe_of = (fun g e -> FStar_Syntax_Syntax.U_zero); use_bv_sorts = false})))

# 213 "FStar.TypeChecker.Env.fst"
let sigtab : env  ->  FStar_Syntax_Syntax.sigelt FStar_Util.smap = (fun env -> (FStar_List.hd env.sigtab))

# 216 "FStar.TypeChecker.Env.fst"
let push : env  ->  Prims.string  ->  env = (fun env msg -> (
# 218 "FStar.TypeChecker.Env.fst"
let _52_165 = (env.solver.push msg)
in (
# 219 "FStar.TypeChecker.Env.fst"
let _52_167 = env
in (let _141_418 = (let _141_417 = (let _141_416 = (sigtab env)
in (FStar_Util.smap_copy _141_416))
in (_141_417)::env.sigtab)
in {solver = _52_167.solver; range = _52_167.range; curmodule = _52_167.curmodule; gamma = _52_167.gamma; gamma_cache = _52_167.gamma_cache; modules = _52_167.modules; expected_typ = _52_167.expected_typ; sigtab = _141_418; is_pattern = _52_167.is_pattern; instantiate_imp = _52_167.instantiate_imp; effects = _52_167.effects; generalize = _52_167.generalize; letrecs = _52_167.letrecs; top_level = _52_167.top_level; check_uvars = _52_167.check_uvars; use_eq = _52_167.use_eq; is_iface = _52_167.is_iface; admit = _52_167.admit; type_of = _52_167.type_of; universe_of = _52_167.universe_of; use_bv_sorts = _52_167.use_bv_sorts}))))

# 219 "FStar.TypeChecker.Env.fst"
let mark : env  ->  env = (fun env -> (
# 221 "FStar.TypeChecker.Env.fst"
let _52_170 = (env.solver.mark "USER MARK")
in (
# 222 "FStar.TypeChecker.Env.fst"
let _52_172 = env
in (let _141_423 = (let _141_422 = (let _141_421 = (sigtab env)
in (FStar_Util.smap_copy _141_421))
in (_141_422)::env.sigtab)
in {solver = _52_172.solver; range = _52_172.range; curmodule = _52_172.curmodule; gamma = _52_172.gamma; gamma_cache = _52_172.gamma_cache; modules = _52_172.modules; expected_typ = _52_172.expected_typ; sigtab = _141_423; is_pattern = _52_172.is_pattern; instantiate_imp = _52_172.instantiate_imp; effects = _52_172.effects; generalize = _52_172.generalize; letrecs = _52_172.letrecs; top_level = _52_172.top_level; check_uvars = _52_172.check_uvars; use_eq = _52_172.use_eq; is_iface = _52_172.is_iface; admit = _52_172.admit; type_of = _52_172.type_of; universe_of = _52_172.universe_of; use_bv_sorts = _52_172.use_bv_sorts}))))

# 222 "FStar.TypeChecker.Env.fst"
let commit_mark : env  ->  env = (fun env -> (
# 224 "FStar.TypeChecker.Env.fst"
let _52_175 = (env.solver.commit_mark "USER MARK")
in (
# 225 "FStar.TypeChecker.Env.fst"
let sigtab = (match (env.sigtab) with
| hd::_52_179::tl -> begin
(hd)::tl
end
| _52_184 -> begin
(FStar_All.failwith "Impossible")
end)
in (
# 228 "FStar.TypeChecker.Env.fst"
let _52_186 = env
in {solver = _52_186.solver; range = _52_186.range; curmodule = _52_186.curmodule; gamma = _52_186.gamma; gamma_cache = _52_186.gamma_cache; modules = _52_186.modules; expected_typ = _52_186.expected_typ; sigtab = sigtab; is_pattern = _52_186.is_pattern; instantiate_imp = _52_186.instantiate_imp; effects = _52_186.effects; generalize = _52_186.generalize; letrecs = _52_186.letrecs; top_level = _52_186.top_level; check_uvars = _52_186.check_uvars; use_eq = _52_186.use_eq; is_iface = _52_186.is_iface; admit = _52_186.admit; type_of = _52_186.type_of; universe_of = _52_186.universe_of; use_bv_sorts = _52_186.use_bv_sorts}))))

# 228 "FStar.TypeChecker.Env.fst"
let reset_mark : env  ->  env = (fun env -> (
# 230 "FStar.TypeChecker.Env.fst"
let _52_189 = (env.solver.reset_mark "USER MARK")
in (
# 231 "FStar.TypeChecker.Env.fst"
let _52_191 = env
in (let _141_428 = (FStar_List.tl env.sigtab)
in {solver = _52_191.solver; range = _52_191.range; curmodule = _52_191.curmodule; gamma = _52_191.gamma; gamma_cache = _52_191.gamma_cache; modules = _52_191.modules; expected_typ = _52_191.expected_typ; sigtab = _141_428; is_pattern = _52_191.is_pattern; instantiate_imp = _52_191.instantiate_imp; effects = _52_191.effects; generalize = _52_191.generalize; letrecs = _52_191.letrecs; top_level = _52_191.top_level; check_uvars = _52_191.check_uvars; use_eq = _52_191.use_eq; is_iface = _52_191.is_iface; admit = _52_191.admit; type_of = _52_191.type_of; universe_of = _52_191.universe_of; use_bv_sorts = _52_191.use_bv_sorts}))))

# 231 "FStar.TypeChecker.Env.fst"
let pop : env  ->  Prims.string  ->  env = (fun env msg -> (match (env.sigtab) with
| ([]) | (_::[]) -> begin
(FStar_All.failwith "Too many pops")
end
| _52_201::tl -> begin
(
# 236 "FStar.TypeChecker.Env.fst"
let _52_203 = (env.solver.pop msg)
in (
# 237 "FStar.TypeChecker.Env.fst"
let _52_205 = env
in {solver = _52_205.solver; range = _52_205.range; curmodule = _52_205.curmodule; gamma = _52_205.gamma; gamma_cache = _52_205.gamma_cache; modules = _52_205.modules; expected_typ = _52_205.expected_typ; sigtab = tl; is_pattern = _52_205.is_pattern; instantiate_imp = _52_205.instantiate_imp; effects = _52_205.effects; generalize = _52_205.generalize; letrecs = _52_205.letrecs; top_level = _52_205.top_level; check_uvars = _52_205.check_uvars; use_eq = _52_205.use_eq; is_iface = _52_205.is_iface; admit = _52_205.admit; type_of = _52_205.type_of; universe_of = _52_205.universe_of; use_bv_sorts = _52_205.use_bv_sorts}))
end))

# 237 "FStar.TypeChecker.Env.fst"
let debug : env  ->  FStar_Options.debug_level_t  ->  Prims.bool = (fun env l -> ((let _141_438 = (FStar_ST.read FStar_Options.debug)
in (FStar_All.pipe_right _141_438 (FStar_Util.for_some (fun x -> ((env.curmodule.FStar_Ident.str = "") || (env.curmodule.FStar_Ident.str = x)))))) && (FStar_Options.debug_level_geq l)))

# 244 "FStar.TypeChecker.Env.fst"
let set_range : env  ->  FStar_Range.range  ->  env = (fun e r -> if (r = FStar_Range.dummyRange) then begin
e
end else begin
(
# 245 "FStar.TypeChecker.Env.fst"
let _52_212 = e
in {solver = _52_212.solver; range = r; curmodule = _52_212.curmodule; gamma = _52_212.gamma; gamma_cache = _52_212.gamma_cache; modules = _52_212.modules; expected_typ = _52_212.expected_typ; sigtab = _52_212.sigtab; is_pattern = _52_212.is_pattern; instantiate_imp = _52_212.instantiate_imp; effects = _52_212.effects; generalize = _52_212.generalize; letrecs = _52_212.letrecs; top_level = _52_212.top_level; check_uvars = _52_212.check_uvars; use_eq = _52_212.use_eq; is_iface = _52_212.is_iface; admit = _52_212.admit; type_of = _52_212.type_of; universe_of = _52_212.universe_of; use_bv_sorts = _52_212.use_bv_sorts})
end)

# 245 "FStar.TypeChecker.Env.fst"
let get_range : env  ->  FStar_Range.range = (fun e -> e.range)

# 246 "FStar.TypeChecker.Env.fst"
let modules : env  ->  FStar_Syntax_Syntax.modul Prims.list = (fun env -> env.modules)

# 251 "FStar.TypeChecker.Env.fst"
let current_module : env  ->  FStar_Ident.lident = (fun env -> env.curmodule)

# 252 "FStar.TypeChecker.Env.fst"
let set_current_module : env  ->  FStar_Ident.lident  ->  env = (fun env lid -> (
# 253 "FStar.TypeChecker.Env.fst"
let _52_219 = env
in {solver = _52_219.solver; range = _52_219.range; curmodule = lid; gamma = _52_219.gamma; gamma_cache = _52_219.gamma_cache; modules = _52_219.modules; expected_typ = _52_219.expected_typ; sigtab = _52_219.sigtab; is_pattern = _52_219.is_pattern; instantiate_imp = _52_219.instantiate_imp; effects = _52_219.effects; generalize = _52_219.generalize; letrecs = _52_219.letrecs; top_level = _52_219.top_level; check_uvars = _52_219.check_uvars; use_eq = _52_219.use_eq; is_iface = _52_219.is_iface; admit = _52_219.admit; type_of = _52_219.type_of; universe_of = _52_219.universe_of; use_bv_sorts = _52_219.use_bv_sorts}))

# 253 "FStar.TypeChecker.Env.fst"
let has_interface : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env l -> (FStar_All.pipe_right env.modules (FStar_Util.for_some (fun m -> (m.FStar_Syntax_Syntax.is_interface && (FStar_Ident.lid_equals m.FStar_Syntax_Syntax.name l))))))

# 254 "FStar.TypeChecker.Env.fst"
let find_in_sigtab : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.sigelt Prims.option = (fun env lid -> (let _141_462 = (sigtab env)
in (FStar_Util.smap_try_find _141_462 (FStar_Ident.text_of_lid lid))))

# 255 "FStar.TypeChecker.Env.fst"
let name_not_found : FStar_Ident.lid  ->  Prims.string = (fun l -> (FStar_Util.format1 "Name \"%s\" not found" l.FStar_Ident.str))

# 258 "FStar.TypeChecker.Env.fst"
let variable_not_found : FStar_Syntax_Syntax.bv  ->  Prims.string = (fun v -> (let _141_467 = (FStar_Syntax_Print.bv_to_string v)
in (FStar_Util.format1 "Variable \"%s\" not found" _141_467)))

# 261 "FStar.TypeChecker.Env.fst"
let new_u_univ = (fun _52_228 -> (let _141_469 = (FStar_Unionfind.fresh None)
in FStar_Syntax_Syntax.U_unif (_141_469)))

# 264 "FStar.TypeChecker.Env.fst"
let inst_tscheme_with : FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.universes  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.term) = (fun ts us -> (match ((ts, us)) with
| (([], t), []) -> begin
([], t)
end
| ((formals, t), _52_241) -> begin
(
# 271 "FStar.TypeChecker.Env.fst"
let _52_243 = ()
in (
# 272 "FStar.TypeChecker.Env.fst"
let n = ((FStar_List.length formals) - 1)
in (
# 273 "FStar.TypeChecker.Env.fst"
let vs = (FStar_All.pipe_right us (FStar_List.mapi (fun i u -> FStar_Syntax_Syntax.UN (((n - i), u)))))
in (let _141_476 = (FStar_Syntax_Subst.subst vs t)
in (us, _141_476)))))
end))

# 274 "FStar.TypeChecker.Env.fst"
let inst_tscheme : FStar_Syntax_Syntax.tscheme  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.term) = (fun _52_1 -> (match (_52_1) with
| ([], t) -> begin
([], t)
end
| (us, t) -> begin
(
# 280 "FStar.TypeChecker.Env.fst"
let us' = (FStar_All.pipe_right us (FStar_List.map (fun _52_256 -> (new_u_univ ()))))
in (inst_tscheme_with (us, t) us'))
end))

# 281 "FStar.TypeChecker.Env.fst"
let inst_effect_fun_with : FStar_Syntax_Syntax.universes  ->  env  ->  FStar_Syntax_Syntax.eff_decl  ->  FStar_Syntax_Syntax.tscheme  ->  FStar_Syntax_Syntax.term = (fun insts env ed _52_264 -> (match (_52_264) with
| (us, t) -> begin
(match (ed.FStar_Syntax_Syntax.binders) with
| [] -> begin
(
# 286 "FStar.TypeChecker.Env.fst"
let univs = (FStar_List.append ed.FStar_Syntax_Syntax.univs us)
in (
# 287 "FStar.TypeChecker.Env.fst"
let _52_267 = if ((FStar_List.length insts) <> (FStar_List.length univs)) then begin
(let _141_492 = (let _141_491 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length univs))
in (let _141_490 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length insts))
in (let _141_489 = (FStar_Syntax_Print.lid_to_string ed.FStar_Syntax_Syntax.mname)
in (let _141_488 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.format4 "Expected %s instantiations; got %s; failed universe instantiation in effect %s\n\t%s\n" _141_491 _141_490 _141_489 _141_488)))))
in (FStar_All.failwith _141_492))
end else begin
()
end
in (let _141_493 = (inst_tscheme_with ((FStar_List.append ed.FStar_Syntax_Syntax.univs us), t) insts)
in (Prims.snd _141_493))))
end
| _52_270 -> begin
(let _141_495 = (let _141_494 = (FStar_Syntax_Print.lid_to_string ed.FStar_Syntax_Syntax.mname)
in (FStar_Util.format1 "Unexpected use of an uninstantiated effect: %s\n" _141_494))
in (FStar_All.failwith _141_495))
end)
end))

# 292 "FStar.TypeChecker.Env.fst"
type tri =
| Yes
| No
| Maybe

# 295 "FStar.TypeChecker.Env.fst"
let is_Yes = (fun _discr_ -> (match (_discr_) with
| Yes (_) -> begin
true
end
| _ -> begin
false
end))

# 296 "FStar.TypeChecker.Env.fst"
let is_No = (fun _discr_ -> (match (_discr_) with
| No (_) -> begin
true
end
| _ -> begin
false
end))

# 297 "FStar.TypeChecker.Env.fst"
let is_Maybe = (fun _discr_ -> (match (_discr_) with
| Maybe (_) -> begin
true
end
| _ -> begin
false
end))

# 297 "FStar.TypeChecker.Env.fst"
let in_cur_mod : env  ->  FStar_Ident.lident  ->  tri = (fun env l -> (
# 300 "FStar.TypeChecker.Env.fst"
let cur = (current_module env)
in if (l.FStar_Ident.nsstr = cur.FStar_Ident.str) then begin
Yes
end else begin
if (FStar_Util.starts_with l.FStar_Ident.nsstr cur.FStar_Ident.str) then begin
(
# 303 "FStar.TypeChecker.Env.fst"
let lns = (FStar_List.append l.FStar_Ident.ns ((l.FStar_Ident.ident)::[]))
in (
# 304 "FStar.TypeChecker.Env.fst"
let cur = (FStar_List.append cur.FStar_Ident.ns ((cur.FStar_Ident.ident)::[]))
in (
# 305 "FStar.TypeChecker.Env.fst"
let rec aux = (fun c l -> (match ((c, l)) with
| ([], _52_281) -> begin
Maybe
end
| (_52_284, []) -> begin
No
end
| (hd::tl, hd'::tl') when (hd.FStar_Ident.idText = hd'.FStar_Ident.idText) -> begin
(aux tl tl')
end
| _52_295 -> begin
No
end))
in (aux cur lns))))
end else begin
No
end
end))

# 311 "FStar.TypeChecker.Env.fst"
let lookup_qname : env  ->  FStar_Ident.lident  ->  ((FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ), (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universes Prims.option)) FStar_Util.either Prims.option = (fun env lid -> (
# 314 "FStar.TypeChecker.Env.fst"
let cur_mod = (in_cur_mod env lid)
in (
# 315 "FStar.TypeChecker.Env.fst"
let cache = (fun t -> (
# 315 "FStar.TypeChecker.Env.fst"
let _52_301 = (FStar_Util.smap_add env.gamma_cache lid.FStar_Ident.str t)
in Some (t)))
in (
# 316 "FStar.TypeChecker.Env.fst"
let found = if (cur_mod <> No) then begin
(match ((FStar_Util.smap_try_find env.gamma_cache lid.FStar_Ident.str)) with
| None -> begin
(FStar_Util.find_map env.gamma (fun _52_2 -> (match (_52_2) with
| Binding_lid (l, t) -> begin
if (FStar_Ident.lid_equals lid l) then begin
(let _141_515 = (let _141_514 = (inst_tscheme t)
in FStar_Util.Inl (_141_514))
in Some (_141_515))
end else begin
None
end
end
| Binding_sig (_52_310, FStar_Syntax_Syntax.Sig_bundle (ses, _52_313, _52_315, _52_317)) -> begin
(FStar_Util.find_map ses (fun se -> if (let _141_517 = (FStar_Syntax_Util.lids_of_sigelt se)
in (FStar_All.pipe_right _141_517 (FStar_Util.for_some (FStar_Ident.lid_equals lid)))) then begin
(cache (FStar_Util.Inr ((se, None))))
end else begin
None
end))
end
| Binding_sig (lids, s) -> begin
(
# 327 "FStar.TypeChecker.Env.fst"
let maybe_cache = (fun t -> (match (s) with
| FStar_Syntax_Syntax.Sig_declare_typ (_52_330) -> begin
Some (t)
end
| _52_333 -> begin
(cache t)
end))
in if (FStar_All.pipe_right lids (FStar_Util.for_some (FStar_Ident.lid_equals lid))) then begin
(maybe_cache (FStar_Util.Inr ((s, None))))
end else begin
None
end)
end
| Binding_sig_inst (lids, s, us) -> begin
if (FStar_All.pipe_right lids (FStar_Util.for_some (FStar_Ident.lid_equals lid))) then begin
Some (FStar_Util.Inr ((s, Some (us))))
end else begin
None
end
end
| _52_340 -> begin
None
end)))
end
| se -> begin
se
end)
end else begin
None
end
in if (FStar_Util.is_some found) then begin
found
end else begin
if ((cur_mod <> Yes) || (has_interface env env.curmodule)) then begin
(match ((find_in_sigtab env lid)) with
| Some (se) -> begin
Some (FStar_Util.Inr ((se, None)))
end
| None -> begin
None
end)
end else begin
None
end
end))))

# 342 "FStar.TypeChecker.Env.fst"
let lid_exists : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env l -> (match ((lookup_qname env l)) with
| None -> begin
false
end
| Some (_52_350) -> begin
true
end))

# 346 "FStar.TypeChecker.Env.fst"
let rec add_sigelt : env  ->  FStar_Syntax_Syntax.sigelt  ->  Prims.unit = (fun env se -> (match (se) with
| FStar_Syntax_Syntax.Sig_bundle (ses, _52_356, _52_358, _52_360) -> begin
(add_sigelts env ses)
end
| _52_364 -> begin
(
# 351 "FStar.TypeChecker.Env.fst"
let lids = (FStar_Syntax_Util.lids_of_sigelt se)
in (FStar_List.iter (fun l -> (let _141_531 = (sigtab env)
in (FStar_Util.smap_add _141_531 l.FStar_Ident.str se))) lids))
end))
and add_sigelts : env  ->  FStar_Syntax_Syntax.sigelt Prims.list  ->  Prims.unit = (fun env ses -> (FStar_All.pipe_right ses (FStar_List.iter (add_sigelt env))))

# 355 "FStar.TypeChecker.Env.fst"
let try_lookup_bv : env  ->  FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.term Prims.option = (fun env bv -> (FStar_Util.find_map env.gamma (fun _52_3 -> (match (_52_3) with
| Binding_var (id) when (FStar_Syntax_Syntax.bv_eq id bv) -> begin
Some (id.FStar_Syntax_Syntax.sort)
end
| _52_375 -> begin
None
end))))

# 364 "FStar.TypeChecker.Env.fst"
let lookup_univ : env  ->  FStar_Syntax_Syntax.univ_name  ->  Prims.bool = (fun env x -> (FStar_All.pipe_right (FStar_List.find (fun _52_4 -> (match (_52_4) with
| Binding_univ (y) -> begin
(x.FStar_Ident.idText = y.FStar_Ident.idText)
end
| _52_382 -> begin
false
end)) env.gamma) FStar_Option.isSome))

# 370 "FStar.TypeChecker.Env.fst"
let lookup_type_of_let : FStar_Syntax_Syntax.sigelt  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.term) Prims.option = (fun se lid -> (match (se) with
| FStar_Syntax_Syntax.Sig_let ((_52_386, lb::[]), _52_391, _52_393, _52_395) -> begin
(let _141_551 = (inst_tscheme (lb.FStar_Syntax_Syntax.lbunivs, lb.FStar_Syntax_Syntax.lbtyp))
in Some (_141_551))
end
| FStar_Syntax_Syntax.Sig_let ((_52_399, lbs), _52_403, _52_405, _52_407) -> begin
(FStar_Util.find_map lbs (fun lb -> (match (lb.FStar_Syntax_Syntax.lbname) with
| FStar_Util.Inl (_52_412) -> begin
(FStar_All.failwith "impossible")
end
| FStar_Util.Inr (fv) -> begin
if (FStar_Syntax_Syntax.fv_eq_lid fv lid) then begin
(let _141_553 = (inst_tscheme (lb.FStar_Syntax_Syntax.lbunivs, lb.FStar_Syntax_Syntax.lbtyp))
in Some (_141_553))
end else begin
None
end
end)))
end
| _52_417 -> begin
None
end))

# 384 "FStar.TypeChecker.Env.fst"
let lookup_bv : env  ->  FStar_Syntax_Syntax.bv  ->  FStar_Syntax_Syntax.typ = (fun env bv -> (match ((try_lookup_bv env bv)) with
| None -> begin
(let _141_561 = (let _141_560 = (let _141_559 = (variable_not_found bv)
in (let _141_558 = (FStar_Syntax_Syntax.range_of_bv bv)
in (_141_559, _141_558)))
in FStar_Syntax_Syntax.Error (_141_560))
in (Prims.raise _141_561))
end
| Some (t) -> begin
t
end))

# 389 "FStar.TypeChecker.Env.fst"
let effect_signature : FStar_Syntax_Syntax.sigelt  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.term) Prims.option = (fun se -> (match (se) with
| FStar_Syntax_Syntax.Sig_new_effect (ne, _52_426) -> begin
(let _141_567 = (let _141_566 = (let _141_565 = (let _141_564 = (FStar_Syntax_Syntax.mk_Total ne.FStar_Syntax_Syntax.signature)
in (FStar_Syntax_Util.arrow ne.FStar_Syntax_Syntax.binders _141_564))
in (ne.FStar_Syntax_Syntax.univs, _141_565))
in (inst_tscheme _141_566))
in Some (_141_567))
end
| FStar_Syntax_Syntax.Sig_effect_abbrev (lid, us, binders, _52_433, _52_435, _52_437) -> begin
(let _141_571 = (let _141_570 = (let _141_569 = (let _141_568 = (FStar_Syntax_Syntax.mk_Total FStar_Syntax_Syntax.teff)
in (FStar_Syntax_Util.arrow binders _141_568))
in (us, _141_569))
in (inst_tscheme _141_570))
in Some (_141_571))
end
| _52_441 -> begin
None
end))

# 399 "FStar.TypeChecker.Env.fst"
let try_lookup_effect_lid : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.term Prims.option = (fun env ftv -> (match ((lookup_qname env ftv)) with
| Some (FStar_Util.Inr (se, None)) -> begin
(match ((effect_signature se)) with
| None -> begin
None
end
| Some (_52_451, t) -> begin
Some (t)
end)
end
| _52_456 -> begin
None
end))

# 408 "FStar.TypeChecker.Env.fst"
let try_lookup_lid : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ) Prims.option = (fun env lid -> (
# 411 "FStar.TypeChecker.Env.fst"
let mapper = (fun _52_5 -> (match (_52_5) with
| FStar_Util.Inl (t) -> begin
Some (t)
end
| FStar_Util.Inr (FStar_Syntax_Syntax.Sig_datacon (_52_463, uvs, t, _52_467, _52_469, _52_471, _52_473, _52_475), None) -> begin
(let _141_582 = (inst_tscheme (uvs, t))
in Some (_141_582))
end
| FStar_Util.Inr (FStar_Syntax_Syntax.Sig_declare_typ (l, uvs, t, qs, _52_486), None) -> begin
if ((in_cur_mod env l) = Yes) then begin
if ((FStar_All.pipe_right qs (FStar_List.contains FStar_Syntax_Syntax.Assumption)) || env.is_iface) then begin
(let _141_583 = (inst_tscheme (uvs, t))
in Some (_141_583))
end else begin
None
end
end else begin
(let _141_584 = (inst_tscheme (uvs, t))
in Some (_141_584))
end
end
| FStar_Util.Inr (FStar_Syntax_Syntax.Sig_inductive_typ (lid, uvs, tps, k, _52_497, _52_499, _52_501, _52_503), None) -> begin
(match (tps) with
| [] -> begin
(let _141_586 = (inst_tscheme (uvs, k))
in (FStar_All.pipe_left (fun _141_585 -> Some (_141_585)) _141_586))
end
| _52_511 -> begin
(let _141_591 = (let _141_590 = (let _141_589 = (let _141_588 = (FStar_Syntax_Syntax.mk_Total k)
in (FStar_Syntax_Util.arrow tps _141_588))
in (uvs, _141_589))
in (inst_tscheme _141_590))
in (FStar_All.pipe_left (fun _141_587 -> Some (_141_587)) _141_591))
end)
end
| FStar_Util.Inr (FStar_Syntax_Syntax.Sig_inductive_typ (lid, uvs, tps, k, _52_517, _52_519, _52_521, _52_523), Some (us)) -> begin
(match (tps) with
| [] -> begin
(let _141_593 = (inst_tscheme_with (uvs, k) us)
in (FStar_All.pipe_left (fun _141_592 -> Some (_141_592)) _141_593))
end
| _52_532 -> begin
(let _141_598 = (let _141_597 = (let _141_596 = (let _141_595 = (FStar_Syntax_Syntax.mk_Total k)
in (FStar_Syntax_Util.arrow tps _141_595))
in (uvs, _141_596))
in (inst_tscheme_with _141_597 us))
in (FStar_All.pipe_left (fun _141_594 -> Some (_141_594)) _141_598))
end)
end
| FStar_Util.Inr (se) -> begin
(match (se) with
| (FStar_Syntax_Syntax.Sig_let (_52_536), None) -> begin
(lookup_type_of_let (Prims.fst se) lid)
end
| _52_541 -> begin
(effect_signature (Prims.fst se))
end)
end))
in (match ((let _141_599 = (lookup_qname env lid)
in (FStar_Util.bind_opt _141_599 mapper))) with
| Some (us, t) -> begin
Some ((us, (
# 445 "FStar.TypeChecker.Env.fst"
let _52_547 = t
in {FStar_Syntax_Syntax.n = _52_547.FStar_Syntax_Syntax.n; FStar_Syntax_Syntax.tk = _52_547.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = (FStar_Ident.range_of_lid lid); FStar_Syntax_Syntax.vars = _52_547.FStar_Syntax_Syntax.vars})))
end
| None -> begin
None
end)))

# 446 "FStar.TypeChecker.Env.fst"
let is_type_constructor : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env lid -> (
# 449 "FStar.TypeChecker.Env.fst"
let mapper = (fun _52_6 -> (match (_52_6) with
| FStar_Util.Inl (_52_554) -> begin
Some (false)
end
| FStar_Util.Inr (se, _52_558) -> begin
(match (se) with
| FStar_Syntax_Syntax.Sig_declare_typ (_52_562, _52_564, _52_566, qs, _52_569) -> begin
Some ((FStar_List.contains FStar_Syntax_Syntax.New qs))
end
| FStar_Syntax_Syntax.Sig_inductive_typ (_52_573) -> begin
Some (true)
end
| _52_576 -> begin
Some (false)
end)
end))
in (match ((let _141_606 = (lookup_qname env lid)
in (FStar_Util.bind_opt _141_606 mapper))) with
| Some (b) -> begin
b
end
| None -> begin
false
end)))

# 461 "FStar.TypeChecker.Env.fst"
let lookup_lid : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ) = (fun env l -> (match ((try_lookup_lid env l)) with
| None -> begin
(let _141_613 = (let _141_612 = (let _141_611 = (name_not_found l)
in (_141_611, (FStar_Ident.range_of_lid l)))
in FStar_Syntax_Syntax.Error (_141_612))
in (Prims.raise _141_613))
end
| Some (x) -> begin
x
end))

# 467 "FStar.TypeChecker.Env.fst"
let lookup_val_decl : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ) = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_declare_typ (_52_589, uvs, t, _52_593, _52_595), None)) -> begin
(inst_tscheme (uvs, t))
end
| _52_603 -> begin
(let _141_620 = (let _141_619 = (let _141_618 = (name_not_found lid)
in (_141_618, (FStar_Ident.range_of_lid lid)))
in FStar_Syntax_Syntax.Error (_141_619))
in (Prims.raise _141_620))
end))

# 472 "FStar.TypeChecker.Env.fst"
let lookup_datacon : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.universes * FStar_Syntax_Syntax.typ) = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_datacon (_52_607, uvs, t, _52_611, _52_613, _52_615, _52_617, _52_619), None)) -> begin
(inst_tscheme (uvs, t))
end
| _52_627 -> begin
(let _141_627 = (let _141_626 = (let _141_625 = (name_not_found lid)
in (_141_625, (FStar_Ident.range_of_lid lid)))
in FStar_Syntax_Syntax.Error (_141_626))
in (Prims.raise _141_627))
end))

# 477 "FStar.TypeChecker.Env.fst"
let lookup_definition : delta_level  ->  env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.univ_names * FStar_Syntax_Syntax.term) Prims.option = (fun delta_level env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (se, None)) -> begin
(match (se) with
| FStar_Syntax_Syntax.Sig_let ((_52_637, lbs), _52_641, _52_643, quals) when (FStar_Util.for_some (visible_at delta_level) quals) -> begin
(FStar_Util.find_map lbs (fun lb -> (
# 485 "FStar.TypeChecker.Env.fst"
let fv = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in if (FStar_Syntax_Syntax.fv_eq_lid fv lid) then begin
(let _141_636 = (let _141_635 = (FStar_Syntax_Util.unascribe lb.FStar_Syntax_Syntax.lbdef)
in (lb.FStar_Syntax_Syntax.lbunivs, _141_635))
in Some (_141_636))
end else begin
None
end)))
end
| _52_650 -> begin
None
end)
end
| _52_652 -> begin
None
end))

# 491 "FStar.TypeChecker.Env.fst"
let lookup_effect_lid : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.term = (fun env ftv -> (match ((try_lookup_effect_lid env ftv)) with
| None -> begin
(let _141_643 = (let _141_642 = (let _141_641 = (name_not_found ftv)
in (_141_641, (FStar_Ident.range_of_lid ftv)))
in FStar_Syntax_Syntax.Error (_141_642))
in (Prims.raise _141_643))
end
| Some (k) -> begin
k
end))

# 496 "FStar.TypeChecker.Env.fst"
let lookup_projector : env  ->  FStar_Ident.lident  ->  Prims.int  ->  FStar_Ident.lident = (fun env lid i -> (
# 499 "FStar.TypeChecker.Env.fst"
let fail = (fun _52_662 -> (match (()) with
| () -> begin
(let _141_654 = (let _141_653 = (FStar_Util.string_of_int i)
in (let _141_652 = (FStar_Syntax_Print.lid_to_string lid)
in (FStar_Util.format2 "Impossible: projecting field #%s from constructor %s is undefined" _141_653 _141_652)))
in (FStar_All.failwith _141_654))
end))
in (
# 500 "FStar.TypeChecker.Env.fst"
let _52_666 = (lookup_datacon env lid)
in (match (_52_666) with
| (_52_664, t) -> begin
(match ((let _141_655 = (FStar_Syntax_Subst.compress t)
in _141_655.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (binders, _52_669) -> begin
if ((i < 0) || (i >= (FStar_List.length binders))) then begin
(fail ())
end else begin
(
# 505 "FStar.TypeChecker.Env.fst"
let b = (FStar_List.nth binders i)
in (let _141_656 = (FStar_Syntax_Util.mk_field_projector_name lid (Prims.fst b) i)
in (FStar_All.pipe_right _141_656 Prims.fst)))
end
end
| _52_674 -> begin
(fail ())
end)
end))))

# 507 "FStar.TypeChecker.Env.fst"
let try_lookup_val_decl : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.tscheme * FStar_Syntax_Syntax.qualifier Prims.list) Prims.option = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_declare_typ (_52_678, uvs, t, q, _52_683), None)) -> begin
Some (((uvs, t), q))
end
| _52_691 -> begin
None
end))

# 512 "FStar.TypeChecker.Env.fst"
let lookup_effect_abbrev : env  ->  FStar_Syntax_Syntax.universe  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.comp) Prims.option = (fun env univ lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_effect_abbrev (lid, univs, binders, c, quals, _52_701), None)) -> begin
if (FStar_All.pipe_right quals (FStar_Util.for_some (fun _52_7 -> (match (_52_7) with
| FStar_Syntax_Syntax.Irreducible -> begin
true
end
| _52_711 -> begin
false
end)))) then begin
None
end else begin
(
# 519 "FStar.TypeChecker.Env.fst"
let insts = if (FStar_Ident.lid_equals lid FStar_Syntax_Const.effect_Lemma_lid) then begin
(univ)::(FStar_Syntax_Syntax.U_zero)::[]
end else begin
(univ)::[]
end
in (match ((binders, univs)) with
| ([], _52_715) -> begin
(FStar_All.failwith "Unexpected effect abbreviation with no arguments")
end
| (_52_718, _52_725::_52_722::_52_720) when (not ((FStar_Ident.lid_equals lid FStar_Syntax_Const.effect_Lemma_lid))) -> begin
(let _141_670 = (let _141_669 = (FStar_Syntax_Print.lid_to_string lid)
in (let _141_668 = (FStar_All.pipe_left FStar_Util.string_of_int (FStar_List.length univs))
in (FStar_Util.format2 "Unexpected effect abbreviation %s; polymorphic in %s universes" _141_669 _141_668)))
in (FStar_All.failwith _141_670))
end
| _52_729 -> begin
(
# 527 "FStar.TypeChecker.Env.fst"
let _52_733 = (let _141_672 = (let _141_671 = (FStar_Syntax_Util.arrow binders c)
in (univs, _141_671))
in (inst_tscheme_with _141_672 insts))
in (match (_52_733) with
| (_52_731, t) -> begin
(match ((let _141_673 = (FStar_Syntax_Subst.compress t)
in _141_673.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (binders, c) -> begin
Some ((binders, c))
end
| _52_739 -> begin
(FStar_All.failwith "Impossible")
end)
end))
end))
end
end
| _52_741 -> begin
None
end))

# 534 "FStar.TypeChecker.Env.fst"
let datacons_of_typ : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident Prims.list = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_inductive_typ (_52_745, _52_747, _52_749, _52_751, _52_753, dcs, _52_756, _52_758), _52_762)) -> begin
dcs
end
| _52_767 -> begin
[]
end))

# 539 "FStar.TypeChecker.Env.fst"
let typ_of_datacon : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_datacon (_52_771, _52_773, _52_775, l, _52_778, _52_780, _52_782, _52_784), _52_788)) -> begin
l
end
| _52_793 -> begin
(let _141_683 = (let _141_682 = (FStar_Syntax_Print.lid_to_string lid)
in (FStar_Util.format1 "Not a datacon: %s" _141_682))
in (FStar_All.failwith _141_683))
end))

# 544 "FStar.TypeChecker.Env.fst"
let is_datacon : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_datacon (_52_797, _52_799, _52_801, _52_803, _52_805, _52_807, _52_809, _52_811), _52_815)) -> begin
true
end
| _52_820 -> begin
false
end))

# 549 "FStar.TypeChecker.Env.fst"
let is_record : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env lid -> (match ((lookup_qname env lid)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_inductive_typ (_52_824, _52_826, _52_828, _52_830, _52_832, _52_834, tags, _52_837), _52_841)) -> begin
(FStar_Util.for_some (fun _52_8 -> (match (_52_8) with
| (FStar_Syntax_Syntax.RecordType (_)) | (FStar_Syntax_Syntax.RecordConstructor (_)) -> begin
true
end
| _52_853 -> begin
false
end)) tags)
end
| _52_855 -> begin
false
end))

# 555 "FStar.TypeChecker.Env.fst"
let is_projector : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env l -> (match ((lookup_qname env l)) with
| Some (FStar_Util.Inr (FStar_Syntax_Syntax.Sig_declare_typ (_52_859, _52_861, _52_863, quals, _52_866), _52_870)) -> begin
(FStar_Util.for_some (fun _52_9 -> (match (_52_9) with
| FStar_Syntax_Syntax.Projector (_52_876) -> begin
true
end
| _52_879 -> begin
false
end)) quals)
end
| _52_881 -> begin
false
end))

# 561 "FStar.TypeChecker.Env.fst"
let interpreted_symbols : FStar_Ident.lident Prims.list = (FStar_Syntax_Const.op_Eq)::(FStar_Syntax_Const.op_notEq)::(FStar_Syntax_Const.op_LT)::(FStar_Syntax_Const.op_LTE)::(FStar_Syntax_Const.op_GT)::(FStar_Syntax_Const.op_GTE)::(FStar_Syntax_Const.op_Subtraction)::(FStar_Syntax_Const.op_Minus)::(FStar_Syntax_Const.op_Addition)::(FStar_Syntax_Const.op_Multiply)::(FStar_Syntax_Const.op_Division)::(FStar_Syntax_Const.op_Modulus)::(FStar_Syntax_Const.op_And)::(FStar_Syntax_Const.op_Or)::(FStar_Syntax_Const.op_Negation)::[]

# 578 "FStar.TypeChecker.Env.fst"
let is_interpreted : env  ->  FStar_Syntax_Syntax.term  ->  Prims.bool = (fun env head -> (match ((let _141_702 = (FStar_Syntax_Util.un_uinst head)
in _141_702.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar (fv) -> begin
(fv.FStar_Syntax_Syntax.fv_delta = FStar_Syntax_Syntax.Delta_equational)
end
| _52_887 -> begin
false
end))

# 585 "FStar.TypeChecker.Env.fst"
let effect_decl_opt : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.eff_decl Prims.option = (fun env l -> (FStar_All.pipe_right env.effects.decls (FStar_Util.find_opt (fun d -> (FStar_Ident.lid_equals d.FStar_Syntax_Syntax.mname l)))))

# 591 "FStar.TypeChecker.Env.fst"
let get_effect_decl : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.eff_decl = (fun env l -> (match ((effect_decl_opt env l)) with
| None -> begin
(let _141_714 = (let _141_713 = (let _141_712 = (name_not_found l)
in (_141_712, (FStar_Ident.range_of_lid l)))
in FStar_Syntax_Syntax.Error (_141_713))
in (Prims.raise _141_714))
end
| Some (md) -> begin
md
end))

# 596 "FStar.TypeChecker.Env.fst"
let join : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident  ->  (FStar_Ident.lident * mlift * mlift) = (fun env l1 l2 -> if (FStar_Ident.lid_equals l1 l2) then begin
(l1, (fun t wp -> wp), (fun t wp -> wp))
end else begin
if (((FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_GTot_lid) && (FStar_Ident.lid_equals l2 FStar_Syntax_Const.effect_Tot_lid)) || ((FStar_Ident.lid_equals l2 FStar_Syntax_Const.effect_GTot_lid) && (FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_Tot_lid))) then begin
(FStar_Syntax_Const.effect_GTot_lid, (fun t wp -> wp), (fun t wp -> wp))
end else begin
(match ((FStar_All.pipe_right env.effects.joins (FStar_Util.find_opt (fun _52_915 -> (match (_52_915) with
| (m1, m2, _52_910, _52_912, _52_914) -> begin
((FStar_Ident.lid_equals l1 m1) && (FStar_Ident.lid_equals l2 m2))
end))))) with
| None -> begin
(let _141_790 = (let _141_789 = (let _141_788 = (let _141_787 = (FStar_Syntax_Print.lid_to_string l1)
in (let _141_786 = (FStar_Syntax_Print.lid_to_string l2)
in (FStar_Util.format2 "Effects %s and %s cannot be composed" _141_787 _141_786)))
in (_141_788, env.range))
in FStar_Syntax_Syntax.Error (_141_789))
in (Prims.raise _141_790))
end
| Some (_52_918, _52_920, m3, j1, j2) -> begin
(m3, j1, j2)
end)
end
end)

# 606 "FStar.TypeChecker.Env.fst"
let monad_leq : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident  ->  edge Prims.option = (fun env l1 l2 -> if ((FStar_Ident.lid_equals l1 l2) || ((FStar_Ident.lid_equals l1 FStar_Syntax_Const.effect_Tot_lid) && (FStar_Ident.lid_equals l2 FStar_Syntax_Const.effect_GTot_lid))) then begin
Some ({msource = l1; mtarget = l2; mlift = (fun t wp -> wp)})
end else begin
(FStar_All.pipe_right env.effects.order (FStar_Util.find_opt (fun e -> ((FStar_Ident.lid_equals l1 e.msource) && (FStar_Ident.lid_equals l2 e.mtarget)))))
end)

# 612 "FStar.TypeChecker.Env.fst"
let wp_sig_aux : FStar_Syntax_Syntax.eff_decl Prims.list  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.term) = (fun decls m -> (match ((FStar_All.pipe_right decls (FStar_Util.find_opt (fun d -> (FStar_Ident.lid_equals d.FStar_Syntax_Syntax.mname m))))) with
| None -> begin
(let _141_805 = (FStar_Util.format1 "Impossible: declaration for monad %s not found" m.FStar_Ident.str)
in (FStar_All.failwith _141_805))
end
| Some (md) -> begin
(
# 618 "FStar.TypeChecker.Env.fst"
let _52_941 = (inst_tscheme (md.FStar_Syntax_Syntax.univs, md.FStar_Syntax_Syntax.signature))
in (match (_52_941) with
| (_52_939, s) -> begin
(
# 619 "FStar.TypeChecker.Env.fst"
let s = (FStar_Syntax_Subst.compress s)
in (match ((md.FStar_Syntax_Syntax.binders, s.FStar_Syntax_Syntax.n)) with
| ([], FStar_Syntax_Syntax.Tm_arrow ((a, _52_954)::(wp, _52_950)::(wlp, _52_946)::[], c)) when (FStar_Syntax_Syntax.is_teff (FStar_Syntax_Util.comp_result c)) -> begin
(a, wp.FStar_Syntax_Syntax.sort)
end
| _52_962 -> begin
(FStar_All.failwith "Impossible")
end))
end))
end))

# 622 "FStar.TypeChecker.Env.fst"
let wp_signature : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.term) = (fun env m -> (wp_sig_aux env.effects.decls m))

# 624 "FStar.TypeChecker.Env.fst"
let build_lattice : env  ->  FStar_Syntax_Syntax.sigelt  ->  env = (fun env se -> (match (se) with
| FStar_Syntax_Syntax.Sig_new_effect (ne, _52_969) -> begin
(
# 628 "FStar.TypeChecker.Env.fst"
let effects = (
# 628 "FStar.TypeChecker.Env.fst"
let _52_972 = env.effects
in {decls = (ne)::env.effects.decls; order = _52_972.order; joins = _52_972.joins})
in (
# 629 "FStar.TypeChecker.Env.fst"
let _52_975 = env
in {solver = _52_975.solver; range = _52_975.range; curmodule = _52_975.curmodule; gamma = _52_975.gamma; gamma_cache = _52_975.gamma_cache; modules = _52_975.modules; expected_typ = _52_975.expected_typ; sigtab = _52_975.sigtab; is_pattern = _52_975.is_pattern; instantiate_imp = _52_975.instantiate_imp; effects = effects; generalize = _52_975.generalize; letrecs = _52_975.letrecs; top_level = _52_975.top_level; check_uvars = _52_975.check_uvars; use_eq = _52_975.use_eq; is_iface = _52_975.is_iface; admit = _52_975.admit; type_of = _52_975.type_of; universe_of = _52_975.universe_of; use_bv_sorts = _52_975.use_bv_sorts}))
end
| FStar_Syntax_Syntax.Sig_sub_effect (sub, _52_979) -> begin
(
# 632 "FStar.TypeChecker.Env.fst"
let compose_edges = (fun e1 e2 -> {msource = e1.msource; mtarget = e2.mtarget; mlift = (fun r wp1 -> (let _141_820 = (e1.mlift r wp1)
in (e2.mlift r _141_820)))})
in (
# 637 "FStar.TypeChecker.Env.fst"
let mk_lift = (fun lift_t r wp1 -> (
# 638 "FStar.TypeChecker.Env.fst"
let _52_994 = (inst_tscheme lift_t)
in (match (_52_994) with
| (_52_992, lift_t) -> begin
(let _141_832 = (let _141_831 = (let _141_830 = (let _141_829 = (FStar_Syntax_Syntax.as_arg r)
in (let _141_828 = (let _141_827 = (FStar_Syntax_Syntax.as_arg wp1)
in (_141_827)::[])
in (_141_829)::_141_828))
in (lift_t, _141_830))
in FStar_Syntax_Syntax.Tm_app (_141_831))
in (FStar_Syntax_Syntax.mk _141_832 None wp1.FStar_Syntax_Syntax.pos))
end)))
in (
# 641 "FStar.TypeChecker.Env.fst"
let edge = {msource = sub.FStar_Syntax_Syntax.source; mtarget = sub.FStar_Syntax_Syntax.target; mlift = (mk_lift sub.FStar_Syntax_Syntax.lift)}
in (
# 645 "FStar.TypeChecker.Env.fst"
let id_edge = (fun l -> {msource = sub.FStar_Syntax_Syntax.source; mtarget = sub.FStar_Syntax_Syntax.target; mlift = (fun t wp -> wp)})
in (
# 650 "FStar.TypeChecker.Env.fst"
let print_mlift = (fun l -> (
# 651 "FStar.TypeChecker.Env.fst"
let arg = (let _141_849 = (FStar_Ident.lid_of_path (("ARG")::[]) FStar_Range.dummyRange)
in (FStar_Syntax_Syntax.lid_as_fv _141_849 FStar_Syntax_Syntax.Delta_constant None))
in (
# 652 "FStar.TypeChecker.Env.fst"
let wp = (let _141_850 = (FStar_Ident.lid_of_path (("WP")::[]) FStar_Range.dummyRange)
in (FStar_Syntax_Syntax.lid_as_fv _141_850 FStar_Syntax_Syntax.Delta_constant None))
in (let _141_851 = (l arg wp)
in (FStar_Syntax_Print.term_to_string _141_851)))))
in (
# 654 "FStar.TypeChecker.Env.fst"
let order = (edge)::env.effects.order
in (
# 656 "FStar.TypeChecker.Env.fst"
let ms = (FStar_All.pipe_right env.effects.decls (FStar_List.map (fun e -> e.FStar_Syntax_Syntax.mname)))
in (
# 658 "FStar.TypeChecker.Env.fst"
let find_edge = (fun order _52_1011 -> (match (_52_1011) with
| (i, j) -> begin
if (FStar_Ident.lid_equals i j) then begin
(FStar_All.pipe_right (id_edge i) (fun _141_857 -> Some (_141_857)))
end else begin
(FStar_All.pipe_right order (FStar_Util.find_opt (fun e -> ((FStar_Ident.lid_equals e.msource i) && (FStar_Ident.lid_equals e.mtarget j)))))
end
end))
in (
# 667 "FStar.TypeChecker.Env.fst"
let order = (FStar_All.pipe_right ms (FStar_List.fold_left (fun order k -> (let _141_865 = (FStar_All.pipe_right ms (FStar_List.collect (fun i -> if (FStar_Ident.lid_equals i k) then begin
[]
end else begin
(FStar_All.pipe_right ms (FStar_List.collect (fun j -> if (FStar_Ident.lid_equals j k) then begin
[]
end else begin
(match ((let _141_864 = (find_edge order (i, k))
in (let _141_863 = (find_edge order (k, j))
in (_141_864, _141_863)))) with
| (Some (e1), Some (e2)) -> begin
((compose_edges e1 e2))::[]
end
| _52_1023 -> begin
[]
end)
end)))
end)))
in (FStar_List.append order _141_865))) order))
in (
# 678 "FStar.TypeChecker.Env.fst"
let order = (FStar_Util.remove_dups (fun e1 e2 -> ((FStar_Ident.lid_equals e1.msource e2.msource) && (FStar_Ident.lid_equals e1.mtarget e2.mtarget))) order)
in (
# 680 "FStar.TypeChecker.Env.fst"
let joins = (FStar_All.pipe_right ms (FStar_List.collect (fun i -> (FStar_All.pipe_right ms (FStar_List.collect (fun j -> (
# 683 "FStar.TypeChecker.Env.fst"
let join_opt = (FStar_All.pipe_right ms (FStar_List.fold_left (fun bopt k -> (match ((let _141_957 = (find_edge order (i, k))
in (let _141_956 = (find_edge order (j, k))
in (_141_957, _141_956)))) with
| (Some (ik), Some (jk)) -> begin
(match (bopt) with
| None -> begin
Some ((k, ik, jk))
end
| Some (ub, _52_1040, _52_1042) -> begin
if ((let _141_958 = (find_edge order (k, ub))
in (FStar_Util.is_some _141_958)) && (not ((let _141_959 = (find_edge order (ub, k))
in (FStar_Util.is_some _141_959))))) then begin
Some ((k, ik, jk))
end else begin
bopt
end
end)
end
| _52_1046 -> begin
bopt
end)) None))
in (match (join_opt) with
| None -> begin
[]
end
| Some (k, e1, e2) -> begin
((i, j, k, e1.mlift, e2.mlift))::[]
end))))))))
in (
# 700 "FStar.TypeChecker.Env.fst"
let effects = (
# 700 "FStar.TypeChecker.Env.fst"
let _52_1055 = env.effects
in {decls = _52_1055.decls; order = order; joins = joins})
in (
# 703 "FStar.TypeChecker.Env.fst"
let _52_1058 = env
in {solver = _52_1058.solver; range = _52_1058.range; curmodule = _52_1058.curmodule; gamma = _52_1058.gamma; gamma_cache = _52_1058.gamma_cache; modules = _52_1058.modules; expected_typ = _52_1058.expected_typ; sigtab = _52_1058.sigtab; is_pattern = _52_1058.is_pattern; instantiate_imp = _52_1058.instantiate_imp; effects = effects; generalize = _52_1058.generalize; letrecs = _52_1058.letrecs; top_level = _52_1058.top_level; check_uvars = _52_1058.check_uvars; use_eq = _52_1058.use_eq; is_iface = _52_1058.is_iface; admit = _52_1058.admit; type_of = _52_1058.type_of; universe_of = _52_1058.universe_of; use_bv_sorts = _52_1058.use_bv_sorts})))))))))))))
end
| _52_1061 -> begin
env
end))

# 705 "FStar.TypeChecker.Env.fst"
let push_sigelt : env  ->  FStar_Syntax_Syntax.sigelt  ->  env = (fun env s -> (let _141_1008 = (
# 710 "FStar.TypeChecker.Env.fst"
let _52_1064 = env
in (let _141_1007 = (let _141_1006 = (let _141_1005 = (let _141_1004 = (FStar_Syntax_Util.lids_of_sigelt s)
in (_141_1004, s))
in Binding_sig (_141_1005))
in (_141_1006)::env.gamma)
in {solver = _52_1064.solver; range = _52_1064.range; curmodule = _52_1064.curmodule; gamma = _141_1007; gamma_cache = _52_1064.gamma_cache; modules = _52_1064.modules; expected_typ = _52_1064.expected_typ; sigtab = _52_1064.sigtab; is_pattern = _52_1064.is_pattern; instantiate_imp = _52_1064.instantiate_imp; effects = _52_1064.effects; generalize = _52_1064.generalize; letrecs = _52_1064.letrecs; top_level = _52_1064.top_level; check_uvars = _52_1064.check_uvars; use_eq = _52_1064.use_eq; is_iface = _52_1064.is_iface; admit = _52_1064.admit; type_of = _52_1064.type_of; universe_of = _52_1064.universe_of; use_bv_sorts = _52_1064.use_bv_sorts}))
in (build_lattice _141_1008 s)))

# 710 "FStar.TypeChecker.Env.fst"
let push_sigelt_inst : env  ->  FStar_Syntax_Syntax.sigelt  ->  FStar_Syntax_Syntax.universes  ->  env = (fun env s us -> (let _141_1019 = (
# 712 "FStar.TypeChecker.Env.fst"
let _52_1069 = env
in (let _141_1018 = (let _141_1017 = (let _141_1016 = (let _141_1015 = (FStar_Syntax_Util.lids_of_sigelt s)
in (_141_1015, s, us))
in Binding_sig_inst (_141_1016))
in (_141_1017)::env.gamma)
in {solver = _52_1069.solver; range = _52_1069.range; curmodule = _52_1069.curmodule; gamma = _141_1018; gamma_cache = _52_1069.gamma_cache; modules = _52_1069.modules; expected_typ = _52_1069.expected_typ; sigtab = _52_1069.sigtab; is_pattern = _52_1069.is_pattern; instantiate_imp = _52_1069.instantiate_imp; effects = _52_1069.effects; generalize = _52_1069.generalize; letrecs = _52_1069.letrecs; top_level = _52_1069.top_level; check_uvars = _52_1069.check_uvars; use_eq = _52_1069.use_eq; is_iface = _52_1069.is_iface; admit = _52_1069.admit; type_of = _52_1069.type_of; universe_of = _52_1069.universe_of; use_bv_sorts = _52_1069.use_bv_sorts}))
in (build_lattice _141_1019 s)))

# 712 "FStar.TypeChecker.Env.fst"
let push_local_binding : env  ->  binding  ->  env = (fun env b -> (
# 714 "FStar.TypeChecker.Env.fst"
let _52_1073 = env
in {solver = _52_1073.solver; range = _52_1073.range; curmodule = _52_1073.curmodule; gamma = (b)::env.gamma; gamma_cache = _52_1073.gamma_cache; modules = _52_1073.modules; expected_typ = _52_1073.expected_typ; sigtab = _52_1073.sigtab; is_pattern = _52_1073.is_pattern; instantiate_imp = _52_1073.instantiate_imp; effects = _52_1073.effects; generalize = _52_1073.generalize; letrecs = _52_1073.letrecs; top_level = _52_1073.top_level; check_uvars = _52_1073.check_uvars; use_eq = _52_1073.use_eq; is_iface = _52_1073.is_iface; admit = _52_1073.admit; type_of = _52_1073.type_of; universe_of = _52_1073.universe_of; use_bv_sorts = _52_1073.use_bv_sorts}))

# 714 "FStar.TypeChecker.Env.fst"
let push_bv : env  ->  FStar_Syntax_Syntax.bv  ->  env = (fun env x -> (push_local_binding env (Binding_var (x))))

# 716 "FStar.TypeChecker.Env.fst"
let push_binders : env  ->  FStar_Syntax_Syntax.binders  ->  env = (fun env bs -> (FStar_List.fold_left (fun env _52_1083 -> (match (_52_1083) with
| (x, _52_1082) -> begin
(push_bv env x)
end)) env bs))

# 719 "FStar.TypeChecker.Env.fst"
let binding_of_lb : FStar_Syntax_Syntax.lbname  ->  (FStar_Ident.ident Prims.list * FStar_Syntax_Syntax.term)  ->  binding = (fun x t -> (match (x) with
| FStar_Util.Inl (x) -> begin
(
# 723 "FStar.TypeChecker.Env.fst"
let _52_1088 = ()
in (
# 724 "FStar.TypeChecker.Env.fst"
let x = (
# 724 "FStar.TypeChecker.Env.fst"
let _52_1090 = x
in {FStar_Syntax_Syntax.ppname = _52_1090.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _52_1090.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = (Prims.snd t)})
in Binding_var (x)))
end
| FStar_Util.Inr (fv) -> begin
Binding_lid ((fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v, t))
end))

# 727 "FStar.TypeChecker.Env.fst"
let push_let_binding : env  ->  FStar_Syntax_Syntax.lbname  ->  FStar_Syntax_Syntax.tscheme  ->  env = (fun env lb ts -> (push_local_binding env (binding_of_lb lb ts)))

# 730 "FStar.TypeChecker.Env.fst"
let push_module : env  ->  FStar_Syntax_Syntax.modul  ->  env = (fun env m -> (
# 732 "FStar.TypeChecker.Env.fst"
let _52_1100 = (add_sigelts env m.FStar_Syntax_Syntax.exports)
in (
# 733 "FStar.TypeChecker.Env.fst"
let _52_1102 = env
in {solver = _52_1102.solver; range = _52_1102.range; curmodule = _52_1102.curmodule; gamma = []; gamma_cache = _52_1102.gamma_cache; modules = (m)::env.modules; expected_typ = None; sigtab = _52_1102.sigtab; is_pattern = _52_1102.is_pattern; instantiate_imp = _52_1102.instantiate_imp; effects = _52_1102.effects; generalize = _52_1102.generalize; letrecs = _52_1102.letrecs; top_level = _52_1102.top_level; check_uvars = _52_1102.check_uvars; use_eq = _52_1102.use_eq; is_iface = _52_1102.is_iface; admit = _52_1102.admit; type_of = _52_1102.type_of; universe_of = _52_1102.universe_of; use_bv_sorts = _52_1102.use_bv_sorts})))

# 736 "FStar.TypeChecker.Env.fst"
let push_univ_vars : env  ->  FStar_Syntax_Syntax.univ_names  ->  env = (fun env xs -> (FStar_List.fold_left (fun env x -> (push_local_binding env (Binding_univ (x)))) env xs))

# 739 "FStar.TypeChecker.Env.fst"
let set_expected_typ : env  ->  FStar_Syntax_Syntax.typ  ->  env = (fun env t -> (
# 742 "FStar.TypeChecker.Env.fst"
let _52_1110 = env
in {solver = _52_1110.solver; range = _52_1110.range; curmodule = _52_1110.curmodule; gamma = _52_1110.gamma; gamma_cache = _52_1110.gamma_cache; modules = _52_1110.modules; expected_typ = Some (t); sigtab = _52_1110.sigtab; is_pattern = _52_1110.is_pattern; instantiate_imp = _52_1110.instantiate_imp; effects = _52_1110.effects; generalize = _52_1110.generalize; letrecs = _52_1110.letrecs; top_level = _52_1110.top_level; check_uvars = _52_1110.check_uvars; use_eq = false; is_iface = _52_1110.is_iface; admit = _52_1110.admit; type_of = _52_1110.type_of; universe_of = _52_1110.universe_of; use_bv_sorts = _52_1110.use_bv_sorts}))

# 742 "FStar.TypeChecker.Env.fst"
let expected_typ : env  ->  FStar_Syntax_Syntax.typ Prims.option = (fun env -> (match (env.expected_typ) with
| None -> begin
None
end
| Some (t) -> begin
Some (t)
end))

# 746 "FStar.TypeChecker.Env.fst"
let clear_expected_typ : env  ->  (env * FStar_Syntax_Syntax.typ Prims.option) = (fun env -> (let _141_1062 = (expected_typ env)
in ((
# 749 "FStar.TypeChecker.Env.fst"
let _52_1117 = env
in {solver = _52_1117.solver; range = _52_1117.range; curmodule = _52_1117.curmodule; gamma = _52_1117.gamma; gamma_cache = _52_1117.gamma_cache; modules = _52_1117.modules; expected_typ = None; sigtab = _52_1117.sigtab; is_pattern = _52_1117.is_pattern; instantiate_imp = _52_1117.instantiate_imp; effects = _52_1117.effects; generalize = _52_1117.generalize; letrecs = _52_1117.letrecs; top_level = _52_1117.top_level; check_uvars = _52_1117.check_uvars; use_eq = false; is_iface = _52_1117.is_iface; admit = _52_1117.admit; type_of = _52_1117.type_of; universe_of = _52_1117.universe_of; use_bv_sorts = _52_1117.use_bv_sorts}), _141_1062)))

# 749 "FStar.TypeChecker.Env.fst"
let finish_module : env  ->  FStar_Syntax_Syntax.modul  ->  env = (
# 752 "FStar.TypeChecker.Env.fst"
let empty_lid = (FStar_Ident.lid_of_ids (((FStar_Ident.id_of_text ""))::[]))
in (fun env m -> (
# 754 "FStar.TypeChecker.Env.fst"
let sigs = if (FStar_Ident.lid_equals m.FStar_Syntax_Syntax.name FStar_Syntax_Const.prims_lid) then begin
(let _141_1068 = (FStar_All.pipe_right env.gamma (FStar_List.collect (fun _52_10 -> (match (_52_10) with
| Binding_sig (_52_1124, se) -> begin
(se)::[]
end
| _52_1129 -> begin
[]
end))))
in (FStar_All.pipe_right _141_1068 FStar_List.rev))
end else begin
m.FStar_Syntax_Syntax.exports
end
in (
# 760 "FStar.TypeChecker.Env.fst"
let _52_1131 = (add_sigelts env sigs)
in (
# 761 "FStar.TypeChecker.Env.fst"
let _52_1133 = (FStar_Util.smap_clear env.gamma_cache)
in (
# 762 "FStar.TypeChecker.Env.fst"
let _52_1135 = env
in {solver = _52_1135.solver; range = _52_1135.range; curmodule = empty_lid; gamma = []; gamma_cache = _52_1135.gamma_cache; modules = (m)::env.modules; expected_typ = _52_1135.expected_typ; sigtab = _52_1135.sigtab; is_pattern = _52_1135.is_pattern; instantiate_imp = _52_1135.instantiate_imp; effects = _52_1135.effects; generalize = _52_1135.generalize; letrecs = _52_1135.letrecs; top_level = _52_1135.top_level; check_uvars = _52_1135.check_uvars; use_eq = _52_1135.use_eq; is_iface = _52_1135.is_iface; admit = _52_1135.admit; type_of = _52_1135.type_of; universe_of = _52_1135.universe_of; use_bv_sorts = _52_1135.use_bv_sorts}))))))

# 765 "FStar.TypeChecker.Env.fst"
let uvars_in_env : env  ->  FStar_Syntax_Syntax.uvars = (fun env -> (
# 771 "FStar.TypeChecker.Env.fst"
let no_uvs = (FStar_Syntax_Syntax.new_uv_set ())
in (
# 772 "FStar.TypeChecker.Env.fst"
let ext = (fun out uvs -> (FStar_Util.set_union out uvs))
in (
# 773 "FStar.TypeChecker.Env.fst"
let rec aux = (fun out g -> (match (g) with
| [] -> begin
out
end
| Binding_univ (_52_1148)::tl -> begin
(aux out tl)
end
| (Binding_lid (_, (_, t))::tl) | (Binding_var ({FStar_Syntax_Syntax.ppname = _; FStar_Syntax_Syntax.index = _; FStar_Syntax_Syntax.sort = t})::tl) -> begin
(let _141_1080 = (let _141_1079 = (FStar_Syntax_Free.uvars t)
in (ext out _141_1079))
in (aux _141_1080 tl))
end
| (Binding_sig (_)::_) | (Binding_sig_inst (_)::_) -> begin
out
end))
in (aux no_uvs env.gamma)))))

# 780 "FStar.TypeChecker.Env.fst"
let univ_vars : env  ->  FStar_Syntax_Syntax.universe_uvar FStar_Util.set = (fun env -> (
# 783 "FStar.TypeChecker.Env.fst"
let no_univs = FStar_Syntax_Syntax.no_universe_uvars
in (
# 784 "FStar.TypeChecker.Env.fst"
let ext = (fun out uvs -> (FStar_Util.set_union out uvs))
in (
# 785 "FStar.TypeChecker.Env.fst"
let rec aux = (fun out g -> (match (g) with
| [] -> begin
out
end
| (Binding_sig_inst (_)::tl) | (Binding_univ (_)::tl) -> begin
(aux out tl)
end
| (Binding_lid (_, (_, t))::tl) | (Binding_var ({FStar_Syntax_Syntax.ppname = _; FStar_Syntax_Syntax.index = _; FStar_Syntax_Syntax.sort = t})::tl) -> begin
(let _141_1092 = (let _141_1091 = (FStar_Syntax_Free.univs t)
in (ext out _141_1091))
in (aux _141_1092 tl))
end
| Binding_sig (_52_1218)::_52_1216 -> begin
out
end))
in (aux no_univs env.gamma)))))

# 792 "FStar.TypeChecker.Env.fst"
let bound_vars_of_bindings : binding Prims.list  ->  FStar_Syntax_Syntax.bv Prims.list = (fun bs -> (FStar_All.pipe_right bs (FStar_List.collect (fun _52_11 -> (match (_52_11) with
| Binding_var (x) -> begin
(x)::[]
end
| (Binding_lid (_)) | (Binding_sig (_)) | (Binding_univ (_)) | (Binding_sig_inst (_)) -> begin
[]
end)))))

# 800 "FStar.TypeChecker.Env.fst"
let binders_of_bindings : binding Prims.list  ->  FStar_Syntax_Syntax.binders = (fun bs -> (let _141_1099 = (let _141_1098 = (bound_vars_of_bindings bs)
in (FStar_All.pipe_right _141_1098 (FStar_List.map FStar_Syntax_Syntax.mk_binder)))
in (FStar_All.pipe_right _141_1099 FStar_List.rev)))

# 802 "FStar.TypeChecker.Env.fst"
let bound_vars : env  ->  FStar_Syntax_Syntax.bv Prims.list = (fun env -> (bound_vars_of_bindings env.gamma))

# 804 "FStar.TypeChecker.Env.fst"
let all_binders : env  ->  FStar_Syntax_Syntax.binders = (fun env -> (binders_of_bindings env.gamma))

# 806 "FStar.TypeChecker.Env.fst"
let fold_env = (fun env f a -> (FStar_List.fold_right (fun e a -> (f a e)) env.gamma a))

# 808 "FStar.TypeChecker.Env.fst"
let lidents : env  ->  FStar_Ident.lident Prims.list = (fun env -> (
# 811 "FStar.TypeChecker.Env.fst"
let keys = (FStar_List.fold_left (fun keys _52_12 -> (match (_52_12) with
| Binding_sig (lids, _52_1250) -> begin
(FStar_List.append lids keys)
end
| _52_1254 -> begin
keys
end)) [] env.gamma)
in (let _141_1123 = (sigtab env)
in (FStar_Util.smap_fold _141_1123 (fun _52_1256 v keys -> (let _141_1122 = (FStar_Syntax_Util.lids_of_sigelt v)
in (FStar_List.append _141_1122 keys))) keys))))

# 814 "FStar.TypeChecker.Env.fst"
let dummy_solver : solver_t = {init = (fun _52_1260 -> ()); push = (fun _52_1262 -> ()); pop = (fun _52_1264 -> ()); mark = (fun _52_1266 -> ()); reset_mark = (fun _52_1268 -> ()); commit_mark = (fun _52_1270 -> ()); encode_modul = (fun _52_1272 _52_1274 -> ()); encode_sig = (fun _52_1276 _52_1278 -> ()); solve = (fun _52_1280 _52_1282 _52_1284 -> ()); is_trivial = (fun _52_1286 _52_1288 -> false); finish = (fun _52_1290 -> ()); refresh = (fun _52_1291 -> ())}

# 831 "FStar.TypeChecker.Env.fst"
let no_solver_env : (env  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.typ * guard_t))  ->  env = (fun tc -> (let _141_1159 = (FStar_Ident.lid_of_path (("dummy")::[]) FStar_Range.dummyRange)
in (initial_env tc dummy_solver _141_1159)))




