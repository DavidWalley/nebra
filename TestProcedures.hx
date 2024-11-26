// TestProcedures.hx - test various procedures for syncing lunar calendar, using pre-calculated data files.
// (c)2024 David C. Walley


// In a UBUNTU terminal (ctrl+alt+T):
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
  var                   _mapasData             = new Map<String,Array<String>>();                       //>


 function               Go_OneFile(///////////////////////////////////////////////////////////////////////> Get data from one file, put in global table.
                        a_sFile                                                                         //>
 )                                      {/////////////////////////////////////////////////////////////////>
  var                   sData           :String         = sys.io.File.getContent(_sPathData + a_sFile); //> Copy from money source directory
  var                   asLines                         = sData.split('\n');                            //>
  var                   r_s                             = "";                                           //>
  var                   n                               = asLines.length;                               //>
  var                   as                              = [];                                           //>
  var                   s                               = "";                                           //>
  var                   asRow           :Array<String>  = [];                                           //> Move to RAM:
  for( i in 2...n ){                                                                                    //>
   as = asLines[i].split(",");                                                                          //> Split line on commas.
   s = (    as[0] ).substr(0, 10);                                                                      //>
   asRow = [                                                                                            //> Move to RAM:
         //,as[1 ]                                                                                      //> sDate   1999-12-31T12:00:00   nDay                ,2451544 
         //,as[2 ]                                                                                      //> Sunset              ,16.026944444444442 
         //,as[3 ]                                                                                      //> Sunrise             ,32.06888888888889 
         //,as[4 ]                                                                                      //> Moonrise            ,26.668333333333333 
         //,as[5 ]                                                                                      //> Moonset             ,37.220555555555556 
            as[6 ]              // 0                                                                    //> MOON_when           ,2000-01-01T13:13:14 
           ,as[7 ]              // 1                                                                    //> illumination        ,22.799720764160156 
           ,as[8 ]              // 2                                                                    //> ra                  ,-137.51418852173234 
           ,as[9 ]              // 3                                                                    //> dec                 ,-11.811177408287486 
         //,as[10]                                                                                      //> TIME_when           ,2000-01-01T00:00:00 
         //,as[11]                                                                                      //> illumination        ,26.628517150878906 
         //,as[12]                                                                                      //> ra                  ,-142.82009664343948 
         //,as[13]                                                                                      //> dec                 ,-9.647356542776926 
         //,as[14]                                                                                      //> VEGA_when           ,1999-12-31T23:59:50 
         //,as[15]                                                                                      //> illumination        ,26.629600524902344 
         //,as[16]                                                                                      //> ra                  ,-142.82155355617718 
         //,as[17]                                                                                      //> dec                 ,-9.646872946743024 
           ];                                                                                           //>
   _mapasData[ s ] = asRow;                                                                             //> Move to RAM: sDate   1999-12-31T12:00:00   nDay                ,2451544 
  }//for i                                                                                              //>
//. try{                                                                                                  //> to
//.  sys.io.File.saveContent(  _sPathOut  +'output.csv'                                                   //>
//.  ,                         r_s                                                                        //> "
//.  );                                                                                                   //> .
//. }catch( e:haxe.Exception ){                                                                           //> If there is a problem, then
//.  trace(e.message);                                                                                    //> report it
//.  trace(e.stack);                                                                                      //> "
//. }//try                                                                                                //> .
 }//Go_OneFile////////////////////////////////////////////////////////////////////////////////////////////>
//  var                   sYYYY           = "";                                                         //>
//  var                   sMM             = "";                                                         //>
//  var                   sDD             = "";                                                         //>
//  var                   sHr             = "";                                                         //>
//  var                   sMin            = "";                                                         //>
//  var                   sS              = "";                                                         //>
// sYYYY = as[0].substr( 0, 4);   sMM   = as[0].substr( 5, 2);   sDD   = as[0].substr( 8, 2);           //> Parse date.
// r_s +="\n"+ sYYYY +","+ sMM +","+ sDD;
 //sYYYY = as[6].substr( 0, 4);   sMM   = as[6].substr( 5, 2);   sDD   = as[6].substr( 8, 2);
 //sHr   = as[6].substr(11, 2);   sMin  = as[6].substr(14, 2);   sS    = as[6].substr(17, 2);           //> Parse time
 //r_s +="\n"+ sYYYY +","+ sMM +","+ sDD +","+ sHr +","+ sMin +","+ sS;

 
 function               dOverLine_360(////////////////////////////////////////////////////////////////////> Test which side of great circle defined by Canis Minor a given point is.
                        a_Qlat_360      :Float                                                          //> Declination and
 ,                      a_Qlong_360     :Float                                                          //> Right Ascension of point to test.
 )                                      {/////////////////////////////////////////////////////////////////>
 // let                                 latA                    = a_Alat_360 *Math.PI/180;              //> Code to find constants for Procyon and Gomeisa latitude) of the first point
 // let                                 longA                   = a_Along_360*Math.PI/180;              //> Polar coordinates (longitude and
 // let                                 xA                      = Math.cos(latA)*Math.cos(longA);       //>
 // let                                 yA                      = Math.cos(latA)*Math.sin(longA);       //>
 // let                                 zA                      = Math.sin(latA)                ;       //>
 // let                                 latB                    = a_Blat_360 *Math.PI/180;              //> latitude) of the first point
 // let                                 longB                   = a_Blong_360*Math.PI/180;              //> Polar coordinates (longitude and
 // let                                 xB                      = Math.cos(latB)*Math.cos(longB);       //>
 // let                                 yB                      = Math.cos(latB)*Math.sin(longB);       //>
 // let                                 zB                      = Math.sin(latB)                ;       //>
 // core.output( "dOverLine_360, "+ xA +", "+  yA +", "+  zA );                                         //>
 // core.output( "dOverLine_360, "+ xB +", "+  yB +", "+  zB );                                         //>
  var                                   xA                      = -0.41812783213741955;                 //> Pre-calculated values for Procyon
  var                                   yA                      =  0.9038249325942993 ;                 //> "
  var                                   zA                      =  0.09093738072416822;                 //> and
  var                                   xB                      = -0.36737866131120084;                 //> Gomeisa
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
 return r_d_360;                                                                                        //> Report distance from point to dividing line defined by Canis Minor.
 }//dOverLine_360/////////////////////////////////////////////////////////////////////////////////////////>


 function               sRunTrial(////////////////////////////////////////////////////////////////////////> Run the HeyDiddleDiddle algorithm from one date.
                        a_sGo                                                                           //>
 )                                      :String {/////////////////////////////////////////////////////////>
  var                   dDAY_ms         :Float                  = 24*60*60*1000.;                       //> One day, in milliseconds.
  var                   as              :Array<String>          = _mapasData[ a_sGo ];                  //> Look up data for the given date.
  if( null == as ){                                                                         return "*";}//> If there is a problem, then quit.
  var                   dateGo                   = new Date( Std.parseInt( a_sGo.substr(    0, 4) )     //> Parse date string for the moonset. Year
                                                       ,     Std.parseInt( a_sGo.substr(    5, 2) ) - 1 //> Month (0-11)
                                                       ,     Std.parseInt( a_sGo.substr(    8, 2) )     //> Date (1-31)
                                                       ,     12 , 0 , 0                                 //> second
                                                       );                                               //>
  var                   sMoonset        :String                 = "";                                   //> 
  var                   dLit_100        :Float                  = 0.;                                   //> Illumination in percent.
  var                   dRa             :Float                  = 0.;                                   //>
  var                   dDec            :Float                  = 0.;                                   //>
  var                   dateRow                                 = Reflect.copy( dateGo );               //>
  var                   isStep          :Int                    = -1;                                   //>
  var                   isLeap          :Int                    = -1;                                   //>
  var                   dSkipAhead_days :Float                  =  1.;                                  //>
  var                   sRow            :String                 = "";                                   //>
  while( isStep < 99 ){                                                                                 //>
   dSkipAhead_days = 1.;                                                                                //> Default is 1 loop = 1 day.
   as = _mapasData[ DateTools.format( dateRow ,"%Y-%m-%d" ) ];                                          //> Look up data for the given date.
   if( null == as ){      trace("???");                                                          break;}//>
   sMoonset    =                 as[0]  ;                                                               //> 
   dLit_100    = Std.parseFloat( as[1] );                                                               //> At Moonset
   dRa         = Std.parseFloat( as[2] );                                                               //> At Moonset
   dDec        = Std.parseFloat( as[3] );                                                               //> At Moonset
   var                  dateMoonset     = new Date( Std.parseInt( sMoonset.substr( 0, 4) )              //> Parse date string for the moonset. Year
                                              ,     Std.parseInt( sMoonset.substr( 5, 2) ) - 1          //> Month (0-11)
                                              ,     Std.parseInt( sMoonset.substr( 8, 2) )              //> Date (1-31)
                                              ,     Std.parseInt( sMoonset.substr(11, 2) )              //> 24 hour
                                              ,     Std.parseInt( sMoonset.substr(14, 2) )              //> minute
                                              ,     Std.parseInt( sMoonset.substr(17, 2) )              //> second
                                              );                                                        //>
   if(      -1 == isStep ){ isStep = 0;                                                                 //> The very first time, move on to next step immediately                                                                            //> First time,
                            sRow =            DateTools.format( dateRow     ,"%Y-%m-%d %H:%M:%S" )      //>
                                  +",mset, "+ DateTools.format( dateMoonset ,"%Y-%m-%d %H:%M:%S" );     //> we will display the date/time of the moon set.
   }//if                                                                                                //>
   if(       0 == isStep ){                                                                             //>
    if( dLit_100 < 2   ){   isStep++;   }                                                               //> Look for new moon.  
   }else if( 1 == isStep ){                                                                             //> In next step, look
    if( 50 <= dLit_100 ){   isStep++;   dSkipAhead_days = 7.;                                           //> for first gibbous, when we count ahead 7 nights.
                            sRow += ",gib, "+ DateTools.format( dateMoonset ,"%Y-%m-%d %H:%M:%S" );     //>
    }//if                                                                                               //>
   }else{                                                                                               //>
  break;//while                                                                                         //>
   }//if                                                                                                //>
   dateRow = DateTools.delta( dateRow ,dSkipAhead_days*dDAY_ms );                                       //> Next day
  }//while                                                                                              //>
                                                                                                        //>
  var                   d_360           :Float                  = dOverLine_360(dDec,dRa);              //>
  if( d_360 < 0 ){                                                                                      //>
   dateRow = DateTools.delta( dateRow ,337.*dDAY_ms );                                                  //>
   sRow += ",337, "+ DateTools.format(dateRow,"%Y-%m-%d");                                              //>
  }else{                                                                                                //>
   dateRow = DateTools.delta( dateRow ,366.*dDAY_ms );                                                  //>
   sRow += ",366, "+ DateTools.format(dateRow,"%Y-%m-%d");                                              //>
  }//if                                                                                                 //>
 return sRow;                                                                                           //>
 }//sRunTrial/////////////////////////////////////////////////////////////////////////////////////////////>


// Letter to the Editor published in Communications of the ACM in October 1968 (Volume 11, Number 10). https://blog.reverberate.org/2020/05/12/optimizing-date-algorithms.html
// Henry F. Fliegel and Thomas C. Van Flandern offered the following Fortran function for yyyy,m,d to JulianDay
// This function uses integer math (all divisions round down):
// This epoch is very long ago, in 4713 BC, but it’s a simple matter to convert it to the Unix epoch of 1970-01-01 by subtracting 2440588, the Julian Day number of the Unix Epoch. 
function                                JD(///////////////////////////////////////////////////////////////> JD here refers to the Julian Date, the number of days that have passed since the Julian Date Epoch.
                                        Y                                                               //>
,                                       M                                                               //>
,                                       D                                                               //>
){                                      //////////////////////////////////////////////////////////////////>
  let                                   A                       = Math.floor( (M - 14)/12 );            //>
  let                                   B                       = Y + 4800 + A;                         //>
return D - 32075 + 367*Math.floor(       (M - 2 - A*12)/12 )                                            //>
                 +     Math.floor(           1461*B     /4 )                                            //>
                 -   3*Math.floor( Math.floor(1 + B/100)/4 );                                           //>
}//JD/////////////////////////////////////////////////////////////////////////////////////////////////////>
// JD (I, J, K) = K - 32075 + 1461*(I + 4800 + (J - 14)/12)/4
//                                                           + 367*(J - 2 - (J - 14)/12*12)/12 - 3
//                                                                                                *((I + 4900 + (J - 14)/12)/100)/4
// JD(I, J, K) = K - 32075 + 1461*(I + 4800 + (J - 14)/12)/4 + 367*(J - 2 - (J - 14)/12*12)/12 - 3*((I + 4900 + (J - 14)/12)/100)/4
// JD(Y, M, D) = D - 32075 + 1461*( Y + 4800 +             (M - 14) /12  )/4 + 367*(M - 2 -             (M - 14) /12 *12)/12 - 3*((Y + 4900 + (M - 14)/12)/100)/4
// JD(Y, M, D) = D - 32075 + 1461*( Y + 4800 + Math.floor( (M - 14) /12) )/4 + 367*(M - 2 - Math.floor( (M - 14) /12)*12)/12 - 3*((Y + 4900 + (M - 14)/12)/100)/4
// JD(Y, M, D) = D - 32075 + 1461*( Y + 4800 + Math.floor( (M - 14) /12) )/4 
//                          + 367*(    M - 2 - Math.floor( (M - 14) /12)*12)/12 
//                            - 3*(   ( Y + 4900 + (M - 14)/12 )/100   )/4
// JD(Y, M, D) = D - 32075 + 1461*( Y + 4800 +                               Math.floor( (M - 14) /12) )/4 
//                          + 367*Math.floor(   (                    M - 2 - Math.floor( (M - 14) /12)*12    )   /12) 
//                            - 3*Math.floor(   (   Math.floor( ( Y + 4900 + Math.floor( (M - 14) /12) ) /100)           )    /4)
// 
// let A = Math.floor( (M - 14) /12);
// let B = Y + 4800 + A;
// JD(Y, M, D) = D - 32075 +                       Math.floor( 1461*( B ) /4) 
//                          + 367*Math.floor(   (                    M - 2 - A*12    )   /12) 
//                            - 3*Math.floor(   (   Math.floor( ( 100 + B ) /100)           )    /4)
// 
// JD(Y, M, D) = D - 32075 + Math.floor(1461*B/4) + 367*Math.floor( (M - 2 - A*12)/12 ) - 3*Math.floor( Math.floor(1+B/100)/4 )


 function               Go(///////////////////////////////////////////////////////////////////////////////> Create source from $ code, replacing macros.
 )                                      :Void {///////////////////////////////////////////////////////////>
  for( y in 2000...2100 ){                                                                              //>
   Go_OneFile( 'table012_'+ y +'_'+ (y + 1) +'.csv' );                                                  //> Get data from one file, put in global table.
  }//for y                                                                                              //>
                                                                                                        //>
  for( y in 2000...2001 ){                                                                              //>
   var                  s1              :String                 = y +'-02-15';
   var                  sReport         :String                 = "";
   for( z in 0...90 ){ 
    s1 = sRunTrial( s1 );  sReport += "\n "+ s1;  s1 = s1.substr(-10);  
   }//for z
   trace(sReport);
   
//   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
//   s1 = sRunTrial( s1 );   s1 = s1.substr(-10);   trace(s1);
// trace(   sRunTrial( y +'-10-15' )   );                                                               //>
// trace(   sRunTrial( y +'-11-01' )   );                                                               //>
// trace(   sRunTrial( y +'-11-15' )   );                                                               //>
// trace(   sRunTrial( y +'-12-01' )   );                                                               //>
// trace(   sRunTrial( y +'-12-15' )   );                                                               //>
// trace(   sRunTrial( y +'-01-01' )   );                                                               //>
// trace(   sRunTrial( y +'-01-15' )   );                                                               //>
// trace(   sRunTrial( y +'-02-01' )   );                                                               //>
   trace("");                                                                                           //>
  }//for y                                                                                              //>
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