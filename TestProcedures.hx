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
  var                   _mapasJdMsIlRaDe       = new Map<String,Array<String>>();                       //> Table of data read from files.


 function                nMod(////////////////////////////////////////////////////////////////////////////>
                         a                                                                              //>
 ,                       m                                                                              //>
 )                                      :Int{/////////////////////////////////////////////////////////////>
 return ( Math.floor(a)%m + m )%m;                                                                      //>
 }//nMod//////////////////////////////////////////////////////////////////////////////////////////////////>


 function               Go_ReadOneFile(///////////////////////////////////////////////////////////////////> Get data from one file, add to global table (map).
                        a_sFile                                                                         //> Name of file within input directory.
 )                                      {/////////////////////////////////////////////////////////////////> Report nothing. Add to _mapasJdMsIlRaDe.
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
              //,  as[6 ]                                                                               //> MOON_when    ,2000-01-01T13:13:14 
              ,    as[7 ]               // 2                                                            //> illumination ,22.799720764160156 
              ,    as[8 ]               // 3                                                            //> ra           ,-137.51418852173234 
              ,    as[9 ]               // 4                                                            //> dec          ,-11.811177408287486 
              //,  as[10]                                                                               //> TIME_when    ,2000-01-01T00:00:00 
              //,  as[11]                                                                               //> illumination ,26.628517150878906 
              //,  as[12]                                                                               //> ra           ,-142.82009664343948 
              //,  as[13]                                                                               //> dec          ,-9.647356542776926 
              //,  as[14]                                                                               //> VEGA_when    ,1999-12-31T23:59:50 
              //,  as[15]                                                                               //> illumination ,26.629600524902344 
              //,  as[16]                                                                               //> ra           ,-142.82155355617718 
              //,  as[17]                                                                               //> dec          ,-9.646872946743024 
              ];                                                                                        //>
   _mapasJdMsIlRaDe[ sKeyJDay ] = asRow;                                                                //> Keep row of data in RAM table, keyed with ISO format date.
  }//for i                                                                                              //>
 }//Go_ReadOneFile////////////////////////////////////////////////////////////////////////////////////////>
//  var                   sYYYY           = "";                                                         //>
//  var                   sMM             = "";                                                         //>
//  var                   sDD             = "";                                                         //>
//  var                   sHr             = "";                                                         //>
//  var                   sMin            = "";                                                         //>
//  var                   sS              = "";                                                         //>
// sYYYY = as[0].substr( 0, 4);   sMM   = as[0].substr( 5, 2);   sDD   = as[0].substr( 8, 2);           //> Parse date.
// r_s +="\n"+ sYYYY +","+ sMM +","+ sDD;                                                               //>
// sYYYY = as[6].substr( 0, 4);   sMM   = as[6].substr( 5, 2);   sDD   = as[6].substr( 8, 2);           //>
// sHr   = as[6].substr(11, 2);   sMin  = as[6].substr(14, 2);   sS    = as[6].substr(17, 2);           //> Parse time
// r_s +="\n"+ sYYYY +","+ sMM +","+ sDD +","+ sHr +","+ sMin +","+ sS;                                 //>

 
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


 function               nDate_jd(/////////////////////////////////////////////////////////////////////////> Convert Gregorian date to a Julian Day, the number of days that have passed since the Julian Date Epoch.
                        Y               :Int                                                            //> Gregorian Year,
 ,                      M               :Int                                                            //> Month. Jan = 1, Dec = 12
 ,                      D               :Int                                                            //> Day. 1st = 1
 )                                      :Int {////////////////////////////////////////////////////////////>
  var                   A               :Int                    = Math.floor( (M - 15)/12 );            //>
  var                   B               :Int                    = Y + 4800 + A;                         //>
 return D - 32075 + Math.floor(    367*             ( M - 3 - 12*A )/12   )                             //>
                  + Math.floor(   1461*               B             / 4   )                             //>
                  - Math.floor(      3*Math.floor(1 + B/100)        / 4   )                             //>
          + 29;                                                                                         //> ??? 29 + 9.5 days difference between Gregorian calendar and Julian days?
 }//nDate_jd///////////////////////////////////////////////////////////////////////////////////////////////>
//function               nDayFromYMD_jd(///////////////////////////////////////////////////////////////////> Alternate implementation to convert Gregorian to JDay.
//                       Y               :Int                                                            //> Gregorian Year,
//,                      M               :Int                                                            //> Month. Jan = 1, Dec = 12
//,                      D               :Int                                                            //> Day. 1st = 1
//)                                      :Int {////////////////////////////////////////////////////////////>
//return (1721425.5                                       //> (this.constants.gregorian.EPOCH - 1)         //>
//        +           365*(Y - 1)                                                                        //>
//        +   Math.floor( (Y - 1) /   4)                                                                 //>
//        -   Math.floor( (Y - 1) / 100)                                                                 //>
//        +   Math.floor( (Y - 1) / 400)                                                                 //>
//        +   Math.floor(   ( (367*M - 362) / 12 ) +( M <= 2  ?0  :bLeapGregorian(Y) ?-1 :-2 )   )       //>
//        + D                                                                                            //>
//       );                                                                                              //>
//}//nDayFromYMD_jd////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_nDate_jd(){////////////////////////////////////////////////////////////////////////> Test the above function.
  var                   n               :Int                    = 0;                                    //>
                                //     Julian Day as displayed in Stellarium.                           //>
                                //     |    I think these fudge factors are because of differences between Julian and Gregorian calendars before 1582 - 3 days every 300 years.
                                //     v    v                                                                                 From Stellarium v
  n = nDate_jd(-4712, 1,1 ); if(       0 +12*3 +2 != n ){ trace( "TEST_nDate_jd 0  -4712, 1,1 : "+ n +" "+ (n -       0) ); } //>       0
  n = nDate_jd(-2000, 1,1 ); if(  990558 + 5*3 +2 != n ){ trace( "TEST_nDate_jd 1  -2000, 1,1 : "+ n +" "+ (n -  990558) ); } //>  990558
  n = nDate_jd(   -1, 1,1 ); if( 1720693 +      2 != n ){ trace( "TEST_nDate_jd 2     -1, 1,1 : "+ n +" "+ (n - 1720693) ); } //> 1720693
  n = nDate_jd(    0, 1,1 ); if( 1721058 +      2 != n ){ trace( "TEST_nDate_jd 3      0, 1,1 : "+ n +" "+ (n - 1721058) ); } //> 1721058
  n = nDate_jd(    1, 1,1 ); if( 1721424 +      1 != n ){ trace( "TEST_nDate_jd 4      1, 1,1 : "+ n +" "+ (n - 1721424) ); } //> 1721424
  n = nDate_jd( 1000, 1,1 ); if( 2086308 - 2*3 +1 != n ){ trace( "TEST_nDate_jd 5   1000, 1,1 : "+ n +" "+ (n - 2086308) ); } //> 2086308
  n = nDate_jd( 1582, 1,1 ); if( 2298884 - 4*3 +2 != n ){ trace( "TEST_nDate_jd 6   1582, 1,1 : "+ n +" "+ (n - 2298884) ); } //> 10 day jump implemented in 1582 Oct.
  n = nDate_jd( 1583, 1,1 ); if( 2299239          != n ){ trace( "TEST_nDate_jd 7   1583, 1,1 : "+ n +" "+ (n - 2299239) ); } //> 2299239
  n = nDate_jd( 1600, 1,1 ); if( 2305448          != n ){ trace( "TEST_nDate_jd 8   1600, 1,1 : "+ n +" "+ (n - 2305448) ); } //> 2305448
  n = nDate_jd( 1700, 1,1 ); if( 2341973          != n ){ trace( "TEST_nDate_jd 9   1700, 1,1 : "+ n +" "+ (n - 2341973) ); } //> 2341973
  n = nDate_jd( 1970, 1,1 ); if( 2440588          != n ){ trace( "TEST_nDate_jd 10  1970, 1,1 : "+ n +" "+ (n - 2440588) ); } //> 2440588
 }//TEST_nDate_jd(){}////////////////////////////////////////////////////////////////////////////////////////////>


 function               nYearFromJd(//////////////////////////////////////////////////////////////////////>
                        jd              :Float                                                          //> Julian Day
 )                                      :Int {////////////////////////////////////////////////////////////>
  var           dWjd                    :Float              = Math.floor(jd - 0.5) + 0.5;               //>
  var           dDay_jd                 :Float              = dWjd - 1721425.5;                           //> this.constants.gregorian.EPOCH;
                                                                                                        //>
  var           nCycles_400y            :Int                = Math.floor(dDay_jd           / 146097);   //> Number of 400 nYear cycles.
  var           nIn400yCycle_day        :Int                = nMod(      dDay_jd           , 146097);   //> Day within 400 nYear cycle.
                                                                                                        //>
  var           nCenturyInCycle_100y    :Int                = Math.floor(nIn400yCycle_day  /  36524);   //> Century within 400 nYear cycle.
  var           nInCentury_day          :Int                = nMod(      nIn400yCycle_day  ,  36524);   //> Day count in century.
                                                                                                        //>
  var           nBlockInCentury_4y      :Int                = Math.floor(nInCentury_day    /   1461);   //> 4 nYear block within the century.
  var           nIn4yBlock_day          :Int                = nMod(      nInCentury_day    ,   1461);   //>
                                                                                                        //>
  var           nYearInBlock_y          :Int                = Math.floor(nIn4yBlock_day    /    365);   //>
                                                                                                        //>
  var           nYear                   :Int                =          nCycles_400y*400                 //>
                                                             + nCenturyInCycle_100y*100                 //>
                                                             +   nBlockInCentury_4y*4                   //>
                                                             +       nYearInBlock_y;                    //>
  if(       nCenturyInCycle_100y != 4   &&   nYearInBlock_y != 4      ){ nYear++; }                     //>
 return nYear;                                                                                          //>
 }//nYearFromJd///////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_nYearFromJd(/////////////////////////////////////////////////////////////////>
 )                                      :Void{////////////////////////////////////////////////////////////>
  var                   n               :Int                    = 0;                                    //>
  n = nYearFromJd(       0 +12*3 +2 ); if( -4712 != n ){ trace( "TEST_nYearFromJd 0  "+ n ); }  
  n = nYearFromJd(  990558 + 5*3 +2 ); if( -2000 != n ){ trace( "TEST_nYearFromJd 1  "+ n ); }  
  n = nYearFromJd( 1720693 +      2 ); if(    -1 != n ){ trace( "TEST_nYearFromJd 2  "+ n ); }  
  n = nYearFromJd( 1721058 +      2 ); if(     0 != n ){ trace( "TEST_nYearFromJd 3  "+ n ); }  
  n = nYearFromJd( 1721424 +      1 ); if(     1 != n ){ trace( "TEST_nYearFromJd 4  "+ n ); }  
  n = nYearFromJd( 2086308 - 2*3 +1 ); if(  1000 != n ){ trace( "TEST_nYearFromJd 5  "+ n ); }  
  n = nYearFromJd( 2298884 - 4*3 +2 ); if(  1582 != n ){ trace( "TEST_nYearFromJd 6  "+ n ); }  
  n = nYearFromJd( 2299239          ); if(  1583 != n ){ trace( "TEST_nYearFromJd 7  "+ n ); }  
  n = nYearFromJd( 2305448          ); if(  1600 != n ){ trace( "TEST_nYearFromJd 8  "+ n ); }  
  n = nYearFromJd( 2341973          ); if(  1700 != n ){ trace( "TEST_nYearFromJd 9  "+ n ); }  
  n = nYearFromJd( 2440588          ); if(  1970 != n ){ trace( "TEST_nYearFromJd 10 "+ n ); }  
 }//nYearFromJd///////////////////////////////////////////////////////////////////////////////////////////>
 

 function bLeapGregorian(nYear){ return nYear%4 == 0   && ( nYear%100 != 0   ||  nYear%400 == 0 );  }


 function               anGregorianFromJd(////////////////////////////////////////////////////////////////>
                        jd              :Float                                                          //>
 )                                      :Array<Int> {/////////////////////////////////////////////////////>
  var              nYear    :Int   = nYearFromJd(jd);                                                   //>
  var              dWjd     :Float = Math.floor(jd - 0.5) + 0.5;                                        //>
  var              dYearday :Float =   dWjd - nDate_jd(nYear,1,1);                                      //>
  var              nLeap    :Int   = ( dWjd < nDate_jd(nYear,3,1) ) ?                        0          //>
                                                                    :(bLeapGregorian(nYear) ?1 :2)      //>
                                    ;                                                                   //>
  var              month    :Int   = Math.floor(      (   ( (dYearday+nLeap)*12 ) +373   )/ 367      ); //>
  var              day      :Int   = Math.floor( dWjd - nDate_jd(nYear, month, 1) ) + 1;                //>
 return [nYear, month, day];                                                                            //>
 }//anGregorianFromJd/////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_anGregorianFromJd(///////////////////////////////////////////////////////////>
 ){                     //////////////////////////////////////////////////////////////////////////////////>
  trace("TEST_anGregorianFromJd");                                                                  //>
  var                   s               :String                 = "";                                   //>
  s = ""+ anGregorianFromJd(      0      ); if( "[-4713,11,24]" != s ){ trace( ">"+ s +"<"); }           //>
  s = ""+ anGregorianFromJd(2440588      ); if( "[1970,1,1]"    != s ){ trace( ">"+ s +"<"); }           //>
  s = ""+ anGregorianFromJd(2459666.13750); if( "[2022,3,27]"   != s ){ trace( ">"+ s +"<"); }           //>
 }//TEST_anGregorianFromJd////////////////////////////////////////////////////////////////////////////////>


 function               sYMD(/////////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date string.
                        jd              :Int                                                            //>
 ){                                     //////////////////////////////////////////////////////////////////>
  var                   an              :Array<Int>             = anGregorianFromJd( jd );              //>
 return an[0] +"-"+ ( "0"+an[1] ).substr(-2) +"-"+ ( "0"+an[2] ).substr(-2);                            //>
 }//sYMD//////////////////////////////////////////////////////////////////////////////////////////////////>


 function               sYMDhms(//////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date string.
                        jd              :Float                                                          //>
 ){                                     //////////////////////////////////////////////////////////////////>
  var                   n_jd       :Int   = Math.floor(jd);                                             //>
  var                   d          :Float                      = jd - n_jd; d =            24*d       ; //>
  var                   nH         :Int   = Math.floor( d ); d =  d - nH  ; d =            60*d       ; //>
  var                   nM         :Int   = Math.floor( d ); d =  d - nM  ; d = Math.floor(60*d + 0.5); //>
 return sYMD(n_jd) +" "+ ("0"+nH).substr(-2) +":"+ ("0"+nM).substr(-2) +":"+ ("0"+d).substr(-2);        //>
 }//sYMDhms///////////////////////////////////////////////////////////////////////////////////////////////>
 function               TEST_sYMDhms(/////////////////////////////////////////////////////////////////////>
 ){                     //////////////////////////////////////////////////////////////////////////////////>
  trace( "220 **************** "+ sYMDhms( 0 ) );
 }//TEST_sYMDhms(){}//////////////////////////////////////////////////////////////////////////////////////>


//.  var                   calendar_constants_gregorian_EPOCH      = 1721425.5; // ??? https://dzucconi.github.io/calendrical/docs/calendrical.calendar.constants.html
//.
//.
//.  function              calendar_gregorianToJd(///////////////////////////////////////////////////////////> Determine Julian day number from Gregorian calendar date
//.                        year
//.  ,                     month
//.  ,                     day
//.  )                     {////////////////////////////////////////////////////////////////////////////////////////
//.  return (calendar_constants_gregorian_EPOCH - 1)       
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
//.                        jd
//.  )                     {///////////////////////////////////////
//.    var wjd        = Math.floor(jd - 0.5) + 0.5;
//.    var depoch     = wjd - calendar_constants_gregorian_EPOCH;
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
//.                        jd
//.  )                     {//////////////////////////////////
//.    var                 wjd             = Math.floor(jd - 0.5) + 0.5;
//.    var                 year            = calendar_jdToGregorianYear(jd);
//.    var                 yearday         = wjd - calendar_gregorianToJd(year, 1, 1);
//.    var                 leapadj         = (     (   wjd < calendar_gregorianToJd(year, 3, 1)   ) ?0 :(calendar_leapGregorian(year) ? 1 : 2)     );
//.    var                 month           = Math.floor(     (   ( (yearday + leapadj)*12 ) + 373   )/367     );
//.    var                 day             = (   wjd - calendar_gregorianToJd(year,month,1)   ) + 1;
//.  return [year, month, day];
//.  }/////////////////////////////////////////////////////


 function               sRunTrial(////////////////////////////////////////////////////////////////////////> Run the "Hey Diddle Diddle algorithm" from one date.
                        a_sGo                                                                           //> Date to start on (start waiting for the new moon).
 )                                      :String {/////////////////////////////////////////////////////////>
  var                   when_jd         :Int              = nDate_jd( Std.parseInt( a_sGo.substr(0,4) ) //> Convert Gregorian date to a Julian Day, the number of days that have passed since the Julian Date Epoch.  Gregorian Year,
                                                            ,         Std.parseInt( a_sGo.substr(5,2) ) //> Month. Jan = 1, Dec = 12
                                                            ,         Std.parseInt( a_sGo.substr(8,2) ) //> Day. 1st = 1
                                                            );                                          //>
  var                   asJdMsIlRaDe    :Array<String>    = _mapasJdMsIlRaDe[ when_jd +"jd" ];          //> Look up data for the given day.
  if( null == asJdMsIlRaDe ){                                                               return "*";}//> If there is a problem, like date isn't in table, then quit.
  var                   sDate_iso       :String           = "";                                         //>
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
   asJdMsIlRaDe = _mapasJdMsIlRaDe[ sYMD(when_jd) ];                                                    //> Look up data for the given date.
   if( null == asJdMsIlRaDe ){      trace("???");                                                break;}//>
   sDate_iso   =                 asJdMsIlRaDe[0]  ;                                                     //> sDate        ,1999-12-31T12:00:00            At Moonset
   sMoonset    =                 asJdMsIlRaDe[1]  ;                                                     //> MOON_when    ,2000-01-01T13:13:14            
   dLit_100    = Std.parseFloat( asJdMsIlRaDe[2] );                                                     //> illumination ,22.799720764160156            
   dRa         = Std.parseFloat( asJdMsIlRaDe[3] );                                                     //> ra           ,-137.51418852173234           
   dDec        = Std.parseFloat( asJdMsIlRaDe[4] );                                                     //> dec          ,-11.811177408287486           
   var                  dMoonset_jd     :Float   = nDate_jd( Std.parseInt( sMoonset.substr( 0, 4) )     //> Parse date string for the moonset. Year
                                                   ,         Std.parseInt( sMoonset.substr( 5, 2) ) -1  //> Month (0-11)
                                                   ,         Std.parseInt( sMoonset.substr( 8, 2) )     //> Date (1-31)
                                                   )   +(    Std.parseInt( sMoonset.substr(11, 2) )     //>
                                                         +(  Std.parseInt( sMoonset.substr(14, 2) )     //>
                                                           + Std.parseInt( sMoonset.substr(17, 2) )/60  //>
                                                          )                                        /60  //>
                                                        )                                          /24  //>
                        ;                                                                               //>
                                                                                                        //>
   if(      -1 == isStep ){ isStep = 0;                                                                 //> The very first time, move on to next step immediately                                                                            //> First time,
                            sRow =            sYMDhms( when_jd     )                                    //> Report date
                                  +",mset, "+ sYMDhms( dMoonset_jd );                                   //> we will display the date/time of the moon set.
   }//if                                                                                                //>
   if(       0 == isStep ){                                                                             //> If in first stage...
    if( dLit_100 < 2   ){   isStep++;   }                                                               //> Look for new moon, if seeing it, go to next stage.
   }else if( 1 == isStep ){                                                                             //> In 2nd stage, look
    if( 50 <= dLit_100 ){   isStep++;   dSkipAhead_days = 7.;                                           //> for first gibbous illumination (50%+), when we start count of nights.
                            sRow += ",gib, "+ sYMDhms( dMoonset_jd );                                   //>
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
 }//sRunTrial/////////////////////////////////////////////////////////////////////////////////////////////>


 function               Go(///////////////////////////////////////////////////////////////////////////////> Main execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>

  TEST_nDate_jd();
//TEST_sYMDhms();
  TEST_nYearFromJd();
  TEST_anGregorianFromJd();

//.   for( y in 2000...2100 ){                                                                              //>
//.    Go_ReadOneFile( 'table012_'+ y +'_'+ (y + 1) +'.csv' );                                                  //> Get data from one file, put in global table.
//.   }//for y                                                                                              //>
//.                                                                                                         //>
//.   for( y in 2000...2001 ){                                                                              //>
//.    var                  s1              :String                 = y +'-02-15';
//.    var                  sReport         :String                 = "";
//.    for( z in 0...90 ){ 
//.     s1 = sRunTrial( s1 );  sReport += "\n "+ s1;  s1 = s1.substr(-10);  
//.    }//for z
//.    trace(sReport);
//.    
//. //   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//. //   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//. //   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//. //   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//. //   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//. //   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//. // trace(   sRunTrial( y +'-10-15' )   );                                                               //>
//. // trace(   sRunTrial( y +'-11-01' )   );                                                               //>
//. // trace(   sRunTrial( y +'-11-15' )   );                                                               //>
//. // trace(   sRunTrial( y +'-12-01' )   );                                                               //>
//. // trace(   sRunTrial( y +'-12-15' )   );                                                               //>
//. // trace(   sRunTrial( y +'-01-01' )   );                                                               //>
//. // trace(   sRunTrial( y +'-01-15' )   );                                                               //>
//. // trace(   sRunTrial( y +'-02-01' )   );                                                               //>
//.    trace("");                                                                                           //>
//.   }//for y                                                                                              //>
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
