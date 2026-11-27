import Std

/-!
# The prism minimum (Theorem 2, Section 2 of the paper)

The base graph is undirected and loopless. Each prism vertex is a pair
`(x, layer)`. A Boolean-valued predicate records membership in a vertex set.

Start with `vertical_covered` and `doubleFibre_dominates`. The theorem
`prism_minimum` proves the equality of the two minima for every nonempty
finite base without isolated vertices. Its corollary treats bipartite bases.
-/

namespace Prism

structure Graph (V : Type) where
  Adj : V → V → Prop
  symm : ∀ {x y}, Adj x y → Adj y x
  loopless : ∀ x, ¬ Adj x x

variable {V : Type} {H : Graph V}

/-- An edge is vertical over one vertex or horizontal in one layer. -/
def prismAdj (H : Graph V) (p q : V × Bool) : Prop :=
  (p.1 = q.1 ∧ p.2 ≠ q.2) ∨ (H.Adj p.1 q.1 ∧ p.2 = q.2)

def Covers (H : Graph V) (T : V × Bool → Bool) : Prop :=
  ∀ p q, prismAdj H p q → T p = true ∨ T q = true

def TotalDominates (H : Graph V) (T : V × Bool → Bool) : Prop :=
  ∀ p, ∃ q, prismAdj H p q ∧ T q = true

/-- The complement of a vertex cover is independent. Here it must also be nonempty. -/
def PrismSet (H : Graph V) (T : V × Bool → Bool) : Prop :=
  Covers H T ∧ TotalDominates H T ∧ ∃ p, T p = false

def Dominates (H : Graph V) (S : V → Bool) : Prop :=
  ∀ x, S x = false → ∃ y, H.Adj x y ∧ S y = true

def TwoColorsOutside (H : Graph V) (S : V → Bool) (color : V → Bool) : Prop :=
  ∀ x y, S x = false → S y = false → H.Adj x y → color x ≠ color y

def BaseSet (H : Graph V) (S : V → Bool) : Prop :=
  Dominates H S ∧ ∃ color, TwoColorsOutside H S color

/-- Project the fibres in which both copies are selected. -/
def doubleFibre (T : V × Bool → Bool) (x : V) : Bool :=
  T (x, false) && T (x, true)

variable {T : V × Bool → Bool}

theorem vertical_covered (cover : Covers H T) (x : V) :
    T (x, false) = true ∨ T (x, true) = true := by
  apply cover
  exact Or.inl ⟨rfl, Bool.false_ne_true⟩

/-- On a single fibre this is the layer of the unique omitted copy. -/
def omittedLayer (T : V × Bool → Bool) (x : V) : Bool := T (x, false)

private theorem single_layers (cover : Covers H T) {x : V} (hx : doubleFibre T x = false) :
    T (x, omittedLayer T x) = false ∧ T (x, !(omittedLayer T x)) = true := by
  have hv := vertical_covered cover x
  cases h₀ : T (x, false) <;> cases h₁ : T (x, true) <;>
    simp_all [doubleFibre, omittedLayer]

private theorem eq_of_ne_other_layer {i j : Bool} (h : (!i) ≠ j) : j = i := by
  cases i <;> cases j <;> simp_all

private theorem both_layers {y : V} {i : Bool}
    (first : T (y, i) = true) (other : T (y, !i) = true) : doubleFibre T y = true := by
  cases i <;> simp_all [doubleFibre]

/-- A horizontal neighbor of the selected copy forces a double fibre next to it. -/
theorem doubleFibre_dominates (cover : Covers H T) (total : TotalDominates H T) :
    Dominates H (doubleFibre T) := by
  intro x hx
  let i := omittedLayer T x
  have hOmit : T (x, i) = false := (single_layers cover hx).1
  obtain ⟨⟨y, j⟩, edge, selected⟩ := total (x, !i)
  rcases edge with ⟨hxy, hj⟩ | ⟨hxy, hj⟩
  · change x = y at hxy
    change (!i) ≠ j at hj
    have heq := eq_of_ne_other_layer hj
    subst y
    subst j
    simp_all
  · change (!i) = j at hj
    subst j
    have sameLayer : prismAdj H (x, i) (y, i) := Or.inr ⟨hxy, rfl⟩
    have second := (cover _ _ sameLayer).resolve_left (by simp [hOmit])
    exact ⟨y, hxy, both_layers second selected⟩

theorem doubleFibre_baseSet (cover : Covers H T) (total : TotalDominates H T) :
    BaseSet H (doubleFibre T) := by
  refine ⟨doubleFibre_dominates cover total, omittedLayer T, ?_⟩
  intro x y hx hy hxy same
  have edge : prismAdj H (x, omittedLayer T x) (y, omittedLayer T y) :=
    Or.inr ⟨hxy, same⟩
  have hit := cover _ _ edge
  simp [(single_layers cover hx).1, (single_layers cover hy).1] at hit

/-- Keep both copies over S, and omit the assigned layer outside S. -/
def liftSet (S : V → Bool) (color : V → Bool) (p : V × Bool) : Bool :=
  S p.1 || (p.2 != color p.1)

private theorem lift_omits_iff {S color : V → Bool} {x : V} {i : Bool} :
    liftSet S color (x, i) = false ↔ S x = false ∧ i = color x := by
  simp [liftSet]

theorem lift_prismSet {S color : V → Bool} (dom : Dominates H S)
    (proper : TwoColorsOutside H S color) (omits : ∃ x, S x = false) :
    PrismSet H (liftSet S color) := by
  constructor
  · rintro ⟨x, i⟩ ⟨y, j⟩ edge
    cases hp : liftSet S color (x, i) with
    | true => exact Or.inl rfl
    | false =>
      cases hq : liftSet S color (y, j) with
      | true => exact Or.inr rfl
      | false =>
        obtain ⟨hx, hi⟩ := lift_omits_iff.mp hp
        obtain ⟨hy, hj⟩ := lift_omits_iff.mp hq
        rcases edge with ⟨hxy, hne⟩ | ⟨hxy, heq⟩
        · exact False.elim (hne (hi.trans ((congrArg color hxy).trans hj.symm)))
        · exact False.elim (proper x y hx hy hxy (hi.symm.trans (heq.trans hj)))
  constructor
  · rintro ⟨x, i⟩
    cases hx : S x with
    | true =>
      have different : i ≠ !i := by cases i <;> decide
      exact ⟨(x, !i), Or.inl ⟨rfl, different⟩, by simp [liftSet, hx]⟩
    | false =>
      obtain ⟨y, hxy, hy⟩ := dom x hx
      exact ⟨(y, i), Or.inr ⟨hxy, rfl⟩, by simp [liftSet, hy]⟩
  · obtain ⟨x, hx⟩ := omits
    exact ⟨(x, color x), lift_omits_iff.mpr ⟨hx, rfl⟩⟩

theorem doubleFibre_lift (S color : V → Bool) : doubleFibre (liftSet S color) = S := by
  funext x
  cases hs : S x <;> cases hc : color x <;> simp [doubleFibre, liftSet, hs, hc]

section Finite

variable {m : Nat}

/-- Label the m base vertices 0 through m-1; count the selected labels. -/
def baseSize (S : Fin m → Bool) : Nat := (List.finRange m).countP S

/-- Count the selected prism vertices in each layer separately. -/
def prismSize (T : Fin m × Bool → Bool) : Nat :=
  baseSize (fun x => T (x, false)) + baseSize (fun x => T (x, true))

private theorem count_fibres (T : V × Bool → Bool) (verts : List V)
    (hit : ∀ x, T (x, false) = true ∨ T (x, true) = true) :
    verts.countP (fun x => T (x, false)) + verts.countP (fun x => T (x, true)) =
      verts.length + verts.countP (doubleFibre T) := by
  induction verts with
  | nil => simp
  | cons x xs ih =>
    have hx := hit x
    cases h₀ : T (x, false) <;> cases h₁ : T (x, true) <;>
      simp_all [doubleFibre] <;> omega

theorem prismSize_eq {H : Graph (Fin m)} {T : Fin m × Bool → Bool} (cover : Covers H T) :
    prismSize T = m + baseSize (doubleFibre T) := by
  simpa [prismSize, baseSize] using count_fibres T (List.finRange m) (vertical_covered cover)

private theorem size_lt_iff_omits (S : Fin m → Bool) :
    baseSize S < m ↔ ∃ x, S x = false := by
  have bound : baseSize S ≤ m := by
    simpa [baseSize] using (List.countP_le_length (p := S) (l := List.finRange m))
  have full : baseSize S = m ↔ ∀ x, S x = true := by
    calc
      baseSize S = m ↔ (List.finRange m).countP S = (List.finRange m).length := by
        simp [baseSize]
      _ ↔ ∀ x ∈ List.finRange m, S x = true := List.countP_eq_length
      _ ↔ ∀ x, S x = true := ⟨fun h x => h x (List.mem_finRange x), fun h x _ => h x⟩
  constructor
  · intro lt
    apply Classical.byContradiction
    intro none
    have hall : ∀ x, S x = true := by
      intro x
      cases hx : S x with
      | true => rfl
      | false => exact False.elim (none ⟨x, hx⟩)
    exact (Nat.ne_of_lt lt) (full.mpr hall)
  · rintro ⟨x, hx⟩
    have neq : baseSize S ≠ m := fun eq => Bool.noConfusion (hx.symm.trans (full.mp eq x))
    omega

/-- With no isolates, deleting all but one vertex gives a proper feasible set. -/
private theorem exists_proper_base (H : Graph (Fin m)) (nonempty : 0 < m)
    (noIsolates : ∀ x, ∃ y, H.Adj x y) :
    ∃ S, BaseSet H S ∧ ∃ x, S x = false := by
  let a : Fin m := ⟨0, nonempty⟩
  let S : Fin m → Bool := fun x => x != a
  have outside {x : Fin m} (hx : S x = false) : x = a := by simpa [S] using hx
  refine ⟨S, ⟨?_, fun _ => false, ?_⟩, a, by simp [S]⟩
  · intro x hx
    obtain ⟨y, edge⟩ := noIsolates x
    have hya : y ≠ a := by
      intro eq
      exact H.loopless x (by simpa [outside hx, eq] using edge)
    exact ⟨y, edge, by simp [S, hya]⟩
  · intro x y hx hy edge
    exact False.elim (H.loopless a (by simpa [outside hx, outside hy] using edge))

/-- k is an attained size and is no larger than any attained size. -/
def IsLeastSize (P : Nat → Prop) (k : Nat) : Prop :=
  P k ∧ ∀ j, P j → k ≤ j

private theorem exists_least {P : Nat → Prop} (existsSize : ∃ j, P j) :
    ∃ k, IsLeastSize P k := by
  classical
  obtain ⟨j, hj⟩ := existsSize
  induction j using Nat.strongRecOn with
  | ind j ih =>
    by_cases smaller : ∃ i, i < j ∧ P i
    · obtain ⟨i, hij, hi⟩ := smaller
      exact ih i hij hi
    · exact ⟨j, hj, fun i hi => Nat.le_of_not_gt (fun hij => smaller ⟨i, hij, hi⟩)⟩

def BaseSizeOccurs (H : Graph (Fin m)) (k : Nat) : Prop :=
  ∃ S, BaseSet H S ∧ baseSize S = k

def PrismSizeOccurs (H : Graph (Fin m)) (k : Nat) : Prop :=
  ∃ T, PrismSet H T ∧ prismSize T = k

/-- The minimum prism size equals m plus the minimum size of a dominating set
whose deletion leaves a bipartite graph. Both values are attained. -/
theorem prism_minimum (H : Graph (Fin m)) (nonempty : 0 < m)
    (noIsolates : ∀ x, ∃ y, H.Adj x y) :
    ∃ k, IsLeastSize (BaseSizeOccurs H) k ∧ IsLeastSize (PrismSizeOccurs H) (m + k) := by
  obtain ⟨S₀, feasible₀, omits₀⟩ := exists_proper_base H nonempty noIsolates
  obtain ⟨k, least⟩ := exists_least (P := BaseSizeOccurs H) ⟨baseSize S₀, S₀, feasible₀, rfl⟩
  obtain ⟨S, ⟨dom, color, proper⟩, sizeS⟩ := least.1
  have smaller := (size_lt_iff_omits S₀).mpr omits₀
  have bound := least.2 _ ⟨S₀, feasible₀, rfl⟩
  have omits : ∃ x, S x = false := (size_lt_iff_omits S).mp (by omega)
  have lifted := lift_prismSet dom proper omits
  refine ⟨k, least, ⟨liftSet S color, lifted, ?_⟩, ?_⟩
  · rw [prismSize_eq lifted.1, doubleFibre_lift, sizeS]
  · rintro j ⟨T, ⟨cover, total, _⟩, sizeT⟩
    have projected := doubleFibre_baseSet cover total
    have lower := least.2 _ ⟨doubleFibre T, projected, rfl⟩
    rw [← sizeT, prismSize_eq cover]
    exact Nat.add_le_add_left lower m

def DominatingSizeOccurs (H : Graph (Fin m)) (k : Nat) : Prop :=
  ∃ S, Dominates H S ∧ baseSize S = k

/-- For a bipartite base the right-hand minimum is the ordinary domination number. -/
theorem bipartite_prism_minimum (H : Graph (Fin m)) (nonempty : 0 < m)
    (noIsolates : ∀ x, ∃ y, H.Adj x y)
    (bipartite : ∃ color : Fin m → Bool, ∀ x y, H.Adj x y → color x ≠ color y) :
    ∃ k, IsLeastSize (DominatingSizeOccurs H) k ∧ IsLeastSize (PrismSizeOccurs H) (m + k) := by
  obtain ⟨k, least, prism⟩ := prism_minimum H nonempty noIsolates
  obtain ⟨S, feasible, sizeS⟩ := least.1
  refine ⟨k, ⟨⟨S, feasible.1, sizeS⟩, ?_⟩, prism⟩
  rintro j ⟨R, domR, sizeR⟩
  obtain ⟨color, proper⟩ := bipartite
  exact least.2 j ⟨R, ⟨domR, color, fun x y _ _ => proper x y⟩, sizeR⟩

end Finite
end Prism

#print axioms Prism.prism_minimum
#print axioms Prism.bipartite_prism_minimum
