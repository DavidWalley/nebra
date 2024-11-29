// TestProcedures.hx - Try various procedures for syncing lunar calendar, reading pre-calculated data files.
// (c)2024 David C. Walley

// This code file is pre-processed and run using the following, in a UBUNTU terminal (ctrl+alt+T):
// cd ~/Desktop/AAA/hey_diddle/code/nebra                                                               # Where I keep this file.
// #      Language (neko for local execution bodge code)                                                #
// #      |    Intermediate file                                                                        #
// #      |    |            Main code class                                                             #
// #      V    V             V                                                                          #
// timedatectl set-timezone Africa/Abidjan && haxe --neko TEMP_neko.n --main TestProcedures && neko TEMP_neko.n DUMMYdATA && timedatectl set-timezone America/Chicago


class TestProcedures /////////////////////////////////////////////////////////////////////////////////////> For a stellarium script:
{/////////////////////////////////////////////////////////////////////////////////////////////////////////>

  var                   _sPathData     :String ="/home/dave/Desktop/AAA/hey_diddle/code/nebra/trials/"; //> ???Hard-coded? Pre-calculated data files.
  var                   _sPathOut      :String ="/home/dave/Desktop/AAA/hey_diddle/code/nebra/trials/"; //> ???Hard-coded? Results output to here.
  var                   _mapasJdMsMsIlRaDe     = new Map<String,Array<String>>();                       //> Table of data read from files.
  var                   _GREGORIANePOCH        = 1721425.5; // ??? https://dzucconi.github.io/calendrical/docs/calendrical.calendar.constants.html


 function                nMod(////////////////////////////////////////////////////////////////////////////>
                         a                                                                              //>
 ,                       m                                                                              //>
 )                                      :Int{/////////////////////////////////////////////////////////////>
 return ( Math.floor(a)%m + m )%m;                                                                      //>
 }//nMod//////////////////////////////////////////////////////////////////////////////////////////////////>


 function               dOverLine_360(////////////////////////////////////////////////////////////////////> Test which side of great circle defined by Canis Minor, a given celestial point is.
                        a_Qlat_360      :Float                                                          //> Declination and
 ,                      a_Qlong_360     :Float                                                          //> Right Ascension of point to test.
 )                                      {/////////////////////////////////////////////////////////////////>
 // let                                 latA                    = a_Alat_360 *Math.PI/180;              //> Code to find constants for Procyon (star in Canis Minor). Polar coordinates (latitude and
 // let                                 longA                   = a_Along_360*Math.PI/180;              //> longitude of the first point.
 // let                                 xA                      = Math.cos(latA)*Math.cos(longA);       //>
 // let                                 yA                      = Math.cos(latA)*Math.sin(longA);       //>
 // let                                 zA                      = Math.sin(latA)                ;       //>
  var                                   xA                      = -0.41812783213741955;                 //> Pre-calculated values for Procyon
  var                                   yA                      =  0.9038249325942993 ;                 //> "
  var                                   zA                      =  0.09093738072416822;                 //> ,
 // let                                 latB                    = a_Blat_360 *Math.PI/180;              //> Code to find constants for Gomeisa (star in Canis Minor). Polar coordinates (latitude and
 // let                                 longB                   = a_Blong_360*Math.PI/180;              //> longitude of the second point.
 // let                                 xB                      = Math.cos(latB)*Math.cos(longB);       //>
 // let                                 yB                      = Math.cos(latB)*Math.sin(longB);       //>
 // let                                 zB                      = Math.sin(latB)                ;       //>
 // core.output( "dOverLine_360, "+ xA +", "+  yA +", "+  zA );                                         //>
 // core.output( "dOverLine_360, "+ xB +", "+  yB +", "+  zB );                                         //>
  var                                   xB                      = -0.36737866131120084;                 //> Pre-calculated values for Gomeisa
  var                                   yB                      =  0.91883139318759   ;                 //> "
  var                                   zB                      =  0.14415890574689555;                 //> .
                                                                                                        //>
  var                                   latQ                    = a_Qlat_360 *Math.PI/180;              //> Polar coordinates (latitude/declination and
  var                                   longQ                   = a_Qlong_360*Math.PI/180;              //> longitude/right-ascension) of the point.
  var                                   xQ                      = Math.cos(latQ)*Math.cos(longQ);       //> Convert to 3-D co-ords of unit vector
  var                                   yQ                      = Math.cos(latQ)*Math.sin(longQ);       //> "
  var                                   zQ                      = Math.sin(latQ)                ;       //> .
  var                                   xS                      =  yA*zB - zA*yB;                       //> a2b3 - a3b2   Cross product.
  var                                   yS                      =  zA*xB - xA*zB;                       //> a3b1 - a1b3
  var                                   zS                      =  xA*yB - yA*xB;                       //> a1b2 - a2b1
  var                                   dDotQS                  =            xS*xQ + yS*yQ + zS*zQ  ;   //>               Dot product.
  var                                   dS                      = Math.sqrt( xS*xS + yS*yS + zS*zS );   //>               Magnitude.
  var                                   r_d_360                 = Math.asin(dDotQS/dS)*180/Math.PI  ;   //> core.output( "Q.S, "+ r_d ); //> Distance from point to dividing line.
 return r_d_360;                                                                                        //> Report distance from point to dividing line defined by Canis Minor, in degrees.
 }//dOverLine_360/////////////////////////////////////////////////////////////////////////////////////////>


//////////////////////////////////////////////////////////////////////////////////////////////////////////>
// GREGORIAN -> JDAY                                                                                    //>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               dDate_jd(/////////////////////////////////////////////////////////////////////////> Alternate implementation to convert Gregorian to JDay.   https://dzucconi.github.io/calendrical/docs/calendrical.calendar.conversions.html
                        Y               :Int                                                            //> Gregorian Year,
 ,                      M               :Int                                                            //> Month. Jan = 1, Dec = 12
 ,                      D               :Int                                                            //> Day. 1st = 1
//,                     12                                                                              //> Assuming time is noon
//,                     0                                                                               //> or after
//,                     0                                                                               //> .
 )                                      :Float {//////////////////////////////////////////////////////////>
 return (  _GREGORIANePOCH                                                                              //>
         +           365*(Y - 1)                                                                        //>
         +   Math.floor( (Y - 1) /   4)                                                                 //> Add a leap year every 4th, 
         -   Math.floor( (Y - 1) / 100)                                                                 //> but not on century years,
         +   Math.floor( (Y - 1) / 400)                                                                 //> except every 4 centuries.
         +   Math.floor(   ( (367*M - 362) / 12 )                                                       //>
              +            ( M <= 2  ?0  :bLeapGregorian(Y) ?-1 :-2 )                                   //> Treat Jan and Feb differently.
             )                                                                                          //>
         + D - 0.5                                                                                      //> Assuming noon of given day. -1 + 0.5
        );                                                                                              //>
 }//dDate_jd//////////////////////////////////////////////////////////////////////////////////////////////>
//.  function               dDate_jd(/////////////////////////////////////////////////////////////////////////> Convert Gregorian date noon to a Julian Day, the number of days that have passed since the Julian Date Epoch.
//.                         Y               :Int                                                            //> Gregorian Year,
//.  ,                      M               :Int                                                            //> Month. Jan = 1, Dec = 12
//.  ,                      D               :Int                                                            //> Day. 1st = 1
//. //,                     12                                                                              //> Assuming time is noon
//. //,                     0                                                                               //> or after
//. //,                     0                                                                               //> .
//.  )                                      :Float {//////////////////////////////////////////////////////////>
//.   var                   A               :Int                    = Math.floor( (M - 14)/12 );            //> ?????????????    https://en.wikipedia.org/wiki/Julian_day
//.   var                   B               :Int                    = Y + 4800 + A;                         //>
//.  return  Math.floor(   1461*             B             / 4   )                                          //>
//.        + Math.floor(    367*           ( M - 2 - 12*A )/12   )                                          //>
//.        - Math.floor(      3*Math.floor( (B+100)/100 )  / 4   )                                          //>
//.        + D - 32075                                                                                      //>
//.        ;                                                                                                //> ??? 29 + 9.5 days difference between Gregorian calendar and Julian days?
//.  }//dDate_jd//////////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_dDate_jd(){//////////////////////////////////////////////////////////////////> Test the above function.
  var                   m               :Float                  = 0;                                    //>
  var                   n               :Float                  = 0;                                    //>
                                //     Julian Day as displayed in Stellarium.                           //>
                                //     |    I think these fudge factors are because of differences between Julian and Gregorian calendars before 1582 - 3 days every 300 years.
                                //     v    v                                                                                 From Stellarium v
//for( i in -4712...2000 ){
 m = dDate_jd(-4713,11,24); trace("TEST_dDate_jd -4713 " + m );                                         // Does not match Stellarium, as it switches to the Julian calendar before 1500s.
 m = dDate_jd(-4712, 1, 1); trace("TEST_dDate_jd -4712 " + m );
for( y in 1600...2100 ){
 m = dDate_jd(y,11,24); 
 //n = dDate_jd(y,11,24); 
 if( y == 1700 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2342300
 if( y == 1800 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2378824
 if( y == 1900 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2415348
 if( y == 2000 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2451873
 if( y <  1609 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 
                        // 2305776                      
                        // 2306141                      
                        // 2306506                      
                        // 2306871                      
                        // 2307237                      
                        // 2307602                      
                        // 2307967                      
                        // 2308332                      
                        // 2308698                      
 // if( m != n ){ trace( "TEST_dDate_jd "+ y +" "+ m +" "+ n ); return 1 ;} //>       0
}//for i
//.  n = dDate_jd(-4713,11,24); if(       0          +0.5 != n ){ trace( "TEST_dDate_jd 1  -4713,11,23: "+ n +" "+  n            ); return 1 ;} //>       0
//.  n = dDate_jd(-4712, 1,1 ); if(       0 +12*3 +2 +0.5 != n ){ trace( "TEST_dDate_jd 3  -4712, 1,1 : "+ n +" "+  n            ); return 3 ;} //>       0                                    
//.  n = dDate_jd(-2000, 1,1 ); if(  990558 + 5*3 +2 +0.5 != n ){ trace( "TEST_dDate_jd 5  -2000, 1,1 : "+ n +" "+ (n -  990558) ); return 5 ;} //>  990558                                    
//.  n = dDate_jd(   -1, 1,1 ); if( 1720693 +      2 +0.5 != n ){ trace( "TEST_dDate_jd 7     -1, 1,1 : "+ n +" "+ (n - 1720693) ); return 7 ;} //> 1720693                                    
//.  n = dDate_jd(    0, 1,1 ); if( 1721058 +      2 +0.5 != n ){ trace( "TEST_dDate_jd 9      0, 1,1 : "+ n +" "+ (n - 1721058) ); return 9 ;} //> 1721058                                    
//.  n = dDate_jd(    1, 1,1 ); if( 1721424 +      1 +0.5 != n ){ trace( "TEST_dDate_jd 11     1, 1,1 : "+ n +" "+ (n - 1721424) ); return 11;} //> 1721424                                    
//.  n = dDate_jd( 1000, 1,1 ); if( 2086308 - 2*3 +1 +0.5 != n ){ trace( "TEST_dDate_jd 14  1000, 1,1 : "+ n +" "+ (n - 2086308) ); return 14;} //> 2086308
//.  n = dDate_jd( 1582, 1,1 ); if( 2298884 - 4*3 +2 +0.5 != n ){ trace( "TEST_dDate_jd 16  1582, 1,1 : "+ n +" "+ (n - 2298884) ); return 16;} //> 10 day jump implemented in 1582 Oct.
//.  n = dDate_jd( 1583, 1,1 ); if( 2299239          +0.5 != n ){ trace( "TEST_dDate_jd 18  1583, 1,1 : "+ n +" "+ (n - 2299239) ); return 18;} //> 2299239
//.  n = dDate_jd( 1600, 1,1 ); if( 2305448          +0.5 != n ){ trace( "TEST_dDate_jd 20  1600, 1,1 : "+ n +" "+ (n - 2305448) ); return 20;} //> 2305448
//.  n = dDate_jd( 1700, 1,1 ); if( 2341973          +0.5 != n ){ trace( "TEST_dDate_jd 22  1700, 1,1 : "+ n +" "+ (n - 2341973) ); return 22;} //> 2341973
//.  n = dDate_jd( 1970, 1,1 ); if( 2440588          +0.5 != n ){ trace( "TEST_dDate_jd 24  1970, 1,1 : "+ n +" "+ (n - 2440588) ); return 24;} //> 2440588
 return 0;                                                                                              //> Report no problems - looks good against Stellarium.
 }//TEST_dDate_jd/////////////////////////////////////////////////////////////////////////////////////////>


//////////////////////////////////////////////////////////////////////////////////////////////////////////>
// JDAY -> GREGORIAN                                                                                    //>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               nYearFromJd(//////////////////////////////////////////////////////////////////////> Convert Julian Day to Year.
                        a_jd            :Float                                                          //> Julian Day
 )                                      :Int {////////////////////////////////////////////////////////////>
  var           dNoon_jd                :Float             = Math.floor(a_jd - 0.5) + 0.5;              //> Round off to the noon before given day number.
  var           dDay_jd                 :Float             = dNoon_jd - _GREGORIANePOCH;                //> this.constants.gregorian.EPOCH;
                                                                                                        //>
  var           nCycles_400y            :Int               = Math.floor(dDay_jd           / 146097);    //> Number of 400 nYear cycles.
  var           nIn400yCycle_day        :Int               = nMod(      dDay_jd           , 146097);    //> Day within 400 nYear cycle.
                                                                                                        //>
  var           nCenturyInCycle_100y    :Int               = Math.floor(nIn400yCycle_day  /  36524);    //> Century within 400 nYear cycle.
  var           nInCentury_day          :Int               = nMod(      nIn400yCycle_day  ,  36524);    //> Day count in century.
                                                                                                        //>
  var           nBlockInCentury_4y      :Int               = Math.floor(nInCentury_day    /   1461);    //> 4 nYear block within the century.
  var           nIn4yBlock_day          :Int               = nMod(      nInCentury_day    ,   1461);    //>
                                                                                                        //>
  var           nYearInBlock_y          :Int               = Math.floor(nIn4yBlock_day    /    365);    //>
                                                                                                        //>
  var           nYear                   :Int               =          nCycles_400y*400                  //>
                                                            + nCenturyInCycle_100y*100                  //>
                                                            +   nBlockInCentury_4y*4                    //>
                                                            +       nYearInBlock_y;                     //>
  if(       nCenturyInCycle_100y != 4   &&   nYearInBlock_y != 4      ){ nYear++; }                     //>
 return nYear;                                                                                          //>
 }//nYearFromJd///////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_nYearFromJd(/////////////////////////////////////////////////////////////////>
 )                                      :Int {////////////////////////////////////////////////////////////>
  var                   n               :Int                    = 0;                                    //>
  var                   d               :Float                  = dDate_jd(1600,1,1);
  for( y in -4172...2100 ){
   d = dDate_jd(y,1,1); n = nYearFromJd(d); if( y != n ){ trace( "TEST_nYearFromJd 1  "+ n ); return 1 ;}  
  }//for y
 return 0;
 }//nYearFromJd///////////////////////////////////////////////////////////////////////////////////////////>
 

 function bLeapGregorian(nYear){ return nYear%4 == 0   && ( nYear%100 != 0   ||  nYear%400 == 0 );  }


 function               anGregorianFromJd(////////////////////////////////////////////////////////////////>
                        a_jd              :Float                                                          //>
 )                                      :Array<Int> {/////////////////////////////////////////////////////>
  var              nYear    :Int   = nYearFromJd(a_jd);                                                   //>
  var              dNoon_jd     :Float = Math.floor(a_jd - 0.5) + 0.5;                                        //>
  var              dYearday :Float =   dNoon_jd - dDate_jd(nYear,1,1);                                      //>
  var              nLeap    :Int   = ( dNoon_jd < dDate_jd(nYear,3,1) ) ?                        0          //>
                                                                    :(bLeapGregorian(nYear) ?1 :2)      //>
                                    ;                                                                   //>
  var              month    :Int   = Math.floor(      (   ( (dYearday+nLeap)*12 ) +373   )/ 367      ); //>
  var              day      :Int   = Math.floor( dNoon_jd - dDate_jd(nYear, month, 1) ) + 1;                //>
 return [nYear, month, day];                                                                            //>
 }//anGregorianFromJd/////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_anGregorianFromJd(///////////////////////////////////////////////////////////>
 ){                     //////////////////////////////////////////////////////////////////////////////////>
  trace("TEST_anGregorianFromJd");                                                                      //>
  var                   s               :String                 = "";                                   //>
  s = ""+ anGregorianFromJd(       0          ); if( "[-4713,11,23]" != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd(       0 +12*3 +2 ); if( "[-4712,1,1]"   != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd(  990558 + 5*3 +2 ); if( "[-2000,1,1]"   != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd( 1720693 +      2 ); if( "[-1,1,1]"      != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd( 1721058 +      2 ); if( "[0,1,1]"       != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd( 1721424 +      1 ); if( "[1,1,1]"       != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd( 2086308 - 2*3 +1 ); if( "[1000,1,1]"    != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd( 2298884 - 4*3 +2 ); if( "[1582,1,1]"    != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd( 2299239          ); if( "[1583,1,1]"    != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd( 2305448          ); if( "[1600,1,1]"    != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd( 2341973          ); if( "[1700,1,1]"    != s ){ trace( ">"+ s +"<"); }       //>
  s = ""+ anGregorianFromJd( 2440588          ); if( "[1970,1,1]"    != s ){ trace( ">"+ s +"<"); }       //>
 }//TEST_anGregorianFromJd////////////////////////////////////////////////////////////////////////////////>


 function               sYMD(/////////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date string.
                        a_jd              :Int                                                            //>
 ){                                     //////////////////////////////////////////////////////////////////>
  var                   an              :Array<Int>             = anGregorianFromJd( a_jd );              //>
 return an[0] +"-"+ ( "0"+an[1] ).substr(-2) +"-"+ ( "0"+an[2] ).substr(-2);                            //>
 }//sYMD//////////////////////////////////////////////////////////////////////////////////////////////////>


 function               sYMDhms(//////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date/time string.
                        a_jd              :Float                                                          //>
 ){                                     //////////////////////////////////////////////////////////////////>
  var                   n_jd       :Int   = Math.floor(a_jd);                                             //>
  var                   d          :Float                      = a_jd - n_jd; d =            24*d       ; //>
  var                   nH         :Int   = Math.floor( d ); d =  d - nH  ; d =            60*d       ; //>
  var                   nM         :Int   = Math.floor( d ); d =  d - nM  ; d = Math.floor(60*d + 0.5); //>
 return sYMD(n_jd) +" "+ ("0"+nH).substr(-2) +":"+ ("0"+nM).substr(-2) +":"+ ("0"+d).substr(-2);        //>
 }//sYMDhms///////////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_sYMDhms(/////////////////////////////////////////////////////////////////////>
 )                                      :Int {//////////////////////////////////////////////////////////////////////////////////>
  var                   n               :Int                    = 0;
  var                   s               :String                 = "";
  n = 0; s = sYMDhms( n ); if( "-4713-11-23 00:00:00" != s ){ trace( "TEST_sYMDhms 1  >"+ n +" "+ s +"<" ); return 1 ;}
  n = 0; s = sYMDhms( n ); if( "-4713-11,23 00:00:00" != s ){ trace( "TEST_sYMDhms 2  >"+ n +" "+ s +"<" ); return 2 ;}
  n = 0; s = sYMDhms( n ); if( "-4712-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 3  >"+ n +" "+ s +"<" ); return 3 ;}
  n = 0; s = sYMDhms( n ); if( "-2000-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 4  >"+ n +" "+ s +"<" ); return 4 ;}
  n = 0; s = sYMDhms( n ); if(    "-1-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 5  >"+ n +" "+ s +"<" ); return 5 ;}
  n = 0; s = sYMDhms( n ); if(     "0-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 6  >"+ n +" "+ s +"<" ); return 6 ;}
  n = 0; s = sYMDhms( n ); if(     "1-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 7  >"+ n +" "+ s +"<" ); return 7 ;}
  n = 0; s = sYMDhms( n ); if( " 1000-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 8  >"+ n +" "+ s +"<" ); return 8 ;}
  n = 0; s = sYMDhms( n ); if( " 1582-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 9  >"+ n +" "+ s +"<" ); return 9 ;}
  n = 0; s = sYMDhms( n ); if( " 1583-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 10 >"+ n +" "+ s +"<" ); return 10;}
  n = 0; s = sYMDhms( n ); if( " 1600-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 11 >"+ n +" "+ s +"<" ); return 11;}
  n = 0; s = sYMDhms( n ); if( " 1700-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 12 >"+ n +" "+ s +"<" ); return 12;}
  n = 0; s = sYMDhms( n ); if( " 1970-01-01 00:00:00" != s ){ trace( "TEST_sYMDhms 13 >"+ n +" "+ s +"<" ); return 13;}
 return 0;
 }//TEST_sYMDhms(){}//////////////////////////////////////////////////////////////////////////////////////>




//.  function              calendar_gregorianToJd(///////////////////////////////////////////////////////////> Determine Julian day number from Gregorian calendar date
//.                        year
//.  ,                     month
//.  ,                     day
//.  )                     {////////////////////////////////////////////////////////////////////////////////////////
//.  return (_GREGORIANePOCH - 1)       
//.        + (365 * (year - 1))                             
//.        + Math.floor((year - 1) / 4)                     
//.        + (-Math.floor((year - 1) / 100))                
//.        + Math.floor((year - 1) / 400)                   
//.        + Math.floor(
//.           (   ( (367*month) - 362 ) /12   )        
//.          +
//.           (   (month <= 2) ?0 
//.                            :( calendar_leapGregorian(year) ? -1 : -2 )
//.           ) 
//.          + day
//.         )
//.  ;
//.  }///////////////////////////////////////////////////////////////////////////////////////////////////////////
//.
//.  function              calendar_jdToGregorianYear(///////////////
//.                        a_jd
//.  )                     {///////////////////////////////////////
//.    var wjd        = Math.floor(a_jd - 0.5) + 0.5;
//.    var depoch     = wjd - _GREGORIANePOCH;
//.    var quadricent = Math.floor(depoch / 146097);
//.    var dqc        = astro.mod(depoch, 146097);
//.    var cent       = Math.floor(dqc / 36524);
//.    var dcent      = astro.mod(dqc, 36524);
//.    var quad       = Math.floor(dcent / 1461);
//.    var dquad      = astro.mod(dcent, 1461);
//.    var yindex     = Math.floor(dquad / 365);
//.    var year       = (quadricent * 400) + (cent * 100) + (quad * 4) + yindex;
//.    if (!((cent == 4) || (yindex == 4))) { year++; }
//.  return year;
//.  }///////////////////////////////////////////////////////>
//.
//.
//.  function              calendar_jdToGregorian(/////////////////////////////////// Calculate Gregorian calendar date from Julian day
//.                        a_jd
//.  )                     {//////////////////////////////////
//.    var                 wjd             = Math.floor(a_jd - 0.5) + 0.5;
//.    var                 year            = calendar_jdToGregorianYear(a_jd);
//.    var                 yearday         = wjd - calendar_gregorianToJd(year, 1, 1);
//.    var                 leapadj         = (     (   wjd < calendar_gregorianToJd(year, 3, 1)   ) ?0 :(calendar_leapGregorian(year) ? 1 : 2)     );
//.    var                 month           = Math.floor(     (   ( (yearday + leapadj)*12 ) + 373   )/367     );
//.    var                 day             = (   wjd - calendar_gregorianToJd(year,month,1)   ) + 1;
//.  return [year, month, day];
//.  }/////////////////////////////////////////////////////


 function               sWinterObservations(//////////////////////////////////////////////////////////////> Run the "Hey Diddle Diddle algorithm" from one date.
                        a_sGo                                                                           //> Date to start on (start waiting for the new moon).
 )                                      :String {/////////////////////////////////////////////////////////>
  var                   when_jd         :Int  = Math.floor( dDate_jd( Std.parseInt( a_sGo.substr(0,4) ) //> Convert Gregorian date to a Julian Day, the number of days that have passed since the Julian Date Epoch.  Gregorian Year,
                                                            ,         Std.parseInt( a_sGo.substr(5,2) ) //> Month. Jan = 1, Dec = 12
                                                            ,         Std.parseInt( a_sGo.substr(8,2) ) //> Day. 1st = 1
                                                )           );                                          //>

trace("sWinterObservations "+ a_sGo +" "+ when_jd);

  var                   asJdMsMsIlRaDe  :Array<String>    = _mapasJdMsMsIlRaDe[ when_jd +"jd" ];        //> Look up data for the given day.
  if( null == asJdMsMsIlRaDe ){                                                             return "*";}//> If there is a problem, like date isn't in table, then quit.
  var                   sDate           :String           = "";                                         //>
  var                   dDate_jd        :Float            = 0.;                                         //>
  var                   dMoonset_jd     :Float            = 0.;                                         //>
  var                   sMoonset        :String           = "";                                         //>
  var                   dLit_100        :Float            = 0.;                                         //> Illumination in percent.
  var                   dRa             :Float            = 0.;                                         //> Short-term right ascension (long) and
  var                   dDec            :Float            = 0.;                                         //> declination (lat) of a point.
  var                   whenGo_jd       :Int              = when_jd;                                    //> Make a copy...
  var                   isStep          :Int              = -1;                                         //>
  var                   isLeap          :Int              = -1;                                         //>
  var                   dSkipAhead_days :Float            =  1.;                                        //>
  var                   sRow            :String           = "";                                         //>
  while( isStep < 99 ){                                                                                 //>
   dSkipAhead_days = 1.;                                                                                //> Default is 1 loop = 1 day.
   asJdMsMsIlRaDe = _mapasJdMsMsIlRaDe[ when_jd +"jd" ];                                                 //> Look up data for the given date.
   if( null == asJdMsMsIlRaDe ){                                        trace("???");            break;}//>
   sDate       =                 asJdMsMsIlRaDe[0]  ;                                                   //> sDate        ,1999-12-31T12:00:00   First cell is nYear as text in ISO format
   dMoonset_jd = Std.parseFloat( asJdMsMsIlRaDe[1] );                                                   //> Moonset      ,37.220555555555556 
   sMoonset    =                 asJdMsMsIlRaDe[2]  ;                                                   //> MOON_when    ,2000-01-01T13:13:14 
   dLit_100    = Std.parseFloat( asJdMsMsIlRaDe[3] );                                                   //> illumination ,22.799720764160156            
   dRa         = Std.parseFloat( asJdMsMsIlRaDe[4] );                                                   //> ra           ,-137.51418852173234           
   dDec        = Std.parseFloat( asJdMsMsIlRaDe[5] );                                                   //> dec          ,-11.811177408287486           
                                                                                                        //>
   if(      -1 == isStep ){ isStep = 0;                                                                 //> The very first time, move on to next step immediately.
                            sRow   = sDate +"="+ sYMDhms(when_jd                    )                   //> But report date and
                                     +",mset, "+ sYMDhms(when_jd + dMoonset_jd - 0.5)                   //> date/time of the moon set.
                                     +     ", "+                   sMoonset          ;                  //>
   }//if                                                                                                //>
   if(       0 == isStep ){                                                                             //> If in first stage...
    if( dLit_100 < 2   ){   isStep++;   }                                                               //> Look for new moon, if seeing it, go to next stage.
   }else if( 1 == isStep ){                                                                             //> In 2nd stage, look
    if( 50 <= dLit_100 ){   isStep++;   dSkipAhead_days = 7.;                                           //> for first gibbous illumination (50%+), when we start count of nights.
                            sRow +=    ",gib, "+ sYMDhms(when_jd + dMoonset_jd - 0.5)                   //>
                                     +     "," +                   sMoonset                             //>
                                  ;                                                                     //>
    }//if                                                                                               //>
   }else{                                                                                               //>
  break;//while                                                                                         //>
   }//if                                                                                                //>
   when_jd++;                                                                                           //> Next day
  }//while                                                                                              //> .
                                                                                                        //>
  var                   d_360           :Float                  = dOverLine_360(dDec,dRa);              //>
  if( d_360 < 0 ){   when_jd += 337;   sRow += ",337, "+ sYMD( when_jd );   }                           //>
  else           {   when_jd += 366;   sRow += ",366, "+ sYMD( when_jd );   }                           //>
 return sRow;                                                                                           //>
 }//sWinterObservations///////////////////////////////////////////////////////////////////////////////////>


 function               Go_ReadOneFile(///////////////////////////////////////////////////////////////////> Get data from one file, add to global table (map).
                        a_sFile                                                                         //> Name of file within input directory.
 )                                      {/////////////////////////////////////////////////////////////////> Report nothing. Add to _mapasJdMsMsIlRaDe.
  var                   sData           :String         = sys.io.File.getContent(_sPathData + a_sFile); //> Get contents of input data file.
  var                   asLines                         = sData.split('\n');                            //> Split file into rows (one per date).
  var                   n                               = asLines.length;                               //> Get number of rows.
  var                   r_s                             = "";                                           //> Output text string.
  var                   as                              = [];                                           //> List of text cell contents.
  var                   sKeyJDay                        = "";                                           //>
  var                   asRow           :Array<String>  = [];                                           //> Move to RAM:
  for( i in 2...n ){                                                                                    //> Skip first 2 lines, and then process each file line.
   as       = asLines[i].split(",");                                                                    //> Split line on commas.
   sKeyJDay = as[1] +"jd";                                                                              //> List key is the Julian Day.
   asRow    = [    as[0]                // 0                                                            //> sDate        ,1999-12-31T12:00:00   First cell is nYear as text in ISO format yyyy-mm-dd. 
              //,  as[1 ]                                                                               //> nDay         ,2451544               Create row of data in RAM table:
              //,  as[2 ]                                                                               //> Sunset       ,16.026944444444442 
              //,  as[3 ]                                                                               //> Sunrise      ,32.06888888888889 
              //,  as[4 ]                                                                               //> Moonrise     ,26.668333333333333 
              ,    as[5 ]               // 1                                                            //> Moonset      ,37.220555555555556 
              ,    as[6 ]               // 2                                                            //> MOON_when    ,2000-01-01T13:13:14 
              ,    as[7 ]               // 3                                                            //> illumination ,22.799720764160156 
              ,    as[8 ]               // 4                                                            //> ra           ,-137.51418852173234 
              ,    as[9 ]               // 5                                                            //> dec          ,-11.811177408287486 
              //,  as[10]                                                                               //> TIME_when    ,2000-01-01T00:00:00 
              //,  as[11]                                                                               //> illumination ,26.628517150878906 
              //,  as[12]                                                                               //> ra           ,-142.82009664343948 
              //,  as[13]                                                                               //> dec          ,-9.647356542776926 
              //,  as[14]                                                                               //> VEGA_when    ,1999-12-31T23:59:50 
              //,  as[15]                                                                               //> illumination ,26.629600524902344 
              //,  as[16]                                                                               //> ra           ,-142.82155355617718 
              //,  as[17]                                                                               //> dec          ,-9.646872946743024 
              ];                                                                                        //>
   _mapasJdMsMsIlRaDe[ sKeyJDay ] = asRow;                                                                //> Keep row of data in RAM table, keyed with ISO format date.
  }//for i                                                                                              //>
 }//Go_ReadOneFile////////////////////////////////////////////////////////////////////////////////////////>

 
 function               Go(///////////////////////////////////////////////////////////////////////////////> Main execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
//if( 0 < TEST_dDate_jd() ){                                                                    return;}//>
//  TEST_sYMDhms();                                                                                       //>
  if( 0 < TEST_nYearFromJd() ){                                                                 return;}//>
//  TEST_anGregorianFromJd();                                                                             //>
                                                                                                        //>
//.  trace("Reading data. -----------------------------------------");
//.  for( y in 2000...2100 ){                                                                              //> For a century...
//.   Go_ReadOneFile( '2000_2099/table012_'+ y +'.csv' );                                                  //> Get data from one file, put in global table
//.  }//for y                                                                                              //> .
//.                                                                                                        //>
//.  for( y in 2000...2001 ){                                                                              //> For each year...
//.   var                  s1              :String                 = y +'-02-15';                          //> Create the starting date (late in this case).
//.   var                  sReport         :String                 = "";                                   //>
//.   trace("Year = "+ y +" "+ s1 +"-------------------------------");
//.   for( z in 0...20 ){                                                                                  //> Run observations for 10 years in a row.
//.    s1 = sWinterObservations( s1 );  sReport += "\n "+ s1;                                              //> Run the "Hey Diddle Diddle algorithm" from one starting date. Add a row to the results.
//.    s1 = s1.substr(-10);                                                                                //> The next date to start observations is given in the last cell of the row
//.   }//for z                                                                                             //> .
//.   trace(sReport);                                                                                      //> Output the report of rows.
//.                                                                                                        //>
//.   trace("");                                                                                           //>
//.  }//for y                                                                                              //>
  trace("Done");
 }//Go////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               new(//////////////////////////////////////////////////////////////////////////////> Construct a new object of this class (and run appropriate processing).
 )                                      :Void {///////////////////////////////////////////////////////////>
  //var                    sCommandLineDirection :String        = ( Sys.args() )[0];                    //> Get direction operation from command line.
  //if(     "TOpROJECT" == sCommandLineDirection ){          trace( sCommandLineDirection +" <-----" ); //> If command line is specifying "Read summaries and write back to project":
  //}//if                                                                                               //>
  Go();                                                                                                 //>
 }//new///////////////////////////////////////////////////////////////////////////////////////////////////>


 static public function main(/////////////////////////////////////////////////////////////////////////////> Execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
  #if sys                                                                                               //> Just check.
   trace("OK. file system can be accessed");                                                            //>
  #end                                                                                                  //>
  new TestProcedures();                                                                                 //> Create and run and instance of this class.
 }//main//////////////////////////////////////////////////////////////////////////////////////////////////>


}//class TestProcedures///////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


// End of file.
