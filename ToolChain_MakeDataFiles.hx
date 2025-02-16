// ToolChain_MakeDataFiles.hx - Bodge code to create/copy Stellarium script for generating daily data tables, AND possibly star data file. v016
// (c)2024 David C. Walley

// THE FOLLOWING IS NOT SOURCE CODE. THESE ARE MY NOTES!

// 1) Start stellarium
// 2) In a UBUNTU terminal (ctrl+alt+T):
//  cd ~/Desktop/AAA/NEBRA/code/nebra && haxe --neko TEMP_neko.n --main ToolChain_MakeDataFiles && neko TEMP_neko.n && sleep 1 && wmctrl -a 'Stellarium 24.3' # Run this file and switch to open STELLARIUM window.
// ??? DOES THE FOLLOWING WORK HERE?
//  cd ~/Desktop/AAA/NEBRA/code/nebra && haxe --neko TEMP_neko.n --main ToolChain_MakeDataFiles && neko TEMP_neko.n && sleep 1 && wmctrl -a 'Stellarium 24.3' && sleep 1 && xdotool key Escape && sleep 0.5 && xdotool key F12 && sleep 0.5 && xdotool mousemove 20 90 && sleep 0.1 && xdotool click 1 && sleep 0.5 && xdotool key Return && sleep 1 && xdotool key slash && sleep 0.1 && xdotool key h && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key m && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key d && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key v && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key D && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key k && sleep 0.04 && xdotool key t && sleep 0.04 && xdotool key o && sleep 0.04 && xdotool key p && sleep 0.04 && xdotool key slash && sleep 0.04 && xdotool key M && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key k && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key D && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key t && sleep 0.04 && xdotool key a && sleep 0.04 && xdotool key F && sleep 0.04 && xdotool key i && sleep 0.04 && xdotool key l && sleep 0.04 && xdotool key e && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key period && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key s && sleep 0.04 && xdotool key c && sleep 0.04 && xdotool key Return && sleep 0.04 && xdotool mousemove 1700 90 && sleep 0.04 && xdotool click 1

// Stellarium
// ==========
// Stellarium is able to run close-to-JavaScript scripts. Unfortunately it seems the code does not 
// "separate model and view", so some graphics generation has to be done to get some values to update, 
// and this requires some waiting for async code to run. To help with this problem, we create data
// look-up files ahead of time.


class ToolChain_MakeDataFiles ////////////////////////////////////////////////////////////////////////////> For a stellarium script:
{/////////////////////////////////////////////////////////////////////////////////////////////////////////>

  var                   _sPathStellarium  :String          ="/home/dave/Desktop/";                      //> ???Hard-coded? Root directory of stellarium script - "source code"
  var                   _sPathMoney       :String          ="/home/dave/Desktop/AAA/NEBRA/code/nebra/"; //> ???Hard-coded? Money code directory.
                                                                  

 function               new(//////////////////////////////////////////////////////////////////////////////> Construct a new object of this class (and run appropriate processing).
 )                                  :Void {///////////////////////////////////////////////////////////////>
  var                   content     :String = sys.io.File.getContent(_sPathMoney +"MakeDataFiles.ssc"); //> Copy from money source directory
  try{                                                                                                  //> to
   sys.io.File.saveContent(                                     _sPathStellarium +"MakeDataFiles.ssc"   //> a directory slightly easier to reload from within Stellarium
   ,                    content                                                                         //> "
   );                                                                                                   //> .
  }catch( e:haxe.Exception ){                                                                           //> If there is a problem, then
   trace(e.message);                                                                                    //> report it
   trace(e.stack);                                                                                      //> "
  }//try                                                                                                //> .
  trace("That should be it.");                                                                          //>
 }//new///////////////////////////////////////////////////////////////////////////////////////////////////>


 static public function main(/////////////////////////////////////////////////////////////////////////////> Execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
  #if sys                                                                                               //> Just check.
   trace("file system can be accessed");                                                                //>
  #end                                                                                                  //>
  new ToolChain_MakeDataFiles();                                                                        //> Create and run and instance of main code.
 }//main//////////////////////////////////////////////////////////////////////////////////////////////////>

}//class ToolChain_MakeDataFiles//////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


//End of file
