#' Graphical model stability and model selection procedures
#' 
#' ...
#' @name mplot-package
#' @docType package
#' @title Graphical model stability and model selection procedures
#' @author Garth Tarr
#' @keywords package
#' @seealso \code{\link{...}}
NULL


#' Body fat data set
#' 
#' A data frame with 128 observations on 15 variables.
#' 
#' @name bodyfat
#' @format A data frame with 128 observations on 15 variables.
#' @details Details about the bodyfat data set go here.
#' @docType data
#' @keywords datasets
#' @usage data(bodyfat)
#' @references Johnson W (1996, Vol 4). Fitting percentage of 
#'   body fat to simple body measurements. Journal of Statistics 
#'   Education. Bodyfat data retrieved from 
#'   http://www.amstat.org/publications/jse/v4n1/datasets.johnson.html
#'   An expanded version is included in the \code{mfp} R package.
#' @examples
#' data(bodyfat)
#' full.mod = lm(Bodyfat~.,data=subset(bodyfat,select=-Id))
NULL


#' Extract model elements
#' 
#' This function extracts things like the formula,
#' data matrix, etc. from a lm or glm object
#' 
#' @param model a fitted 'full' model, the result of a call
#'   to lm or glm (and in the future lme or lmer).
mextract = function(model){
  # what's the name of the dependent variable?
  yname = deparse(formula(model)[[2]])
  # Set up the data frames for use
  X = model.matrix(model)
  if(colnames(X)[1]=="(Intercept)"){
    # overwrite intercept with y-variable
    X[,1] = model.frame(model)[,yname] 
  } else {
    X = cbind(model.frame(model)[,yname],X)
  }
  colnames(X)[1] = yname
  X = data.frame(X)
  fixed = as.formula(c(paste(yname,"~"),
                       paste(colnames(X)[-1],collapse="+")))
  Xy = X[c(2:ncol(X),1)]
  return(list(yname=yname,
              fixed=fixed,
              X=Xy,
              k = length(model$coef),
              n=nrow(Xy),
              family = family(model)))
  
  # MIXED MODELS NOT IMPLEMENTED IN FIRST RELEASE   
  #   if(class(model)=="lmerMod"){ # lme4 package
  #     X = model.matrix(model)
  #     data = data.frame(model.frame(model)) # or slot(model, "frame")
  #     if(isGLMM(model)){
  #       family = family(model) # 
  #       # pass to glm ?? 
  #       # i.e. wild bootstrap appropriate for glmm's too?
  #       # though should really call glmer for the full model
  #       # so it may be the case that class(model) won't be lmerMod
  #       # if the family argument was passed to it as lmer() 
  #       # calls glmer() if there is a family argument present
  #     }
  #     yname = deparse(formula(model)[[2]])
  #     X = data.frame(data[,yname],X)
  #     colnames(X)[1] = yname
  #     fixed.formula = paste(yname,"~",
  #                           paste(names(fixef(model))[-1],collapse="+"))
  #     model = lm(fixed.formula,data = X)
  #   } else if(class(model)=="lme"){ # nlme package
  #     data = model$data
  #     X = model.matrix(model,data = data)
  #     # nlme package assumes gaussian errors 
  #     yname = deparse(formula(model)[[2]])
  #     X = data.frame(data[,yname],X)
  #     colnames(X)[1] = yname
  #     fixed.formula = paste(yname,"~",
  #                           paste(names(coef(model))[-1],collapse="+"))
  #     model = lm(fixed.formula, data = X)
  #   }
}

#' Print text for fence methods
#' 
#' This function provides the text for the case when trace=TRUE
#' when using lmfence and glmfence functions.
#' 
#' @param score realised value
#' @param UB upper bound
#' @param obj fitted model object
txt.fn = function(score,UB,obj){
  cat("\n")
  cat(paste("hatQm:", round(score,2),"; Upper bound:", round(UB,2)),"\n")
  cat(paste("hatQm <= UB:",score<=UB,"\n"))
  cat(deparse(formula(obj)))
  cat("\n")
}

#' Process results within af function
#' 
#' This function is used by the af function to process
#' the results when iterating over different boundary values
#' 
#' @param fence.mod set of fence models
#' @param fence.rank set of fence model ranks
process.fn = function(fence.mod,fence.rank){
  # all that pass the fence
  temp.all = sort(table(sapply(fence.mod,deparse,
                               width.cutoff=500)),
                  decreasing=TRUE)
  pstarj.all = as.numeric(temp.all[1]/length(fence.mod))
  pstarnamej.all = names(temp.all)[1]
  # best only (true fence)
  fence.mod.bo = fence.mod[fence.rank==1]
  temp.bo = sort(table(sapply(fence.mod.bo,deparse,
                              width.cutoff=500)),
                 decreasing=TRUE)
  pstarj.bo = as.numeric(temp.bo[1]/length(fence.mod.bo))
  pstarnamej.bo = names(temp.bo)[1]
  return(c(pstarj.bo,pstarnamej.bo,pstarj.all,pstarnamej.all))
}

