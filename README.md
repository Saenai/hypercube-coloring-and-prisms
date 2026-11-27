# Total dominator colorings of hypercubes and total co-independent domination in prisms

A total dominator coloring of the six-dimensional cube requires exactly **16 colors**. For every dimension $d\geq 4$, the **total dominator chromatic number** of $Q_d$ is $\gamma_t(Q_d)+2$, where $\gamma_t$ is the total domination number. In a total dominator coloring, adjacent vertices have different colors and each vertex is adjacent to every member of some color class.

The paper also answers a question of Alfred Raju M., V. S. R. Palagiri and I. G. Yero in *On the total version of the covering Italian domination problem* (2024, §5.1, p. 341). For a nonempty finite simple graph $H$ without isolated vertices, the covering total Italian domination number of the prism $H\square K_2$ attains the upper bound in their Theorem 5.1 exactly when the domination number of $H$ equals its minimum vertex cover size. Allowing isolated vertices gives a five-vertex counterexample. [Original question, p. 341](https://rodin.uca.es/bitstream/handle/10498/35785/OA_2024_0987.pdf#page=9) · [Answer in Corollary 4, p. 4](paper/preprint.pdf#page=4)

[Read the preprint (PDF)](paper/preprint.pdf) · [中文说明](README.zh-CN.md)

## Original problems and related proofs

**Kazemi’s Conjecture 6.1.** In *Total dominator coloring of the hypercube* $Q_{2^n}$ (2026), Adel P. Kazemi proved the coloring equality for dimensions $2^r$ with $r\geq3$ and conjectured it for $2^r+1$ with $r\geq2$. Jonas J. Gebendorfer proved the conjecture in *Total dominator colorings of hypercubes of dimension* $2^n+1$ (Theorem 4.3, October 2026). Theorem 1 here extends the equality to every $d\geq4$, using Gebendorfer’s color-class count and classical covering-code bounds. [Kazemi’s conjecture](https://doi.org/10.47443/cm.2025.102) · [Gebendorfer’s proof](https://doi.org/10.13140/RG.2.2.31321.28006) · [Proof of the extension, §4](paper/preprint.pdf#page=3)

**Earlier hypercube conjecture.** Kazemi’s 2013 Open Problem Garden entry *Total Dominator Chromatic Number of a Hypercube* proposed $2^{d-2}+2$ colors for every $d\geq5$. A 2014 comment there already pointed out the failure in large dimensions. At $d=6$ that prediction gives 18, while Theorem 1 gives 16. [Original problem and dated comment](https://www.openproblemgarden.org/op/total_dominator_chromatic_number_of_a_hypercube)

**Total co-independent domination.** Theorem 2 builds on the double-fiber bound of Raju, Palagiri and Yero for prisms. Its bipartite-base case also follows by combining earlier theorems. Applied to hypercubes, it recovers the power-of-two equality discussed by Sonkamble, Patekar and Waphare on p. 460. [Prism formula, §2](paper/preprint.pdf#page=2) · [Sonkamble, Patekar and Waphare, p. 460](https://pphmjopenaccess.com/aadm/article/download/4533/2173#page=10) · [Literature search record](notes/searches.tsv)

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
