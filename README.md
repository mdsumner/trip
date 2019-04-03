
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](http://badges.herokuapp.com/travis/Trackage/trip?branch=master&env=BUILD_NAME=trusty_release&label=linux)](https://travis-ci.org/Trackage/trip)
[![OSX Build
Status](http://badges.herokuapp.com/travis/Trackage/trip?branch=master&env=BUILD_NAME=osx_release&label=osx)](https://travis-ci.org/Trackage/trip)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/mdsumner/trip?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/trip)[![Coverage\_Status](https://img.shields.io/codecov/c/github/Trackage/trip/master.svg)](https://codecov.io/github/Trackage/trip?branch=master)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/trip)](https://cran.r-project.org/package=trip)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/trip)](https://cran.r-project.org/package=trip)

# Tools for animal track data

The trip package provides functions for accessing and manipulating
spatial data for animal tracking. Filter for speed and create time spent
plots from animal track data.

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

# Development

Currently working on tidying up old daggy ends, see [next release
milestones](https://github.com/Trackage/trip/milestone/2).

Particulary, I want it to be very easy to create trip objects from other
forms, either by reading known formats (Argos), coercion from other
packages (sp, sf, adehabitatLT, move, etc.), or from raw data with a
dplyr/gg aesthetic e.g. this kind of construct from a data frame:

``` r
## NOTE: this is pseudocode, neither works yet
d %>% arrange(id, time) %>% group_by(id) %>%  select(x, y, time, everything()) %>% trip(crs = "+proj=longlat")

## OR this for the same outcome
trip(d, x, y, time, id, crs = "+proj=longlat")
```

We could assume longlat is input if it has sane ranges, much like raster
does.

There is some ongoing integration with the `sf` package, mostly to
provide outputs in its formats.

We can already convert to POINT:

``` r
library(trip)
#> Loading required package: sp
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

Trip itself would be better implemented on top of the ideas in [the
silicate package](https://github.com/hypertidy/silicate/), rather than
the twilight zone between MULTIPOINTs and LINESTRINGs as it is now.

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
