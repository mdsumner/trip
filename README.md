
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](http://badges.herokuapp.com/travis/Trackage/trip?branch=master&env=BUILD_NAME=trusty_release&label=linux)](https://travis-ci.org/Trackage/trip)
[![OSX Build
Status](http://badges.herokuapp.com/travis/Trackage/trip?branch=master&env=BUILD_NAME=osx_release&label=osx)](https://travis-ci.org/Trackage/trip)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/Trackage/trip?branch=master&svg=true)](https://ci.appveyor.com/project/Trackage/trip)[![Coverage\_Status](https://img.shields.io/codecov/c/github/Trackage/trip/master.svg)](https://codecov.io/github/Trackage/trip?branch=master)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/trip)](https://cran.r-project.org/package=trip)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/trip)](https://cran.r-project.org/package=trip)

# Tools for animal track data

The trip package provides facilities to access and manipulate
spatial-temporal data organized for tracking movements. Data with
locations, date-times, and grouping IDs for trips are formally declared
using the `trip()` function and enables easy calculation of step
distance and angle and grouped summaries of trip duration and length.

Conversion from and to many disparate formats is a key focus, and data
may be treated as points-in-time or as line segments with a start/end
time property. There are functions for simple speed-distance-angle
filtering determining time-spent in area and creating line or point
plots with standard R spatial tools and graphics.

## Reading data

Track data may be read from various Argos formats with `readArgos()` or
`readDiag()`, from generic data frame or spatial- data frames, and many
types of objects from other tracking packages are supported.

## Converting data

Trip objects can be imported directly from types defined in packages
`adehabitatLT`, `amt`, `eyetrackeRdata`, `mousetrap`, `sf`, and `sp`.
When these formats do not have time or trip-grouping values they may be
declared by name. A generic data frame may be converted to trip by
organizing the x, y, time, ID columns in order, or by a combination of
row grouping with x, y, time columns. All other data are retained in the
obvious way.

Trip objects can be used to create other data types defined by
`adehabitatLT`, `amt`, `sf`, `sp`, `spatstat`, and this is possible for
conversion to point types or line types. For example, `as(trip,
"SpatialLinesDataFrame")` creates a single multi-line for each trip,
with start and end time properties. The `explode(trip)` function breaks
a trip into individual line segments for every pair of coordinates, and
`as(trip, "SpatialPointsDataFrame")` will create a standard sp points
data frame. There are similar facilities for `sf` types, and for the
`spatstat` types point pattern `as.ppp(trip)` or line segments
`as.psp(trip)`.

## Validating data

The `trip()` function performs a significant series of data validation,
to ensure that basic sense prevails. The function will always proceed to
give a valid trip object, and simply warn about which problems had to be
overcome. These validation checks can be used to discover what is wrong
with a particular set of data, and in time we hope this to become much
more powerful and transparent.

## Transforming and merging data

Trip objects can be reproject directly with the `spTransform` function
in the usual way, and functions that are coordinate system aware such as
`raster::extract` will automatically reproject the coordinates behind
the scenes. We are developing more sophisticated [point-in-time data
extraction](https://github.com/AustralianAntarcticDivision/raadtools)
routines and [auto-reprojecting map
plotting](https://github.com/AustralianAntarcticDivision/SOmap)
functions in related projects.

## Simple data filtering and time-spent gridding

Decades of fancy modern statistical techniques have obscured many simple
data summary methods from days of yore. Trip retains some of these
long-forgottent techniques and allows direct aceess to the
`speedfilter()`, `sdafilter()` and `rasterize()` functions for
straightforward data filtering on maximum speed, minimum angle/distance,
and time-spent-in-area gridding.

There is a `homedist()` function to calculate the maximum distance from
each trip’s starting point, and various old-schooly functions. Some of
these will be improved and better exposed in time.

Let us know what you think via
[Issues](https://github.com/Trackage/trip/issues).

## Installing

The package is easily installed from CRAN in R.

``` r
install.packages("trip")
```

## Install dev version

To install the development package from Github:

``` r
remotes::install_github("Trackage/trip")
```

# Current concerns

Currently working on tidying up old daggy ends, see [next release
milestones](https://github.com/Trackage/trip/milestone/2).

I want it to be very easy to create trip objects from other forms,
either by reading known formats (Argos), coercion from other packages
(sp, sf, adehabitatLT, move, etc.), or from raw data with a dplyr/gg
aesthetic e.g. this kind of construct from a data
frame:

``` r
d <- read.csv(system.file("extdata/MI_albatross_sub10.csv", package = "trip"), stringsAsFactors = FALSE)
d$gmt <- as.POSIXct(d$gmt, tz = "UTC")
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(trip)
tr <- d %>% arrange(tag_ID, gmt) %>% group_by(tag_ID) %>%  select(lon, lat, gmt, everything()) %>% trip()
#> Warning in assume_if_longlat(out): input looks like longitude/latitude
#> data, assuming +proj=longlat +datum=WGS84

## OR this for the same outcome
tr <- trip(dplyr::select(d, lon, lat, gmt, tag_ID, everything()))
#> Warning in assume_if_longlat(out): input looks like longitude/latitude
#> data, assuming +proj=longlat +datum=WGS84
```

Longitude latitude is assumed if the values have sane ranges.

There is some ongoing integration with the `sf` package, mostly to
provide outputs in its formats.

We can nominate the date-time and trip ID column of an sf POINT data
frame.

``` r
trip(sf, c("time", "id"))
```

It’s unclear what do do with MULTIPOINT, unless `XYZ[,3]` is the times
and `$time` is the *offset*? Or we just assume constant time interval
from the `time`. But otherwise, MULTIPOINT or LINESTRING is a kind of
neat grouping.

We can already convert to POINT:

``` r
library(trip)
sf::st_as_sf(walrus818)
#> Simple feature collection with 10558 features and 4 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -117277 ymin: -412557 xmax: 307789 ymax: 84896
#> epsg (SRID):    NA
#> proj4string:    +proj=aeqd +lat_0=70 +lon_0=-170 +x_0=0 +y_0=0 +ellps=WGS84 +units=m +no_defs
#> First 10 features:
#>    Deployment              DataDT Wet Forage             geometry
#> 1         353 2009-09-15 04:00:00   1      0 POINT (281017 22532)
#> 2         353 2009-09-15 05:00:00   0      0 POINT (281399 22392)
#> 3         353 2009-09-15 06:00:00   0      0 POINT (281209 22218)
#> 4         353 2009-09-15 07:00:00   0      0 POINT (281376 22175)
#> 5         353 2009-09-15 08:00:00   0      0 POINT (281543 22132)
#> 6         353 2009-09-15 09:00:00   0      0 POINT (281710 22089)
#> 7         353 2009-09-15 10:00:00   0      0 POINT (281877 22046)
#> 8         353 2009-09-15 11:00:00   0      0 POINT (282044 22003)
#> 9         353 2009-09-15 12:00:00   0      0 POINT (282211 21961)
#> 10        353 2009-09-15 13:00:00   0      0 POINT (282378 21918)
```

or atomic LINESTRING with time on the MEASURE:

``` r
as(walrus818, "sf")
#> Simple feature collection with 14 features and 4 fields
#> geometry type:  LINESTRING
#> dimension:      XYM
#> bbox:           : -117277 : -412557 : 307789 : 84896
#> epsg (SRID):    NA
#> proj4string:    +proj=aeqd +ellps=WGS84 +lon_0=-170 +lat_0=70
#> First 10 features:
#>     tripID           tripStart             tripEnd tripDur
#> 353    353 2009-09-15 04:00:00 2009-09-30 19:00:00 1350000
#> 354    354 2009-09-16 04:00:00 2009-10-20 00:00:00 2923200
#> 355    355 2009-09-16 04:00:00 2009-11-04 19:00:00 4287600
#> 356    356 2009-09-16 23:00:00 2009-11-21 21:00:00 5695200
#> 357    357 2009-09-16 23:00:00 2009-11-09 22:00:00 4662000
#> 358    358 2009-09-16 23:00:00 2009-10-18 19:00:00 2750400
#> 359    359 2009-09-16 23:00:00 2009-10-30 19:00:00 3787200
#> 361    361 2009-09-17 01:00:00 2009-11-06 04:00:00 4330800
#> 362    362 2009-09-17 01:00:00 2009-10-03 17:00:00 1440000
#> 366    366 2009-09-19 15:00:00 2009-10-12 20:00:00 2005200
#>                           geometry
#> 353 LINESTRING M (281017 22532 ...
#> 354 LINESTRING M (267900 -9078 ...
#> 355 LINESTRING M (267657 -9668 ...
#> 356 LINESTRING M (268080 -9030 ...
#> 357 LINESTRING M (263622 -8147 ...
#> 358 LINESTRING M (267884 -9155 ...
#> 359 LINESTRING M (268330 -8509 ...
#> 361 LINESTRING M (305229 55449 ...
#> 362 LINESTRING M (305740 56129 ...
#> 366 LINESTRING M (208779 -53699...
```

But, trip itself would be better implemented on top of the ideas in [the
silicate package](https://github.com/hypertidy/silicate/), rather than
the twilight zone between MULTIPOINTs and LINESTRINGs as it is now.

# Development

  - **partly done** trip should work with sf or sp, there’s really no
    need to distinguish these
  - ability to treat all line segments as continuous, as `cut.trip` can
    for rasterizing, possibly needs a second-level ID grouping
  - separate out reading functionality to
    [rgos](https://github.com/mdsumner/rgos)
  - separate out algorithm functions into a generic package that other
    tracking packages could use (distance, speed, angle filtering,
    rasterizing, time spent, interpolation etc.)

Let me know what you think via
[Issues](https://github.com/Trackage/trip/issues).

## TODO

  - **Probability image**. The SGAT (and tripEstimation) packages have
    functions for dealing with spatial track summaries that are atomized
    to the level of each time step. There are methods for combining
    summaries from multiple tracks and for casting arbitrary durations
    (by sum) to standard image structures. This would be a good feature
    to replace the existing tripGrid function by storing the individual
    grid summaries for each implicit line segment.

  - **Coercion to/from other classes** See
    [spbabel](https://github.com/mdsumner/spbabel).

  - **Validation** Must include a detailed report object of where the
    problems are, and how to filter/fix/flush them.

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
