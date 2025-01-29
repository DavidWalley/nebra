// TryMultiYearRuns.hx - Try various procedures for syncing lunar calendar, reading pre-calculated data files.
// (c)2024 David C. Walley

// This code file is pre-processed and run using the following, in a UBUNTU terminal (ctrl+alt+T) (some hard-coding follows):
// cd ~/Desktop/AAA/NEBRA/code/nebra                                                                    # Where I keep this file.
// timedatectl set-timezone Africa/Abidjan && haxe --neko TEMP_neko.n --main TryMultiYearRuns && neko TEMP_neko.n && timedatectl set-timezone America/Chicago
// Output is to stdout (trace()).

class TryMultiYearRuns ///////////////////////////////////////////////////////////////////////////////////> For a stellarium script:
{/////////////////////////////////////////////////////////////////////////////////////////////////////////>

  var           _bYEARLY                :Bool                   = true ;                                //> What to display as output: year-by-year details,
  var           _bPATTERN               :Bool                   = true ;                                //> Graphic for leap-year pattern.
  var           _bSTATS                 :Bool                   = true ;                                //>

  var                   _sPATHdATA     :String = "/home/dave/Desktop/AAA/NEBRA/code/nebra/daily_data/"; //> ???Hard-coded? Pre-calculated data files.
  var                   _sPATHoUT      :String = "/home/dave/Desktop/AAA/NEBRA/code/nebra/daily_data/"; //> ???Hard-coded? Results output to here.

  var                   _dYEAR_days      :Float                 = 365.242189;                           //> Mean tropical year (Laskar's expression)
  var                   _dMONTH_days     :Float                 = 29 + 12/24 + 44/60/24 + 2.9/60/60/24; //> Synodic month.
  var                   _dGREGORIANePOCH :Float                 = 1721425.5;                            //> ??? https://dzucconi.github.io/calendrical/docs/calendrical.calendar.constants.html
  var                   _mapasDaysData                          = new Map<String,Array<String>>();      //> Table of data for Sun, Moon and Vega for each day (night), read from files.
  var                    _iDAYSdATA_sDate            :Int       =  0;                                   //> Table column indexes in daily data file. [2000-02-15T12:00:00      First cell is nYear as text in ISO format yyyy-mm-dd.
  var                    _iDAYSdATA_nDay_jd          :Int       =  1;                                   //> ,2451590                  Numeric version of key.
  var                    _iDAYSdATA_dSunSet_h        :Int       =  2;                                   //> ,17.242222222222225       Hours (UTC, since last midnight)
  var                    _iDAYSdATA_dSunRise_h       :Int       =  3;                                   //> ,31.211111111111112       24+ because this is the number of hours from UTC start of day, to end of one continuous night.
  var                    _iDAYSdATA_dMoonRise_h      :Int       =  4;                                   //> ,12.511944444444444       Rises just after noon in this case
  var                    _iDAYSdATA_dMoonSet_h       :Int       =  5;                                   //> ,28.874722222222225       24+ because this is the number of hours from UTC start of day, to moonset during the night.
  var                    _iDAYSdATA_Moon_sDate       :Int       =  6;                                   //> ,2000-02-16T04:52:29      Moonset time
  var                      _iDAYSdATA_Moon_dLit      :Int       =  7;                                   //> ,83.7523193359375         83% - we missed 1st quarter moon.
  var                      _iDAYSdATA_Moon_dRa       :Int       =  8;                                   //> ,99.84598216989706        
  var                      _iDAYSdATA_Moon_dDec      :Int       =  9;                                   //> ,20.129735102040208       
  var                    _iDAYSdATA_MidN_sDate       :Int       = 10;                                   //> ,2000-02-16T00:00:00      Earlier at midnight...
  var                      _iDAYSdATA_MidN_dLit      :Int       = 11;                                   //> ,82.00177001953125        1% less illumination
  var                      _iDAYSdATA_MidN_dRa       :Int       = 12;                                   //> ,96.78695239100111        3 degrees movement 5 hours?
  var                      _iDAYSdATA_MidN_dDec      :Int       = 13;                                   //> ,20.314673377009978       
  var                    _iDAYSdATA_Vega_sDate       :Int       = 14;                                   //> ,2000-02-15T20:58:59      
  var                      _iDAYSdATA_Vega_dLit      :Int       = 15;                                   //> ,81.1370849609375         
  var                      _iDAYSdATA_Vega_dRa       :Int       = 16;                                   //> ,95.28642241319756        5 degrees movement in 8 hours?
  var                      _iDAYSdATA_Vega_dDec      :Int       = 17;                                   //> ,20.313803702885604


 function               nMod(/////////////////////////////////////////////////////////////////////////////> Fix the modulus function (% is the remainder function in this language?)
                        a               :Float                                                          //> Integer, a float that will be rounded down.
 ,                      m               :Int                                                            //> The integer modulus.
 )                                      :Int{/////////////////////////////////////////////////////////////>
 return ( Math.floor(a)%m + m )%m;                                                                      //>
 }//nMod//////////////////////////////////////////////////////////////////////////////////////////////////>

 function               cosR(a:Float) :Float{ return Math.cos(         a      ); }
 function               sinR(a:Float) :Float{ return Math.sin(         a      ); }
 function               cosD(a:Float) :Float{ return Math.cos( Math.PI*a/180. ); }
 function               sinD(a:Float) :Float{ return Math.sin( Math.PI*a/180. ); }


 function               dOverLine_360(////////////////////////////////////////////////////////////////////> Test which side of great circle defined by Canis Minor, a given celestial point is.
                        a_latQ_360      :Float                                                          //> Declination and
 ,                      a_longQ_360     :Float                                                          //> Right Ascension of point to test.
 )                                      :Float{///////////////////////////////////////////////////////////>
  var                   longA_360       :Float              = 360.*(  6.+(55.+  8.58   /60.)/60.)/24. ; //> Gomeisa RA=6 55  8.58        =  0.; //      
  var                   latA_360        :Float              =         9.+(17.+ 57.9    /60.)/60.      ; //>        DEC=9 17 57.9         =  0.; //     
  var                   longB_360       :Float              = 360.*(  7.+( 8.+ 23.14   /60.)/60.)/24. ; //> Procyon RA=7  8 23.14        =  0.; //     
  var                   latB_360        :Float              =         6.+(34.+ 22.1    /60.)/60.      ; //>        DEC=6 34 22.1         = 10.; //      
  var                   xA              :Float                  = cosD(  latA_360)*cosD(  longA_360);   //>
  var                   yA              :Float                  = cosD(  latA_360)*sinD(  longA_360);   //>
  var                   zA              :Float                  = sinD(  latA_360)                  ;   //> trace(longA_360 +" , "+ latA_360 +"  "+ xA +"  "+ yA +"  "+ zA); //> -0.41812783213741955  0.9038249325942993  0.09093738072416822;
  var                   xB              :Float                  = cosD(  latB_360)*cosD(  longB_360);   //>
  var                   yB              :Float                  = cosD(  latB_360)*sinD(  longB_360);   //>
  var                   zB              :Float                  = sinD(  latB_360)                  ;   //> trace(longB_360 +" , "+ latB_360 +"  "+ xB +"  "+ yB +"  "+ zB); //>-0.36737866131120084   0.91883139318759    0.14415890574689555;
  var                   xQ              :Float                  = cosD(a_latQ_360)*cosD(a_longQ_360);   //> Polar coordinates (latitude/declination and  
  var                   yQ              :Float                  = cosD(a_latQ_360)*sinD(a_longQ_360);   //> longitude/right-ascension) of the point.     
  var                   zQ              :Float                  = sinD(a_latQ_360)                  ;   //> .
  var                   xS              :Float                  =  yA*zB - zA*yB;                       //> Cross product. a2b3 - a3b2
  var                   yS              :Float                  =  zA*xB - xA*zB;                       //>                a3b1 - a1b3
  var                   zS              :Float                  =  xA*yB - yA*xB;                       //>                a1b2 - a2b1
  var                   dDotQS          :Float                  =            xS*xQ + yS*yQ + zS*zQ  ;   //> Dot product.
  var                   dS              :Float                  = Math.sqrt( xS*xS + yS*yS + zS*zS );   //> Magnitude.
  var                   r_d_360         :Float                  = Math.asin(dDotQS/dS)*180/Math.PI  ;   //> core.output( "Q.S, "+ r_d ); //> Distance from point to dividing line.
  //trace( a_latQ_360 +" "+ a_longQ_360 +" "+ r_d_360 );
 return r_d_360;                                                                                        //> Report distance from point to dividing line defined by Canis Minor, in degrees.
 }//dOverLine_360/////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_dOverLine_360(///////////////////////////////////////////////////////////////>
 )                                      :Int {////////////////////////////////////////////////////////////>
  var                   l               :Float                  = 0.;                                   //>
  var                   d               :Float                  = 0.;
  var                   r               :Float                  = 0.;
  r= 360*( 6.+( 55.+  8.58  /60.)/60.)/24.;d=   9.+(17.+ 57.9   /60.)/60.;   l = dOverLine_360(d,r); if( l < -0.001 ||  0.001 < l ){ trace("TEST_dOverLine_360 "+ d +","+ r +" = "+ l); return 1;}      
  r= 360*( 7.+(  8.+ 23.14  /60.)/60.)/24.;d=   6.+(34.+ 22.1   /60.)/60.;   l = dOverLine_360(d,r); if( l < -0.001 ||  0.001 < l ){ trace("TEST_dOverLine_360 "+ d +","+ r +" = "+ l); return 1;}      
                                                                                                                       
  r= 360*( 6.+( 21.+ 23.23  /60.)/60.)/24.;d=  13.+(44.+  1.8   /60.)/60.;   l = dOverLine_360(d,r); if( l < -1.8   || -1.7   < l ){ trace("TEST_dOverLine_360 "+ d +","+ r +" = "+ l); return 1;}      
  r= 360*( 6.+( 41.+ 38.70  /60.)/60.)/24.;d=  12.+(56.+ 34.6   /60.)/60.;   l = dOverLine_360(d,r); if( l <  0.73  ||  0.74  < l ){ trace("TEST_dOverLine_360 "+ d +","+ r +" = "+ l); return 1;}      

 return 0;                                                                                              //>
 }//TEST_dOverLine_360////////////////////////////////////////////////////////////////////////////////////>


//////////////////////////////////////////////////////////////////////////////////////////////////////////>
// GREGORIAN -> JDAY, JDAY -> GREGORIAN                                                                 //>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               dJDayOfYms_jd(////////////////////////////////////////////////////////////////////> Alternate implementation to convert Gregorian to JDay.   https://dzucconi.github.io/calendrical/docs/calendrical.calendar.conversions.html
                        Y               :Int                                                            //> Gregorian Year,
 ,                      M               :Int                                                            //> Month. Jan = 1, Dec = 12
 ,                      D               :Int                                                            //> Day. 1st = 1
//,                     12                                                                              //> Assuming time is noon
//,                     0                                                                               //> or after
//,                     0                                                                               //> .
 )                                      :Float {//////////////////////////////////////////////////////////>
 return (  _dGREGORIANePOCH                                                                             //>
         +           365*(Y - 1)                                                                        //>
         +   Math.floor( (Y - 1) /   4)                                                                 //> Add a leap year every 4th,
         -   Math.floor( (Y - 1) / 100)                                                                 //> but not on century years,
         +   Math.floor( (Y - 1) / 400)                                                                 //> except every 4 centuries.
         +   Math.floor(   ( (367*M - 362) / 12 )                                                       //> The magic numbers - it works!
              +            ( M <= 2  ?0  :bLeap(Y) ?-1 :-2 )                                            //> Treat Jan and Feb differently.
             )                                                                                          //>
         + D - 0.5                                                                                      //> Assuming noon of given day. -1 + 0.5
        );                                                                                              //>
 }//dJDayOfYms_jd/////////////////////////////////////////////////////////////////////////////////////////>


 function               nYearOfJd(////////////////////////////////////////////////////////////////////////> Convert Julian Day to Year.
                        a_jd            :Float                                                          //> Julian Day, immediately rounded down to last midnight.
 )                                      :Int {////////////////////////////////////////////////////////////>
  var           dStartOfDay_jd          :Float                  = Math.floor(a_jd - 0.5) + 0.5;         //> Integer is noon, so everything after midnight keeps same day but at midight, everything before midnight gets rounded down to previous day's midnight (= start of today).
  var           dDay_jd                 :Float                  = dStartOfDay_jd - _dGREGORIANePOCH;    //>
                                                                                                        //>
  var           nCycles_400y            :Int                    = Math.floor(dDay_jd          /146097); //> Number of 400 year cycles.
  var           nIn400yCycle_day        :Int                    = nMod(      dDay_jd          ,146097); //> Day within 400 year cycle.
                                                                                                        //>
  var           nCenturyInCycle_100y    :Int                    = Math.floor(nIn400yCycle_day / 36524); //> Century within 400 year cycle.
  var           nInCentury_day          :Int                    = nMod(      nIn400yCycle_day , 36524); //> Day count in century.
                                                                                                        //>
  var           nBlockInCentury_4y      :Int                    = Math.floor(nInCentury_day   /  1461); //> 4 year block within the century.
  var           nIn4yBlock_day          :Int                    = nMod(      nInCentury_day   ,  1461); //>
                                                                                                        //>
  var           nYearInBlock_y          :Int                    = Math.floor(nIn4yBlock_day   /   365); //>
                                                                                                        //>
  var           nYear                   :Int                    =          nCycles_400y*400             //>
                                                                 + nCenturyInCycle_100y*100             //>
                                                                 +   nBlockInCentury_4y*4               //>
                                                                 +       nYearInBlock_y;                //>
  if(   nCenturyInCycle_100y != 4   &&   nYearInBlock_y != 4   ){ nYear++; }                            //>
 return nYear;                                                                                          //>
 }//nYearOfJd/////////////////////////////////////////////////////////////////////////////////////////////>


 function             bLeap(nYear){ return nYear%4 == 0   && ( nYear%100 != 0   ||  nYear%400 == 0 );  }//> Is Gregorian year a leap year or not?


 function               anYmdOfJd(////////////////////////////////////////////////////////////////////////> Convert Julian Day to Gregorian year, month, day.
                        a_jd            :Float                                                          //> Julian Day (immediately rounded down to previous midnight).
 )                                      :Array<Int> {/////////////////////////////////////////////////////>
  var                   r_nY            :Int            = nYearOfJd(a_jd);                              //>
  var                   r_nM            :Int            = 0;                                            //>
  var                   r_nD            :Int            = 0;                                            //>
  var                   dStartOfDay_jd  :Float          = Math.floor(a_jd - 0.5) + 0.5;                 //> The midnight before the given date/time.
  var                   iDayInYear      :Int            = Math.floor(                                   //> Count of day in year so far,
                                                           dStartOfDay_jd - dJDayOfYms_jd(r_nY,1,1) + 2 //> 1 = Jan 1.
                                                          );                                            //>
  if( dJDayOfYms_jd(r_nY,3,1) <= dStartOfDay_jd ){ iDayInYear += bLeap(r_nY) ?1 :2; }                   //> If after Jan and Feb, add a day and a possible leap day.
  r_nM = Math.floor(   ( (iDayInYear-1)*12 + 373 )/367   );                                             //> Magic! (worked in Excel!)
  r_nD = Math.floor( dStartOfDay_jd - dJDayOfYms_jd(r_nY, r_nM, 1) + 0.5 ) + 1;                         //>
 return [r_nY, r_nM, r_nD];                                                                             //>
 }//anYmdOfJd/////////////////////////////////////////////////////////////////////////////////////////////>


 function               sYmd(/////////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date string.
                        a_jd            :Float                                                          //> Julian Day (immediately rounded down to previous midnight).
 )                                      :String {/////////////////////////////////////////////////////////>
  var                   an              :Array<Int>             = anYmdOfJd( a_jd );                    //>
 return an[0]   +"-"+ ( "0"+an[1] ).substr(-2)   +"-"+   ( "0"+an[2] ).substr(-2);                      //>
 }//sYmd//////////////////////////////////////////////////////////////////////////////////////////////////>


 function               sYmdHms(//////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date PLUS time string.
                        a_jd            :Float                                                          //> Julian Day (noon-night-noon)
 )                                      :String {/////////////////////////////////////////////////////////>
  var                   n_jd            :Int   = Math.floor(a_jd);                                      //> .0 = noon, subtract 0.5 to get (normal) start of day.
  var                   d               :Float = a_jd - n_jd;              d =            24*d - 12. ;  //> -12 = noon, 0 = midnight, 12 = next noon
  if( d < 0 ){ d += 24; }                                                                               //> Basically fixing modulus issue?
  var                   nH              :Int   = Math.floor( d ); d -= nH; d =            60*d       ;  //>
  var                   nM              :Int   = Math.floor( d ); d -= nM; d = Math.floor(60*d + 0.5);  //>
 return sYmd(a_jd) +" "+ ("0"+nH).substr(-2) +":"+ ("0"+nM).substr(-2) +":"+ ("0"+d).substr(-2);        //>
 }//sYmdHms///////////////////////////////////////////////////////////////////////////////////////////////>



//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               TEST_nYearOfJd(///////////////////////////////////////////////////////////////////>
 )                                      :Int {////////////////////////////////////////////////////////////>
  var                   n               :Int                    = 0;                                    //>
  var                   d               :Float                  = 0.;                                   //>
  for( y in -4172...2100 ){                                                                             //>
   d = dJDayOfYms_jd(y,1,1); n =nYearOfJd(d); if( y != n ){ trace("TEST_nYearOfJd "+n); return 1;}      //> Test that this is the inverse of a known good function.
  }//for y                                                                                              //>
 return 0;                                                                                              //>
 }//TEST_nYearOfJd////////////////////////////////////////////////////////////////////////////////////////>


 function               TEST_dDate_jd(////////////////////////////////////////////////////////////////////> Test the above function.
 )                                      :Int {////////////////////////////////////////////////////////////> Report 0 if no problems.
//. TODO - Make more sense of the following:                                                            //>
//.  var                   m               :Float                  = 0;                                 //>
//.  var                   n               :Float                  = 0;                                 //>
//.  m = dJDayOfYms_jd(-4713,11,24); trace("TEST_dDate_jd -4713 " + m );                                //> Does not match Stellarium, as Stellarium switches to the Julian calendar before 1500s.
//.  m = dJDayOfYms_jd(-4712, 1, 1); trace("TEST_dDate_jd -4712 " + m );                                //>
//.  for( y in 1600...2100 ){                                                                           //>
//.   m = dJDayOfYms_jd(y,11,24);                                                                       //>
//.   //n = dJDayOfYms_jd(y,11,24);                                                                     //>
//.   if( y == 1700 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2342300           //>
//.   if( y == 1800 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2378824           //>
//.   if( y == 1900 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2415348           //>
//.   if( y == 2000 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2451873           //>
//.   if( y <  1609 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //>                   //>
//.                          // 2305776                                                                 //>
//.                          // 2306141                                                                 //>
//.                          // 2306506                                                                 //>
//.                          // 2306871                                                                 //>
//.                          // 2307237                                                                 //>
//.                          // 2307602                                                                 //>
//.                          // 2307967                                                                 //>
//.                          // 2308332                                                                 //>
//.                          // 2308698                                                                 //>
//.   // if( m != n ){ trace( "TEST_dDate_jd "+ y +" "+ m +" "+ n ); return 1 ;} //>       0            //>
//.  }//for i                                                                                           //>
 return 0;                                                                                              //> Report no problems - looks good against Stellarium.
 }//TEST_dDate_jd/////////////////////////////////////////////////////////////////////////////////////////>


 function               TEST_anYmdOfJd(///////////////////////////////////////////////////////////////////> Test: Convert Julian Day to Gregorian year, month, day.
 ){                     //////////////////////////////////////////////////////////////////////////////////>
  trace("TEST_anYmdOfJd");                                                                              //>
  var                   s               :String                 = "";                                   //>
                 // Stellarium  Fudge factor                                                            //> Fudge factor because Stellarium switches to the Julian calendar before 1500s.
                 //    v-----v  v-----v                                                                 //>
  s = ""+ anYmdOfJd(       0          ); if( "[-4713,11,24]" != s ){ trace("TEST_anYmdOfJd 1  >"+ s +"<"); return 1 ; } //>
  s = ""+ anYmdOfJd(       0 +12*3 +2 ); if( "[-4712,1,1]"   != s ){ trace("TEST_anYmdOfJd 2  >"+ s +"<"); return 2 ; } //>
  s = ""+ anYmdOfJd(  990558 + 5*3 +2 ); if( "[-2000,1,1]"   != s ){ trace("TEST_anYmdOfJd 3  >"+ s +"<"); return 3 ; } //>
  s = ""+ anYmdOfJd( 1720693 +      2 ); if( "[-1,1,1]"      != s ){ trace("TEST_anYmdOfJd 4  >"+ s +"<"); return 4 ; } //>
  s = ""+ anYmdOfJd( 1721058 +      2 ); if( "[0,1,1]"       != s ){ trace("TEST_anYmdOfJd 5  >"+ s +"<"); return 5 ; } //>
  s = ""+ anYmdOfJd( 1721424 +      2 ); if( "[1,1,1]"       != s ){ trace("TEST_anYmdOfJd 6  >"+ s +"<"); return 6 ; } //>
  s = ""+ anYmdOfJd( 2086308 - 2*3 +1 ); if( "[1000,1,1]"    != s ){ trace("TEST_anYmdOfJd 7  >"+ s +"<"); return 7 ; } //>
  s = ""+ anYmdOfJd( 2298884 - 4*3 +2 ); if( "[1582,1,1]"    != s ){ trace("TEST_anYmdOfJd 8  >"+ s +"<"); return 8 ; } //>
  s = ""+ anYmdOfJd( 2299239          ); if( "[1583,1,1]"    != s ){ trace("TEST_anYmdOfJd 9  >"+ s +"<"); return 9 ; } //>
  s = ""+ anYmdOfJd( 2305448          ); if( "[1600,1,1]"    != s ){ trace("TEST_anYmdOfJd 10 >"+ s +"<"); return 10; } //>
  s = ""+ anYmdOfJd( 2341973          ); if( "[1700,1,1]"    != s ){ trace("TEST_anYmdOfJd 11 >"+ s +"<"); return 11; } //>
  s = ""+ anYmdOfJd( 2440588          ); if( "[1970,1,1]"    != s ){ trace("TEST_anYmdOfJd 12 >"+ s +"<"); return 12; } //>
  for( d in 0...3000000 ){                                                                              //> Test every day for a long time...
   var                  an              :Array<Int>             = anYmdOfJd(d);                         //> Convert to Gregorian Y M D
   var                  d1              :Float                  = dJDayOfYms_jd( an[0]                  //> Convert back - Gregorian Year,
                                                                  ,                an[1]                //> Month. Jan = 1, Dec = 12
                                                                  ,                an[2]                //> Day. 1st = 1
                                                                  );                                    //>
   if( 0 == d%100000 ){ trace( "Progress: "+ sYmd(d) +" "+ an ); }                                      //> Progress indication.
   if( d != d1 ){                                         trace("mismatch "+ d +" "+ d1); return d+100;}//>
  }//for d                                                                                              //>
 return 0;                                                                                              //>
 }//TEST_anYmdOfJd////////////////////////////////////////////////////////////////////////////////////////>


 function               TEST_sYmd(////////////////////////////////////////////////////////////////////////> Test: Convert Julian Day to ISO date string.
 )                                      :Int {////////////////////////////////////////////////////////////>
  var                   d               :Float                  = 0.;                                   //>
  var                   s               :String                 = "";                                   //>
  d =       0         ; s = sYmd( d ); if( "-4713-11-24" != s ){ trace( "TEST_sYmd 1 : "+ d +" >"+ s +"<" ); return 1 ;}//> November 24, 4714 BC (= -4713), in the proleptic Gregorian calendar (where 2 BC = -1)
  d =       0 +12*3 +2; s = sYmd( d ); if( "-4712-01-01" != s ){ trace( "TEST_sYmd 2 : "+ d +" >"+ s +"<" ); return 2 ;}//>
  d =  990558 + 5*3 +2; s = sYmd( d ); if( "-2000-01-01" != s ){ trace( "TEST_sYmd 3 : "+ d +" >"+ s +"<" ); return 3 ;}//>
  d = 1720693 +      2; s = sYmd( d ); if(    "-1-01-01" != s ){ trace( "TEST_sYmd 4 : "+ d +" >"+ s +"<" ); return 4 ;}//>
  d = 1721058 +      2; s = sYmd( d ); if(     "0-01-01" != s ){ trace( "TEST_sYmd 5 : "+ d +" >"+ s +"<" ); return 5 ;}//>
  d = 1721424 +      2; s = sYmd( d ); if(     "1-01-01" != s ){ trace( "TEST_sYmd 6 : "+ d +" >"+ s +"<" ); return 6 ;}//>
  d = 2086308 - 2*3 +1; s = sYmd( d ); if(  "1000-01-01" != s ){ trace( "TEST_sYmd 7 : "+ d +" >"+ s +"<" ); return 7 ;}//>
  d = 2298884 - 4*3 +2; s = sYmd( d ); if(  "1582-01-01" != s ){ trace( "TEST_sYmd 8 : "+ d +" >"+ s +"<" ); return 8 ;}//>
  d = 2299239         ; s = sYmd( d ); if(  "1583-01-01" != s ){ trace( "TEST_sYmd 9 : "+ d +" >"+ s +"<" ); return 9 ;}//>
  d = 2305448         ; s = sYmd( d ); if(  "1600-01-01" != s ){ trace( "TEST_sYmd 10: "+ d +" >"+ s +"<" ); return 10;}//>
  d = 2341973         ; s = sYmd( d ); if(  "1700-01-01" != s ){ trace( "TEST_sYmd 11: "+ d +" >"+ s +"<" ); return 11;}//>
  d = 2440588         ; s = sYmd( d ); if(  "1970-01-01" != s ){ trace( "TEST_sYmd 12: "+ d +" >"+ s +"<" ); return 12;}//>
  d = 2440588.25      ; s = sYmd( d ); if(  "1970-01-01" != s ){ trace( "TEST_sYmd 13: "+ d +" >"+ s +"<" ); return 13;}//>
  d = 2440588.5       ; s = sYmd( d ); if(  "1970-01-02" != s ){ trace( "TEST_sYmd 14: "+ d +" >"+ s +"<" ); return 14;}//>
  d = 2440588.75      ; s = sYmd( d ); if(  "1970-01-02" != s ){ trace( "TEST_sYmd 15: "+ d +" >"+ s +"<" ); return 15;}//>
  d = 2440588.751     ; s = sYmd( d ); if(  "1970-01-02" != s ){ trace( "TEST_sYmd 16: "+ d +" >"+ s +"<" ); return 16;}//>
  d = 2440588.75101   ; s = sYmd( d ); if(  "1970-01-02" != s ){ trace( "TEST_sYmd 17: "+ d +" >"+ s +"<" ); return 17;}//>
  d = 2451590         ; s = sYmd( d ); if(  "2000-02-15" != s ){ trace( "TEST_sYmd 18: "+ d +" >"+ s +"<" ); return 18;}//>
 return 0;                                                                                              //>
 }//TEST_sYmd(){}/////////////////////////////////////////////////////////////////////////////////////////>


 function               TEST_sYMDhms(/////////////////////////////////////////////////////////////////////> Test: Convert Julian Day to ISO date PLUS time string.
 )                                      :Int {////////////////////////////////////////////////////////////>
  var                   d               :Float                  = 0.;                                   //>
  var                   s               :String                 = "";                                   //>
  d =       0         ; s = sYmdHms( d ); if( "-4713-11-24 12:00:00" != s ){ trace( "TEST_sYMDhms 1 : "+ d +" >"+ s +"<" ); return 1 ;}//> November 24, 4714 BC (= -4713), in the proleptic Gregorian calendar (where 2 BC = -1)
  d =       0 +12*3 +2; s = sYmdHms( d ); if( "-4712-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 2 : "+ d +" >"+ s +"<" ); return 2 ;}//>
  d =  990558 + 5*3 +2; s = sYmdHms( d ); if( "-2000-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 3 : "+ d +" >"+ s +"<" ); return 3 ;}//>
  d = 1720693 +      2; s = sYmdHms( d ); if(    "-1-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 4 : "+ d +" >"+ s +"<" ); return 4 ;}//>
  d = 1721058 +      2; s = sYmdHms( d ); if(     "0-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 5 : "+ d +" >"+ s +"<" ); return 5 ;}//>
  d = 1721424 +      2; s = sYmdHms( d ); if(     "1-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 6 : "+ d +" >"+ s +"<" ); return 6 ;}//>
  d = 2086308 - 2*3 +1; s = sYmdHms( d ); if(  "1000-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 7 : "+ d +" >"+ s +"<" ); return 7 ;}//>
  d = 2298884 - 4*3 +2; s = sYmdHms( d ); if(  "1582-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 8 : "+ d +" >"+ s +"<" ); return 8 ;}//>
  d = 2299239         ; s = sYmdHms( d ); if(  "1583-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 9 : "+ d +" >"+ s +"<" ); return 9 ;}//>
  d = 2305448         ; s = sYmdHms( d ); if(  "1600-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 10: "+ d +" >"+ s +"<" ); return 10;}//>
  d = 2341973         ; s = sYmdHms( d ); if(  "1700-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 11: "+ d +" >"+ s +"<" ); return 11;}//>
  d = 2440588         ; s = sYmdHms( d ); if(  "1970-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 12: "+ d +" >"+ s +"<" ); return 12;}//>
  d = 2440588.25      ; s = sYmdHms( d ); if(  "1970-01-01 18:00:00" != s ){ trace( "TEST_sYMDhms 13: "+ d +" >"+ s +"<" ); return 13;}//>
  d = 2440588.5       ; s = sYmdHms( d ); if(  "1970-01-02 00:00:00" != s ){ trace( "TEST_sYMDhms 14: "+ d +" >"+ s +"<" ); return 14;}//>
  d = 2440588.75      ; s = sYmdHms( d ); if(  "1970-01-02 06:00:00" != s ){ trace( "TEST_sYMDhms 15: "+ d +" >"+ s +"<" ); return 15;}//>
  d = 2440588.751     ; s = sYmdHms( d ); if(  "1970-01-02 06:01:26" != s ){ trace( "TEST_sYMDhms 16: "+ d +" >"+ s +"<" ); return 16;}//>
  d = 2451590         ; s = sYmdHms( d ); if(  "2000-02-15 12:00:00" != s ){ trace( "TEST_sYMDhms 18: "+ d +" >"+ s +"<" ); return 18;}//>
 return 0;                                                                                              //>
 }//TEST_sYMDhms(){}//////////////////////////////////////////////////////////////////////////////////////>


 function               Go_TESTs(/////////////////////////////////////////////////////////////////////////>
 )                                      :Int {////////////////////////////////////////////////////////////>
//if( 0 < TEST_dDate_jd()      ){                                                             return 1;}//> TESTS:
//if( 0 < TEST_nYearOfJd()     ){                                                             return 2;}//>
//if( 0 < TEST_anYmdOfJd()     ){                                                             return 3;}//>
//if( 0 < TEST_sYmd()          ){                                                             return 4;}//> Test: Convert Julian Day to ISO date string.
//if( 0 < TEST_sYMDhms()       ){                                                             return 5;}//>
  if( 0 < TEST_dOverLine_360() ){                                                             return 6;}//>
 return 0;                                                                                              //>
 }//Go_TESTs//////////////////////////////////////////////////////////////////////////////////////////////>


//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               New_ReadMapasDataOfFile(//////////////////////////////////////////////////////////> Get data from one file, add to global table (map).
                        a_sFile                                                                         //> Name of file within input directory.
 )                                      :Void {///////////////////////////////////////////////////////////> Report nothing. Add to _mapasDaysData.
  if(   !sys.FileSystem.exists( _sPATHdATA + a_sFile )   ){   
   trace("No file >"+ _sPATHdATA + a_sFile +"<");
 return;
  }//if
  var                   sData           :String         = sys.io.File.getContent(_sPATHdATA + a_sFile); //> Get contents of input data file.
  var                   asLines         :Array<String>  = sData.split('\n');                            //> Split file into rows (one per date).
  var                   n               :Int            = asLines.length;                               //> Get number of rows.
  var                   r_s             :String         = "";                                           //> Output text string.
  var                   asCell          :Array<String>  = [];                                           //> List of text cell contents.
  var                   sKeyJDay        :String         = "";                                           //>
  var                   asRow           :Array<String>  = [];                                           //>
  for( i in 2...n ){                                                                                    //> Move to RAM: Skip first 2 lines, and then process each file line...
   asCell   = asLines[i].split(",");                                                                    //> Split line on commas.
   sKeyJDay =   asCell[ 1] +"jd";                                                                       //> List key is the Julian Day.
   asRow    = [ asCell[ 0]       //  0        sDate             // _iDAYSdATA_sDate         =  0;      1399-12-31T12:00:00   //> sDate         ,1999-12-31T12:00:00  First cell is nYear as text in ISO format yyyy-mm-dd.
              , asCell[ 1]       //  1     ,a_nDay_jd           // _iDAYSdATA_nDay_jd       =  1;   ,2232407                 //> a_nDay_jd     ,2451544              Numeric version of key.
              , asCell[ 2]       //  2     ,  dSunSet_h         // _iDAYSdATA_dSunSet_h     =  2;     ,16.210833333333333    //> dSunSet_h     ,16.026944444444442
              , asCell[ 3]       //  3     ,  dSunRise_h        // _iDAYSdATA_dSunRise_h    =  3;     ,32.00333333333333     //> dSunRise_h    ,32.06888888888889
              , asCell[ 4]       //  4     ,r_dMoonRise_h       // _iDAYSdATA_dMoonRise_h   =  4;   ,9.402222222222223       //> r_dMoonRise_h ,26.668333333333333
              , asCell[ 5]       //  5     ,  dMoonSet_h        // _iDAYSdATA_dMoonSet_h    =  5;     ,20.462777777777777    //> dMoonSet_h    ,37.220555555555556
              , asCell[ 6]       //  6     ,  Moon_sDate        // _iDAYSdATA_Moon_sDate    =  6;     ,1399-12-31T20:27:46   //> Moon_sDate    ,2000-01-01T13:13:14
              , asCell[ 7]       //  7     ,  dLit_100          // _iDAYSdATA_Moon_dLit =  7;     ,13.873039245605469    //> dLit_100      ,22.799720764160156
              , asCell[ 8]       //  8     ,  dRa               // _iDAYSdATA_Moon_dRa      =  8;     ,-19.4712266310741     //> dRa           ,-137.51418852173234
              , asCell[ 9]       //  9     ,  dDec              // _iDAYSdATA_Moon_dDec     =  9;     ,-4.219550841570022    //> dDec          ,-11.811177408287486
              , asCell[10]       //  10    ,  MidN_sDate        // _iDAYSdATA_MidN_sDate    = 10;     ,1400-01-01T00:00:00   //> MidN_sDate    ,2000-01-01T00:00:00
              , asCell[11]       //  11    ,  dLit_100          // _iDAYSdATA_MidN_dLit = 11;     ,14.93198299407959     //> dLit_100      ,26.628517150878906
              , asCell[12]       //  12    ,  dRa               // _iDAYSdATA_MidN_dRa      = 12;     ,-17.693637879029943   //> dRa           ,-142.82009664343948
              , asCell[13]       //  13    ,  dDec              // _iDAYSdATA_MidN_dDec     = 13;     ,-3.578822285176965    //> dDec          ,-9.647356542776926
              , asCell[14]       //  14    ,  Vega_sDate        // _iDAYSdATA_Vega_sDate    = 14;     ,1399-12-31T23:03:40   //> Vega_sDate    ,1999-12-31T23:59:50
              , asCell[15]       //  15    ,  dLit_100          // _iDAYSdATA_Vega_dLit = 15;     ,14.62572956085205     //> dLit_100      ,26.629600524902344
              , asCell[16]       //  16    ,  dRa               // _iDAYSdATA_Vega_dRa      = 16;     ,-18.20596665525843    //> dRa           ,-142.82155355617718
              , asCell[17]       //  17    ,  dDec              // _iDAYSdATA_Vega_dDec     = 17;     ,-3.7472010079806166   //> dDec          ,-9.646872946743024
                                 //  18    ,  age                                                     ,3.73                                    
                                 //  19    ,  distance-km                                             ,408161.29651962605                      
                                 //  20    ,  size-dd                                                 ,0.4877732710136179                      
                                 //  21    ,  ecliptic-obliquity                                      ,23.51721493600158                       
                                 //  22    ,  elat                                                    ,3.693187727162013                       
                                 //  23    ,  elong                                                   ,333.41763178710016                      
                                 //  24    ,  glat                                                    ,-52.23369523560149                      
                                 //  25    ,  glong                                                   ,65.71202390759264                       
                                 //  26    ,  phase-angle-deg                                         ,135.0307°                               
                                 //  27    ,  hourAngle-dd                                            ,118.22678759555845                      
                                 //  28    ,  parallacticAngle                                        ,36.8034293236707                        
                                 //  29    ,  sglat                                                   ,29.391412707762264                      
                                 //  30    ,  sglong                                                  ,282.77951939034534                      
                                 //  31    ,  size-deg                                                ,0.48777°                                
                                 //  32    ,  transit-dhr                                             ,14.859444444444444                      
                                 //  33    ,  albedo                                                  ,0.11999999731779099                     
                                 //  34    ,  ecl-elongation-deg                                      ,44.7428°                                
                                 //  35    ,  elongation-deg                                          ,44.8570°                                
                                 //  36    ,  subsolar_l                                              ,226.64938088549144                      
                                 //  37    ,  subsolar_b                                              ,1.5298619259101536                      
                                 //  38    ,  heliocentric-distance                                   ,0.9818250348776882                      
                                 //  39    ,  libration_l                                             ,-1.0173694823111317                     
                                 //  40    ,  libration_b                                             ,-5.424631020251859                      
                                 //  41    ,  pa_axis                                                 ,337.50836228320014                      
                                 //  42    ,  penumbral-eclipse-magnitude                             ,0                                       
                                 //  43    ,  umbral-eclipse-magnitude                                ,0                                       
                                 //  44    ,  heliocentric-velocity                                   ,[-0.0154388, -0.00734661, -3.90024e-05] 
                                 //  45    ,  velocity                                                ,[0.000170595, 0.000531719, -2.6824e-05] 
                                 //  46    ,  velocity-kms                                            ,0.96799                                 
              ];                                                                                        //>
   _mapasDaysData[ sKeyJDay ] = asRow;                                                                  //> Keep row of data in RAM table, keyed with ISO format date.
  }//for i                                                                                              //>
 }//New_ReadMapasDataOfFile///////////////////////////////////////////////////////////////////////////////>


 function               New_ReadData(/////////////////////////////////////////////////////////////////////>
 )                                      :Void {///////////////////////////////////////////////////////////>
//for( y in 1000...1100 ){   New_ReadMapasDataOfFile( '1000_1099/table012_'+ y +'.csv' );   }            //> For a century... Get data from each file, put in global table.
//for( y in 1100...1200 ){   New_ReadMapasDataOfFile( '1100_1199/table012_'+ y +'.csv' );   }            //> "
//for( y in 1200...1300 ){   New_ReadMapasDataOfFile( '1200_1299/table012_'+ y +'.csv' );   }            //> "
//for( y in 1300...1379 ){   New_ReadMapasDataOfFile( '1300_1399/table012_'+ y +'.csv' );   }            //> "
//for( y in 1379...1400 ){   New_ReadMapasDataOfFile( '1300_1399/table013_'+ y +'.csv' );   }            //> " Format change?
  for( y in 1400...1500 ){   New_ReadMapasDataOfFile( '1400/table017_'+ y +'.csv' );   }                //>
  for( y in 1500...1558 ){   New_ReadMapasDataOfFile( '1500/table017_'+ y +'.csv' );   }                //>
//for( y in 1800...1900 ){   New_ReadMapasDataOfFile(      '1800/table015_'+ y +'.csv' );   }            //>
//for( y in 1900...2000 ){   New_ReadMapasDataOfFile(      '1900/table015_'+ y +'.csv' );   }            //>
//for( y in 2000...2100 ){   New_ReadMapasDataOfFile(      '2000/table015_'+ y +'.csv' );   }            //>
 }//New_ReadData///////////////////////////////////////////////////////////////////////////////////////////>


 function               avWinterLooks_Row_Over_Full(//////////////////////////////////////////////////////> Run the "Hey Diddle Diddle" observational procedure from one date.
                        r_jd            :Int                                                            //> Julian Day to start on (start waiting for the new moon)
 ,                      a_nNights       :Int                                                            //> 7 or 8 count from last gibbous to full.
 ,                      a_sWhenLook     :String                                                         //> "Moon", "MidN", or "Vega".
 ,                      a_sWhereLook    :String                                                         //> Boundary line: "Cani", "Long" or "Lon2"
 )                                      :Array<Dynamic> {/////////////////////////////////////////////////> Report text row, Over-line amount, Julian day of big night, number of days till next run of procedure.
  var                   asDaysData      :Array<String>          = _mapasDaysData[ r_jd +"jd" ];         //>
  if( null == asDaysData ){            trace( "??? "+ "*0 no data >"+ (r_jd +"jd") +"< "+ sYmd(r_jd) ); //>
                                              return ["*0 no data >"+ (r_jd +"jd") +"< "+ sYmd(r_jd) ];}//> Look up data for the given day. If there is a problem, like date isn't in table, then quit.
                                                                                                        //> trace("avWinterLooks_Row_Over_Full "+ a_sGo +" "+ r_jd +" "+ asDaysData);//>
  var                   whenGo_jd       :Int                    = r_jd;                                 //> Keep a copy of start day.
  var                   isStep          :Int                    = 0;                                    //> Step in Hey Diddle algorithm.
  var                   r_s             :String                 = "";                                   //> Output text, start from scratch.
  for( iNotUsed_Limit in 0...99 ){                                                                      //> Loop we promise to break out of, with a limit just in case.
   asDaysData    = _mapasDaysData[ r_jd +"jd" ];                                                        //> Look up data for the given date.
   if( null == asDaysData ){               trace("???"); return ["*1 no data "+ r_jd +" "+ sYmd(r_jd)];}//>
                                                                                                        //>  trace( asDaysData );
   if(       0 == isStep ){   isStep = 1;                                                               //> The very first time only...
    r_s    =                r_jd                                                                        //> ###0
            +","+             asDaysData[_iDAYSdATA_sDate    ].substr(0,10)                             //> +" = "+ sYmdHms( r_jd ) DEBUG    //> Report date and ###1  //> date/time of the moon set. ###2
            ;                                                                                           //>
   }//if                                                                                                //>
   if(       1 == isStep ){                                                                             //> If in first stage of algorithm...
    if(       Std.parseFloat( asDaysData[_iDAYSdATA_Moon_dLit] ) < 2   ){                               //> Look for new moon, if seeing it, go to next stage.
     isStep = 2;                                                                                        //>
    }//if                                                                                               //>
   }else{//  2 == isStep                                                                                //> In 2nd stage of algorithm, look
    if( 50 <= Std.parseFloat( asDaysData[_iDAYSdATA_Moon_dLit] )       ){                               //> for first gibbous illumination (50%+), when
     r_s += ","+ asDaysData[_iDAYSdATA_Moon_sDate];                                                     //> ###3   First gibbous
  break;//for                                                                                           //> get out of this loop
   }}//if//if                                                                                           //> .
   r_jd++;                                                                                              //> If staying in loop, then skip ahead.
  }//for                                                                                                //> .
                                                                                                        //>
  r_jd += a_nNights - 1;                                                                                //> we skip ahead to the big night.
  asDaysData    = _mapasDaysData[ r_jd +"jd" ];                                                         //> Look up data for the given date.
  if( null == asDaysData ){                         trace("???");         return ["*2 no data "+ r_jd];}//>
                                                                                                        //>
  var                                   iDate                   = 0;                                    //> Indexes
  var                                   iDec                    = 0;                                    //> to use depending on
  var                                   iRa                     = 0;                                    //> the scheme we are testing.
  var                                   iLit                    = 0;                                    //>
  switch( a_sWhenLook ){                                                                                //> Depending on the scheme we are testing....
  case "Moon": iDate = _iDAYSdATA_Moon_sDate;  iLit = _iDAYSdATA_Moon_dLit; iDec = _iDAYSdATA_Moon_dDec; iRa = _iDAYSdATA_Moon_dRa; //> Moonset
  case "MidN": iDate = _iDAYSdATA_MidN_sDate;  iLit = _iDAYSdATA_MidN_dLit; iDec = _iDAYSdATA_MidN_dDec; iRa = _iDAYSdATA_MidN_dRa; //> Modern midnight
  case "Vega": iDate = _iDAYSdATA_Vega_sDate;  iLit = _iDAYSdATA_Vega_dLit; iDec = _iDAYSdATA_Vega_dDec; iRa = _iDAYSdATA_Vega_dRa; //> Vega kissing the horizon
  }//switch                                                                                             //> ...
  r_s += " "                                                                                            //>
       + ","+ a_sWhenLook                                                                               //> ###4   "Moon", "MidN", or "Vega".
       + ","+  asDaysData[iDate]                                                                        //> ###5   Date/time of "Moon", "MidN", or "Vega".
       +" ,"+ (asDaysData[iDec ]+"       ").substr(0,6)                                                 //> ###7
       + ","+ (asDaysData[ iRa ]+"       ").substr(0,7)                                                 //> ###8
       ;                                                                                                //>
  var                   d_360           :Float                  = 0;                                    //> See if full moon has crossed from Taurus to Gemini.
  switch( a_sWhereLook ){                                                                               //> Boundary line: "Cani", "Long" or "Lon2"
  case "Cani": d_360 = dOverLine_360( Std.parseFloat( asDaysData[iDec] )                                //> See if full moon has crossed "little dog" line or not
                       ,              Std.parseFloat( asDaysData[iRa ] )                                //> "
                       );                                                                               //> .
  case "Long": d_360 =  90 - Std.parseFloat( asDaysData[iRa ] ); if( 180 < d_360 ){ d_360 -= 360; }     //> See if full moon has crossed 90 degree right ascension.
  case "Lon2": d_360 = 120 - Std.parseFloat( asDaysData[iRa ] ); if( 180 < d_360 ){ d_360 -= 360; }     //> See if full moon has crossed 120 degree right ascension.
  }//switch                                                                                             //>
  r_s +=" ,"+ (d_360+"     ").substr(0,6);                                                              //> ###9   Amount over the Canis Minor line.
return [r_s ,d_360 ,r_jd];                                                                              //>
 }//avWinterLooks_Row_Over_Full///////////////////////////////////////////////////////////////////////////>


 function               New_MultiYearRun(/////////////////////////////////////////////////////////////////>
                        a_jd            :Int             //= Math.floor( dJDayOfYms_jd( 1000,12,31 ) ); //> Convert Gregorian date to a Julian Day, the number of days that have passed since the Julian Date Epoch.  Gregorian Year,
 ,                      a_nNights       :Int                                                            //> Parameters to test in this pass - the count from first quarter moon to full.
 ,                      a_sWhenGibbous  :String                                                         //> When during night to apply the crescent/gibbous test.
 ,                      a_sWhereLook    :String                                                         //> How to draw the line between Taurus and Gemini.
 ,                      a_nMinJump_yr   :Int                                                            //> Minimum number of normal years between leap years.
 ,                      a_nMaxJump_yr   :Int                                                            //> Miximum number of normal years between leap years.
 ,                      a_nRun_yr       :Int                                                            //> Length of the trial run.
 )                                      :Void {///////////////////////////////////////////////////////////>
  var                   r_s             :String                 = "";                                   //> Initialize the output text string.
  var                   av              :Array<Dynamic>         = [];                                   //>
  var                   dS0             :Float                  = 0;                                    //> STATS:
  var                   dS1             :Float                  = 0;                                    //>
  var                   dS2             :Float                  = 0;                                    //>
  var                   dMin            :Float                  =  999999.;                             //>
  var                   dMax            :Float                  = -999999.;                             //>
  var                   sPattern        :String                 = "";                                   //> Generate the pattern of leap/non-leap years.
  var                   nSinceLeap_yr   :Int                    = 1;                                    //>
  var                   sLeap           :String                 = "";                                   //>
  var                   dMoons_days     :Float                  = 0;                                    //> For modern math-based lunar leap month determination.
  var                   sRow            :String                 = "";                                   //> Report for one year trial.
  var                   dOver           :Float                  = 0.;                                   //> Over-line amount (between Gemini and Taurus)
  var                   nBigNight_jd    :Int                    = 0;                                    //> Julian day of big night - offset from some date-of-the-Gregorian-year to prevent discontinuity of new year.
  var                   nAt_jd          :Int                    = a_jd;                                 //>
  var                   nWas_jd         :Int                    = 0;                                    //>
  for( dYearRun in 0...a_nRun_yr ){                                                                     //> Run observations for 100 years in a row  (hoping they converge on a winter date)...
   if( 0 == a_nNights ){                                                                                //> If the math-based procedure is being tried, then...
    dMoons_days += 12*_dMONTH_days - _dYEAR_days;                                                       //>
    if( dMoons_days < 0 ){ dOver =  1; dMoons_days += _dMONTH_days; }                                   //>
    else                 { dOver = -1;                              }                                   //>
    nBigNight_jd  =  0;                                                                                 //> From Nov 24?
   }else{                                                                                               //> But if not math-based, then for any observational procedure...
                    av  = avWinterLooks_Row_Over_Full(nAt_jd ,a_nNights ,a_sWhenGibbous ,a_sWhereLook); //> Run the "Hey Diddle Diddle algorithm" from one starting date. Add a row to the results.  The next date to start observations is given in the last cell of the row.
    sRow          = av[0];   if( "*" == sRow.substr(0,1) ){ trace("what??????? "+ nAt_jd +" "+ sRow); } //> Reported text row. ###0..9
    dOver         = av[1];                                                                              //> Over-the-finish-line amount, +ve = no leap year, -ve = leap year needed.
    nBigNight_jd  = av[2];                                                                              //> Julian day of big night.
   }//if a_nNights                                                                                      //>
   nAt_jd         = nBigNight_jd + 354 - 17;                                                            //> Next day to check is a sufficient runup before 12 lunar months .
   if( dOver < 0 ){                                                                                     //> If a leap year is suggested by observation...
                  if( nSinceLeap_yr < a_nMinJump_yr ){ nSinceLeap_yr++  ; sLeap= "- "+ nSinceLeap_yr; } //> If we haven't held steady the minimum number, then hold steady now.
                  else                               { nSinceLeap_yr = 0; sLeap= "-T ";  nAt_jd +=29; } //> Otherwise, follow suggestion of a leap year, and restart count between leap years.
   }else{                                                                                               //> If leap year is not suggested...
                  if( nSinceLeap_yr < a_nMaxJump_yr ){ nSinceLeap_yr++  ; sLeap= "+ "+ nSinceLeap_yr; } //> If less than maximum allowed, follow suggestion of no leap year.
                  else                               { nSinceLeap_yr = 0; sLeap= "+x ";  nAt_jd +=29; } //> But if at maximum number of holding steady, use a leap year anyway.
                                                                                                        //>
   }//if                                                                                                //>
   var                  d               :Float                  = 0.;                                   //> Short-term utility.
   if( 0 == a_nNights ){                                                                                //> If the math-based procedure is being tried, then
    d = dMoons_days + 113;                                                                              //> Get fractional part of year, in days. Add an offest to adjust average date to winter solstice.
   }else{                                                                                               //>
    d = (nBigNight_jd + 100)/_dYEAR_days;   d = d - Math.floor(d);   d *= _dYEAR_days;                  //> Get fractional part of year, in days. Add an offest to avoid discontinuity at Nov 24.
   }//if                                                                                                //>
   if( 38 == dYearRun ){ r_s += "\n"; }                                                                 //>
   if( 38 <= dYearRun ){                                                                                //>
    dS0 += 1;   dS1 += d;   dS2 += d*d;                                                                 //> Stats
    if(    d < dMin ){ dMin = d; }                                                                      //>
    if( dMax < d    ){ dMax = d; }                                                                      //>
   }//if                                                                                                //>
   sPattern      += sLeap.substr(1,1);                                                                  //>
   r_s           += "\n"+ (   0.==nWas_jd   ?"   "   :( ""+(nBigNight_jd - nWas_jd) )   )               //>
                   +" ,"+ sRow.substr(0,150) +","+ sLeap +" ,"+ (d+"      ").substr(0,6);               //> ###10 big nights distance from some solar date - for statistical analysis of variance of big night date.
   nWas_jd = nBigNight_jd;                                                                              //> Remember for next time around.
  }//for dYearRun                                                                                       //>
  //                               ###3   First gibbous      ###5 Date/time of observation                    ###10 big nights distance from some solar date - for statistical analysis of variance of big night date.
  //                                                    ###4="Moon", "MidN", or "Vega".                              //>
  //            ###0   ,###1      ,###3                ,###4,###5                ,###7  ,###8    ,###9       ,###10  //> ,###6   
  r_s = "\nLen ,JDay   ,LastMonth ,GibbousMoonsetLMST  ,What,WhenBigNight        ,Declin,RtAscen ,OverL ,L   ,stats" //> ,illumin
       + r_s;                                                                                           //>
  trace(""                                                                                              //>
  +"\n\n\nRun for: "+ a_nNights +" when:"+ a_sWhenGibbous +" look:"+ a_sWhereLook                       //>
                                  +" min:"+ a_nMinJump_yr +" max:"+ a_nMaxJump_yr +" years:"+ a_nRun_yr //> Show pattern in a 19-year grid:
  +(   !_bYEARLY  ?"" :r_s    )                                                                         //>
  +(   !_bPATTERN ?"" :( "\n |"+ sPattern.substr(    0 ,19) +"|"                                        //>
                        +"\n |"+ sPattern.substr(   19 ,19) +"|"                                        //>
                        +"\n |"+ sPattern.substr(2 *19 ,19) +"|"                                        //>
                        +"\n |"+ sPattern.substr(3 *19 ,19) +"|"                                        //>
                        +"\n |"+ sPattern.substr(4 *19 ,19) +"|"                                        //>
                        +"\n |"+ sPattern.substr(5 *19 ,19) +"|"                                        //>
                        +"\n |"+ sPattern.substr(6 *19 ,19) +"|"                                        //>
                       )                                                                                //>
   )                                                                                                    //>
  +(   !_bSTATS   ?"" :( "\nRange: "  + ( (dMax - dMin)+"               " ).substr(0,16)                //> Max range.
                        +"\nCount: "  + dS0                                                             //>
                        +"\nAverage: "+ sYmdHms(dS1/dS0 - 100).substr(6)                                //> Average date is corrected for the offset added earlier.
                        +"\nStdDev: "+ (                                                                //>
                                          Math.sqrt(   (dS0*dS2 - dS1*dS1)                              //>
                                                       /( dS0*(dS0 - 1) )                               //>
                                          )            +"               "                               //>
                                       ).substr(0,16)                                                   //>
                        +"\n\n"                                                                         //>
                       )                                                                                //>
   )                                                                                                    //>
  );                                                                                                    //>
 }//New_MultiYearRun//////////////////////////////////////////////////////////////////////////////////////>


 function               new(//////////////////////////////////////////////////////////////////////////////> Construct a new object of this class (and run appropriate processing).
 )                                      :Void {///////////////////////////////////////////////////////////>
  if( 0 != Go_TESTs() ){                                                                        return;}//>
                                                                                                        //> Main execution starts here.
  New_ReadData();                                                                                       //> READING DATA:
                                                                                                        //> RUNNING TRIALS:
  New_MultiYearRun( Math.floor( dJDayOfYms_jd(1400,12,1) )  ,7 ,"Vega" ,"Cani" ,1 ,2 ,150 );            //>
  New_MultiYearRun( Math.floor( dJDayOfYms_jd(1400,12,1) )  ,8 ,"Vega" ,"Cani" ,1 ,2 ,150 );            //>
  trace("Done");                                                                                        //>
 }//new///////////////////////////////////////////////////////////////////////////////////////////////////>


 static public function main(/////////////////////////////////////////////////////////////////////////////> Execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
  #if sys                                                                                               //> Just check.
   trace("OK. file system can be accessed");                                                            //>
  #end                                                                                                  //>
  new TryMultiYearRuns();                                                                               //> Create and run and instance of this class.
 }//main//////////////////////////////////////////////////////////////////////////////////////////////////>

}//class TryMultiYearRuns/////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


// End of file.
