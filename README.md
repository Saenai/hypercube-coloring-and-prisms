# Total dominator colorings of hypercubes and total co-independent domination in prisms

Working draft, 27 November 2026. [Read the paper (PDF)](paper/preprint.pdf) · [中文说明](README.zh-CN.md)

The paper proves two results in graph theory.

1. For every dimension $d\geq 4$, the total dominator chromatic number of the binary hypercube $Q_d$ is exactly $\gamma_t(Q_d)+2$, where $\gamma_t$ is the total domination number. In dimension six this gives 16 colors.
2. For a graph $H$ without isolated vertices, the covering total Italian domination number of the prism over $H$ attains the upper bound of Alfred Raju M., Palagiri and Yero exactly when the domination number of $H$ equals its minimum vertex cover size. If isolated vertices are allowed in $H$, a complete graph on four vertices together with an isolated vertex gives a counterexample. [The question on p. 341](https://rodin.uca.es/bitstream/handle/10498/35785/OA_2024_0987.pdf#page=9)

## Prior work and review status

Kazemi proved the coloring equality for dimensions $2^r$ with $r\geq3$. Gebendorfer proved Kazemi’s Conjecture 6.1 for $2^r+1$ with $r\geq2$ in October 2026. The paper extends these dimension families using Gebendorfer’s color-class count and classical covering-code bounds. [Kazemi](https://doi.org/10.47443/cm.2025.102) · [Gebendorfer](https://doi.org/10.13140/RG.2.2.31321.28006)

The prism proof builds on the earlier double-fiber lower bound. The paper gives a formula for all bases without isolated vertices and uses it to characterize equality. Section 2 explains how the bipartite-base case already follows by combining earlier theorems. [Paper, §2 and §5](paper/preprint.pdf) · [Literature search queries, 27 November 2026](notes/searches.tsv)

OpenAI language models derived the extensions, searched the literature and drafted the manuscript. Separate model instances checked the arguments, and Python programs checked the finite cases described below. Independent human mathematical review is pending. Corrections to the proofs and references to earlier results are welcome in the repository’s Issues.

## Reproduce the checks

Run the following from the repository root with Python 3.10 or later. Both scripts use only the standard library.

```sh
python3 code/verify.py
python3 code/verify_prisms.py --all-labels
```

The first script checks explicit covering codes and a five-dimensional coloring. The second checks all 814 labelled base graphs on two through five vertices with no isolates. With `--all-labels` it enumerates 45,621,630 Italian labelings on their prisms, then checks two examples separately. Omitting the flag runs the faster subset check. The manuscript contains the proofs for arbitrary orders and dimensions.

The English [LaTeX source](paper/preprint.tex) builds with two runs of pdfLaTeX. The [Chinese proof notes](notes/proofs-zh.pdf) include a 384-word covering code of length twelve. Their [source](notes/proofs-zh.tex) uses XeLaTeX and the Noto CJK fonts.
