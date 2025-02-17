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
