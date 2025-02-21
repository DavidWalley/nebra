// ToolChain_MakeScreenShots.hx - Bodge code to create/copy Stellarium script for generating sky disc views.
// (c)2024 David C. Walley

// THE FOLLOWING IS NOT SOURCE CODE. THESE ARE MY NOTES!

//copy ALIGNMENT PNGs: Stellarium Screenshots for showing alignments of constellations and the Nebra Sky Disc
//copy ===============
//copy 2a)  Open Stellarium. Ensure application window is NOT maximized or full screen. Stop any running script. Open script dialog box has to be resized to minimum allowed width. CAPS LOCK off.
//copy         cd ~/Desktop/CODE/nebra && haxe --neko TEMP_neko.n --main ToolChain_MakeScreenShots && neko TEMP_neko.n ALIGNMENTS && sleep 1 && wmctrl -a 'Stellarium 24.3' && sleep 1 search --onlyvisible --name 'Stellarium 24.3'&& sleep 1 && xdotool key Escape && sleep 0.5 && xdotool key Escape && sleep 0.5 && xdotool key F12 && sleep 0.5 && xdotool mousemove 20 90 && sleep 0.1 && xdotool click 1 && sleep 0.5 && xdotool key Return && sleep 1 && xdotool key slash && sleep 0.1 && xdotool key h && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key m && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key d && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key v && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key D && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key k && sleep 0.04 && xdotool key t && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key p && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key M && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key k && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key S && sleep 0.04 && xdotool key c && sleep 0.04 && xdotool key r && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key n && sleep 0.04 && xdotool key S && sleep 0.04 && xdotool key h && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key t && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key period && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key c && sleep 0.04 && xdotool key Return && sleep 0.5 && xdotool mousemove 600 90 && sleep 0.5 && xdotool click 1   # Make alignment SVGs in Stellarium.
//copy      Stellarium script runs, output to "CODE/nebra/alignment/"
//copy xx   cd ~/Desktop/CODE/nebra && haxe ... 'Stellarium 24.3' Esc F12 click Return /home/dave/Desktop/MakeScreenShots.ssc Return mousemove click
//copy 3) PNGs can be opened in InkScape for further manual manipulation - to prove alignment of disc and stars in sky.
//copy xx   cd ~/Desktop/AAA/NEBRA/lunascope  && for i in scr_*.png; do convert "$i"  -fuzz 25% -transparent black trans_$i; done # TRANSPARENTA 
//copy xx   cd ~/Desktop/AAA/NEBRA/lunascope  && haxe --neko TEMP_neko.n --main Lunascope_svg && neko TEMP_neko.n DUMMYdATA && sleep 1 && wmctrl -a 'lunascope.svg' # CREATE SVG
//copy 
//copy ANIMATION FRAMES:
//copy =================
//copy 2b)  Open Stellarium. Ensure application window is NOT maximized or full screen. Stop any running script. Open script dialog box has to be resized to minimum allowed width. CAPS LOCK off.
//copy      In a UBUNTU terminal (ctrl+alt+T): Run this file (Preprocesses script, switches to Stellarium, and runs the script) using the following statement:
//copy         cd ~/Desktop/CODE/nebra && haxe --neko TEMP_neko.n --main ToolChain_MakeScreenShots && neko TEMP_neko.n FRAMES && sleep 1 && wmctrl -a 'Stellarium 24.3' && xdotool search --onlyvisible --name 'Stellarium 24.3' windowsize 1336 1400 windowmove 0 0 && sleep 1 && xdotool key Escape && sleep 1 && xdotool key Escape && sleep 1 && xdotool key Escape && sleep 1 && xdotool key F12 && sleep 1 && xdotool mousemove 20 90 && sleep 1 && xdotool click 1 && sleep 1 && xdotool key Return && sleep 1 && xdotool key slash && sleep 0.1 && xdotool key h && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key m && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key d && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key v && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key D && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key k && sleep 0.04 && xdotool key t && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key p && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key M && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key k && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key S && sleep 0.04 && xdotool key c && sleep 0.04 && xdotool key r && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key n && sleep 0.04 && xdotool key S && sleep 0.04 && xdotool key h && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key t && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key period && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key c && sleep 0.04 && xdotool key Return && sleep 0.5 && xdotool mousemove 600 96 && sleep 0.5 && xdotool click 1   # Make frames in Stellarium. ###frames1, output to USB
//copy #       cd ~/Desktop/CODE/nebra && haxe --neko TEMP_neko.n --main ToolChain_MakeScreenShots . . . 'Stellarium 24.3' windowsize 1336 1400 windowmove 0 0 && Esc Esc F12 mousemove click && Return/home/dave/Desktop/MakeScreenShots.ssc Return mousemove click # Make frames in Stellarium. ###frames1, output to USB
//copy 
//copy 2z)     cd ~/Desktop/CODE/nebra && haxe --neko TEMP_neko.n --main ToolChain_MakeScreenShots && neko TEMP_neko.n TESTS  && sleep 1 && wmctrl -a 'Stellarium 24.3' && xdotool search --onlyvisible --name 'Stellarium 24.3' windowsize 1336 1400 windowmove 0 0 && sleep 1 && xdotool key Escape && sleep 0.5 && xdotool key Escape && sleep 0.5 && xdotool key F12 && sleep 0.5 && xdotool mousemove 20 90 && sleep 0.1 && xdotool click 1 && sleep 0.5 && xdotool key Return && sleep 1 && xdotool key slash && sleep 0.1 && xdotool key h && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key m && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key d && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key v && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key D && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key k && sleep 0.04 && xdotool key t && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key p && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key M && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key k && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key S && sleep 0.04 && xdotool key c && sleep 0.04 && xdotool key r && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key n && sleep 0.04 && xdotool key S && sleep 0.04 && xdotool key h && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key t && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key period && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key c && sleep 0.04 && xdotool key Return && sleep 0.5 && xdotool mousemove 600 96 && sleep 0.5 && xdotool click 1   # TEST in Stellarium.
//copy 
//copy 3a) PNGs can be output and converted to video with ffmpeg, 
//copy         OR...
//copy 
//copy 3b) Import these PNGs into GENERATED InkScape SVG wrapper files, then run system command to convert these SVG files to final PNG image files:
//copy      cd ~/Desktop/CODE/lunascope && haxe --neko TEMP_neko.n --main LunascopePanel_svg && neko TEMP_neko.n FRAMES # CREATE SVGs and PNGs for Animation
//copy    Output is in: CODE/lunascope/frames
//copy 4) Convert numbered PNGs to video:
//copy ###  cd ~/Desktop/CODE/nebra/animation  && ffmpeg -f image2 -r 25 -pattern_type glob -i './scr_Luna_*.png' -vcodec libx264 -crf 22 luna_001.mp4
//copy      cd ~/Desktop/CODE/lunascope/frames && ffmpeg -f image2 -r 25 -pattern_type glob -i './S*.png' -vcodec libx264 -crf 22 luna_001.mp4


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
