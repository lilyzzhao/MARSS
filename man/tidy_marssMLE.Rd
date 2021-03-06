\name{tidy.marssMLE}
\alias{tidy.marssMLE}
\title{Return estimated parameters and states with summary information}
\usage{
  tidy.marssMLE(x, type = c("parameters", "states"),
                conf.int = TRUE, conf.level = 0.95,
                form=attr(x[["model"]], "form")[1], ...)
}
\arguments{
  \item{x}{a marssMLE object}
  
  \item{type}{Estimates for the parameters or for the states.}
  
  \item{conf.int}{ Whether to include a confidence interval.}

  \item{conf.level}{ Confidence level if interval is returned.}

  \item{form}{If you want the augment function to use a different form than that specified in attr(x$model, "form").  Useful if you have a DFA model that you manually set up, which does not have the form attribute set.}
  
  \item{...}{Optional arguments.  If \code{conf.int=TRUE}, then arguments to specify how CIs are computed can be passed in. See details and \code{\link{MARSSparamCIs}}. If form="dfa", \code{rotate=TRUE} can be passed in to rotate the trends (only trends not Z matrix).}

}
\description{
  This returns a data.frame with the estimated parameters (or states) of a MARSS model with optionally standard errors and confidence intervals. This assembles information available via the print and coef functions into a data.frame that summarizes the estimates.
  
  If conf.int=TRUE.  For parameters, \code{\link{MARSSparamCIs}} will be run to add confidence intervals to the fitted model object if these are not already added.  The default CIs are calculated using a analytically computed Hessian matrix.  This can be changed by passing in optional arguments for \code{\link{MARSSparamCIs}}. For states, the approximate CIs using the standard deviation of the states is used to compute the confidence intervals (\code{qnorm(alpha/2)*se.fit + fitted}).
  
  If you have a DFA model (form='dfa'), you can pass in \code{rotate=TRUE} to return the rotated trends.  If you want the rotated loadings, you will need to compute those yourself:
\preformatted{
dfa <- MARSS(t(harborSealWA[,-1]), model=list(m=2), form="dfa")
Z.est <- coef(dfa, type="matrix")$Z
H.inv <- varimax(coef(dfa, type="matrix")$Z)$rotmat
Z.rot <- Z.est \%*\% H.inv
}
  
  The tidy function is compatible with the \code{broom} package.
}
\examples{
  dat <- t(harborSeal)
  dat <- dat[c(2,11,12),]
  MLEobj <- MARSS(dat, model=list(Z=factor(c("WA","OR","OR"))))

library(broom)
library(ggplot2)

# A data frame of the estimated parameters
 tidy(MLEobj)
 
# Make a plot of the estimated states
# Don't use augment.  States are not data.
d <- tidy(MLEobj, type="states")
ggplot(data = d) + 
  geom_line(aes(t, estimate)) +
  geom_ribbon(aes(x=t, ymin=conf.low, ymax=conf.high), linetype=2, alpha=0.1) +
  facet_grid(~term) +
  xlab("Time Step") + ylab("Count")
}