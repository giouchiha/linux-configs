#!/bin/sh
#
# shalla_update.sh, v 0.3.1 20080403
# done by kapivie at sil.at under FreeBSD
# without any warranty
# updated by Len Tucker to create and use diff
# files to reduce load and increase speed.
# Added Checks for required elements
# Added output info for status of script
#--------------------------------------------------
# little script (for crond)
# to fetch and modify new list from shalla.de
#--------------------------------------------------
#
# *check* paths and squidGuard-owner on your system
# try i.e. "which squid" to find out the path for squid
# try "ps aux | grep squid" to find out the owner for squidGuard
#     *needs wget*
#

squidGuardpath="/usr/bin/squidGuard"
squidpath="/usr/sbin/squid"
httpget="/usr/bin/wget"
tarpath="/bin/tar"
chownpath="/bin/chown"
wgetlogdir="/var/log"

dbhome="/var/lib/squidguard/db"     # like in squidGuard.conf
squidGuardowner="proxy:proxy"

##########################################

workdir="/tmp"
shallalist="http://www.shallalist.de/Downloads/shallalist.tar.gz"

# Check for required components
if [ ! -f $squidGuardpath ]
 then echo "Could not locate squidGuard."
      exit 1
fi

if [ ! -f $squidpath ]
 then echo "Could not locate squid."
      exit 1
fi

if [ ! -f $httpget ]
 then echo "Could not locate wget. wget is required to download shallalist.tar.gz."
      exit 1
fi

if [ ! -f $tarpath ]
 then echo "Could not locate tar."
      exit 1
fi

if [ ! -f $chownpath ]
 then echo "Could not locate chown."
      exit 1
fi

if [ ! -d  $dbhome ]
 then echo "Could not locate squid db directory."
      exit 1
fi

if [ ! -d $wgetlogdir ]
 then echo "Could not locate wget log directory."
      exit 1
fi

# download actual shalla's blacklist
# thanks for the " || exit 1 " hint to Rich Wales
# (-b run in background does not work correctly) -o log to $wgetlog

echo "Retrieving shallalist.tar.gz"

$httpget $shallalist -a $wgetlogdir/shalla-wget.log -O $workdir/shallalist.tar.gz || { echo "Unable to download shallalist.tar.gz." && exit 1 ; }                                                                                                                               

echo "Unzippping shallalist.tar.gz"

$tarpath xzf $workdir/shallalist.tar.gz -C $workdir || { echo "Unable to extract $workdir/shallalist.tar.gz." && exit 1 ; }

# Create diff files for all categories
# There has to be a better way, some type of foreach loop

echo "Creating diff files."

if [ -f $workdir/BL/adv/domains ] && [ -f $dbhome/BL/adv/domains ]
  then                                                            
    diff -ur $workdir/BL/adv/domains $dbhome/BL/adv/domains > $dbhome/BL/adv/domains.diff
fi                                                                                       

if [ -f $workdir/BL/adv/urls ] && [ -f $dbhome/BL/adv/urls ]
  then                                                      
    diff -ur $workdir/BL/adv/urls $dbhome/BL/adv/urls > $dbhome/BL/adv/urls.diff
fi                                                                              

if [ -f $workdir/BL/aggressive/domains ] && [ -f $dbhome/BL/aggressive/domains ]
  then                                                                          
    diff -ur $workdir/BL/aggressive/domains $dbhome/BL/aggressive/domains > $dbhome/BL/aggressive/domains.diff
fi                                                                                                            

if [ -f $workdir/BL/aggressive/urls ] && [ -f $dbhome/BL/aggressive/urls ]
  then                                                                    
    diff -ur $workdir/BL/aggressive/urls $dbhome/BL/aggressive/urls > $dbhome/BL/aggressive/urls.diff
fi                                                                                                   

if [ -f $workdir/BL/automobile/cars/domains ] && [ -f $dbhome/BL/automobile/cars/domains ]
  then                                                                                    
    diff -ur $workdir/BL/automobile/cars/domains $dbhome/BL/automobile/cars/domains > $dbhome/BL/automobile/cars/domains.diff
fi                                                                                                                           

if [ -f $workdir/BL/automobile/cars/urls ] && [ -f $dbhome/BL/automobile/cars/urls ]
  then                                                                              
    diff -ur $workdir/BL/automobile/cars/urls $dbhome/BL/automobile/cars/urls > $dbhome/BL/automobile/cars/urls.diff
fi                                                                                                                  

if [ -f $workdir/BL/automobile/bikes/domains ] && [ -f $dbhome/BL/automobile/bikes/domains ]
  then                                                                                      
    diff -ur $workdir/BL/automobile/bikes/domains $dbhome/BL/automobile/bikes/domains > $dbhome/BL/automobile/bikes/domains.diff
fi                                                                                                                              

if [ -f $workdir/BL/automobile/bikes/urls ] && [ -f $dbhome/BL/automobile/bikes/urls ]
  then                                                                                
    diff -ur $workdir/BL/automobile/bikes/urls $dbhome/BL/automobile/bikes/urls > $dbhome/BL/automobile/bikes/urls.diff
fi                                                                                                                     

if [ -f $workdir/BL/automobile/boats/domains ] && [ -f $dbhome/BL/automobile/boats/domains ]
  then                                                                                      
    diff -ur $workdir/BL/automobile/boats/domains $dbhome/BL/automobile/boats/domains > $dbhome/BL/automobile/boats/domains.diff
fi                                                                                                                              

if [ -f $workdir/BL/automobile/boats/urls ] && [ -f $dbhome/BL/automobile/boats/urls ]
  then                                                                                
    diff -ur $workdir/BL/automobile/boats/urls $dbhome/BL/automobile/boats/urls > $dbhome/BL/automobile/boats/urls.diff
fi                                                                                                                     

if [ -f $workdir/BL/automobile/planes/domains ] && [ -f $dbhome/BL/automobile/planes/domains ]
  then                                                                                        
    diff -ur $workdir/BL/automobile/planes/domains $dbhome/BL/automobile/planes/domains > $dbhome/BL/automobile/planes/domains.diff
fi                                                                                                                                 

if [ -f $workdir/BL/automobile/planes/urls ] && [ -f $dbhome/BL/automobile/planes/urls ]
  then                                                                                  
    diff -ur $workdir/BL/automobile/planes/urls $dbhome/BL/automobile/planes/urls > $dbhome/BL/automobile/planes/urls.diff
fi                                                                                                                        

if [ -f $workdir/BL/chat/domains ] && [ -f $dbhome/BL/chat/domains ]
  then                                                              
    diff -ur $workdir/BL/chat/domains $dbhome/BL/chat/domains > $dbhome/BL/chat/domains.diff
fi                                                                                          

if [ -f $workdir/BL/chat/urls ] && [ -f $dbhome/BL/chat/urls ]
  then                                                        
    diff -ur $workdir/BL/chat/urls $dbhome/BL/chat/urls > $dbhome/BL/chat/urls.diff
fi                                                                                 

if [ -f $workdir/BL/dating/domains ] && [ -f $dbhome/BL/dating/domains ]
  then                                                                  
    diff -ur $workdir/BL/dating/domains $dbhome/BL/dating/domains > $dbhome/BL/dating/domains.diff
fi                                                                                                

if [ -f $workdir/BL/dating/urls ] && [ -f $dbhome/BL/dating/urls ]
  then                                                            
    diff -ur $workdir/BL/dating/urls $dbhome/BL/dating/urls > $dbhome/BL/dating/urls.diff
fi                                                                                       

if [ -f $workdir/BL/downloads/domains ] && [ -f $dbhome/BL/downloads/domains ]
  then                                                                        
    diff -ur $workdir/BL/downloads/domains $dbhome/BL/downloads/domains > $dbhome/BL/downloads/domains.diff
fi                                                                                                         

if [ -f $workdir/BL/downloads/urls ] && [ -f $dbhome/BL/downloads/urls ]
  then                                                                  
    diff -ur $workdir/BL/downloads/urls $dbhome/BL/downloads/urls > $dbhome/BL/downloads/urls.diff
fi                                                                                                

if [ -f $workdir/BL/drugs/domains ] && [ -f $dbhome/BL/drugs/domains ]
  then                                                                
    diff -ur $workdir/BL/drugs/domains $dbhome/BL/drugs/domains > $dbhome/BL/drugs/domains.diff
fi                                                                                             

if [ -f $workdir/BL/drugs/urls ] && [ -f $dbhome/BL/drugs/urls ]
  then                                                          
    diff -ur $workdir/BL/drugs/urls $dbhome/BL/drugs/urls > $dbhome/BL/drugs/urls.diff
fi                                                                                    

if [ -f $workdir/BL/dynamic/domains ] && [ -f $dbhome/BL/dynamic/domains ]
  then                                                                    
    diff -ur $workdir/BL/dynamic/domains $dbhome/BL/dynamic/domains > $dbhome/BL/dynamic/domains.diff
fi                                                                                                   

if [ -f $workdir/BL/dynamic/urls ] && [ -f $dbhome/BL/dynamic/urls ]
  then                                                              
    diff -ur $workdir/BL/dynamic/urls $dbhome/BL/dynamic/urls > $dbhome/BL/dynamic/urls.diff
fi                                                                                          

if [ -f $workdir/BL/finance/banking/domains ] && [ -f $dbhome/BL/finance/banking/domains ]
  then                                                                                    
    diff -ur $workdir/BL/finance/banking/domains $dbhome/BL/finance/banking/domains > $dbhome/BL/finance/banking/domains.diff
fi                                                                                                                           

if [ -f $workdir/BL/finance/banking/urls ] && [ -f $dbhome/BL/finance/banking/urls ]
  then                                                                              
    diff -ur $workdir/BL/finance/banking/urls $dbhome/BL/finance/banking/urls > $dbhome/BL/finance/banking/urls.diff
fi                                                                                                                  

if [ -f $workdir/BL/finance/insurance/domains ] && [ -f $dbhome/BL/finance/insurance/domains ]
  then                                                                                        
    diff -ur $workdir/BL/finance/insurance/domains $dbhome/BL/finance/insurance/domains > $dbhome/BL/finance/insurance/domains.diff
fi                                                                                                                                 

if [ -f $workdir/BL/finance/insurance/urls ] && [ -f $dbhome/BL/finance/insurance/urls ]
  then                                                                                  
    diff -ur $workdir/BL/finance/insurance/urls $dbhome/BL/finance/insurance/urls > $dbhome/BL/finance/insurance/urls.diff
fi                                                                                                                        

if [ -f $workdir/BL/finance/moneylending/domains ] && [ -f $dbhome/BL/finance/moneylending/domains ]
  then                                                                                              
    diff -ur $workdir/BL/finance/moneylending/domains $dbhome/BL/finance/moneylending/domains > $dbhome/BL/finance/moneylending/domains.diff                                                                                                                                    
fi                                                                                                                                      

if [ -f $workdir/BL/finance/moneylending/urls ] && [ -f $dbhome/BL/finance/moneylending/urls ]
  then                                                                                        
    diff -ur $workdir/BL/finance/moneylending/urls $dbhome/BL/finance/moneylending/urls > $dbhome/BL/finance/moneylending/urls.diff
fi                                                                                                                                 

if [ -f $workdir/BL/finance/other/domains ] && [ -f $dbhome/BL/finance/other/domains ]
  then                                                                                
    diff -ur $workdir/BL/finance/other/domains $dbhome/BL/finance/other/domains > $dbhome/BL/finance/other/domains.diff
fi                                                                                                                     

if [ -f $workdir/BL/finance/other/urls ] && [ -f $dbhome/BL/finance/other/urls ]
  then                                                                          
    diff -ur $workdir/BL/finance/other/urls $dbhome/BL/finance/other/urls > $dbhome/BL/finance/other/urls.diff
fi                                                                                                            

if [ -f $workdir/BL/finance/realestate/domains ] && [ -f $dbhome/BL/finance/realestate/domains ]
  then                                                                                          
    diff -ur $workdir/BL/finance/realestate/domains $dbhome/BL/finance/realestate/domains > $dbhome/BL/finance/realestate/domains.diff
fi                                                                                                                                    

if [ -f $workdir/BL/finance/realestate/urls ] && [ -f $dbhome/BL/finance/realestate/urls ]
  then                                                                                    
    diff -ur $workdir/BL/finance/realestate/urls $dbhome/BL/finance/realestate/urls > $dbhome/BL/finance/realestate/urls.diff
fi                                                                                                                           

if [ -f $workdir/BL/forum/domains ] && [ -f $dbhome/BL/forum/domains ]
  then                                                                
    diff -ur $workdir/BL/forum/domains $dbhome/BL/forum/domains > $dbhome/BL/forum/domains.diff
fi                                                                                             

if [ -f $workdir/BL/forum/urls ] && [ -f $dbhome/BL/forum/urls ]
  then                                                          
    diff -ur $workdir/BL/forum/urls $dbhome/BL/forum/urls > $dbhome/BL/forum/urls.diff
fi                                                                                    

if [ -f $workdir/BL/gamble/domains ] && [ -f $dbhome/BL/gamble/domains ]
  then                                                                  
    diff -ur $workdir/BL/gamble/domains $dbhome/BL/gamble/domains > $dbhome/BL/gamble/domains.diff
fi                                                                                                

if [ -f $workdir/BL/gamble/urls ] && [ -f $dbhome/BL/gamble/urls ]
  then                                                            
    diff -ur $workdir/BL/gamble/urls $dbhome/BL/gamble/urls > $dbhome/BL/gamble/urls.diff
fi                                                                                       

if [ -f $workdir/BL/hacking/domains ] && [ -f $dbhome/BL/hacking/domains ]
  then                                                                    
    diff -ur $workdir/BL/hacking/domains $dbhome/BL/hacking/domains > $dbhome/BL/hacking/domains.diff
fi                                                                                                   

if [ -f $workdir/BL/hacking/urls ] && [ -f $dbhome/BL/hacking/urls ]
  then                                                              
    diff -ur $workdir/BL/hacking/urls $dbhome/BL/hacking/urls > $dbhome/BL/hacking/urls.diff
fi                                                                                          

if [ -f $workdir/BL/hobby/cooking/domains ] && [ -f $dbhome/BL/hobby/cooking/domains ]
  then                                                                                
    diff -ur $workdir/BL/hobby/cooking/domains $dbhome/BL/hobby/cooking/domains > $dbhome/BL/hobby/cooking/domains.diff
fi                                                                                                                     

if [ -f $workdir/BL/hobby/cooking/urls ] && [ -f $dbhome/BL/hobby/cooking/urls ]
  then                                                                          
    diff -ur $workdir/BL/hobby/cooking/urls $dbhome/BL/hobby/cooking/urls > $dbhome/BL/hobby/cooking/urls.diff
fi                                                                                                            

if [ -f $workdir/BL/hobby/games/domains ] && [ -f $dbhome/BL/hobby/games/domains ]
  then                                                                            
    diff -ur $workdir/BL/hobby/games/domains $dbhome/BL/hobby/games/domains > $dbhome/BL/hobby/games/domains.diff
fi                                                                                                               

if [ -f $workdir/BL/hobby/games/urls ] && [ -f $dbhome/BL/hobby/games/urls ]
  then                                                                      
    diff -ur $workdir/BL/hobby/games/urls $dbhome/BL/hobby/games/urls > $dbhome/BL/hobby/games/urls.diff
fi                                                                                                      

if [ -f $workdir/BL/hobby/pets/domains ] && [ -f $dbhome/BL/hobby/pets/domains ]
  then                                                                          
    diff -ur $workdir/BL/hobby/pets/domains $dbhome/BL/hobby/pets/domains > $dbhome/BL/hobby/pets/domains.diff
fi                                                                                                            

if [ -f $workdir/BL/hobby/pets/urls ] && [ -f $dbhome/BL/hobby/pets/urls ]
  then                                                                    
    diff -ur $workdir/BL/hobby/pets/urls $dbhome/BL/hobby/pets/urls > $dbhome/BL/hobby/pets/urls.diff
fi                                                                                                   

if [ -f $workdir/BL/isp/domains ] && [ -f $dbhome/BL/isp/domains ]
  then                                                            
    diff -ur $workdir/BL/isp/domains $dbhome/BL/isp/domains > $dbhome/BL/isp/domains.diff
fi                                                                                       

if [ -f $workdir/BL/isp/urls ] && [ -f $dbhome/BL/isp/urls ]
  then                                                      
    diff -ur $workdir/BL/isp/urls $dbhome/BL/isp/urls > $dbhome/BL/isp/urls.diff
fi                                                                              

if [ -f $workdir/BL/jobsearch/domains ] && [ -f $dbhome/BL/jobsearch/domains ]
  then                                                                        
    diff -ur $workdir/BL/jobsearch/domains $dbhome/BL/jobsearch/domains > $dbhome/BL/jobsearch/domains.diff
fi                                                                                                         

if [ -f $workdir/BL/jobsearch/urls ] && [ -f $dbhome/BL/jobsearch/urls ]
  then                                                                  
    diff -ur $workdir/BL/jobsearch/urls $dbhome/BL/jobsearch/urls > $dbhome/BL/jobsearch/urls.diff
fi                                                                                                

if [ -f $workdir/BL/models/domains ] && [ -f $dbhome/BL/models/domains ]
  then                                                                  
    diff -ur $workdir/BL/models/domains $dbhome/BL/models/domains > $dbhome/BL/models/domains.diff
fi                                                                                                

if [ -f $workdir/BL/models/urls ] && [ -f $dbhome/BL/models/urls ]
  then                                                            
    diff -ur $workdir/BL/models/urls $dbhome/BL/models/urls > $dbhome/BL/models/urls.diff
fi                                                                                       

if [ -f $workdir/BL/movies/domains ] && [ -f $dbhome/BL/movies/domains ]
  then                                                                  
    diff -ur $workdir/BL/movies/domains $dbhome/BL/movies/domains > $dbhome/BL/movies/domains.diff
fi                                                                                                

if [ -f $workdir/BL/movies/urls ] && [ -f $dbhome/BL/movies/urls ]
  then                                                            
    diff -ur $workdir/BL/movies/urls $dbhome/BL/movies/urls > $dbhome/BL/movies/urls.diff
fi                                                                                       

if [ -f $workdir/BL/music/domains ] && [ -f $dbhome/BL/music/domains ]
  then                                                                
    diff -ur $workdir/BL/music/domains $dbhome/BL/music/domains > $dbhome/BL/music/domains.diff
fi                                                                                             

if [ -f $workdir/BL/music/urls ] && [ -f $dbhome/BL/music/urls ]
  then                                                          
    diff -ur $workdir/BL/music/urls $dbhome/BL/music/urls > $dbhome/BL/music/urls.diff
fi                                                                                    

if [ -f $workdir/BL/news/domains ] && [ -f $dbhome/BL/news/domains ]
  then                                                              
    diff -ur $workdir/BL/news/domains $dbhome/BL/news/domains > $dbhome/BL/news/domains.diff
fi                                                                                          

if [ -f $workdir/BL/news/urls ] && [ -f $dbhome/BL/news/urls ]
  then                                                        
    diff -ur $workdir/BL/news/urls $dbhome/BL/news/urls > $dbhome/BL/news/urls.diff
fi                                                                                 

if [ -f $workdir/BL/porn/domains ] && [ -f $dbhome/BL/porn/domains ]
  then                                                              
    diff -ur $workdir/BL/porn/domains $dbhome/BL/porn/domains > $dbhome/BL/porn/domains.diff
fi                                                                                          

if [ -f $workdir/BL/porn/urls ] && [ -f $dbhome/BL/porn/urls ]
  then                                                        
    diff -ur $workdir/BL/porn/urls $dbhome/BL/porn/urls > $dbhome/BL/porn/urls.diff
fi                                                                                 

if [ -f $workdir/BL/recreation/humor/domains ] && [ -f $dbhome/BL/recreation/humor/domains ]
  then                                                                                      
    diff -ur $workdir/BL/recreation/humor/domains $dbhome/BL/recreation/humor/domains > $dbhome/BL/recreation/humor/domains.diff
fi                                                                                                                              

if [ -f $workdir/BL/recreation/humor/urls ] && [ -f $dbhome/BL/recreation/humor/urls ]
  then                                                                                
    diff -ur $workdir/BL/recreation/humor/urls $dbhome/BL/recreation/humor/urls > $dbhome/BL/recreation/humor/urls.diff
fi                                                                                                                     

if [ -f $workdir/BL/recreation/sports/domains ] && [ -f $dbhome/BL/recreation/sports/domains ]
  then                                                                                        
    diff -ur $workdir/BL/recreation/sports/domains $dbhome/BL/recreation/sports/domains > $dbhome/BL/recreation/sports/domains.diff
fi                                                                                                                                 
                                                                                                                                   
if [ -f $workdir/BL/recreation/sports/urls ] && [ -f $dbhome/BL/recreation/sports/urls ]                                           
  then                                                                                                                             
    diff -ur $workdir/BL/recreation/sports/urls $dbhome/BL/recreation/sports/urls > $dbhome/BL/recreation/sports/urls.diff         
fi                                                                                                                                 

if [ -f $workdir/BL/recreation/travel/domains ] && [ -f $dbhome/BL/recreation/travel/domains ]
  then                                                                                        
    diff -ur $workdir/BL/recreation/travel/domains $dbhome/BL/recreation/travel/domains > $dbhome/BL/recreation/travel/domains.diff
fi                                                                                                                                 

if [ -f $workdir/BL/recreation/travel/urls ] && [ -f $dbhome/BL/recreation/travel/urls ]
  then                                                                                  
    diff -ur $workdir/BL/recreation/travel/urls $dbhome/BL/recreation/travel/urls > $dbhome/BL/recreation/travel/urls.diff
fi                                                                                                                        


if [ -f $workdir/BL/recreation/wellness/domains ] && [ -f $dbhome/BL/recreation/wellness/domains ]
  then                                                                                            
    diff -ur $workdir/BL/recreation/wellness/domains $dbhome/BL/recreation/wellness/domains > $dbhome/BL/recreation/wellness/domains.diff                                                                                                                                       
fi                                                                                                                                      

if [ -f $workdir/BL/recreation/wellness/urls ] && [ -f $dbhome/BL/recreation/wellness/urls ]
  then                                                                                      
    diff -ur $workdir/BL/recreation/wellness/urls $dbhome/BL/recreation/wellness/urls > $dbhome/BL/recreation/wellness/urls.diff
fi                                                                                                                              

if [ -f $workdir/BL/redirector/domains ] && [ -f $dbhome/BL/redirector/domains ]
  then                                                                          
    diff -ur $workdir/BL/redirector/domains $dbhome/BL/redirector/domains > $dbhome/BL/redirector/domains.diff
fi                                                                                                            

if [ -f $workdir/BL/redirector/urls ] && [ -f $dbhome/BL/redirector/urls ]
  then                                                                    
    diff -ur $workdir/BL/redirector/urls $dbhome/BL/redirector/urls > $dbhome/BL/redirector/urls.diff
fi                                                                                                   

if [ -f $workdir/BL/religion/domains ] && [ -f $dbhome/BL/religion/domains ]
  then                                                                      
    diff -ur $workdir/BL/religion/domains $dbhome/BL/religion/domains > $dbhome/BL/religion/domains.diff
fi                                                                                                      

if [ -f $workdir/BL/religion/urls ] && [ -f $dbhome/BL/religion/urls ]
  then                                                                
    diff -ur $workdir/BL/religion/urls $dbhome/BL/religion/urls > $dbhome/BL/religion/urls.diff
fi                                                                                             

if [ -f $workdir/BL/ringtones/domains ] && [ -f $dbhome/BL/ringtones/domains ]
  then                                                                        
    diff -ur $workdir/BL/ringtones/domains $dbhome/BL/ringtones/domains > $dbhome/BL/ringtones/domains.diff
fi                                                                                                         

if [ -f $workdir/BL/ringtones/urls ] && [ -f $dbhome/BL/ringtones/urls ]
  then                                                                  
    diff -ur $workdir/BL/ringtones/urls $dbhome/BL/ringtones/urls > $dbhome/BL/ringtones/urls.diff
fi                                                                                                

if [ -f $workdir/BL/science/astronomy/domains ] && [ -f $dbhome/BL/science/astronomy/domains ]
  then                                                                                        
    diff -ur $workdir/BL/science/astronomy/domains $dbhome/BL/science/astronomy/domains > $dbhome/BL/science/astronomy/domains.diff
fi                                                                                                                                 

if [ -f $workdir/BL/science/astronomy/urls ] && [ -f $dbhome/BL/science/astronomy/urls ]
  then                                                                                  
    diff -ur $workdir/BL/science/astronomy/urls $dbhome/BL/science/astronomy/urls > $dbhome/BL/science/astronomy/urls.diff
fi                                                                                                                        

if [ -f $workdir/BL/science/chemistry/domains ] && [ -f $dbhome/BL/science/chemistry/domains ]
  then                                                                                        
    diff -ur $workdir/BL/science/chemistry/domains $dbhome/BL/science/chemistry/domains > $dbhome/BL/science/chemistry/domains.diff
fi                                                                                                                                 

if [ -f $workdir/BL/science/chemistry/urls ] && [ -f $dbhome/BL/science/chemistry/urls ]
  then                                                                                  
    diff -ur $workdir/BL/science/chemistry/urls $dbhome/BL/science/chemistry/urls > $dbhome/BL/science/chemistry/urls.diff
fi                                                                                                                        

if [ -f $workdir/BL/searchengines/domains ] && [ -f $dbhome/BL/searchengines/domains ]
  then                                                                                
    diff -ur $workdir/BL/searchengines/domains $dbhome/BL/searchengines/domains > $dbhome/BL/searchengines/domains.diff
fi                                                                                                                     

if [ -f $workdir/BL/searchengines/urls ] && [ -f $dbhome/BL/searchengines/urls ]
  then                                                                          
    diff -ur $workdir/BL/searchengines/urls $dbhome/BL/searchengines/urls > $dbhome/BL/searchengines/urls.diff
fi                                                                                                            

if [ -f $workdir/BL/sex/lingerie/domains ] && [ -f $dbhome/BL/sex/lingerie/domains ]
  then                                                                              
    diff -ur $workdir/BL/sex/lingerie/domains $dbhome/BL/sex/lingerie/domains > $dbhome/BL/sex/lingerie/domains.diff
fi                                                                                                                  

if [ -f $workdir/BL/sex/lingerie/urls ] && [ -f $dbhome/BL/sex/lingerie/urls ]
  then                                                                        
    diff -ur $workdir/BL/sex/lingerie/urls $dbhome/BL/sex/lingerie/urls > $dbhome/BL/sex/lingerie/urls.diff
fi                                                                                                         

if [ -f $workdir/BL/shopping/domains ] && [ -f $dbhome/BL/shopping/domains ]
  then                                                                      
    diff -ur $workdir/BL/shopping/domains $dbhome/BL/shopping/domains > $dbhome/BL/shopping/domains.diff
fi                                                                                                      

if [ -f $workdir/BL/shopping/urls ] && [ -f $dbhome/BL/shopping/urls ]
  then                                                                
    diff -ur $workdir/BL/shopping/urls $dbhome/BL/shopping/urls > $dbhome/BL/shopping/urls.diff
fi                                                                                             

if [ -f $workdir/BL/socialnet/domains ] && [ -f $dbhome/BL/socialnet/domains ]
  then                                                                        
    diff -ur $workdir/BL/socialnet/domains $dbhome/BL/socialnet/domains > $dbhome/BL/socialnet/domains.diff
fi                                                                                                         

if [ -f $workdir/BL/socialnet/urls ] && [ -f $dbhome/BL/socialnet/urls ]
  then                                                                  
    diff -ur $workdir/BL/socialnet/urls $dbhome/BL/socialnet/urls > $dbhome/BL/socialnet/urls.diff
fi                                                                                                

if [ -f $workdir/BL/spyware/domains ] && [ -f $dbhome/BL/spyware/domains ]
  then                                                                    
    diff -ur $workdir/BL/spyware/domains $dbhome/BL/spyware/domains > $dbhome/BL/spyware/domains.diff
fi                                                                                                   

if [ -f $workdir/BL/spyware/urls ] && [ -f $dbhome/BL/spyware/urls ]
  then                                                              
    diff -ur $workdir/BL/spyware/urls $dbhome/BL/spyware/urls > $dbhome/BL/spyware/urls.diff
fi                                                                                          

if [ -f $workdir/BL/tracker/domains ] && [ -f $dbhome/BL/tracker/domains ]
  then                                                                    
    diff -ur $workdir/BL/tracker/domains $dbhome/BL/tracker/domains > $dbhome/BL/tracker/domains.diff
fi                                                                                                   

if [ -f $workdir/BL/tracker/urls ] && [ -f $dbhome/BL/tracker/urls ]
  then                                                              
    diff -ur $workdir/BL/tracker/urls $dbhome/BL/tracker/urls > $dbhome/BL/tracker/urls.diff
fi                                                                                          

if [ -f $workdir/BL/updatesites/domains ] && [ -f $dbhome/BL/updatesites/domains ]
  then                                                                            
    diff -ur $workdir/BL/updatesites/domains $dbhome/BL/updatesites/domains > $dbhome/BL/updatesites/domains.diff
fi                                                                                                               

if [ -f $workdir/BL/updatesites/urls ] && [ -f $dbhome/BL/updatesites/urls ]
  then                                                                      
    diff -ur $workdir/BL/updatesites/urls $dbhome/BL/updatesites/urls > $dbhome/BL/updatesites/urls.diff
fi                                                                                                      

if [ -f $workdir/BL/violence/domains ] && [ -f $dbhome/BL/violence/domains ]
  then                                                                      
    diff -ur $workdir/BL/violence/domains $dbhome/BL/violence/domains > $dbhome/BL/violence/domains.diff
fi                                                                                                      

if [ -f $workdir/BL/violence/urls ] && [ -f $dbhome/BL/violence/urls ]
  then                                                                
    diff -ur $workdir/BL/violence/urls $dbhome/BL/violence/urls > $dbhome/BL/violence/urls.diff
fi                                                                                             


if [ -f $workdir/BL/warez/domains ] && [ -f $dbhome/BL/warez/domains ]
  then                                                                
    diff -ur $workdir/BL/warez/domains $dbhome/BL/warez/domains > $dbhome/BL/warez/domains.diff
fi                                                                                             

if [ -f $workdir/BL/warez/urls ] && [ -f $dbhome/BL/warez/urls ]
  then                                                          
    diff -ur $workdir/BL/warez/urls $dbhome/BL/warez/urls > $dbhome/BL/warez/urls.diff
fi                                                                                    

if [ -f $workdir/BL/weapons/domains ] && [ -f $dbhome/BL/weapons/domains ]
  then                                                                    
    diff -ur $workdir/BL/weapons/domains $dbhome/BL/weapons/domains > $dbhome/BL/weapons/domains.diff
fi                                                                                                   

if [ -f $workdir/BL/weapons/urls ] && [ -f $dbhome/BL/weapons/urls ]
  then                                                              
    diff -ur $workdir/BL/weapons/urls $dbhome/BL/weapons/urls > $dbhome/BL/weapons/urls.diff
fi                                                                                          

if [ -f $workdir/BL/webmail/domains ] && [ -f $dbhome/BL/webmail/domains ]
  then                                                                    
    diff -ur $workdir/BL/webmail/domains $dbhome/BL/webmail/domains > $dbhome/BL/webmail/domains.diff
fi                                                                                                   

if [ -f $workdir/BL/webmail/urls ] && [ -f $dbhome/BL/webmail/urls  ]
  then                                                               
    diff -ur $workdir/BL/webmail/urls $dbhome/BL/webmail/urls > $dbhome/BL/webmail/urls.diff
fi                                                                                          

if [ -f $workdir/BL/webphone/domains ] && [ -f $dbhome/BL/webphone/domains ]
  then                                                                      
    diff -ur $workdir/BL/webphone/domains $dbhome/BL/webphone/domains > $dbhome/BL/webphone/domains.diff
fi                                                                                                      

if [ -f $workdir/BL/webphone/urls ] && [ -f $dbhome/BL/webphone/urls ]
  then
    diff -ur $workdir/BL/webphone/urls $dbhome/BL/webphone/urls > $dbhome/BL/webphone/urls.diff
fi

if [ -f $workdir/BL/webradio/domains ] && [ -f $dbhome/BL/webradio/domains ]
  then
    diff -ur $workdir/BL/webradio/domains $dbhome/BL/webradio/domains > $dbhome/BL/webradio/domains.diff
fi

if [ -f $workdir/BL/webradio/urls ] && [ -f $dbhome/BL/webradio/urls ]
  then
    diff -ur $workdir/BL/webradio/urls $dbhome/BL/webradio/urls > $dbhome/BL/webradio/urls.diff
fi

if [ -f $workdir/BL/webtv/domains ] && [ -f $dbhome/BL/webtv/domains ]
  then
    diff -ur $workdir/BL/webtv/domains $dbhome/BL/webtv/domains > $dbhome/BL/webtv/domains.diff
fi

if [ -f $workdir/BL/webtv/urls ] && [ -f $dbhome/BL/webtv/urls ]
  then
    diff -ur $workdir/BL/webtv/urls $dbhome/BL/webtv/urls > $dbhome/BL/webtv/urls.diff
fi


echo "Setting file permisions."
$chownpath -R $squidGuardowner $dbhome

echo "Updating squid db files with diffs."
$squidGuardpath -u all

echo "Reconfiguring squid."
$squidpath -k reconfigure

echo "Clean up downloaded file and directories."
#rm $workdir/shallalist.tar.gz
#rm -rf $workdir/BL