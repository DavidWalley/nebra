// ToolChain_MakeDataFiles.hx - Haxe language BODGE code to run Stellarium script (currently just copies it to a directory).
// (c)2024 David C. Walley

// THE FOLLOWING IS NOT SOURCE CODE. THESE ARE MY NOTES!

// Start stellarium
// In a UBUNTU terminal (ctrl+alt+T):
// cd ~/Desktop/AAA/hey_diddle/code/nebra && haxe --neko TEMP_neko.n --main ToolChain_MakeDataFiles && neko TEMP_neko.n && sleep 1 && wmctrl -a 'Stellarium 24.3' # Run this file and switch to open STELLARIUM window.

// Stellarium
// ==========
// Stellarium is able to run close-to-JavaScript scripts. Unfortunately it seems some graphics
// generation has to be done to get some values to update, and this requires some waiting for async
// code to run. To help with this problem, we create data look-up files ahead of time.


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
