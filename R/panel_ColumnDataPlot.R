#' The ColumnDataPlot panel
#'
#' The ColumnDataPlot is a panel class for creating a \linkS4class{ColumnDotPlot} where the y-axis represents a variable from the \code{\link{colData}} of a \linkS4class{SummarizedExperiment} object.
#' It provides slots and methods for specifying which variable to use on the y-axis (and, optionally, also the x-axis), as well as a method to create the data.frame in preparation for plotting.
#'
#' @section Slot overview:
#' The following slots control the column data information that is used:
#' \itemize{
#' \item \code{YAxis}, a string specifying the column of the \code{\link{colData}} to show on the y-axis.
#' If \code{NA}, defaults to the first valid field (see \code{?"\link{.refineParameters,ColumnDotPlot-method}"}).
#' \item \code{XAxis}, string specifying what should be plotting on the x-axis.
#' This can be any one of \code{"None"} or \code{"Column data"}.
#' Defaults to \code{"None"}.
#' \item \code{XAxisColumnData}, string specifying the column of the \code{\link{colData}} to show on the x-axis.
#' If \code{NA}, defaults to the first valid field.
#' }
#'
#' In addition, this class inherits all slots from its parent \linkS4class{ColumnDotPlot}, \linkS4class{DotPlot} and \linkS4class{Panel} classes.
#'
#' @section Constructor:
#' \code{ColumnDataPlot(...)} creates an instance of a ColumnDataPlot class, where any slot and its value can be passed to \code{...} as a named argument.
#'
#' @section Supported methods:
#' In the following code snippets, \code{x} is an instance of a \linkS4class{ColumnDataPlot} class.
#' Refer to the documentation for each method for more details on the remaining arguments.
#'
#' For setting up data values:
#' \itemize{
#' \item \code{\link{.refineParameters}(x, se)} returns \code{x} after replacing any \code{NA} value in \code{YAxis} or \code{XAxisColumnData} with the name of the first valid \code{\link{colData}} variable.
#' This will also call the equivalent \linkS4class{ColumnDotPlot} method for further refinements to \code{x}.
#' If no valid column metadata variables are available, \code{NULL} is returned instead.
#' }
#'
#' For defining the interface:
#' \itemize{
#' \item \code{\link{.defineDataInterface}(x, se, select_info)} returns a list of interface elements for manipulating all slots described above.
#' \item \code{\link{.panelColor}(x)} will return the specified default color for this panel class.
#' \item \code{\link{.allowableXAxisChoices}(x, se)} returns a character vector specifying the acceptable variables in \code{\link{colData}(se)} that can be used as choices for the x-axis. 
#' This consists of all variables with atomic values.
#' \item \code{\link{.allowableYAxisChoices}(x, se)} returns a character vector specifying the acceptable variables in \code{\link{colData}(se)} that can be used as choices for the y-axis. 
#' This consists of all variables with atomic values.
#' }
#'
#' For monitoring reactive expressions:
#' \itemize{
#' \item \code{\link{.createObservers}(x, se, input, session, pObjects, rObjects)} sets up observers for all slots described above and in the parent classes.
#' This will also call the equivalent \linkS4class{ColumnDotPlot} method.
#' }
#'
#' For defining the panel name:
#' \itemize{
#' \item \code{\link{.fullName}(x)} will return \code{"Column data plot"}.
#' }
#'
#' For creating the plot:
#' \itemize{
#' \item \code{\link{.generateDotPlotData}(x, envir)} will create a data.frame of column metadata variables in \code{envir}.
#' It will return the commands required to do so as well as a list of labels.
#' }
#'
#' @section Subclass expectations:
#' Subclasses do not have to provide any methods, as this is a concrete class.
#' 
#' @author Aaron Lun
#'
#' @seealso
#' \linkS4class{ColumnDotPlot}, for the immediate parent class.
#'
#' @examples
#' #################
#' # For end-users #
#' #################
#'
#' x <- ColumnDataPlot()
#' x[["XAxis"]]
#' x[["XAxis"]] <- "Column data"
#'
#' ##################
#' # For developers #
#' ##################
#'
#' library(scater)
#' sce <- mockSCE()
#' sce <- logNormCounts(sce)
#'
#' old_cd <- colData(sce)
#' colData(sce) <- NULL
#'
#' # Spits out a NULL and a warning if there is nothing to plot.
#' sce0 <- .cacheCommonInfo(x, sce)
#' .refineParameters(x, sce0)
#'
#' # Replaces the default with something sensible.
#' colData(sce) <- old_cd
#' sce0 <- .cacheCommonInfo(x, sce)
#' .refineParameters(x, sce0)
#'
#' @docType methods
#' @aliases ColumnDataPlot ColumnDataPlot-class
#' initialize,ColumnDataPlot-method
#' .refineParameters,ColumnDataPlot-method
#' .defineDataInterface,ColumnDataPlot-method
#' .createObservers,ColumnDataPlot-method
#' .fullName,ColumnDataPlot-method
#' .panelColor,ColumnDataPlot-method
#' .generateDotPlotData,ColumnDataPlot-method
#' .allowableXAxisChoices,ColumnDataPlot-method
#' .allowableYAxisChoices,ColumnDataPlot-method
#'
#' @name ColumnDataPlot-class
NULL

#' @export
ColumnDataPlot <- function(...) {
    new("ColumnDataPlot", ...)
}

#' @export
#' @importFrom methods callNextMethod
setMethod("initialize", "ColumnDataPlot", function(.Object, ...) {
    args <- list(...)
    args <- .emptyDefault(args, .colDataXAxis, .colDataXAxisNothingTitle)
    args <- .emptyDefault(args, .colDataXAxisColData, NA_character_)
    args <- .emptyDefault(args, .colDataYAxis, NA_character_)
    do.call(callNextMethod, c(list(.Object), args))
})

.colDataXAxisNothingTitle <- "None"
.colDataXAxisColDataTitle <- "Column data"

#' @export
#' @importFrom methods callNextMethod
setMethod(".refineParameters", "ColumnDataPlot", function(x, se) {
    x <- callNextMethod() # Do this first to trigger warnings from base classes.
    if (is.null(x)) {
        return(NULL)
    }

    yaxis <- .allowableYAxisChoices(x, se)
    if (length(yaxis)==0L) {
        warning(sprintf("no valid y-axis 'colData' fields for '%s'", class(x)[1]))
        return(NULL)
    }

    xaxis <- .allowableXAxisChoices(x, se)
    if (length(xaxis)==0L) {
        warning(sprintf("no valid x-axis 'colData' fields for '%s'", class(x)[1]))
        return(NULL)
    }

    x <- .replace_na_with_first(x, .colDataYAxis, yaxis)
    x <- .replace_na_with_first(x, .colDataXAxisColData, xaxis)

    x
})

#' @importFrom S4Vectors setValidity2
setValidity2("ColumnDataPlot", function(object) {
    msg <- character(0)

    msg <- .allowable_choice_error(msg, object, .colDataXAxis,
        c(.colDataXAxisNothingTitle, .colDataXAxisColDataTitle))

    msg <- .single_string_error(msg, object,
        c(.colDataXAxisColData, .colDataYAxis))

    if (length(msg)) {
        return(msg)
    }
    TRUE
})

#' @export
#' @importFrom shiny selectInput radioButtons
#' @importFrom methods callNextMethod
setMethod(".defineDataInterface", "ColumnDataPlot", function(x, se, select_info) {
    panel_name <- .getEncodedName(x)
    .input_FUN <- function(field) { paste0(panel_name, "_", field) }

    list(
        .selectInputHidden(x, .colDataYAxis,
            label="Column of interest (Y-axis):",
            choices=.allowableYAxisChoices(x, se),
            selected=x[[.colDataYAxis]]),
        .radioButtonsHidden(x, .colDataXAxis, 
            label="X-axis:", inline=TRUE,
            choices=c(.colDataXAxisNothingTitle, .colDataXAxisColDataTitle),
            selected=x[[.colDataXAxis]]),
        .conditional_on_radio(.input_FUN(.colDataXAxis),
            .colDataXAxisColDataTitle,
            .selectInputHidden(x, .colDataXAxisColData,
                label="Column of interest (X-axis):",
                choices=.allowableXAxisChoices(x, se),
                selected=x[[.colDataXAxisColData]]))
    )
})

#' @export
setMethod(".allowableXAxisChoices", "ColumnDataPlot", function(x, se) {
    .getCachedCommonInfo(se, "ColumnDotPlot")$valid.colData.names
})

#' @export
setMethod(".allowableYAxisChoices", "ColumnDataPlot", function(x, se) {
    .getCachedCommonInfo(se, "ColumnDotPlot")$valid.colData.names
})

#' @export
#' @importFrom shiny updateSelectInput
#' @importFrom methods callNextMethod
setMethod(".createObservers", "ColumnDataPlot", function(x, se, input, session, pObjects, rObjects) {
    callNextMethod()

    plot_name <- .getEncodedName(x)

    .createProtectedParameterObservers(plot_name,
        fields=c(.colDataYAxis, .colDataXAxis, .colDataXAxisColData),
        input=input, pObjects=pObjects, rObjects=rObjects)
})

#' @export
setMethod(".fullName", "ColumnDataPlot", function(x) "Column data plot")

#' @export
setMethod(".panelColor", "ColumnDataPlot", function(x) "#DB0230")

#' @export
setMethod(".generateDotPlotData", "ColumnDataPlot", function(x, envir) {
    data_cmds <- list()

    y_lab <- x[[.colDataYAxis]]
    # NOTE: deparse() automatically adds quotes, AND protects against existing quotes/escapes.
    data_cmds[["y"]] <- sprintf(
        "plot.data <- data.frame(Y=colData(se)[, %s], row.names=colnames(se));",
        deparse(y_lab)
    )

    # Prepare X-axis data.
    if (x[[.colDataXAxis]] == .colDataXAxisNothingTitle) {
        x_lab <- ''
        data_cmds[["x"]] <- "plot.data$X <- factor(character(ncol(se)))"
    } else {
        x_lab <- x[[.colDataXAxisColData]]
        data_cmds[["x"]] <- sprintf(
            "plot.data$X <- colData(se)[, %s];",
            deparse(x_lab)
        )
    }

    x_title <- ifelse(x_lab == '', x_lab, sprintf("vs %s", x_lab))
    plot_title <- sprintf("%s %s", y_lab, x_title)

    data_cmds <- unlist(data_cmds)
    .textEval(data_cmds, envir)

    list(commands=data_cmds, labels=list(title=plot_title, X=x_lab, Y=y_lab))
})
