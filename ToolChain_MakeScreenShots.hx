// ToolChain_MakeScreenShots.hx - Bodge code to create/copy Stellarium script for generating sky disc views.
// (c)2024 David C. Walley

// THE FOLLOWING IS NOT SOURCE CODE. THESE ARE MY NOTES!


class ToolChain_MakeScreenShots //////////////////////////////////////////////////////////////////////////> For a stellarium script:
{/////////////////////////////////////////////////////////////////////////////////////////////////////////>

  var                   _sPathMoney       :String               = "/home/dave/Desktop/CODE/nebra/";     //> Money code directory.
  var                   _sPathStellarium  :String               = "/home/dave/Desktop/";                //> Generated "source code" directory (by Stellarium).



 function               new(//ToolChain_MakeScreenShots///////////////////////////////////////////////////> Main procedure of this class.
 )                                :Void {/////////////////////////////////////////////////////////////////> Report nothing.
  var                   sContent  :String = sys.io.File.getContent(_sPathMoney +'MakeScreenShots.ssc'); //> Copy from money source directory
  sContent = StringTools.replace(sContent ,"€VERSION" ,Sys.args()[0] );                                 //> PREPROCESS: Replace all occurrences of the String sub in the String s by argument from command line.
  try{                                                                                                  //> to
   sys.io.File.saveContent(                                   _sPathStellarium +'MakeScreenShots.ssc'   //> a directory slightly easier to reload from within Stellarium
   ,                    sContent                                                                        //> "
   );                                                                                                   //> .
  }catch( e:haxe.Exception ){                                                                           //> If there is a problem, then
   trace(e.message);                                                                                    //> report it
   trace(e.stack);                                                                                      //> "
  }//try                                                                                                //> .

//Sys.command("cd ~/Desktop/CODE/nebra \n &&  haxe --neko TEMP_neko.n --main ToolChain_MakeScreenShots &&  neko TEMP_neko.n FRAMES "); //# Make frames in Stellarium. ###frames1, output to USB
  Sys.command(                           "wmctrl -a 'Stellarium 24.4'"                               ); //>
  Sys.command( "xdotool search --onlyvisible --name 'Stellarium 24.4' windowsize 1336 1400 windowmove 0 0" );//. &&  sleep 1 && 
  Sys.command( "sleep 1"); Sys.command("xdotool key Escape");                                           //>
  Sys.command( "sleep 1"); Sys.command("xdotool key Escape");                                           //>
  Sys.command( "sleep 1"); Sys.command("xdotool key Escape");                                           //>
  Sys.command( "sleep 1"); Sys.command("xdotool key F12");                                              //>
  Sys.command( "sleep 1"); Sys.command("xdotool mousemove "+                   (1366 +  20) +" 80");    //>
  Sys.command( "sleep 1"); Sys.command("xdotool click 1");                                              //>
  Sys.command( "sleep 1"); Sys.command("xdotool key Return");                                           //>
  var                   s               :String             = "/home/dave/Desktop/MakeScreenShots.ssc"; //>
  var                   n               :Int                = s.length;                                 //>
  Sys.command("sleep 1");
  for( i in 0...n ){                                                                                    //>
   trace( s.charAt(i) );                                                                                //>
   switch( s.charAt(i) ){                                                                               //>
   case "/":     Sys.command("sleep 0.04"); Sys.command("xdotool key slash"                       );    //>
   case ".":     Sys.command("sleep 0.04"); Sys.command("xdotool key period"                      );    //>
   default :     Sys.command("sleep 0.04"); Sys.command("xdotool key " + s.charAt(i)              );    //>
  }}//switch//for i                                                                                     //>
  trace( "47" ); Sys.command("sleep 1"   ); Sys.command("xdotool key Return"                      );    //>
  trace( "48" ); Sys.command("sleep 1"   ); Sys.command("xdotool mousemove "+  (1366 + 510) +" 80");    //>
  trace( "49" ); Sys.command("sleep 1"   ); Sys.command("xdotool click 1"                         );    //>
  trace( "50" ); Sys.command("sleep 1"   );                                                             //>
  trace("That should be it.");                                                                          //>
 }//new ToolChain_MakeScreenShots/////////////////////////////////////////////////////////////////////////>


 static public function main(/////////////////////////////////////////////////////////////////////////////> Execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
  #if sys                                                                                               //> Just check.
   trace("file system can be accessed");                                                                //>
  #end                                                                                                  //>
  new ToolChain_MakeScreenShots();                                                                      //> Create and run and instance of main code.
 }//main//////////////////////////////////////////////////////////////////////////////////////////////////>

}//class ToolChain_MakeScreenShots////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


//End of file
