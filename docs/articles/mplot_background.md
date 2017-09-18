---
title: mplot philosophy
keywords: mplot, getting_started
bibliography: jss.bib
csl: apa-old-doi-prefix.csl
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{egebundleR}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

> Background on model selection and the mplot package.

The methods provided by the **mplot** package rely heavily on various bootstrap techniques to give an indication of the stability of selecting a given model or variable and even though not done here, could be implemented with resampling methods other than the bootstrap, for example cross validation. The **m** in **mplot** stands for model selection/building and we anticipate that in  future more graphs and methods will be added to the package to further aid better and more stable building of regression models.  The intention is to encourage researchers to engage more closely with the model selection process, allowing them to pair their experience and domain specific knowledge with comprehensive summaries of the relative importance of various statistical models.

Two major challenges in model building are the vast number of models to choose from and the myriad of ways to do so.  Standard approaches include stepwise variable selection techniques and more recently the lasso. A common issue with these and other methods is their instability, that is, the tendency for small changes in the data to lead to the selection of different models.

An early and significant contribution to the use of bootstrap model selection is [Shao (2013)](http://doi.org/10.2307/2291661 "Shao J (1996). “Bootstrap Model Selection.” Journal of the American Statistical Association, 91(434), 655-665.") who showed that carefully selecting \\(m\\) in an \\(m\\)-out-of-\\(n\\) bootstrap drives the theoretical properties of the model selector. [Mueller and Welsh (2005)](http://doi.org/10.1198/ 016214505000000529 "Mueller S, Welsh AH (2005). “Outlier Robust Model Selection in Linear Regression.” Journal of the American Statistical Association, 100(472), 1297–1310.") and [Mueller and Welsh (2009)](http://www3.stat.sinica.edu.tw/sstest/oldpdf/A19n315.pdf "Mueller S, Welsh AH (2009). “Robust Model Selection in Generalized Linear Models.” Statistica Sinica, 19(3), 1155–1170.") modified and generalised Shao's \\(m\\)-out-of-\\(n\\) bootstrap model selection method to robust settings, first in linear regression and then in generalised linear models. The bootstrap is also used in regression models that are not yet covered by the **mplot** package, such as mixed models (e.g. [Shang and Cavanaugh (2008)](http://doi.org/10.1016/j.csda.2007.06.019 "Shang J, Cavanaugh JE (2008). “Bootstrap Variants of the Akaike Information Criterion for Mixed Model Selection.” Computational Statistics & Data Analysis, 52(4), 2004–2021.")) or partially linear models (e.g. [Mueller and Vial (2008)](http://doi.org/10.1111/j.1467-842X.2009.00540.x "Mueller S, Vial C (2009). “Partially Linear Model Selection by the Bootstrap.” Australian & New Zealand Journal of Statistics, 51(2), 183–200.")) as well as for the selection of tuning parameters in regularisation methods (e.g. [Park, Sakaori and Konishi (2008)](http://doi.org/10.1080/00949655.2012.755532 "Park H, Sakaori F, Konishi S (2014). "Robust Sparse Regression and Tuning Parameter Selection via the Efficient Bootstrap Information Criteria.” Journal of Statistical Computation and Simulation, 84(7), 1596–1607.")).

Assume that we have \\(n\\) independent observations \\(\mathbf{y} = (y\_{1},\ldots,y\_{n})^{\top}\\) and an \\(n\times p\\) full rank design matrix \\(\mathbf{X}\\) whose columns are indexed by \\(1,\ldots,p\\). Let \\(\alpha\\) denote any subset of \\(p\_{\alpha}\\) distinct elements from \\(\{1,\ldots,p\}\\). Let \\(\mathbf{X}\_{\alpha}\\) be the corresponding \\(n\times p\_{\alpha}\\) design matrix and \\(\mathbf{x}\_{\alpha i}^{\top}\\) denote the \\(i\\)th row of \\(\mathbf{X}\_{\alpha}\\).

The **mplot** package focuses specifically on linear and generalised linear models (GLM). In the context of GLMs, a model \\(\alpha\\) for the relationship between the response \\(\mathbf{y}\\) and the design matrix \\(\mathbf{X}\_{\alpha}\\) is specified by
\begin{align}
\mathbb{E}(\mathbf{y}) = h(\mathbf{X}\_{\alpha}^{\top}\boldsymbol{\beta}\_{\alpha}), \text{ and }\operatorname{var}(\mathbf{y}) = \sigma^{2}v(h(\mathbf{X}\_{\alpha}^{\top}\boldsymbol{\beta}\_{\alpha})),
\end{align}
where \\(\boldsymbol{\beta}\_{\alpha}\\) is an unknown \\(p\_{\alpha}\\)-vector of regression parameters and \\(\sigma\\) is an unknown scale parameter. Here \\(\mathbb{E}(\cdot)\\) and \\(\operatorname{var}(\cdot)\\)  denote the expected value and variance of a random variable, \\(h\\) is the inverse of the usual link function and both \\(h\\) and \\(v\\) are assumed known. When \\(h\\) is the identity and \\(v(\cdot)=1\\), we recover the standard linear model.  

The purpose of model selection is to choose one or more models \\(\alpha\\) from a set of candidate models, which may be the set of all models \\(\mathcal{A}\\) or a reduced model set (obtained, for example, using any initial screening method). Many model selection procedures assess model fit using the generalised information criterion,
\begin{equation}
\textrm{GIC}(\alpha,\lambda) = \hat{Q}(\alpha) + \lambda p\_{\alpha}. \label{GIC}
\end{equation}
The \\(\hat{Q}(\alpha)\\) component is a measure of _description loss_ or _lack of fit_, a function that describes how well a model fits the data, for example, the residual sum of squares or \\(-2~\times~\text{log-likelihood}\\). The number of independent regression model parameters, \\(p\_{\alpha}\\), is a measure of _model complexity_. The penalty multiplier, \\(\lambda\\), determines the properties of the model selection criterion ([Murray, Heritier and Mueller (2013)](http://doi.org/10.1002/sim.5855 "Murray K, Heritier S, Mueller S (2013). “Graphical Tools for Model Selection in Generalized Linear Models.” Statistics in Medicine, 32(25), 4438–4451."); [Mueller and Welsh (2010)](http://doi.org/10.1111/j.1751-5823.2010.00108.x "Mueller S, Welsh A (2010). “On Model Selection Curves.” International Statistical Review, 78(2), 240–256.")). Special cases, when \\(\hat{Q}(\alpha)=-2\times\text{log-likelihood}(\alpha)\\), include the AIC with \\(\lambda=2\\), BIC with \\(\lambda=\log(n)\\) and more generally the generalised information criterion (GIC) with \\(\lambda\in\mathbb{R}\\) [Konishi and Kitagawa (2008)](http://doi.org/10.1093/biomet/83.4.875 "Konishi S, Kitagawa G (1996). “Generalised Information Criteria in Model Selection.” Biometrika, 83(4), 875–890.").

The **mplot** package currently implements _variable inclusion plots_, _model stability plots_ and a model selection procedure inspired by the adaptive fence of [Jiang et al. (2008)](http://doi.org/10.1214/07-AOS517 "Jiang J, Rao JS, Gu Z, Nguyen T (2008). “Fence Methods for Mixed Model Selection.” The Annals of Statistics, 36(4), 1669–1692.").  Variable inclusion plots were introduced independently by [Mueller and Welsh (2010)](http://doi.org/10.1111/j.1751-5823.2010.00108.x "Mueller S, Welsh A (2010). “On Model Selection Curves.” International Statistical Review, 78(2), 240–256.") and [Meinshausen and Bühlmann (2010)](http://doi.org/10.1111/j.1467-9868.2010.00740.x "Meinshausen N, Bühlmann P (2010). “Stability Selection.” Journal of the Royal Statistical Society: Series B (Statistical Methodology), 72(4), 417–473."). The idea is that the best model is selected over a range of values of the penalty multiplier \\(\lambda\\) and the results are visualised on a plot which shows how often each variable is included in the best model.  These types of plots have previously been referred to as stability paths, model selection curves and most recently variable inclusion plots (VIPs) in [Murray, Heritier and Mueller (2013)](http://doi.org/10.1002/sim.5855 "Murray K, Heritier S, Mueller S (2013). “Graphical Tools for Model Selection in Generalized Linear Models.” Statistics in Medicine, 32(25), 4438–4451.").  An alternative to penalising for the number of variables in a model is to assess the fit of models within each model size. This is the approach taken in our model stability plots where searches are performed over a number of bootstrap replications and the best models for each size are tallied. The rationale is that if there exists a _correct_ model of a particular model size it will be selected overwhelmingly more often than other models of the same size.  Finally, the adaptive fence was introduced by [Jiang et al. (2009)](http://doi.org/10.1016/j.spl.2008.10.014 "Jiang J, Nguyen T, Rao JS (2009). “A Simplified Adaptive Fence Procedure.” Statistics & Probability Letters, 79(5), 625–629.") to select mixed models.  This is the first time code has been made available to implement the adaptive fence and the first time the adaptive fence has been applied to linear and generalised linear models.

For all methods, we provide publication quality classical plot methods using base **R** graphics as well as interactive plots using the **googleVis** package [@Gesmann:2011]. We also add further utility to these plot methods by packaging the results in a **shiny** web interface which facilitates a high degree of interactivity [@Chang:2015a; @Chang:2015b].



In the rejoinder to their least angle regression paper, @Tibshirani:2004 comment,

> "In actual practice, or at least in good actual practice, there is a cycle of activity between the investigator, the statistician and the computer ...  The statistician examines the output critically, as did several of our commentators, discussing the results with the investigator, who may at this point suggest adding or removing explanatory variables, and so on, and so on."

We hope the suite of methods available in the **mplot** package adds valuable information to this cycle of activity between researchers and statisticians.  In particular, providing statisticians and researchers alike with a deeper understanding of the relative importance of different models and the variables contained therein.

In the artificial example, we demonstrated a situation where giving the researcher more information in a graphical presentation can lead to choosing the _correct_ model when standard stepwise procedures would have failed.  

The diabetes data set suggested the existence of a number of different dominant models at various model sizes which could then be investigated further, for example, statistically using cross validation to determine predictive ability, or in discussion with researchers to see which makes the most practical sense.  In contrast, there are no clear models suggested for the birth weight example.  The adaptive fence has no peaks, nor is there a clearly dominant model in the model stability plot even though all but one variable are more informative than the added redundant variable in the variable inclusion plot.

While the core of the **mplot** package is built around exhaustive searches, this becomes computationally infeasible as the number of variables grows.  We have implemented similar visualisations to model stability plots and variable inclusion plots for **glmnet** which  brings the concept of model stability to much larger model sizes, though it will no longer be based around exhaustive searches.

The graphs provided by the **mplot** package are a major contribution.  A large amount of information is generated by the various methods and the best way to interpret that information is through effective visualisations.  For example, as was be shown in the [diabetes example](mplot_diabetes), the path a variable takes through the variable inclusion plot is often more important than the average inclusion probability over the range of penalty values considered.  It can also be instructive to observe when there are no peaks in the adaptive fence plot as this indicates that the variability of the log-likelihood is limited and no single model stands apart from the others.  Such a relatively flat likelihood over various models would also be seen in the model stability plot where there was no dominant model over the range of model sizes considered.

Although interpretation of the model selection plots provided here is something of an _art_, this is not something to shy away from.  We accept and train young statisticians to interpret qq-plots and residual plots.  There is a wealth of information in our plots, particularly the interactive versions enhanced with the shiny interface, that can better inform a researchers' model selection choice.

