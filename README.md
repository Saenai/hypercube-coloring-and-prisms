# Total dominator colorings of hypercubes and total co-independent domination in prisms

A total dominator coloring of the six-dimensional cube requires exactly **16 colors**. For every dimension $d\geq 4$, the minimum number of colors for $Q_d$ is $\gamma_t(Q_d)+2$, where $\gamma_t$ is the total domination number. In a total dominator coloring, adjacent vertices have different colors and each vertex is adjacent to every member of some color class.

The paper also answers a question of Alfred Raju M., Palagiri and Yero. For a nonempty finite simple graph $H$ without isolated vertices, the covering total Italian domination number of the prism over $H$ attains their upper bound exactly when the domination number of $H$ equals its minimum vertex cover size. Allowing isolated vertices gives a five-vertex counterexample. [Original question, p. 341](https://rodin.uca.es/bitstream/handle/10498/35785/OA_2024_0987.pdf#page=9)

[Read the preprint (PDF)](paper/preprint.pdf) · [中文说明](README.zh-CN.md)

## Prior work and review status

Kazemi proved the coloring equality for dimensions $2^r$ with $r\geq3$. Gebendorfer proved Kazemi’s Conjecture 6.1 for $2^r+1$ with $r\geq2$ in October 2026. The paper extends these dimension families using Gebendorfer’s color-class count and classical covering-code bounds. [Kazemi](https://doi.org/10.47443/cm.2025.102) · [Gebendorfer](https://doi.org/10.13140/RG.2.2.31321.28006)

The prism proof builds on the earlier double-fiber lower bound. The paper gives a formula for all bases without isolated vertices and uses it to characterize equality. Section 2 explains how the bipartite-base case already follows by combining earlier theorems. [Paper, §2 and §5](paper/preprint.pdf) · [Literature search queries, 27 November 2026](notes/searches.tsv)

OpenAI language models derived the extensions, searched the literature and wrote the manuscript and Lean proof. Separate model instances checked the arguments, and Python programs checked the finite cases described below. Independent human mathematical review is pending. Corrections and references to earlier results are welcome. [Repository issues](https://github.com/Saenai/hypercube-coloring-and-prisms/issues)

## Verify the prism theorem

Lean 4.36.0 checks Theorem 2 in §2 for every nonempty finite simple graph with no isolated vertices, including the bipartite case. In the prism, we minimize over total dominating sets with a nonempty independent complement. In the base, we minimize over dominating sets whose deletion leaves a bipartite graph. The prism minimum equals the base minimum plus the number of base vertices. The paper gives the hypercube coloring proof in §§1–4 and the upper-bound equality proof in §5. [Lean source](lean/Prism.lean) · [Check the complete proof online](https://live.lean-lang.org/#project=lean-v4.36.0&url=https%3A%2F%2Fraw.githubusercontent.com%2FSaenai%2Fhypercube-coloring-and-prisms%2Fv0.1.1%2Flean%2FPrism.lean)

To run both proof checkers locally, install elan and run the following from the repository root in Bash. The project pins the Lean version and uses only its standard library. [Install Lean with elan](https://lean-lang.org/install/)

```sh
bash lean/check.sh
```

The script compiles the complete file with Lean, then exports both proofs and their dependencies to Nanoda, an independent type checker bundled with this Lean release. It allows three standard logical axioms (`propext`, `Classical.choice`, `Quot.sound`). A successful run ends with `Checked 2270 declarations with no errors`. [Verification script](lean/check.sh)

## Reproduce the checks

Run the following from the repository root with Python 3.10 or later. Both scripts use only the standard library.

```sh
python3 code/verify.py
python3 code/verify_prisms.py --all-labels
```

The first script checks explicit covering codes and a five-dimensional coloring. The second checks all 814 labelled base graphs on two through five vertices with no isolates. With `--all-labels` it enumerates 45,621,630 Italian labelings on their prisms, then checks two examples separately. Omitting the flag runs the faster subset check. The manuscript contains the proofs for arbitrary orders and dimensions.

The English [LaTeX source](paper/preprint.tex) builds with two runs of pdfLaTeX. The [Chinese proof notes](notes/proofs-zh.pdf) include a 384-word covering code of length twelve. Their [source](notes/proofs-zh.tex) uses XeLaTeX and the Noto CJK fonts.
