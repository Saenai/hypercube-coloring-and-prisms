# 超立方体的全支配着色与棱柱图的支配数

六维超立方体的全支配着色恰好需要 **16 种颜色**。对每个 $d\geq4$，最少颜色数都等于 $Q_d$ 的全支配数加二。

[中文证明](notes/proofs-zh.pdf) · [英文预印本](paper/preprint.pdf) · [English](README.md)

**超立方体着色。** 把长度为 $d$ 的二进制串视为顶点，相差一位的两个串相连，得到超立方体 $Q_d$。全支配着色要求相邻顶点异色，并且每个顶点都与某种颜色的全部顶点相邻。若选取一些顶点，使每个顶点（包括被选的顶点）都与至少一个被选顶点相邻，就得到一个全支配集。全支配数 $\gamma_t(Q_d)$ 是这种集合的最小大小。

**棱柱图的取等问题。** 把同一个图 $H$ 复制成两层，在对应顶点间连边，就得到棱柱图 $H\square K_2$。Alfred Raju M.、V. S. R. Palagiri 和 I. G. Yero 在 2024 年的 *On the total version of the covering Italian domination problem* 第 5.1 节询问，棱柱图的覆盖全意大利支配数达到定理 5.1 的上界时，底图的支配数是否必定等于最小点覆盖数。本文推论 4 证明，对非空、无孤立点的有限简单底图，答案是肯定的。如果允许孤立点，四点完全图加上一个孤立点就是反例。[原问题，第 341 页](https://rodin.uca.es/bitstream/handle/10498/35785/OA_2024_0987.pdf#page=9) · [本文推论 4，第 4 页](paper/preprint.pdf#page=4)

## 原问题与已有证明

**Kazemi 猜想 6.1。** Adel P. Kazemi 在 2026 年的 *Total dominator coloring of the hypercube* $Q_{2^n}$ 中证明了 $d=2^r$、$r\geq3$ 的情形，并对 $d=2^r+1$、$r\geq2$ 提出猜想。Jonas J. Gebendorfer 于同年 10 月在 *Total dominator colorings of hypercubes of dimension* $2^n+1$ 的定理 4.3 中证明了这个猜想。本文定理 1 用其色类计数和经典覆盖码界，把等式推广到所有 $d\geq4$。[Kazemi 原文](https://doi.org/10.47443/cm.2025.102) · [Gebendorfer 的证明](https://doi.org/10.13140/RG.2.2.31321.28006) · [推广的证明，第 4 节](paper/preprint.pdf#page=3)

**更早的超立方体猜想。** Kazemi 于 2013 年在 Open Problem Garden 发表 *Total Dominator Chromatic Number of a Hypercube*，当时猜测每个 $d\geq5$ 都需要 $2^{d-2}+2$ 色。该页 2014 年的评论已指出旧公式在高维失效。代入六维，旧公式给出 18 色，本文定理 1 给出的确切值是 16 色。[原始问题与评论](https://www.openproblemgarden.org/op/total_dominator_chromatic_number_of_a_hypercube)

**棱柱公式的相关工作。** 本文定理 2 沿用 Raju、Palagiri 和 Yero 的下界论证。二分底图的情形也可以由第 2 节列出的早期定理推出。对维数为二的幂的超立方体，公式还给出 Sonkamble、Patekar 和 Waphare 在第 460 页讨论的等式。[棱柱公式，第 2 节](paper/preprint.pdf#page=2) · [Sonkamble 等人的原文，第 460 页](https://pphmjopenaccess.com/aadm/article/download/4533/2173#page=10) · [查新记录](notes/searches.tsv)

OpenAI 模型推导了文中的推广结论，完成了文献检索、撰稿、模型间交叉检查和 Lean 证明。Python 程序核验了下文列出的有限情形。本版尚待数学研究者独立审读。欢迎指出某条定理或某一步推导的问题，也欢迎提供在先文献。[提交或查看反馈](https://github.com/Saenai/hypercube-coloring-and-prisms/issues)

## 核验棱柱定理

Lean 4.36.0 核验了论文第 2 节的定理 2，覆盖每个非空、无孤立点的有限简单图，也包含二分底图的推论。在棱柱中，找一个最小的全支配集，使剩下的顶点非空且互不相邻。在底图中，找一个最小的支配集，使删去它后的图能用两种颜色着色，且相邻顶点异色。前一个最小值等于后一个最小值加上底图顶点数。超立方体着色定理和取等条件的书面证明分别见论文第 1 至 4 节和第 5 节。[Lean 源码](lean/Prism.lean) · [在浏览器中核验完整证明](https://live.lean-lang.org/#project=lean-v4.36.0&url=https%3A%2F%2Fraw.githubusercontent.com%2FSaenai%2Fhypercube-coloring-and-prisms%2Fv0.1.1%2Flean%2FPrism.lean)

安装 elan 后，在仓库根目录用 Bash 运行下面的命令，即可调用两套证明检查器。项目已固定 Lean 版本，只依赖自带的标准库。[Lean 安装说明](https://lean-lang.org/install/)

```sh
bash lean/check.sh
```

脚本先用 Lean 编译完整文件，再把两项证明和全部依赖交给独立类型检查器 Nanoda。核验只允许三条标准逻辑公理（`propext`、`Classical.choice`、`Quot.sound`）。成功时最后一行显示 `Checked 2270 declarations with no errors`。[核验脚本](lean/check.sh)

## 复现计算

在仓库根目录运行以下命令。需要 Python 3.10 或更新版本，两个程序均只使用标准库。

```sh
python3 code/verify.py
python3 code/verify_prisms.py --all-labels
```

第一份程序核验覆盖码与五维着色的显式构造。第二份程序检查二至五点的全部 814 个无孤立点标号底图。加上 `--all-labels` 后，它还会在这些图的棱柱上逐一核对 45,621,630 个三值标号，并另行检查两个例子。省去该参数可运行较快的子集枚举。

[英文源稿](paper/preprint.tex) 用 pdfLaTeX 编译两次。[中文源稿](notes/proofs-zh.tex) 用 XeLaTeX 编译，使用 Noto 中文字体。
