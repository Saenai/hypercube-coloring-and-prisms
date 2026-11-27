# 超立方体的全支配着色与棱柱图的支配数

研究草稿，2026 年 11 月 27 日。[中文证明](notes/proofs-zh.pdf) · [英文论文](paper/preprint.pdf) · [English](README.md)

## 论文证明了什么

**超立方体着色。** 把长度为 $d$ 的二进制串视为顶点，相差一位的两个串相连，得到超立方体 $Q_d$。全支配着色要求相邻顶点异色，并且每个顶点都能看见某种颜色的全部顶点。若选取一些顶点，使每个顶点（包括被选的顶点）都与至少一个被选顶点相邻，就得到一个全支配集。记其最小大小为 $\gamma_t(Q_d)$。论文证明，对每个 $d\geq4$，最少需要的颜色数恰好是 $\gamma_t(Q_d)+2$。例如六维恰好需要 16 色。

**棱柱图的取等问题。** 把同一个图复制成两层，在对应顶点间连边，就得到它的棱柱图。2024 年，Alfred Raju M.、Palagiri 和 Yero 询问，棱柱图的覆盖全意大利支配数达到他们给出的上界时，底图的支配数是否必定等于最小点覆盖数。论文证明，对于无孤立点的底图，答案是肯定的。如果允许孤立点，四点完全图加上一个孤立点就是反例。[原问题，印刷第 341 页](https://rodin.uca.es/bitstream/handle/10498/35785/OA_2024_0987.pdf#page=9)

## 文献与审读状态

着色定理的两个维数族已有证明。Kazemi 处理了 $d=2^r$、$r\geq3$ 的情形，Gebendorfer 于 2026 年 10 月证明了 Kazemi 猜想 6.1 的全部情形，即 $d=2^r+1$、$r\geq2$。本稿用 Gebendorfer 的色类计数和经典覆盖码界，把结论推广到所有 $d\geq4$。棱柱部分沿用了 Raju 等人的下界。英文稿第 2 节也列出能直接推出二分底图特例的早期文献。[Kazemi](https://doi.org/10.47443/cm.2025.102) · [Gebendorfer](https://doi.org/10.13140/RG.2.2.31321.28006) · [查新记录](notes/searches.tsv)

OpenAI 模型推导了文中的推广结论，完成了文献检索、撰稿、模型间交叉检查和 Lean 证明。Python 程序核验了下文列出的有限情形。本版尚待数学研究者独立审读。欢迎指出某条定理或某一步推导的问题，也欢迎提供在先文献。[提交或查看反馈](https://github.com/Saenai/hypercube-coloring-and-prisms/issues)

## 亲手试一次 Lean

Lean 4.36.0 核验了论文第 2 节的定理 2，覆盖每个非空、无孤立点的有限简单图，也包含二分底图的推论。定理比较两个最小值。在棱柱中，找一个最小的全支配集，使剩下的顶点非空且互不相邻。在底图中，找一个最小的支配集，使删去它后的图能用两种颜色着色，且相邻顶点异色。前一个最小值等于后一个最小值加上底图顶点数。第 1 节的超立方体着色定理和第 5 节的取等条件仍由论文中的证明支撑。[Lean 源码](lean/Prism.lean) · [在浏览器里打开可编辑的证明](https://live.lean-lang.org/#project=lean-v4.36.0&url=https%3A%2F%2Fraw.githubusercontent.com%2FSaenai%2Fhypercube-coloring-and-prisms%2Fmain%2Flean%2FPrism.lean)

第一次用 Lean，可以在网页里搜索 `vertical_covered`。它说，棱柱中同一个顶点的上下两份之间有一条竖边，点覆盖必须选中至少一端。删掉 `apply cover` 的下一行，Lean 会留下一个目标 `⊢ prismAdj H (x, false) (x, true)`，意思是“请证明这两个顶点相邻”。亲手填入下面两行。第一行选择竖边的情形，第二行说明底图顶点相同、所在层不同。

```lean
  left
  exact ⟨rfl, Bool.false_ne_true⟩
```

要在自己的电脑上核验整份文件，先安装 elan，再从仓库根目录运行下面两行。项目已固定 Lean 版本，只依赖自带的标准库。[Lean 安装说明](https://lean-lang.org/install/)

```sh
cd lean
lean -DwarningAsError=true Prism.lean
```

输出的最后两行会列出两个定理各自依赖的标准逻辑公理（`propext`、`Classical.choice`、`Quot.sound`）。

在同一目录运行 `bash check.sh`，还可以用第二种方法复核。脚本把两个定理的证明导出，交给这一版 Lean 附带的独立类型检查器 Nanoda。它只允许上述三条公理，并检查证明用到的所有声明。[核验脚本](lean/check.sh)

## 复现计算

在仓库根目录运行以下命令。需要 Python 3.10 或更新版本，两个程序均只使用标准库。

```sh
python3 code/verify.py
python3 code/verify_prisms.py --all-labels
```

第一份程序核验覆盖码与五维着色的显式构造。第二份程序检查二至五点的全部 814 个无孤立点标号底图。加上 `--all-labels` 后，它还会在这些图的棱柱上逐一核对 45,621,630 个三值标号，并另行检查两个例子。省去该参数可运行较快的子集枚举。

[英文源稿](paper/preprint.tex) 用 pdfLaTeX 编译两次。[中文源稿](notes/proofs-zh.tex) 用 XeLaTeX 编译，使用 Noto 中文字体。
