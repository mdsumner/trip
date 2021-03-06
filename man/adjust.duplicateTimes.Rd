% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trip.R
\name{adjust.duplicateTimes}
\alias{adjust.duplicateTimes}
\title{Adjust duplicate DateTime values}
\usage{
adjust.duplicateTimes(time, id)
}
\arguments{
\item{time}{vector of DateTime values}

\item{id}{vector of ID values, matching DateTimes that are assumed sorted
within ID}
}
\value{
The adjusted DateTime vector is returned.
}
\description{
Duplicated DateTime values within ID are adjusted forward (recursively) by
one second until no duplicates are present. This is considered reasonable
way of avoiding the nonsensical problem of duplicate times.
}
\details{
This function is used to remove duplicate time records in animal track data,
rather than removing the record completely.
}
\section{Warning}{


I have no idea what goes on at CLS when they output data that are either not
ordered by time or have duplicates. If this problem exists in your data it's
probably worth finding out why.
}

\examples{


## DateTimes with a duplicate within ID
tms <- Sys.time() + c(1:6, 6, 7:10) *10
id <- rep("a", length(tms))
range(diff(tms))

## duplicate record is now moved one second forward
tms.adj <- adjust.duplicateTimes(tms, id)
range(diff(tms.adj))


}
\seealso{
\code{\link{readArgos}}
}
