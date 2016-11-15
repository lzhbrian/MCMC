### Markov Chain Monte Carlo

##### 	An overview

***

* Whole paper in PDF： `./mcmc.pdf`
* Source Codes in the paper can be found in this repository.

### Abstract

__Markov Chain Monte Carlo (MCMC)__ is a technique to make an estimation of a statistic by simulation in a complex model. __Restricted Bolztmann Machine(RBM)__ is a crucial model in the ﬁeld of Machine Learning. However, training a large RBM model will include intractable computation of the __partition functions__, i.e.Z(θ). This problem has aroused in- terest in the work of estimation using a MCMC methods. In this paper, we ﬁrst conduct __Metropolis-Hastings Algorithm__, one of the most prevalent sampling methods, and analyze its correctness & performance, along with the choice of the accepting rate. We then implement three algorithms: __TAP, AIS, RTS__, to estimate partition functions of an RBM model. Our work not only give an introduction about the available algorithms, but systematically compare the performance & diﬀerence between them. We seek to provide an overall view in the ﬁeld of MCMC.

### Author

__Tzu-Heng Lin__ is currently an undergraduate student in the Dept. of Electronic Engineering, Tsinghua University. His research interests include Big Data Mining, Machine Learning, etc. For more information about him, please see www.linkedin.com/in/lzhbrian. Feel free to contact him at any time via lzhbrian@gmail.com or linzh14@mails.tsinghua.edu.cn

```bash
├── LICENSE
├── README.md
├── requirement/
├── src
│   ├── MH
│   │   ├── metropolis_hasting.R
│   └── partition
│       ├── AIS.m
│       ├── RTS.m
│       ├── TAP.m
│       ├── ais_sampling.m
│       ├── calculate_logprob.m
│       ├── draw_ais.m
│       ├── logsum.m
│       ├── main.m
│       └── run.m
├── tex/
├── upload/
└── z.mat
```