# Total dominator colorings of hypercubes and total co-independent domination in prisms

Working draft, 27 November 2026. [Read the paper (PDF)](paper/preprint.pdf) · [中文说明](README.zh-CN.md)

This graph theory draft studies hypercube colorings and domination in prisms. It includes a Lean proof of the prism formula and Python checks for finite examples.

1. For every dimension $d\geq 4$, the total dominator chromatic number of the binary hypercube $Q_d$ is exactly $\gamma_t(Q_d)+2$, where $\gamma_t$ is the total domination number. In dimension six this gives 16 colors.
2. For a graph $H$ without isolated vertices, the covering total Italian domination number of the prism over $H$ attains the upper bound of Alfred Raju M., Palagiri and Yero exactly when the domination number of $H$ equals its minimum vertex cover size. If isolated vertices are allowed in $H$, a complete graph on four vertices together with an isolated vertex gives a counterexample. [The question on p. 341](https://rodin.uca.es/bitstream/handle/10498/35785/OA_2024_0987.pdf#page=9)

## Prior work and review status

Kazemi proved the coloring equality for dimensions $2^r$ with $r\geq3$. Gebendorfer proved Kazemi’s Conjecture 6.1 for $2^r+1$ with $r\geq2$ in October 2026. The paper extends these dimension families using Gebendorfer’s color-class count and classical covering-code bounds. [Kazemi](https://doi.org/10.47443/cm.2025.102) · [Gebendorfer](https://doi.org/10.13140/RG.2.2.31321.28006)

The prism proof builds on the earlier double-fiber lower bound. The paper gives a formula for all bases without isolated vertices and uses it to characterize equality. Section 2 explains how the bipartite-base case already follows by combining earlier theorems. [Paper, §2 and §5](paper/preprint.pdf) · [Literature search queries, 27 November 2026](notes/searches.tsv)

OpenAI language models derived the extensions, searched the literature, drafted the manuscript and wrote the Lean proof. Separate model instances checked the arguments, and Python programs checked the finite cases described below. Independent human mathematical review is pending. If you find a gap or an earlier result, please include the theorem, proof step or citation in a [GitHub issue](https://github.com/Saenai/hypercube-coloring-and-prisms/issues).

## Try the Lean proof

Lean 4.36.0 checks Theorem 2 in §2 for every nonempty finite simple graph with no isolated vertices, including the bipartite case. The theorem relates two minimum sizes. In the prism, we minimize over total dominating sets with a nonempty independent complement. In the base, we minimize over dominating sets whose deletion leaves a bipartite graph. The prism minimum equals the base minimum plus the number of base vertices. The hypercube coloring theorem (§1) and the upper-bound equality criterion (§5) still rely on their paper proofs. [Lean source](lean/Prism.lean) · [Open the editable proof in Lean Playground](https://live.lean-lang.org/#project=lean-v4.36.0&url=https%3A%2F%2Fraw.githubusercontent.com%2FSaenai%2Fhypercube-coloring-and-prisms%2Fmain%2Flean%2FPrism.lean)

For a first exercise, find `vertical_covered` in the playground. It says a vertex cover contains at least one endpoint of each vertical edge. Delete the line after `apply cover`. Lean asks you to prove that the two copies of `x` are adjacent. Replace the deleted line with these two lines. `left` selects the vertical case of adjacency.

```lean
  left
  exact ⟨rfl, Bool.false_ne_true⟩
```

To check the entire file locally, install elan and run these commands from the repository root. The project pins the Lean version and uses only its standard library. [Install Lean with elan](https://lean-lang.org/install/)

```sh
cd lean
lean -DwarningAsError=true Prism.lean
```

The final two lines of output list the standard logical axioms used by each theorem (`propext`, `Classical.choice`, `Quot.sound`).

For a second check, run `bash check.sh` in the same directory. It exports the proofs to Nanoda, a separately implemented type checker bundled with this Lean release. Nanoda checks the two theorems and their dependencies with only the three axioms above permitted. [Verification script](lean/check.sh)

## Reproduce the checks

Run the following from the repository root with Python 3.10 or later. Both scripts use only the standard library.

```sh
python3 code/verify.py
python3 code/verify_prisms.py --all-labels
```

The first script checks explicit covering codes and a five-dimensional coloring. The second checks all 814 labelled base graphs on two through five vertices with no isolates. With `--all-labels` it enumerates 45,621,630 Italian labelings on their prisms, then checks two examples separately. Omitting the flag runs the faster subset check. The manuscript contains the proofs for arbitrary orders and dimensions.

The English [LaTeX source](paper/preprint.tex) builds with two runs of pdfLaTeX. The [Chinese proof notes](notes/proofs-zh.pdf) include a 384-word covering code of length twelve. Their [source](notes/proofs-zh.tex) uses XeLaTeX and the Noto CJK fonts.
