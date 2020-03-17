#' Function: Compute drought characteristics
#'
#' @param X       A vector of time series data
#' @param start   Start of time series 
#' @param end     End of time series
#' @param theta   Threshold of a drought event
#'
#' @return
#' @export
#' 
#' @references Van Loon, A. F. (2015). "Hydrological drought explained." Wiley Interdisciplinary Reviews: Water 2(4): 359-392.
#'
#' @examples
#' 
drought <- function(X, start, end, theta){
  #X <- data.SPI.obs[,Grids[1]]; start=c(1951,1);end=c(1970,12); theta=-1

  data = window(X, start=start, end = end)
  dates = as.Date(as.yearmon(time(data)))
  if(length(theta)==1) theta = rep(theta,length(data))
    
  dur = array() #duration
  def = array() #deficit volume, one measure of severity
  sev = array() #severity
  st  = array() #start of the event
  end = array() #end of the event
  p = 0         #number of events
  
  sel = which(data < theta)
  int = data - theta            #intensity: lowest SPI value of the drought event
  last = -999

  for(i in sel){
    if((i-1) != last){ #if still the same drought event
      p = p + 1
      st[p] = as.character(dates[i])
      dur[p] = 0
      def[p] = 0
      sev[p] = 0
      end[p] = 0
    }
    last = i
    dur[p] = dur[p] + 1
    def[p] = def[p] + data[i] - theta[i]  #severity by the accumulated value of the event
    sev[p] = min(int[i],sev[p])           #severity by the min value of the event
    end[p] = as.character(dates[i])
  }
  
  # if(sum(def==0)){ #sel = which(data<=theta) 
      # ind=which(def==0)
      # st=st[-ind];end=end[-ind];dur=dur[-ind];def=def[-ind];sev=sev[-ind]
  # }
  
  #return(as.data.frame(cbind(st, end, dur, signif(-def, digits=4), signif(-sev, digits=4))))
  return(list(start=st, end=end, 
              dur=dur, 
              def=signif(-def, digits=4), 
              sev=signif(-sev, digits=4)))
    
}