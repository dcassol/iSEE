% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R
\name{visual-parameters-generics}
\alias{visual-parameters-generics}
\alias{.defineVisualColorInterface}
\title{Generics for row/column visual parameters}
\description{
These generics allow subclasses to override the user inputs controlling visual parameters
of a \linkS4class{ColumnDataPlot} or \linkS4class{RowDataPlot}.
}
\section{Color parameters}{

\code{.defineVisualColorInterface(x, se, select_info)} takes \code{x}, a \linkS4class{Panel} instance,
\code{se}, the \linkS4class{SummarizedExperiment} object,
and \code{select_info} a list of character vectors named \code{row} and \code{column} which specifies the names of panels available for transmitting single selections on the rows/columns.
It is expected to return an HTML tag definition that contains the user inputs to display in the \code{"Color"} section of the visual parameters.

In practice, it is a good idea to make use of information precomputed by \code{\link{.cacheCommonInfo}}.
For example, \code{\link{.cacheCommonInfo,ColumnDotPlot-method}} will add vectors specifying whether a variable in the \code{\link{colData}} is valid and discrete or continuous.
}

\section{Shape parameters}{

\code{.defineVisualShapeInterface} takes \code{x}, a \linkS4class{Panel} instance,
and \code{se}, the \linkS4class{SummarizedExperiment} object.
It is expected to return an HTML tag definition that contains the user inputs to display in the \code{"Shape"} section of the visual parameters.
}

\section{Point parameters}{

\code{.defineVisualPointInterface} takes \code{x}, a \linkS4class{Panel} instance,
and \code{se}, the \linkS4class{SummarizedExperiment} object.
It is expected to return an HTML tag definition that contains the user inputs to display in the \code{"Point"} section of the visual parameters.
}

\section{Facet paraeters}{

\code{.defineVisualFacetInterface} takes \code{x}, a \linkS4class{Panel} instance,
and \code{se}, the \linkS4class{SummarizedExperiment} object.
It is expected to return an HTML tag definition that contains the user inputs to display in the \code{"Facet"} section of the visual parameters.
}

\section{Other parameters}{

\code{.defineVisualOtherInterface} takes \code{x}, a \linkS4class{Panel} instance.
It is expected to return an HTML tag definition that contains the user inputs to display in the \code{"Other"} section of the visual parameters.
}

\seealso{
\code{tagList}
}
\author{
Kevin Rue-Albrecht
}