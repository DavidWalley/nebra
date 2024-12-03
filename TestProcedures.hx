// TestProcedures.hx - Try various procedures for syncing lunar calendar, reading pre-calculated data files.
// (c)2024 David C. Walley

// This code file is pre-processed and run using the following, in a UBUNTU terminal (ctrl+alt+T) (some hard-coding follows):
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

  var                       _mapasDaysData                      = new Map<String,Array<String>>();      //> Table of data for Sun, Moon and Vega for each day (night), read from files. 
  var                       _iDAYSdATA_sDate                    =  0;                                   //> Table column indexes. [2000-02-15T12:00:00       // _iDAYSdATA_sDate         =  0;  First cell is nYear as text in ISO format yyyy-mm-dd.  
  var                       _iDAYSdATA_nDay_jd                  =  1;                                   //>                       ,2451590                   // _iDAYSdATA_nDay_jd       =  1;  Numeric version of key. 
  var                       _iDAYSdATA_dSunSet_h                =  2;                                   //>                       ,17.242222222222225        // _iDAYSdATA_dSunSet_h     =  2;  Hours (UTC, since last midnight)
  var                       _iDAYSdATA_dSunRise_h               =  3;                                   //>                       ,31.211111111111112        // _iDAYSdATA_dSunRise_h    =  3;  24+ because this is the number of hours from UTC start of day, to end of one continuous night.
  var                       _iDAYSdATA_dMoonRise_h              =  4;                                   //>                       ,12.511944444444444        // _iDAYSdATA_dMoonRise_h   =  4;  Rises just after noon in this case      
  var                       _iDAYSdATA_dMoonSet_h               =  5;                                   //>                       ,28.874722222222225        // _iDAYSdATA_dMoonSet_h    =  5;  24+ because this is the number of hours from UTC start of day, to moonset during the night.
  var                       _iDAYSdATA_Moon_sDate               =  6;                                   //>                       ,2000-02-16T04:52:29       // _iDAYSdATA_Moon_sDate    =  6;  Moonset time       
  var                       _iDAYSdATA_Moon_dLit_100            =  7;                                   //>                       ,83.7523193359375          // _iDAYSdATA_Moon_dLit_100 =  7;  83% - we missed 1st quarter moon.       
  var                       _iDAYSdATA_Moon_dRa                 =  8;                                   //>                       ,99.84598216989706         // _iDAYSdATA_Moon_dRa      =  8;         
  var                       _iDAYSdATA_Moon_dDec                =  9;                                   //>                       ,20.129735102040208        // _iDAYSdATA_Moon_dDec     =  9;         
  var                       _iDAYSdATA_MidN_sDate               = 10;                                   //>                       ,2000-02-16T00:00:00       // _iDAYSdATA_MidN_sDate    = 10; Earlier at midnight...
  var                       _iDAYSdATA_MidN_dLit_100            = 11;                                   //>                       ,82.00177001953125         // _iDAYSdATA_MidN_dLit_100 = 11; 1% less illumination                
  var                       _iDAYSdATA_MidN_dRa                 = 12;                                   //>                       ,96.78695239100111         // _iDAYSdATA_MidN_dRa      = 12; 3 degrees movement 5 hours?        
  var                       _iDAYSdATA_MidN_dDec                = 13;                                   //>                       ,20.314673377009978        // _iDAYSdATA_MidN_dDec     = 13;         
  var                       _iDAYSdATA_Vega_sDate               = 14;                                   //>                       ,2000-02-15T20:58:59       // _iDAYSdATA_Vega_sDate    = 14;         
  var                       _iDAYSdATA_Vega_dLit_100            = 15;                                   //>                       ,81.1370849609375          // _iDAYSdATA_Vega_dLit_100 = 15;         
  var                       _iDAYSdATA_Vega_dRa                 = 16;                                   //>                       ,95.28642241319756         // _iDAYSdATA_Vega_dRa      = 16; 5 degrees movement in 8 hours?        
  var                       _iDAYSdATA_Vega_dDec                = 17;                                   //>                       ,20.313803702885604        // _iDAYSdATA_Vega_dDec     = 17;         
  var                   _dGREGORIANePOCH                        = 1721425.5;                            //> ??? https://dzucconi.github.io/calendrical/docs/calendrical.calendar.constants.html


 function               nMod(/////////////////////////////////////////////////////////////////////////////> Fix the modulus function (% is the remainder function in this language?)
                        a               :Float                                                          //> Integer, a float that will be rounded down.
 ,                      m               :Int                                                            //> The integer modulus.
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
// GREGORIAN -> JDAY, JDAY -> GREGORIAN                                                                 //>
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
 

 function             bLeap(nYear){ return nYear%4 == 0   && ( nYear%100 != 0   ||  nYear%400 == 0 );  }//> Is Gregorian year a leap year or not?


 function               anYmdFromJd(//////////////////////////////////////////////////////////////////////> Convert Julian Day to Gregorian year, month, day.
                        a_jd            :Float                                                          //> Julian Day (immediately rounded down to previous midnight).
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


 function               sYmd(/////////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date string.
                        a_jd            :Float                                                          //> Julian Day (immediately rounded down to previous midnight).
 ){                                     //////////////////////////////////////////////////////////////////>
  var                   an              :Array<Int>             = anYmdFromJd( a_jd );                  //>
 return an[0]   +"-"+ ( "0"+an[1] ).substr(-2)   +"-"+   ( "0"+an[2] ).substr(-2);                      //>
 }//sYmd//////////////////////////////////////////////////////////////////////////////////////////////////>


 function               sYmdHms(//////////////////////////////////////////////////////////////////////////> Convert Julian Day to ISO date PLUS time string.
                        a_jd       :Float                                                               //> Julian Day (noon-night-noon)
 )                                 :String {//////////////////////////////////////////////////////////////>
  var                   n_jd       :Int   = Math.floor( a_jd );                                         //> .0 = noon, -0.5 = start of (normal Gregorian) day.
  var                   d          :Float =                    a_jd - n_jd; d =            24*d   - 12; //> -12 = noon, 0 = midnight, 12 = next noon
  if( d < 0 ){ d += 24; }                                                                               //> Basically fixing modulus issue?
  var                   nH         :Int   = Math.floor( d ); d =  d - nH  ; d =            60*d       ; //>
  var                   nM         :Int   = Math.floor( d ); d =  d - nM  ; d = Math.floor(60*d + 0.5); //>
 return sYmd(a_jd) +" "+ ("0"+nH).substr(-2) +":"+ ("0"+nM).substr(-2) +":"+ ("0"+d).substr(-2);        //>
 }//sYmdHms///////////////////////////////////////////////////////////////////////////////////////////////>


//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               avWinterLooks_Row_Over_Full(///////////////////////////////////////////////////////////> Run the "Hey Diddle Diddle" observational procedure from one date.
                        n_jd            :Int                                                            //> Julian Day to start on (start waiting for the new moon), as ISO formatted text (yyyy-mm-dd)
 ,                      a_nNights_days  :Int                                                            //> 7 or 8
 ,                      a_sWhenLook     :String                                                         //> "Moon", "MidN", or "Vega".
 ,                      a_sWhereLook    :String                                                         //> "Cani","Long"
 )                                      :Array<Dynamic> {/////////////////////////////////////////////////> Report text row, Over-line amount, Julian day of big night, number of days till next run of procedure.
  var                   asDaysData      :Array<String>          = _mapasDaysData[ n_jd +"jd" ];         //>
  if( null == asDaysData ){                   return ["*0 no data >"+ (n_jd +"jd") +"< "+ sYmd(n_jd) ];}//> Look up data for the given day. If there is a problem, like date isn't in table, then quit.
                                                                                                        //> trace("avWinterLooks_Row_Over_Full "+ a_sGo +" "+ n_jd +" "+ asDaysData);//>
  var                   whenGo_jd       :Int                    = n_jd;                                 //> Keep a copy of start day.
  var                   isStep          :Int                    = 0 ;                                   //> Step in Hey Diddle algorithm.
  var                   r_s             :String                 = "";                                   //> Output text, start from scratch.
  for( iNotUsed_Limit in 0...99 ){                                                                      //> Loop we promise to break out of, with a limit just in case.
   asDaysData    = _mapasDaysData[ n_jd +"jd" ];                                                        //> Look up data for the given date.
   if( null == asDaysData ){                        trace("???");         return ["*1 no data "+ n_jd];}//>
                                                                                                        //>  trace( asDaysData );
   if(       0 == isStep ){   isStep = 1;                                                               //> The very first time only...
    r_s    = asDaysData[ _iDAYSdATA_sDate ]                                                             //> +" = "+ sYmdHms( n_jd ) DEBUG    //> Report date and
             + ", mset,"+sYmdHms(  n_jd +Std.parseFloat( asDaysData[_iDAYSdATA_dMoonSet_h] )/24 -0.5  ) //> date/time of the moon set.
             +       ","+                                asDaysData[_iDAYSdATA_Moon_sDate]        ;     //>
   }//if                                                                                                //>
   if(       1 == isStep ){                                                                             //> If in first stage of algorithm...
    if(       Std.parseFloat( asDaysData[_iDAYSdATA_Moon_dLit_100] ) < 2   ){                           //> Look for new moon, if seeing it, go to next stage.
     isStep = 2;                                                                                        //>
    }//if                                                                                               //>
   }else{//  2 == isStep                                                                                //> In 2nd stage of algorithm, look
    if( 50 <= Std.parseFloat( asDaysData[_iDAYSdATA_Moon_dLit_100] )       ){                           //> for first gibbous illumination (50%+), when 
     r_s +=     ", gib,"+sYmdHms(  n_jd +Std.parseFloat( asDaysData[_iDAYSdATA_dMoonSet_h] )/24 -0.5  ) //>
             +       ","+                                asDaysData[_iDAYSdATA_Moon_sDate]        ;     //>
  break;//for                                                                                           //> get out of this loop
   }}//if//if                                                                                           //> .
   n_jd++;                                                                                              //> If staying in loop, then skip ahead.
  }//for                                                                                                //> .
                                                                                                        //>
  n_jd += a_nNights_days;                                                                               //> we skip ahead to the big night.
  asDaysData    = _mapasDaysData[ n_jd +"jd" ];                                                         //> Look up data for the given date.
  if( null == asDaysData ){                         trace("???");         return ["*2 no data "+ n_jd];}//>
                                                                                                        //>
  var                                   iDate                   = 0;                                    //> Indexes
  var                                   iDec                    = 0;                                    //> to use depending on                      
  var                                   iRa                     = 0;                                    //> the scheme we are testing.
  switch( a_sWhenLook ){                                                                                //> Depending on the scheme we are testing....
  case "Moon": iDate = _iDAYSdATA_Moon_sDate;  iDec = _iDAYSdATA_Moon_dDec;  iRa = _iDAYSdATA_Moon_dRa; //> Moonset
  case "MidN": iDate = _iDAYSdATA_MidN_sDate;  iDec = _iDAYSdATA_MidN_dDec;  iRa = _iDAYSdATA_MidN_dRa; //> Modern midnight
  case "Vega": iDate = _iDAYSdATA_Vega_sDate;  iDec = _iDAYSdATA_Vega_dDec;  iRa = _iDAYSdATA_Vega_dRa; //> Vega kissing the horizon
  }//switch                                                                                             //> ...
  r_s += ", full,"+ a_sWhenLook +","+ asDaysData[iDate] +","+ asDaysData[iDec] +","+ asDaysData[iRa];   //>
       // , full,   Moon          ,2000-03-22T07:19:46    ,-6.721736286863378    ,-152.88917086184642   //>
                                                                                                        //>
  var                   d_360           :Float                  = 0;                                    //> See if full moon has crossed from Taurus to Gemini.
  switch( a_sWhereLook ){                                                                               //>
  case "Cani": d_360 = dOverLine_360( Std.parseFloat( asDaysData[iDec] )                                //> See if full moon has crossed "little dog" line or not.
                       ,              Std.parseFloat( asDaysData[iRa ] )                                //>
                       );                                                                               //>
  case "Long": d_360 =  90 - Std.parseFloat( asDaysData[iRa ] ); if( 180 < d_360 ){ d_360 -= 360; }     //> See if full moon has crossed 90 degree right ascension.
  case "Lon2": d_360 = 120 - Std.parseFloat( asDaysData[iRa ] ); if( 180 < d_360 ){ d_360 -= 360; }     //> See if full moon has crossed 120 degree right ascension.
  }//switch                                                                                             //>
  r_s += "        ,"+ d_360 +","+ n_jd;                                                                 //>
//trace( r_s );                                                                                         //>
return [r_s ,d_360 ,n_jd];                                                                              //>
 }//avWinterLooks_Row_Over_Full///////////////////////////////////////////////////////////////////////////>


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
   asRow    = [ asCell[ 0]              // _iDAYSdATA_sDate         =  0;                               //> sDate         ,1999-12-31T12:00:00  First cell is nYear as text in ISO format yyyy-mm-dd. 
              , asCell[ 1]              // _iDAYSdATA_nDay_jd       =  1;                               //> a_nDay_jd     ,2451544              Numeric version of key.
              , asCell[ 2]              // _iDAYSdATA_dSunSet_h     =  2;                               //> dSunSet_h     ,16.026944444444442 
              , asCell[ 3]              // _iDAYSdATA_dSunRise_h    =  3;                               //> dSunRise_h    ,32.06888888888889 
              , asCell[ 4]              // _iDAYSdATA_dMoonRise_h   =  4;                               //> r_dMoonRise_h ,26.668333333333333 
              , asCell[ 5]              // _iDAYSdATA_dMoonSet_h    =  5;                               //> dMoonSet_h    ,37.220555555555556 
              , asCell[ 6]              // _iDAYSdATA_Moon_sDate    =  6;                               //> Moon_sDate    ,2000-01-01T13:13:14 
              , asCell[ 7]              // _iDAYSdATA_Moon_dLit_100 =  7;                               //> dLit_100      ,22.799720764160156 
              , asCell[ 8]              // _iDAYSdATA_Moon_dRa      =  8;                               //> dRa           ,-137.51418852173234 
              , asCell[ 9]              // _iDAYSdATA_Moon_dDec     =  9;                               //> dDec          ,-11.811177408287486 
              , asCell[10]              // _iDAYSdATA_MidN_sDate    = 10;                               //> MidN_sDate    ,2000-01-01T00:00:00 
              , asCell[11]              // _iDAYSdATA_MidN_dLit_100 = 11;                               //> dLit_100      ,26.628517150878906 
              , asCell[12]              // _iDAYSdATA_MidN_dRa      = 12;                               //> dRa           ,-142.82009664343948 
              , asCell[13]              // _iDAYSdATA_MidN_dDec     = 13;                               //> dDec          ,-9.647356542776926 
              , asCell[14]              // _iDAYSdATA_Vega_sDate    = 14;                               //> Vega_sDate    ,1999-12-31T23:59:50 
              , asCell[15]              // _iDAYSdATA_Vega_dLit_100 = 15;                               //> dLit_100      ,26.629600524902344 
              , asCell[16]              // _iDAYSdATA_Vega_dRa      = 16;                               //> dRa           ,-142.82155355617718 
              , asCell[17]              // _iDAYSdATA_Vega_dDec     = 17;                               //> dDec          ,-9.646872946743024 
              ];                                                                                        //>
   _mapasDaysData[ sKeyJDay ] = asRow;                                                                  //> Keep row of data in RAM table, keyed with ISO format date.
  }//for i                                                                                              //>
 }//Go_ReadMapasDataFromFile//////////////////////////////////////////////////////////////////////////////>


//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>

 
 function               TEST_nYearFromJd(/////////////////////////////////////////////////////////////////>
 )                                      :Int {////////////////////////////////////////////////////////////>
  var                   n               :Int                    = 0;                                    //>
  var                   d               :Float                  = 0.;                                   //>
  for( y in -4172...2100 ){                                                                             //>
   d = dJDayFromYms_jd(y,1,1); n =nYearFromJd(d); if( y != n ){ trace("TEST_nYearFromJd "+n); return 1;}//> Test that this is the inverse of a known good function.
  }//for y                                                                                              //>
 return 0;                                                                                              //>
 }//nYearFromJd///////////////////////////////////////////////////////////////////////////////////////////>


 function               TEST_dDate_jd(////////////////////////////////////////////////////////////////////> Test the above function.
 )                                      :Int {////////////////////////////////////////////////////////////> Report 0 if no problems.
//. TODO - Make more sense of the following:                                                            //>
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


 function               TEST_anYmdFromJd(/////////////////////////////////////////////////////////////////> Test: Convert Julian Day to Gregorian year, month, day.
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
                                                                  ,                an[1]                //> Month. Jan = 1, Dec = 12
                                                                  ,                an[2]                //> Day. 1st = 1
                                                                  );                                    //>
   if( 0 == d%50000 ){ trace( sYmd(d) +" "+ an ); }                                                     //> Progress indication.
   if( d != d1 ){                                         trace("mismatch "+ d +" "+ d1); return d+100;}//>
  }//for d                                                                                              //>
 return 0;                                                                                              //>
 }//TEST_anYmdFromJd//////////////////////////////////////////////////////////////////////////////////////>


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


//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


 function               Go_TESTs(/////////////////////////////////////////////////////////////////////////> Main execution starts here.
 )                                      :Int {////////////////////////////////////////////////////////////>
  if( 0 < TEST_dDate_jd()    ){                                                               return 1;}//> TESTS:
  if( 0 < TEST_nYearFromJd() ){                                                               return 1;}//>
  if( 0 < TEST_anYmdFromJd() ){                                                               return 1;}//>
  if( 0 < TEST_sYmd()        ){                                                               return 1;}//> Test: Convert Julian Day to ISO date string.
  if( 0 < TEST_sYMDhms()     ){                                                               return 1;}//>
 return 0;                                                                                              //>
 }//Go_TESTs//////////////////////////////////////////////////////////////////////////////////////////////>


 function               Go_ReadData(//////////////////////////////////////////////////////////////////////> Main execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
  for( y in 2000...2100 ){   Go_ReadMapasDataFromFile( '2000_2099/table012_' + y +'.csv' );   }         //> For a century... Get data from each file, put in global table.
  for( y in 1000...1100 ){   Go_ReadMapasDataFromFile( '1000_1099/table012_' + y +'.csv' );   }         //> For a century... Get data from each file, put in global table.
  for( y in 1100...1200 ){   Go_ReadMapasDataFromFile( '1100_1199/table012_' + y +'.csv' );   }         //> "
  for( y in 1200...1300 ){   Go_ReadMapasDataFromFile( '1200_1299/table012_' + y +'.csv' );   }         //> "
  for( y in 1300...1379 ){   Go_ReadMapasDataFromFile(  '1300_1399/table012_'+ y +'.csv' );   }         //> "
  for( y in 1379...1400 ){   Go_ReadMapasDataFromFile(  '1300_1399/table013_'+ y +'.csv' );   }         //> " Format change?
  for( y in 1400...1470 ){   Go_ReadMapasDataFromFile(  '1400_1499/table013_'+ y +'.csv' );   }         //> " Format change?
 }//Go_ReadData///////////////////////////////////////////////////////////////////////////////////////////>


 function               Go(///////////////////////////////////////////////////////////////////////////////> Main execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
//if( 0 < Go_TESTs() ){                                                                         return;}//>
  Go_ReadData();                                                                                        //> READING DATA:
                                                                                                        //> RUNNING TRIALS:
  var                   d               :Float                  = 0;                                    //> Short-term utility.
  var                   sRow            :String                 = "";                                   //> Report text row
  var                   dOver           :Float                  = 0.;                                   //> Over-line amount (between Gemini and Taurus)
  var                   nFullMoon_jd    :Int                    = 0 ;                                   //> Julian day of big night - offset from some date-of-the-Gregorian-year to prevent discontinuity of new year.
  var                   nNextYear_days  :Int                    = 0 ;                                   //> number of days till next run of procedure.
  var                   a2vPasses       :Array<Array<Dynamic>>  =                                       //> Table of parameters to use in several trials:
        [[7,"Moon","Cani",-99999,99999] ,[7,"MidN","Cani",-99999,99999] ,[7,"Vega","Cani",-99999,99999] //>
        ,[7,"Moon","Long",-99999,99999] ,[7,"MidN","Long",-99999,99999] ,[7,"Vega","Long",-99999,99999] //>
        ,[7,"Moon","Lon2",-99999,99999] ,[7,"MidN","Lon2",-99999,99999] ,[7,"Vega","Lon2",-99999,99999] //>
        ,[7,"Vega","Cani",    1,99999]                                                                  //> Require at least 1 normal year between leap years.
        ,[7,"Vega","Cani",    1,   2]                                                                   //> Require at least 1 normal year and at most 2, between leap years.
        ,[0,"Math",""    ,-99999,99999]                                                                 //>
        ,[8,"Moon","Cani",-99999,99999] ,[8,"MidN","Cani",-99999,99999] ,[8,"Vega","Cani",-99999,99999] //>
        ,[8,"Moon","Long",-99999,99999] ,[8,"MidN","Long",-99999,99999] ,[8,"Vega","Long",-99999,99999] //>
        ,[8,"Moon","Lon2",-99999,99999] ,[8,"MidN","Lon2",-99999,99999] ,[8,"Vega","Lon2",-99999,99999] //>
        ];                                                                                              //>
  var                   dYEAR_days      :Float                  = 365.242189;                           //> Mean tropical year (Laskar's expression)
  var                   dMONTH_days     :Float                  = 29 + 12/24 + 44/60/24 + 2.9/60/60/24; //> Synodic month.
//.  var                   n12             :Int                    = 0;                                 //>
//.  sRow = "";                                                                                         //>
//.  var                   y               :Int                    = 0;                                 //>
//.  for( m in 0...12000 ){                                                                             //>
//.   d += dMONTH_days; n12++;                                                                          //>
//.   if( dYEAR_days < d ){                                                                             //>
//.    sRow += 12 == n12   ?" "   :"*";                                                                 //> Show normal or leap year.
//.    if( 0 == y%(19*1) ){   trace( (1000+y/19) + ">"+ sRow +sRow +"<"); sRow = "";   }                //> Make it easier to see 19-year Metonic cycles.
//.    y++;   d -= dYEAR_days;   n12 = 0;                                                               //> Count up year, adjust the day number back a solar year, reset month count.
//.  }}//if//for y                                                                                      //>
                                                                                                        //>
  for( avPass in a2vPasses ){                                                                           //>
   var                  nNights_days    = avPass[0];                                                    //> Parameters to test in this pass - the count from first quarter moon to full.
   var                  sWhenGibbous    = avPass[1];                                                    //> When during night to apply the crescent/gibbous test.
   var                  sWhereLook      = avPass[2];                                                    //> How to draw the line between Taurus and Gemini.
   var                  nMinJump_yr     = avPass[3];                                                    //> Minimum number of normal years between leap years.
   var                  nMaxJump_yr     = avPass[4];                                                    //> Miximum number of normal years between leap years.
   for( dYear0 in 1000...1001 ){                                                                        //> For each year in a test run (starting with different years just to mix things up for testing)...
    sRow = "";                                                                                          //>
    var                 sReport         :String                 = "";                                   //> Initialize the output text string.
    var                 av              :Array<Dynamic>         = [];                                   //>
    var                 dS0             :Float                  = 0;                                    //> STATS:
    var                 dS1             :Float                  = 0;                                    //>
    var                 dS2             :Float                  = 0;                                    //>
    var                 dMin            :Float                  =  999999.;                             //>
    var                 dMax            :Float                  = -999999.;                             //>
    var                 sPattern        :String                 = "";                                   //> Generate the pattern of leap/non-leap years.
                                                                                                        //>
    var                 n_jd            :Int          = Math.floor( dJDayFromYms_jd( dYear0 ,12,31 ) ); //> Convert Gregorian date to a Julian Day, the number of days that have passed since the Julian Date Epoch.  Gregorian Year,
    var                 nSinceLeap_yr   :Int                    = 1;                                    //>
    var                 sLeap           :String                 = "";                                   //>
    var                 dMoons_days     :Float                  = 0;                                    //> For modern math-based lunar leap month determination.
    for( dYearRun in 0...100 ){                                                                         //> Run observations for 100 years in a row  (hoping they converge on a winter date)...
     if( 0 == nNights_days ){                                                                           //> If the math-based procedure is being tried, then
      dMoons_days += 12*dMONTH_days - dYEAR_days;                                                       //>
      if( dMoons_days < 0 ){ dOver =  1; dMoons_days += dMONTH_days; }                                  //>
      else                 { dOver = -1;                             }                                  //>
      nFullMoon_jd  =  0;                                                                               //> From Nov 24?
     }else{                                                                                             //> For any observational procedure...
                      av = avWinterLooks_Row_Over_Full( n_jd ,nNights_days ,sWhenGibbous ,sWhereLook ); //> Run the "Hey Diddle Diddle algorithm" from one starting date. Add a row to the results.  The next date to start observations is given in the last cell of the row.
      sRow          = av[0];                                                                            if( "*" == sRow.substr(0,1) ){ trace("what????????? "+ n_jd +" "+ sRow); } //> Reported text row.
      dOver         = av[1];                                                                            //> Over-the-finish-line amount.
      nFullMoon_jd  = av[2];                                                                            //> Julian day of big night.
     }//if nNights_days                                                                                 //>
     n_jd           = nFullMoon_jd + 354 - 17;                                                          //>
                                                                                                        //>
     if( 0 < dOver ){                                                                                   //> If a leap year is suggested...
                      if( nSinceLeap_yr < nMinJump_yr  ){ nSinceLeap_yr++  ;             sLeap = " "; } //> No leap until we are past minimum normal years between leaps.
                      else                              { nSinceLeap_yr = 0; n_jd += 29; sLeap = "*"; } //> Otherwise, follow suggestion of a leap year, and restart count between leap years.
     }else{                                                                                             //> If leap year is not suggested...
                      if( nSinceLeap_yr < nMaxJump_yr  ){ nSinceLeap_yr++  ;             sLeap = " "; } //> follow suggestion of no leap year if less than maximum allowed.
                      else                              { nSinceLeap_yr = 0; n_jd += 29; sLeap = "*"; } //> But if at maximum, use a leap year anyway.
     }//if                                                                                              //>
     if( 10 <= dYearRun ){                                                                              //> Ignoring the first decade when things are getting into long-term sync...
      if( 0 == nNights_days ){                                                                          //> If the math-based procedure is being tried, then
       d = dMoons_days + 113;                                                                           //> Get fractional part of year, in days. Add an offest to adjust average date to winter solstice.
      }else{                                                                                            //>
       d = (nFullMoon_jd + 100)/dYEAR_days;   d = d - Math.floor(d);   d *= dYEAR_days;                 //> Get fractional part of year, in days. Add an offest to avoid discontinuity at Nov 24.
      }//if                                                                                             //>
      dS0           += 1;                                                                               //> Stats
      dS1           += d;                                                                               //>
      dS2           += d*d;                                                                             //>
      if(    d < dMin ){ dMin = d; }                                                                    //>
      if( dMax < d    ){ dMax = d; }                                                                    //>
      sPattern      += sLeap;                                                                           //>
      sReport       += "\n"+ sRow.substr(0,50) +"   "+ d;                                               //>
     }//if                                                                                              //>
    }//for dYearRun                                                                                     //>
    //trace( sReport );                                                                                 //>
    trace(                        ( avPass   +"                   " ).substr(0,28)                      //>
                 +",  Max-min," + ( (dMax - dMin)+"               " ).substr(0,16)                      //> Max range.
                  +" ,N,"       + dS0                                                                   //>
                  +" ,Ave,"     + sYmdHms(dS1/dS0 - 100)                                                //> Average date is corrected for the offset added earlier.
                  +" ,StDev,"   + (                                                                     //>
                                    Math.sqrt(   (dS0*dS2 - dS1*dS1)                                    //>
                                                 /( dS0*(dS0 - 1) )                                     //>
                                    )            +"               "                                     //>                
                                  ).substr(0,16)                                                        //>
                  +" ,Pattern,'"+ sPattern +"'"                                                         //>
    );                                                                                                  //>
  }}//for dYear0//for avPass                                                                            //>
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
