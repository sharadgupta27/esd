\name{track}
\alias{Cylcone tracking algorithm}
\alias{track.default}
\alias{track.events}
\alias{Track}
\alias{Trackstats}
\title{3-step cyclone tracking algorithm.}
\description{
Applies a tracking algorithm to a set of cyclones (\code{\link{CCI}}).

The algorithm connects events in three subsequent time steps, chosing
the path that minimizes the total displacement as well as the change in
angle and displacement between them. The relative weight of these criteria
can be adjusted. The analysis can be applied to 'events' objects.

Note: The algorithm has been developed for tracking midlatitude cyclones
in the northern hemisphere and may not work as well for other
regions or 'events' of different types, e.g., anti-cyclones. 
}
\usage{
track(X,x0=NULL,it=NULL,is=NULL,dmax=1E6,
      f.d=0.5, f.da=0.3, f.dd=0.2,
      nmax=124,nmin=5,dmin=1E5,plot=FALSE,progress=TRUE,verbose=FALSE)
track.events(X,...) 

}
\arguments{
    \item{X}{An 'events' object containing temporal and spatial information about a set of cyclones or anticyclones.}
    \item{x0}{A tracked 'events' object from previous time steps, used as a starting point for the tracking 
              of X so that trajectories can continue from x0 to X.}
     \item{it}{A list providing time index, e.g. month.}
    \item{is}{A list providing space index, lon and/or lat.}
    \item{dmax}{Maximum displacement of events between two time steps. Unit: m.}
    \item{f.d}{Relative weight of the total displacement criterion in finding the most probable trajectories.}
    \item{f.dd}{Relative weight of the change in displacement as a criterion in finding the most probable trajectories.}
    \item{f.da}{Relative weight of the change in direction (angle) as a criterion in finding the most probable trajectories.}
    \item{nmax}{Maximum total lifetime of a trajectory. Unit: number of time steps.}
    \item{nmin}{Minimum total lifetime of a trajectory. Unit: number of time steps.}
    \item{dmin}{Minimum total length of a trajectory. Unit: m.}
    \item{plot}{TRUE: Show plots of trajectories for selected time steps.}
    \item{progress}{TRUE: Show progress bar.}
    \item{verbose}{TRUE: Print out diagnosics.}  
 }
\value{An 'events' object containing the original information as well as 
  the trajectory number ('trajectory') of each event and statistical properties 
  of the trajectories ('trackcount' - number of events in path;
  'tracklen' - distance between start and end point of path').}
\seealso{CCI,as.trajectory}
\author{K. Parding}
\examples{
# Load sample data to use for example
# ERA5 6-hourly SLP data from the North Atlantic region, 2016-09-15 to 2016-10-15
data(slp.ERA5)

## Cyclone identification
Cstorms <- CCI(slp.ERA5, m=20, label='ERA5', pmax=1000, verbose=TRUE, plot=TRUE)

## Cyclone tracking
Ctracks <- track(Cstorms, plot=TRUE, verbose=TRUE)

## Map with points and lines showing the cyclone centers and trajectories
map(Ctracks, type=c("trajectory","points"), col="blue")
## Map with only the trajectory and start and end points
map(Ctracks, type=c("trajectory","start","end"), col="red")
## Map showing the cyclone depth (slp) as a color scale (rd = red scale)
map(Ctracks, param="pcent", type=c('trajectory','start'), 
    colbar=list(pal="rd", rev=TRUE, breaks=seq(980,1010,5)), alpha=0.9)

## Select only the long lasting trajectories...
Ct <- subset(Ctracks, ic=list(param='trackcount', pmin=12) )
map(Ct)
## ...or only the long distance ones...
Ct <- subset(Ctracks, ic=list(param='tracklength', pmin=3000) )
map(Ct)
## ...or only the deep cyclones
Ct <- subset(Ctracks, ic=list(param='pcent', pmax=980) )
map(Ct)

## Map of cyclone trajectories with the slp field in background
cb <- list(pal="budrd",breaks=seq(990,1040,5))
map(Ctracks, slp.ERA5, it=as.POSIXct("2016-09-30 19:00"), colbar=cb, verbose=TRUE)

## Transform the cyclones into a 'trajectory' object which takes up less space
Ctraj <- as.trajectory(Ctracks)
map(Ctraj)
print(object.size(Ctracks), units="auto")
print(object.size(Ctraj), units="auto")
}
\keyword{track}
