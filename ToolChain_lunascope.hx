// hey_diddle/code/nebra/ToolChain_lunascope.hx - Haxe language BODGE code to run Stellarium script (currently just copies it to a directory).
// (c)2024 David C. Walley

// THE FOLLOWING IS NOT SOURCE CODE. THESE ARE MY NOTES!

// Start stellarium
// In a UBUNTU terminal (ctrl+alt+T):
// cd ~/Desktop/AAA/hey_diddle/code/nebra && haxe --neko TEMP_neko.n --main ToolChain_lunascope && neko TEMP_neko.n DUMMYdATA && sleep 1 && wmctrl -a 'Stellarium 24.3' # Run this file and switch to open STELLARIUM window.
// cd ~/Desktop/AAA/hey_diddle/lunascope  && for i in scr_*.png; do convert "$i"  -fuzz 25% -transparent black trans_$i; done # TRANSPARENT
// cd ~/Desktop/AAA/hey_diddle/lunascope  && haxe --neko TEMP_neko.n --main Lunascope_svg && neko TEMP_neko.n DUMMYdATA && sleep 1 && wmctrl -a 'lunascope.svg' # CREATE SVG

// haxe --neko TEMP_neko.n --main ToolChain_lunascope && neko TEMP_neko.n SUMMARIZE  # <-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<-<- DANGER WILL ROBINSON <-<-<- WILL OVER-WRITE $-CODE <-<-<-

// MACROS: Custom tool chain (ToolChain_lunascope.hx) does some custom preprocessing (mostly search and replace, and file splitting/splicing)
// Note: € euro symbol is used as escape character for custom tool-chain's preprocessor, because everything else on my keyboard is used for something in GML.
// To get 2-keystroke euro symbol in UBUNTU, run:   
//      setxkbmap "us(euro)"        
// in UBUNTU terminal, then Alt_right + 5 should do the trick.

// This Haxe program is bodge code for processing $-code notes to source code.   https://haxe.org/
// Any project-related notes should be in electronic (preferrably text) format in a repo, because they belong to the enterprise, and shareholders should be pissed if not.
// Therefore, I am releasing this as $-code, not source code, as an example of my note-taking.

// I like to have the ability to easily and non-distractingly write notes about individual lines or tokens found in the enterprise's source code.
// The easiest way to do this is with single-line comments, starting at or after a given column and continuing on a single line until hitting a new-line.
// Set your text editor to non-wrapping, and ignore comments that spill of the right side of the screen, or scroll over, or toggle word-wrap to read them.
// In general reading long comments is discouraged, unless you need to. 
// Beware the Stroop Effect. 
//
// But comments don't work, because:
// Extensive note-taking messes with the source code repo.
// And, too many devs read all the footnotes, which can get to be a waste of their time.
// Notes are most useful for fixing bugs or perhaps refactoring - otherwise they can be a distraction.

// I DON'T WRITE TOO MANY COMMENTS - YOU READ TOO MANY!

// I believe notes should be kept separately, in their own repo, in a one-to-zero-or-one relationship between code lines or tokens, and footnotes about them.
// This can be achieved with almost any text editor and in-line comments in $-code files, and minimal tooling to strip out most comments, and automatically prettify and post-process to meet desired standards.
//
// My notes are written for my brain, my visual cortex, and my neural net of memories - this bodge code is not for you, especially without reprogramming your brain's familiarity processors, which take about 2 weeks.
// However, as a normal part of codebase-as-database methodology, this Haxe code can be exported to a fair number of other programming languages.
// And, what do you care how I keep bodge code notes?
// If, however, you like my notes, you are welcome to read, copy and use what you like.
//
// However, it is a property of my $-code notes that they can be converted into source code in the enterprise's preferred format, in what is hopefully a fully automated process.
// In particular, this file of notes should execute properly as a Haxe file.
// I co-locate relevant code, notes, and diagrams whenever possible, so I don't have to switch applications or even pages.
// If everything is ASCII, then they can be presented to your eye with minimal effort and distraction on your part, and kept as if data in a database.

// The following outlines what I want to do with most $-code to source code projects:                   //>
//   +--------+  +------------+  +------------+      +------------+   +---------+   +---------+         //>
//   | $ code |->| Bodge Pre- |->| Prettify*  |      | Prettify*  |<--| Source  |<--| Manual  |         //> * Post-processing sometimes required.
//   | Notes  |  | Process    |  | 1-1 to AST |      | 1-1 to AST |   | repo ** |   | changes |         //> ** It is preferred that the Source repo code be prettified before it is commited - eliminate a step.
//   +--------+  +------------+  +------------+      +------------+   +---------+   +---------+         //>
//     ^                |                      \    /                                    ^              //>
//     |                v                    +---------+                                 |              //>
//     |     Docs, tests, reports            | Compare |                                 |              //>
//     |                                     +---------+                                 |              //>
// +-------------------------+                    |                                      |              //>
// | Manual edits? Automate? |<----Changes--------+---------Changes->--------------------+              //>
// +-------------------------+                                                                          //>

// Stellarium
// ==========
// Stellarium is able to run close to JavaScript scripts. Unfortunately it seems some graphics
// generation has to be done to get some values to update, and this requires some waiting for async
// code to run.


class ToolChain_lunascope ///////////////////////////////////////////////////////////////////////////////> For a stellarium script:
{/////////////////////////////////////////////////////////////////////////////////////////////////////////>

  var                   _sPathStellarium  :String     ="/home/dave/Desktop/";                           //> ???Hard-coded? Root directory of stellarium script - "source code"
//var                   _sPathStellarium  :String     ="/home/dave/";                                   //> This should be simpler to use, but isn't because folders get in the way of the file listing when selecting the file.
  var                   _sPathMoney       :String     ="/home/dave/Desktop/AAA/NEBRA/code/nebra/";      //> ???Hard-coded? Money code directory.


 function               new_ToProject(////////////////////////////////////////////////////////////////////> Create source from $ code, replacing macros.
 ){                                     //////////////////////////////////////////////////////////////////>
  var                   content         :String = sys.io.File.getContent(_sPathMoney +'lunascope.ssc'); //> Copy from money source directory
  try{                                                                                                  //> to
   sys.io.File.saveContent(                                        _sPathStellarium  +'lunascope.ssc'   //> a directory slightly easier to reload from within Stellarium
   ,                    content                                                                         //> "
   );                                                                                                   //> .
  }catch( e:haxe.Exception ){                                                                           //> If there is a problem, then
   trace(e.message);                                                                                    //> report it
   trace(e.stack);                                                                                      //> "
  }//try                                                                                                //> .
  trace("That should be it.");                                                                          //>
 }//new_ToProject/////////////////////////////////////////////////////////////////////////////////////////>


 function               new(//////////////////////////////////////////////////////////////////////////////> Construct a new object of this class (and run appropriate processing).
 )                                      :Void {///////////////////////////////////////////////////////////>
//var                      sCommandLineDirection :String        = ( Sys.args() )[0];                    //> Get direction operation from command line.
//if(       "TOpROJECT" == sCommandLineDirection ){          trace( sCommandLineDirection +" <-----" ); //> If command line is specifying "Read summaries and write back to project":
   new_ToProject();                                                                                     //>
//}//if                                                                                                 //>
 }//new///////////////////////////////////////////////////////////////////////////////////////////////////>


 static public function main(/////////////////////////////////////////////////////////////////////////////> Execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
  #if sys                                                                                               //> Just check.
   trace("file system can be accessed");                                                                //>
  #end                                                                                                  //>
  new ToolChain_lunascope();                                                                            //> Create and run and instance of main code.
 }//main//////////////////////////////////////////////////////////////////////////////////////////////////>

}//class ToolChain_lunascope//////////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


//End of file
