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

  var                   _mapasDaysData                        = new Map<String,Array<String>>();      //> Table of data for moon for each day (night), read from files.
  var                       _iDATAfORdAY_sDate                  =  0;                                   //> sDate         ,1999-12-31T12:00:00  First cell is nYear as text in ISO format yyyy-mm-dd. 
  var                       _iDATAfORdAY_nDay_jd                =  1;                                   //> a_nDay_jd     ,2451544              Numeric version of key.
  var                       _iDATAfORdAY_dSunSet_h              =  2;                                   //> dSunSet_h     ,16.026944444444442 
  var                       _iDATAfORdAY_dSunRise_h             =  3;                                   //> dSunRise_h    ,32.06888888888889 
  var                       _iDATAfORdAY_dMoonRise_h            =  4;                                   //> r_dMoonRise_h ,26.668333333333333 
  var                       _iDATAfORdAY_dMoonSet_h             =  5;                                   //> dMoonSet_h    ,37.220555555555556 
  var                       _iDATAfORdAY_Moon_sDate             =  6;                                   //> Moon_sDate    ,2000-01-01T13:13:14 
  var                       _iDATAfORdAY_Moon_dLit_100          =  7;                                   //> dLit_100      ,22.799720764160156 
  var                       _iDATAfORdAY_Moon_dRa               =  8;                                   //> dRa           ,-137.51418852173234 
  var                       _iDATAfORdAY_Moon_dDec              =  9;                                   //> dDec          ,-11.811177408287486 
  var                       _iDATAfORdAY_MidN_sDate             = 10;                                   //> MidN_sDate    ,2000-01-01T00:00:00 
  var                       _iDATAfORdAY_MidN_dLit_100          = 11;                                   //> dLit_100      ,26.628517150878906 
  var                       _iDATAfORdAY_MidN_dRa               = 12;                                   //> dRa           ,-142.82009664343948 
  var                       _iDATAfORdAY_MidN_dDec              = 13;                                   //> dDec          ,-9.647356542776926 
  var                       _iDATAfORdAY_Vega_sDate             = 14;                                   //> Vega_sDate    ,1999-12-31T23:59:50 
  var                       _iDATAfORdAY_Vega_dLit_100          = 15;                                   //> dLit_100      ,26.629600524902344 
  var                       _iDATAfORdAY_Vega_dRa               = 16;                                   //> dRa           ,-142.82155355617718 
  var                       _iDATAfORdAY_Vega_dDec              = 17;                                   //> dDec          ,-9.646872946743024 

  var                   _dGREGORIANePOCH                        = 1721425.5;                            //> ??? https://dzucconi.github.io/calendrical/docs/calendrical.calendar.constants.html


 function                nMod(////////////////////////////////////////////////////////////////////////////> Fix the modulus function (% is the remainder function in this language?)
                         a              :Float                                                          //> Integer, a float that will be rounded down.
 ,                       m              :Int                                                            //> The integer modulus.
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


 function               dJDayFromYms_jd(//////////////////////////////////////////////////////////////////> Alternate implementation to convert Gregorian to JDay.   https://dzucconi.github.io/calendrical/docs/calendrical.calendar.conversions.html
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
 }//dJDayFromYms_jd///////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_dDate_jd(////////////////////////////////////////////////////////////////////> Test the above function.
 )                                      :Int {////////////////////////////////////////////////////////////> Report 0 if no problems.
//. TODO - Make more sense of the following:
//.  var                   m               :Float                  = 0;                                 //>
//.  var                   n               :Float                  = 0;                                 //>
//.  m = dJDayFromYms_jd(-4713,11,24); trace("TEST_dDate_jd -4713 " + m );                              //> Does not match Stellarium, as Stellarium switches to the Julian calendar before 1500s.
//.  m = dJDayFromYms_jd(-4712, 1, 1); trace("TEST_dDate_jd -4712 " + m );                              //>
//.  for( y in 1600...2100 ){                                                                           //>
//.   m = dJDayFromYms_jd(y,11,24);                                                                     //>
//.   //n = dJDayFromYms_jd(y,11,24);                                                                   //>
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


//////////////////////////////////////////////////////////////////////////////////////////////////////////>
// JDAY -> GREGORIAN                                                                                    //>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               nYearFromJd(//////////////////////////////////////////////////////////////////////> Convert Julian Day to Year.
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
 }//nYearFromJd///////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_nYearFromJd(/////////////////////////////////////////////////////////////////>
 )                                      :Int {////////////////////////////////////////////////////////////>
  var                   n               :Int                    = 0;                                    //>
  var                   d               :Float                  = 0.;                                   //>
  for( y in -4172...2100 ){                                                                             //>
   d = dJDayFromYms_jd(y,1,1); n =nYearFromJd(d); if( y != n ){ trace("TEST_nYearFromJd "+n); return 1;}//> Test that this is the inverse of a known good function.
  }//for y                                                                                              //>
 return 0;                                                                                              //>
 }//nYearFromJd///////////////////////////////////////////////////////////////////////////////////////////>
 

 function bLeap(nYear){ return nYear%4 == 0   && ( nYear%100 != 0   ||  nYear%400 == 0 );  }            //>


 function               anYmdFromJd(//////////////////////////////////////////////////////////////////////> Convert Julian Day to Gregorian year, month, day.
                        a_jd            :Float                                                          //> Julian Day, immediately rounded down to last midnight.
 )                                      :Array<Int> {/////////////////////////////////////////////////////>
  var                   r_nY            :Int          = nYearFromJd(a_jd);                              //>
  var                   r_nM            :Int          = 0;                                              //>
  var                   r_nD            :Int          = 0;                                              //>
  var                   dStartOfDay_jd  :Float        = Math.floor(a_jd - 0.5) + 0.5;                   //> The midnight before the given date/time.
  var                   iDayInYear      :Int          = Math.floor(                                     //> Count of day in year so far, 
                                                         dStartOfDay_jd - dJDayFromYms_jd(r_nY,1,1) + 2 //> 1 = Jan 1.
                                                        );                                              //>
  if( dJDayFromYms_jd(r_nY,3,1) <= dStartOfDay_jd ){ iDayInYear += bLeap(r_nY) ?1 :2; }                 //> If after Jan and Feb, add a day and a possible leap day.
  r_nM = Math.floor(   ( (iDayInYear-1)*12 + 373 )/367   );                                             //> Magic! (worked in Excel!)
  r_nD = Math.floor( dStartOfDay_jd - dJDayFromYms_jd(r_nY, r_nM, 1) + 0.5 ) + 1;                       //>
 return [r_nY, r_nM, r_nD];                                                                             //>
 }//anYmdFromJd///////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_anYmdFromJd(/////////////////////////////////////////////////////////////////>
 ){                     //////////////////////////////////////////////////////////////////////////////////>
  trace("TEST_anYmdFromJd");                                                                            //>
  var                   s               :String                 = "";                                   //>
                 // Stellarium  Fudge factor                                                            //> Fudge factor because Stellarium switches to the Julian calendar before 1500s.
                 //    v-----v  v-----v                                                                 //>
  s = ""+ anYmdFromJd(       0          ); if( "[-4713,11,24]" != s ){ trace("TEST_anYmdFromJd 1  >"+ s +"<"); return 1 ; } //>
  s = ""+ anYmdFromJd(       0 +12*3 +2 ); if( "[-4712,1,1]"   != s ){ trace("TEST_anYmdFromJd 2  >"+ s +"<"); return 2 ; } //>
  s = ""+ anYmdFromJd(  990558 + 5*3 +2 ); if( "[-2000,1,1]"   != s ){ trace("TEST_anYmdFromJd 3  >"+ s +"<"); return 3 ; } //>
  s = ""+ anYmdFromJd( 1720693 +      2 ); if( "[-1,1,1]"      != s ){ trace("TEST_anYmdFromJd 4  >"+ s +"<"); return 4 ; } //>
  s = ""+ anYmdFromJd( 1721058 +      2 ); if( "[0,1,1]"       != s ){ trace("TEST_anYmdFromJd 5  >"+ s +"<"); return 5 ; } //>
  s = ""+ anYmdFromJd( 1721424 +      2 ); if( "[1,1,1]"       != s ){ trace("TEST_anYmdFromJd 6  >"+ s +"<"); return 6 ; } //>
  s = ""+ anYmdFromJd( 2086308 - 2*3 +1 ); if( "[1000,1,1]"    != s ){ trace("TEST_anYmdFromJd 7  >"+ s +"<"); return 7 ; } //>
  s = ""+ anYmdFromJd( 2298884 - 4*3 +2 ); if( "[1582,1,1]"    != s ){ trace("TEST_anYmdFromJd 8  >"+ s +"<"); return 8 ; } //>
  s = ""+ anYmdFromJd( 2299239          ); if( "[1583,1,1]"    != s ){ trace("TEST_anYmdFromJd 9  >"+ s +"<"); return 9 ; } //>
  s = ""+ anYmdFromJd( 2305448          ); if( "[1600,1,1]"    != s ){ trace("TEST_anYmdFromJd 10 >"+ s +"<"); return 10; } //>
  s = ""+ anYmdFromJd( 2341973          ); if( "[1700,1,1]"    != s ){ trace("TEST_anYmdFromJd 11 >"+ s +"<"); return 11; } //>
  s = ""+ anYmdFromJd( 2440588          ); if( "[1970,1,1]"    != s ){ trace("TEST_anYmdFromJd 12 >"+ s +"<"); return 12; } //>
  for( d in 0...3000000 ){                                                                              //> Test every day for a long time...
   var                  an              :Array<Int>             = anYmdFromJd(d);                       //> Convert to Gregorian Y M D
   var                  d1              :Float                  = dJDayFromYms_jd( an[0]                //> Convert back - Gregorian Year,
                                                                  ,         an[1]                       //> Month. Jan = 1, Dec = 12
                                                                  ,         an[2]                       //> Day. 1st = 1
                                                                  );                                    //>
   if( 0 == d%50000 ){ trace( sYmd(d) +" "+ an ); }                                                     //> Progress indication.
   if( d != d1 ){                                         trace("mismatch "+ d +" "+ d1); return d+100;}//>
  }//for d                                                                                              //>
 return 0;                                                                                              //>
 }//TEST_anYmdFromJd//////////////////////////////////////////////////////////////////////////////////////>


 function               sYmd(/////////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date string.
                        a_jd            :Int                                                            //> Given a Julian Day number.
 ){                                     //////////////////////////////////////////////////////////////////>
  var                   an              :Array<Int>             = anYmdFromJd( a_jd );                  //>
 return an[0]   +"-"+ ( "0"+an[1] ).substr(-2)   +"-"+   ( "0"+an[2] ).substr(-2);                      //>
 }//sYmd//////////////////////////////////////////////////////////////////////////////////////////////////>


 function               sYmdHms(//////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date PLUS time string.
                        a_jd       :Float                                                               //>
 )                                 :String {//////////////////////////////////////////////////////////////>
  var                   n_jd       :Int   = Math.floor( a_jd - 0.5);                                    //> .0 = noon, -0.5 = start of (normal Gregorian) day.
  var                   d          :Float =                    a_jd - n_jd; d =            24*d   - 12; //>
  var                   nH         :Int   = Math.floor( d ); d =  d - nH  ; d =            60*d       ; //>
  var                   nM         :Int   = Math.floor( d ); d =  d - nM  ; d = Math.floor(60*d + 0.5); //>
 return sYmd(n_jd) +" "+ ("0"+nH).substr(-2) +":"+ ("0"+nM).substr(-2) +":"+ ("0"+d).substr(-2);        //>
 }//sYmdHms///////////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_sYMDhms(/////////////////////////////////////////////////////////////////////>
 )                                      :Int {////////////////////////////////////////////////////////////>
  var                   d               :Float                  = 0.;                                   //>
  var                   s               :String                 = "";                                   //>
  d =       0         ; s = sYmdHms( d ); if( "-4713-11-24 12:00:00" != s ){ trace( "TEST_sYMDhms 0 : "+ d +" >"+ s +"<" ); return 0 ;}//>
  d =       0 +12*3 +2; s = sYmdHms( d ); if( "-4712-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 1 : "+ d +" >"+ s +"<" ); return 1 ;}//>
  d =  990558 + 5*3 +2; s = sYmdHms( d ); if( "-2000-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 2 : "+ d +" >"+ s +"<" ); return 2 ;}//>
  d = 1720693 +      2; s = sYmdHms( d ); if(    "-1-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 3 : "+ d +" >"+ s +"<" ); return 3 ;}//>
  d = 1721058 +      2; s = sYmdHms( d ); if(     "0-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 4 : "+ d +" >"+ s +"<" ); return 4 ;}//>
  d = 1721424 +      2; s = sYmdHms( d ); if(     "1-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 5 : "+ d +" >"+ s +"<" ); return 5 ;}//>
  d = 2086308 - 2*3 +1; s = sYmdHms( d ); if(  "1000-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 6 : "+ d +" >"+ s +"<" ); return 6 ;}//>
  d = 2298884 - 4*3 +2; s = sYmdHms( d ); if(  "1582-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 7 : "+ d +" >"+ s +"<" ); return 7 ;}//>
  d = 2299239         ; s = sYmdHms( d ); if(  "1583-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 8 : "+ d +" >"+ s +"<" ); return 8 ;}//>
  d = 2305448         ; s = sYmdHms( d ); if(  "1600-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 9 : "+ d +" >"+ s +"<" ); return 9 ;}//>
  d = 2341973         ; s = sYmdHms( d ); if(  "1700-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 10: "+ d +" >"+ s +"<" ); return 10;}//>
  d = 2440588         ; s = sYmdHms( d ); if(  "1970-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 11: "+ d +" >"+ s +"<" ); return 11;}//>

  d = 2440588.25      ; s = sYmdHms( d ); if(  "1970-01-01 18:00:00" != s ){ trace( "TEST_sYMDhms 12: "+ d +" >"+ s +"<" ); return 12;}//>
  d = 2440588.5       ; s = sYmdHms( d ); if(  "1970-01-02 00:00:00" != s ){ trace( "TEST_sYMDhms 13: "+ d +" >"+ s +"<" ); return 13;}//>
  d = 2440588.75      ; s = sYmdHms( d ); if(  "1970-01-02 06:00:00" != s ){ trace( "TEST_sYMDhms 14: "+ d +" >"+ s +"<" ); return 14;}//>
  d = 2440588.751     ; s = sYmdHms( d ); if(  "1970-01-02 06:00:00" != s ){ trace( "TEST_sYMDhms 15: "+ d +" >"+ s +"<" ); return 15;}//>
  d = 2440588.75101   ; s = sYmdHms( d ); if(  "1970-01-02 06:00:00" != s ){ trace( "TEST_sYMDhms 16: "+ d +" >"+ s +"<" ); return 16;}//>

 return 0;                                                                                              //>
 }//TEST_sYMDhms(){}//////////////////////////////////////////////////////////////////////////////////////>


 function               sWinterObservations(//////////////////////////////////////////////////////////////> Run the "Hey Diddle Diddle algorithm" from one date.
                        a_sGo                                                                           //> Date to start on (start waiting for the new moon), as ISO formatted text (yyyy-mm-dd)
 )                                      :String {/////////////////////////////////////////////////////////> Report text errors, or empty string if okay.
  var                   n_jd      :Int = Math.floor( dJDayFromYms_jd( Std.parseInt( a_sGo.substr(0,4) ) //> Convert Gregorian date to a Julian Day, the number of days that have passed since the Julian Date Epoch.  Gregorian Year,
                                                     ,                Std.parseInt( a_sGo.substr(5,2) ) //> Month. Jan = 1, Dec = 12
                                                     ,                Std.parseInt( a_sGo.substr(8,2) ) //> Day. 1st = 1
                                         )           );                                                 //>
                                                                                                        trace("sWinterObservations "+ a_sGo +" "+ n_jd);//>
  var                   asDaysData      :Array<String>          = _mapasDaysData[ n_jd +"jd" ];         //> Look up data for the given day.
  if( null == asDaysData ){                                                                 return "*";}//> If there is a problem, like date isn't in table, then quit.
  var                   whenGo_jd       :Int                    = n_jd;                                 //> Keep a copy of start day.
  var                   isStep          :Int                    = 0 ;                                   //> Step in Hey Diddle algorithm.
  var                   nSkipAhead_days :Int                    = 1 ;                                   //> Number of days we can skip ahead in running the Hey Diddle algorithm.
  var                   r_s             :String                 = "";                                   //> Output text, start from scratch.
  for( iLimit in 0...99 ){                                                                              //> Loop we promise to break out of, with a limit just in case.
   nSkipAhead_days = 1;                                                                                 //> Default is 1 loop = 1 day, but we may want to skip some days.
   asDaysData    = _mapasDaysData[ n_jd +"jd" ];                                                        //> Look up data for the given date.
   if( null == asDaysData ){                                        trace("???");                break;}//>
   if(       0 == isStep ){                                                                             //>
    isStep = 1;                                                                                         //> The very first time, move on to next step immediately.
    r_s    = asDaysData[ _iDATAfORdAY_sDate ]  +"="+ sYmdHms( n_jd )                         //DEBUG    //> But report date and
             + ", mset,"+sYmdHms(  n_jd +Std.parseFloat( asDaysData[_iDATAfORdAY_dMoonSet_h] )-0.5  )   //> date/time of the moon set.
             +       ","+                                asDaysData[_iDATAfORdAY_Moon_sDate]        ;   //>
   }//if                                                                                                //>
   if(       1 == isStep ){                                                                             //> If in first stage of algorithm...
    if(       Std.parseFloat( asDaysData[_iDATAfORdAY_Moon_dLit_100] ) < 2   ){                         //> Look for new moon, if seeing it, go to next stage.
     isStep = 2;                                                                                        //>
    }//if                                                                                               //>
   }else{                                                                                               //> In 2nd stage of algorithm, look
    if( 50 <= Std.parseFloat( asDaysData[_iDATAfORdAY_Moon_dLit_100] )       ){                         //> for first gibbous illumination (50%+), when 
     isStep = 3;    nSkipAhead_days = 8;                                                                //> we skip ahead to the big night.
     r_s +=     ", gib,"+sYmdHms(  n_jd +Std.parseFloat( asDaysData[_iDATAfORdAY_dMoonSet_h] )-0.5  )   //>
             +       ","+                                asDaysData[_iDATAfORdAY_Moon_sDate]        ;   //>
  break;//for                                                                                           //> get out of this loop
   }}//if//if                                                                                           //> .
   n_jd += nSkipAhead_days;                                                                             //> If staying in loop, then skip ahead.
  }//for                                                                                                //> .
                                                                                                        //>
  var                                   iDec                    = 0;                                    //>
  var                                   iRa                     = 0;                                    //>
  iDec = _iDATAfORdAY_Moon_dDec; iRa = _iDATAfORdAY_Moon_dRa; r_s += ", full,Moon,"+ asDaysData[iDec] +","+ asDaysData[iRa]; //>
//iDec = _iDATAfORdAY_MidN_dDec; iRa = _iDATAfORdAY_MidN_dRa; r_s += ", full,MidN,"+ asDaysData[iDec] +","+ asDaysData[iRa]; //>
//iDec = _iDATAfORdAY_Vega_dDec; iRa = _iDATAfORdAY_Vega_dRa; r_s += ", full,Vega,"+ asDaysData[iDec] +","+ asDaysData[iRa]; //>
                                                                                                        //>
  var                   d_360           :Float = dOverLine_360( Std.parseFloat( asDaysData[iDec] )      //> See if full moon has crossed "little dog" line or not.
                                                 ,              Std.parseFloat( asDaysData[iRa ] )      //>
                                                 );                                                     //>
  if( d_360 < 0 ){   n_jd += 337;   r_s += ", 337,";   }                                                //> If it has, then skip ahead to next year.
  else           {   n_jd += 366;   r_s += ", 366,";   }                                                //> If not, skip ahead with extra month, to next year.
 return r_s + sYmd( n_jd );                                                                             //> Report results, with row ending in next year's date.
 }//sWinterObservations///////////////////////////////////////////////////////////////////////////////////>


 function               Go_ReadMapasDataFromFile(/////////////////////////////////////////////////////////> Get data from one file, add to global table (map).
                        a_sFile                                                                         //> Name of file within input directory.
 )                                      :Void {///////////////////////////////////////////////////////////> Report nothing. Add to _mapasDaysData.
  var                   sData           :String         = sys.io.File.getContent(_sPathData + a_sFile); //> Get contents of input data file.
  var                   asLines         :Array<String>  = sData.split('\n');                            //> Split file into rows (one per date).
  var                   n               :Int            = asLines.length;                               //> Get number of rows.
  var                   r_s             :String         = "";                                           //> Output text string.
  var                   asCell          :Array<String>  = [];                                           //> List of text cell contents.
  var                   sKeyJDay        :String         = "";                                           //>
  var                   asRow           :Array<String>  = [];                                           //>
  for( i in 2...n ){                                                                                    //> Move to RAM: Skip first 2 lines, and then process each file line...
   asCell   = asLines[i].split(",");                                                                    //> Split line on commas.
   sKeyJDay =   asCell[ 1] +"jd";                                                                       //> List key is the Julian Day.
   asRow    = [ asCell[ 0]              // _iDATAfORdAY_sDate         =  0;                             //> sDate         ,1999-12-31T12:00:00  First cell is nYear as text in ISO format yyyy-mm-dd. 
              , asCell[ 1]              // _iDATAfORdAY_nDay_jd       =  1;                             //> a_nDay_jd     ,2451544              Numeric version of key.
              , asCell[ 2]              // _iDATAfORdAY_dSunSet_h     =  2;                             //> dSunSet_h     ,16.026944444444442 
              , asCell[ 3]              // _iDATAfORdAY_dSunRise_h    =  3;                             //> dSunRise_h    ,32.06888888888889 
              , asCell[ 4]              // _iDATAfORdAY_dMoonRise_h   =  4;                             //> r_dMoonRise_h ,26.668333333333333 
              , asCell[ 5]              // _iDATAfORdAY_dMoonSet_h    =  5;                             //> dMoonSet_h    ,37.220555555555556 
              , asCell[ 6]              // _iDATAfORdAY_Moon_sDate    =  6;                             //> Moon_sDate    ,2000-01-01T13:13:14 
              , asCell[ 7]              // _iDATAfORdAY_Moon_dLit_100 =  7;                             //> dLit_100      ,22.799720764160156 
              , asCell[ 8]              // _iDATAfORdAY_Moon_dRa      =  8;                             //> dRa           ,-137.51418852173234 
              , asCell[ 9]              // _iDATAfORdAY_Moon_dDec     =  9;                             //> dDec          ,-11.811177408287486 
              , asCell[10]              // _iDATAfORdAY_MidN_sDate    = 10;                             //> MidN_sDate    ,2000-01-01T00:00:00 
              , asCell[11]              // _iDATAfORdAY_MidN_dLit_100 = 11;                             //> dLit_100      ,26.628517150878906 
              , asCell[12]              // _iDATAfORdAY_MidN_dRa      = 12;                             //> dRa           ,-142.82009664343948 
              , asCell[13]              // _iDATAfORdAY_MidN_dDec     = 13;                             //> dDec          ,-9.647356542776926 
              , asCell[14]              // _iDATAfORdAY_Vega_sDate    = 14;                             //> Vega_sDate    ,1999-12-31T23:59:50 
              , asCell[15]              // _iDATAfORdAY_Vega_dLit_100 = 15;                             //> dLit_100      ,26.629600524902344 
              , asCell[16]              // _iDATAfORdAY_Vega_dRa      = 16;                             //> dRa           ,-142.82155355617718 
              , asCell[17]              // _iDATAfORdAY_Vega_dDec     = 17;                             //> dDec          ,-9.646872946743024 
              ];                                                                                        //>
   _mapasDaysData[ sKeyJDay ] = asRow;                                                                //> Keep row of data in RAM table, keyed with ISO format date.
  }//for i                                                                                              //>
 }//Go_ReadMapasDataFromFile//////////////////////////////////////////////////////////////////////////////>

 
 function               Go(///////////////////////////////////////////////////////////////////////////////> Main execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
// if( 0 < TEST_dDate_jd()    ){                                                                return;}//>
// if( 0 < TEST_nYearFromJd() ){                                                                return;}//>
// if( 0 < TEST_anYmdFromJd() ){                                                                return;}//>
  if( 0 < TEST_sYMDhms()     ){                                                                return;}//>
                                                                                                        //>
  trace("Reading data. -----------------------------------------");                                     //>
  for( y in 2000...2100 ){                                                                              //> For a century...
   Go_ReadMapasDataFromFile( '2000_2099/table012_'+ y +'.csv' );                                        //> Get data from one file, put in global table
  }//for y                                                                                              //> .
                                                                                                        //>
//.  for( y in 2000...2001 ){                                                                           //> For each year...
  var                   y               :Int                    = 2000;                                 //> Year as an integer.
  var                   s1              :String                 = y +'-02-15';                          //> Create a starting date in ISO format (late in this case).
  var                   sReport         :String                 = "";                                   //> Initialize the output text string.
  trace("Year = "+ y +" "+ s1 +"-------------------------------");                                      //>
  for( z in 0...20 ){                                                                                   //> Run observations for 20 years in a row.
   s1 = sWinterObservations( s1 );                                                                      //> Run the "Hey Diddle Diddle algorithm" from one starting date. Add a row to the results.
   sReport += "\n "+ s1;                                                                                //>
   s1 = s1.substr(-10);                                                                                 //> The next date to start observations is given in the last cell of the row.
  }//for z                                                                                              //> Repeat with the next date we have calculated.
  trace(sReport);                                                                                       //> Output the report of rows.
  trace("");                                                                                            //>
//.  }//for y                                                                                           //>
  trace("Done");                                                                                        //>
 }//Go////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               new(//////////////////////////////////////////////////////////////////////////////> Construct a new object of this class (and run appropriate processing).
 )                                      :Void {///////////////////////////////////////////////////////////>
  //var                    sCommandLine :String        = ( Sys.args() )[0];                             //> Get operation from command line.
  //if(     "TOpROJECT" == sCommandLine ){          trace( sCommandLine +" <-----" );     }             //> If command line is specifying...
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
