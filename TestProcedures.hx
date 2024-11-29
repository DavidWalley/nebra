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
 function               TEST_dDate_jd(////////////////////////////////////////////////////////////////////> Test the above function.
 )                                      :Int {////////////////////////////////////////////////////////////> Report 0 if no problems.
//.  var                   m               :Float                  = 0;                                    //>
//.  var                   n               :Float                  = 0;                                    //>
//.  m = dDate_jd(-4713,11,24); trace("TEST_dDate_jd -4713 " + m );                                        //> Does not match Stellarium, as Stellarium switches to the Julian calendar before 1500s.
//.  m = dDate_jd(-4712, 1, 1); trace("TEST_dDate_jd -4712 " + m );                                        //>
//.  for( y in 1600...2100 ){                                                                              //>
//.   m = dDate_jd(y,11,24);                                                                               //>
//.   //n = dDate_jd(y,11,24);                                                                             //>
//.   if( y == 1700 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2342300              //>
//.   if( y == 1800 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2378824              //>
//.   if( y == 1900 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2415348              //>
//.   if( y == 2000 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //> 2451873              //>
//.   if( y <  1609 ){ trace( "TEST_dDate_jd "+ y +" "+ m +" " ); } //return 1 ;} //>                      //>
//.                          // 2305776                                                                    //>
//.                          // 2306141                                                                    //>
//.                          // 2306506                                                                    //>
//.                          // 2306871                                                                    //>
//.                          // 2307237                                                                    //>
//.                          // 2307602                                                                    //>
//.                          // 2307967                                                                    //>
//.                          // 2308332                                                                    //>
//.                          // 2308698                                                                    //>
//.   // if( m != n ){ trace( "TEST_dDate_jd "+ y +" "+ m +" "+ n ); return 1 ;} //>       0               //>
//.  }//for i                                                                                              //>
 return 0;                                                                                              //> Report no problems - looks good against Stellarium.
 }//TEST_dDate_jd/////////////////////////////////////////////////////////////////////////////////////////>


//////////////////////////////////////////////////////////////////////////////////////////////////////////>
// JDAY -> GREGORIAN                                                                                    //>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               nYearFromJd(//////////////////////////////////////////////////////////////////////> Convert Julian Day to Year.
                        a_jd            :Float                                                          //> Julian Day
 )                                      :Int {////////////////////////////////////////////////////////////>
  var           dStartOfDay_jd            :Float             = Math.floor(a_jd - 0.5) + 0.5;              //> Round off to the noon before given day number.
  var           dDay_jd                 :Float             = dStartOfDay_jd - _GREGORIANePOCH;                //> this.constants.gregorian.EPOCH;
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
  var                   d               :Float                  = dDate_jd(1600,1,1);                   //>
  for( y in -4172...2100 ){                                                                             //>
   d = dDate_jd(y,1,1); n = nYearFromJd(d); if( y != n ){ trace( "TEST_nYearFromJd "+ n ); return 1 ;}  //> Test that this is the inverse of a known good function.
  }//for y                                                                                              //>
 return 0;                                                                                              //>
 }//nYearFromJd///////////////////////////////////////////////////////////////////////////////////////////>
 

 function bLeapGregorian(nYear){ return nYear%4 == 0   && ( nYear%100 != 0   ||  nYear%400 == 0 );  }


 function               anGregorianFromJd(////////////////////////////////////////////////////////////////>
                        a_jd            :Float                                                          //>
 )                                      :Array<Int> {/////////////////////////////////////////////////////>
  var                   r_nY            :Int     = nYearFromJd(a_jd);                                   //>
  var                   r_nM            :Int     = 0;                                                   //>
  var                   r_nD            :Int     = 0;                                                   //>
  var                   dStartOfDay_jd  :Float   = Math.floor(a_jd - 0.5) + 0.5;                    //> The midnight before the given date/time.
  var                   iDayInYear      :Int     = Math.floor( dStartOfDay_jd - dDate_jd(r_nY,1,1) +2);   //> Count of days in year, 1 = Jan 1.
  if( dDate_jd(r_nY,3,1) <= dStartOfDay_jd ){ iDayInYear += bLeapGregorian(r_nY) ?1 :2; }                 //> If after Jan and Feb, add a day and a possible leap day.
  r_nM = Math.floor(   ( (iDayInYear-1)*12 + 373 )/367   );                                             //> Magic! (worked in Excel!)
  r_nD = Math.floor( dStartOfDay_jd - dDate_jd(r_nY, r_nM, 1) + 0.5 ) + 1;                                //>
 return [r_nY, r_nM, r_nD];                                                                             //>
 }//anGregorianFromJd/////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_anGregorianFromJd(///////////////////////////////////////////////////////////>
 ){                     //////////////////////////////////////////////////////////////////////////////////>
  trace("TEST_anGregorianFromJd");                                                                      //>
  var                   s               :String                 = "";                                   //>
  s = ""+ anGregorianFromJd( 2299239          ); if( "[1583,1,1]"    != s ){ trace("TEST_anGregorianFromJd 1  >"+ s +"<"); return 1 ; } //>
  s = ""+ anGregorianFromJd( 2305448          ); if( "[1600,1,1]"    != s ){ trace("TEST_anGregorianFromJd 2  >"+ s +"<"); return 2 ; } //>
  s = ""+ anGregorianFromJd( 2341973          ); if( "[1700,1,1]"    != s ){ trace("TEST_anGregorianFromJd 3  >"+ s +"<"); return 3 ; } //>
  s = ""+ anGregorianFromJd( 2440588          ); if( "[1970,1,1]"    != s ){ trace("TEST_anGregorianFromJd 4  >"+ s +"<"); return 4 ; } //>
  s = ""+ anGregorianFromJd( 2298884 - 4*3 +2 ); if( "[1582,1,1]"    != s ){ trace("TEST_anGregorianFromJd 5  >"+ s +"<"); return 5 ; } //>
  s = ""+ anGregorianFromJd( 2086308 - 2*3 +1 ); if( "[1000,1,1]"    != s ){ trace("TEST_anGregorianFromJd 6  >"+ s +"<"); return 6 ; } //>
  s = ""+ anGregorianFromJd( 1721424 +      2 ); if( "[1,1,1]"       != s ){ trace("TEST_anGregorianFromJd 7  >"+ s +"<"); return 7 ; } //>
  s = ""+ anGregorianFromJd( 1721058 +      2 ); if( "[0,1,1]"       != s ){ trace("TEST_anGregorianFromJd 8  >"+ s +"<"); return 8 ; } //>
  s = ""+ anGregorianFromJd(       0          ); if( "[-4713,11,24]" != s ){ trace("TEST_anGregorianFromJd 9  >"+ s +"<"); return 9 ; } //>
  s = ""+ anGregorianFromJd(       0 +12*3 +2 ); if( "[-4712,1,1]"   != s ){ trace("TEST_anGregorianFromJd 10 >"+ s +"<"); return 10; } //>
  s = ""+ anGregorianFromJd(  990558 + 5*3 +2 ); if( "[-2000,1,1]"   != s ){ trace("TEST_anGregorianFromJd 11 >"+ s +"<"); return 11; } //>
  s = ""+ anGregorianFromJd( 1720693 +      2 ); if( "[-1,1,1]"      != s ){ trace("TEST_anGregorianFromJd 12 >"+ s +"<"); return 12; } //>

  for( d in 0...3000000 ){                                                                              //> Test every day for a long time...
   var                  an              :Array<Int>             = anGregorianFromJd(d);                 //> Convert to Gregorian Y M D
   var                  d1              :Float                  = dDate_jd( an[0]                       //> Convert back - Gregorian Year,
                                                                  ,         an[1]                       //> Month. Jan = 1, Dec = 12
                                                                  ,         an[2]                       //> Day. 1st = 1
                                                                  );                                    //>
 //if( 0 == d%50000 ){ trace( sYMD(d) +" "+ an ); }                                                                   //> Progress indication.
   if( d != d1 ){                                         trace("mismatch "+ d +" "+ d1); return d+100;}//>
  }//for d                                                                                              //>
 return 0;                                                                                              //>
 }//TEST_anGregorianFromJd////////////////////////////////////////////////////////////////////////////////>


 function               sYMD(/////////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date string.
                        a_jd              :Int                                                            //>
 ){                                     //////////////////////////////////////////////////////////////////>
  var                   an              :Array<Int>             = anGregorianFromJd( a_jd );              //>
 return an[0] +"-"+ ( "0"+an[1] ).substr(-2) +"-"+ ( "0"+an[2] ).substr(-2);                            //>
 }//sYMD//////////////////////////////////////////////////////////////////////////////////////////////////>


 function               sYMDhms(//////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date/time string.
                        a_jd       :Float                                                               //>
 )                                 :String {//////////////////////////////////////////////////////////////>
  var                   n_jd       :Int   = Math.floor(a_jd);                                           //>
  var                   d          :Float                    = a_jd - n_jd; d =            24*d       - 12; //>
  var                   nH         :Int   = Math.floor( d ); d =  d - nH  ; d =            60*d       ; //>
  var                   nM         :Int   = Math.floor( d ); d =  d - nM  ; d = Math.floor(60*d + 0.5); //>
 return sYMD(n_jd) +" "+ ("0"+nH).substr(-2) +":"+ ("0"+nM).substr(-2) +":"+ ("0"+d).substr(-2);        //>
 }//sYMDhms///////////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_sYMDhms(/////////////////////////////////////////////////////////////////////>
 )                                      :Int {//////////////////////////////////////////////////////////////////////////////////>
  var                   d               :Float                  = 0.;
  var                   s               :String                 = "";
  d =       0         ; s = sYMDhms( d ); if( "-4713-11-24 12:00:00" != s ){ trace( "TEST_sYMDhms 1 : "+ d +" >"+ s +"<" ); return 1 ;}//>
  d =       0 +12*3 +2; s = sYMDhms( d ); if( "-4712-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 2 : "+ d +" >"+ s +"<" ); return 2 ;}//>
  d =  990558 + 5*3 +2; s = sYMDhms( d ); if( "-2000-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 3 : "+ d +" >"+ s +"<" ); return 3 ;}//>
  d = 1720693 +      2; s = sYMDhms( d ); if(    "-1-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 4 : "+ d +" >"+ s +"<" ); return 4 ;}//>
  d = 1721058 +      2; s = sYMDhms( d ); if(     "0-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 5 : "+ d +" >"+ s +"<" ); return 5 ;}//>
  d = 1721424 +      2; s = sYMDhms( d ); if(     "1-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 6 : "+ d +" >"+ s +"<" ); return 6 ;}//>
  d = 2299239         ; s = sYMDhms( d ); if(  "1583-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 7 : "+ d +" >"+ s +"<" ); return 7 ;}//>
  d = 2305448         ; s = sYMDhms( d ); if(  "1600-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 8 : "+ d +" >"+ s +"<" ); return 8 ;}//>
  d = 2341973         ; s = sYMDhms( d ); if(  "1700-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 9 : "+ d +" >"+ s +"<" ); return 9 ;}//>
  d = 2440588         ; s = sYMDhms( d ); if(  "1970-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 10: "+ d +" >"+ s +"<" ); return 10;}//>
  d = 2298884 - 4*3 +2; s = sYMDhms( d ); if(  "1582-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 11: "+ d +" >"+ s +"<" ); return 11;}//>
  d = 2086308 - 2*3 +1; s = sYMDhms( d ); if(  "1000-01-01 12:00:00" != s ){ trace( "TEST_sYMDhms 12: "+ d +" >"+ s +"<" ); return 12;}//>
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
  if( 0 < TEST_dDate_jd() ){                                                                    return;}//>
  if( 0 < TEST_nYearFromJd()       ){                                                           return;}//>
  if( 0 < TEST_anGregorianFromJd() ){                                                           return;}//>
  if( 0 < TEST_sYMDhms()           ){                                                           return;}//>
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
