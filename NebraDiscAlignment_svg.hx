// NebraDiscAlignment_svg.hx - Bodge code to create SVG file for showing Nebra Sky Disc alignments.
// (c)2024 David C. Walley

// CREATE THE SVG FILE OF ALIGNMENTS:
// In UBUNTU terminal (ctrl+alt+T): This code file (in this path) is pre-processed and run using the following, (some hard-coding follows):
// cd ~/Desktop/CODE/nebra      && haxe --neko TEMP_neko.n --main NebraDiscAlignment_svg && neko TEMP_neko.n && sleep 1 && wmctrl -a 'lunascope.svg' # CREATE SVG


final                   _sPATHsVGoUT    :String           = "/home/dave/Desktop/CODE/nebra/alignment/"; //> ???Hard-coded? Directory with images, BUT ALSO the output directory.
final                   _sSVGoUT        :String           = "lunascope_align.svg";                      //> File name of result.


class NebraDiscAlignment_svg /////////////////////////////////////////////////////////////////////////////> For a stellarium script:
{/////////////////////////////////////////////////////////////////////////////////////////////////////////>
                                                                                                        //>
//*   var               g_iDOTS_dot     :Int                    = 0 ;                                   //>
  var                   g_iDOTS_x       :Int                    = 1 ;                                   //>
  var                   g_iDOTS_y       :Int                    = 2 ;                                   //>
//*   var               g_iDOTS_sName   :Int                    = 3 ;                                   //>
//*   var               g_iDOTS_sId     :Int                    = 4 ;                                   //>
  var                   g_iDOTS_sView   :Int                    = 5 ;                                   //>
//*   var               g_iDOTS_sConst  :Int                    = 6 ;                                   //>
//*   var               g_iDOTS_sName2  :Int                    = 7 ;                                   //>
//*   var               g_iDOTS_sId2    :Int                    = 8 ;                                   //>
//*   var               g_iDOTS_dElat   :Int                    = 9 ;                                   //>
//*   var               g_iDOTS_dElong  :Int                    = 10;                                   //>
//*   var               g_iDOTS_dDec    :Int                    = 11;                                   //>
//*   var               g_iDOTS_dRa     :Int                    = 12;                                   //>
//*   var               g_iDOTS_dMag    :Int                    = 13;                                   //>
  var                   g_a2vDOTS       :Array<Array<Dynamic>>  =                                       //> COPIED FROM lunascope.ssc:
 //  0   1         2          3                    4          5     6      7                   8           9            10           11           12            13    //>
 //  DOT (x,y) of dots        star name            desig      view  const  name2               id1         elat         elong        dec          RA            Mag   //> Table of Nebra Sky Disc dots and associated stars:
   [[1  ,108.1498 ,18.1577  ,""                  ,"HR 1656" ,"p"  ,"Tau" ,"m Tau"            ,"HIP 23835" ,-4.22757736 ,77.53867299 ,18.64563797 ,76.872793943 ,4.90] //> 0  m Tau
   ,[2  ,126.3757 ,25.09133 ,""                  ,"HR 1554" ,"p"  ,"Tau" ,"HIP 22697"        ,"HIP 22697" ,5.321147746 ,75.13733004 ,27.89789880 ,73.202952944 ,5.95] //> 1  
   ,[3  ,70.83071 ,28.24098 ,"Castor"            ,"HR 2891" , "g" ,"Gem" ,"Castor"           ,"HIP 36850" ,10.09375094 ,110.2445114 ,31.88560856 ,113.65401298 ,1.90] //> 2  HR 2891   36850   α Gem   Gem     From its ancient Greek name Κάστωρ, a character in Greek mythology, the twin of Pollux (β Gem). Reapplied in Renaissance times. Greek   Kunitzsch, Paul; Smart, Tim (2006). A Dictionary of Modern star Names: A Short Guide to 254 Star Names and Their Derivations (2nd rev. ed.). Cambridge, Massachusetts: Sky Pub.
   ,[4  ,96.88832 ,31.32991 ,"Aldebaran"         ,"HR 1457" ,"p"  ,"Tau" ,"Aldebaran"        ,"HIP 21421" ,-5.46902602 ,69.79493535 ,16.50842997 ,68.986323401 ,0.85] //> 3  HR 1457   21421   α Tau   Tau     Applied in medieval times from its ind-A name al-dabaran, possibly meaning "the Follower," alternatively used as the lunar mansion name for all the Hyades (or again for α Tau alone). The name is thought to refer to this star's following the Pleiades across the sky, or to the Hyades (or α Tau) coming after the Pleiades as a lunar mansion. "Aldebaran" is one of the oldest Arabic star names applied in the West, from the end of the 10th century A.D.       Arabic  Kunitzsch, Paul; Smart, Tim (2006). A Dictionary of Modern star Names: A Short Guide to 254 Star Names and Their Derivations (2nd rev. ed.). Cambridge, Massachusetts: Sky Pub.
   ,[5  ,57.53873 ,40.46251 ,""                  ,"HR 2905" , "g" ,"Gem" ,"υ Gem"            ,"HIP 36962" ,5.214980108 ,111.3497335 ,26.89384299 ,113.98638207 ,4.05] //> 4  
   ,[6  ,83.44666 ,46.62984 ,""                  ,"HR 1239" ,"p"  ,"Tau" ,"λ Tau"            ,"HIP 18724" ,-7.96025099 ,60.63957058 ,12.49090067 ,60.175190376 ,3.40] //> 5  
   ,[6  ,-999     ,-999     ,""                  ,"HR 2697" , "g" ,"Gem" ,"τ Gem"            ,"HIP 34693" ,7.753792736 ,105.4497733 ,30.24383889 ,107.79100553 ,4.40] //> 6
   ,[7  ,112.1699 ,46.02002 ,""                  ,"HR 1256" ,"p"  ,"Tau" ,"A1 Tau"           ,"HIP 19038" ,1.259198008 ,63.46112813 ,22.08241414 ,61.180044518 ,4.34] //> 7  
   ,[7  ,-999     ,-999     ,""                  ,"HR 2540" , "g" ,"Gem" ,"θ Gem"            ,"HIP 33018" ,11.02960860 ,101.1293019 ,33.96015699 ,103.20412524 ,3.59] //> 8  
   ,[8  ,124.5944 ,40.92313 ,"Pleiades: Asterope","HR 1151" ,"P"  ,"Tau" ,"Asterope"         ,"HIP 17579" ,4.567966892 ,59.74484169 ,24.55548105 ,56.482481616 ,5.75] //> 9  HR 1151   17579   21 Tau  Tau     These names were individually applied in Renaissance times from a family of characters in Greek mythology: Atlas, Pleione and their seven daughters, the Pleiades.
   ,[9  ,121.0292 ,48.75188 ,"Pleiades: Maia"    ,"HR 1149" ,"P"  ,"Tau" ,"Maia"             ,"HIP 17573" ,4.389866533 ,59.68549106 ,24.36871969 ,56.462195999 ,3.84] //> 10
   ,[10 ,131.831  ,50.85698 ,"Atik"              ,"HR 1203" ,"p"  ,"Per" ,"ζ Per"            ,"HIP 18246" ,11.33393540 ,63.12917675 ,31.88515447 ,58.538914573 ,2.80] //> 11
   ,[11 ,112.4277 ,54.75468 ,"Pleiades: Alcyone" ,"HR 1165" ,"P"  ,"Tau" ,"Alcyone"          ,"HIP 17702" ,4.050899728 ,59.99748894 ,24.10618542 ,56.876600512 ,2.84] //> 12
   ,[12 ,128.7177 ,58.49874 ,"Pleiades: Electra" ,"HR 1142" ,"P"  ,"Tau" ,"Electra"          ,"HIP 17499" ,4.189786908 ,59.41698059 ,24.11439627 ,56.224319838 ,3.70] //> 13
   ,[13 ,120.2459 ,61.54713 ,"Pleiades: Merope"  ,"HR 1156" ,"P"  ,"Tau" ,"Merope"           ,"HIP 17608" ,3.955643081 ,59.70436670 ,23.94927508 ,56.587017801 ,4.09] //> 14
   ,[14 ,154.2186 ,44.34876 ,""                  ,""        ,""                                                                                                     ] //> 15
   ,[15 ,53.85233 ,64.36998 ,"Wasat"             ,"HR 2777" , "g" ,"Gem" ,"Wasat"            ,"HIP 35550" ,-0.17844208 ,108.5246902 ,21.98152794 ,110.03649036 ,3.5 ] //> 16 HR 2777  35550   δ Gem   Gem     From the Arabic word wasat, "middle," used by a sci-A commentator who was speculating on the meaning of the ind-A constellation name al-jauza'. Reference was made to al-jauza's being in the "middle" (wasat) of the sky (perhaps meaning the celestial equator). The reference was intended to apply to the ind-A figure located in today's Orion, however it was under the constellation which is today Gemini that the reference appeared (note the confusion between Orion and Gemini mentioned under α Ori). Therefore, after  transliteration into Latin, it was in Gemini (to δ) that the word "Wasat" was arbitrarily applied as a star name in recent times.  Arabic
   ,[16 ,35.4     ,81.51411 ,""                  ,"HR 2763" , "g" ,"Gem" ,"λ Gem"            ,"HIP 35350" ,-5.63533629 ,108.7840055 ,16.53956000 ,109.52854314 ,3.55] //> 17
   ,[17 ,38.3646  ,81.51411 ,""                  ,""        ,""                                                                                                     ] //> 18
   ,[18 ,123.5546 ,81.93696 ,"Bahrani"           ,"HR 838"  ,"p"  ,"Ari" ,"Bharani"          ,"HIP 13209" ,10.44940709 ,48.20824285 ,27.26160756 ,42.501043704 ,3.59] //> 19 HR 838   6193    41  Ari Ari
   ,[19 ,141.7191 ,78.15144 ,""                  ,"HR 840"  ,"p"  ,"Per" ,"16 Per"           ,"HIP 13254" ,20.94327211 ,51.84192759 ,38.32052223 ,42.653086066 ,4.20] //> 20
   ,[20 ,50.30947 ,98.89025 ,""                  ,"HR 2615" , "g" ,"Gem" ,"41 Gem"           ,"HIP 33715" ,-6.60175956 ,104.5677183 ,16.07857180 ,105.07171491 ,5.70] //> 21
   ,[21 ,119.1031 ,102.6168 ,"Hamal"             ,"HR 617"  ,"p"  ,"Ari" ,"Hamal"            ,"HIP 9884"  ,9.964961307 ,37.66700911 ,23.46380209 ,31.797982866 ,2   ] //> 22 HR 617   9884    α Ari   Ari     Applied in recent times from the Arabic constellation name, al-hamal, "the Lamb", for Aries. al-hamal seems to belong to those zodiacal constellation names already known in Arabic times.
   ,[22 ,47.5255  ,118.5022 ,"Alzirr"            ,"HR 2484" , "g" ,"Gem" ,"Alzirr"           ,"HIP 32362" ,-10.1055159 ,101.2142292 ,12.89389186 ,101.32730563 ,3.34] //> 23 HR 2484  32362   ξ Gem   Gem
   ,[23 ,70.8448  ,117.6285 ,""                  ,"HR 489"  ,"p"  ,"Psc" ,"ν Psc"            ,"HIP 7884"  ,-4.69444433 ,25.50897990 ,5.488188234 ,25.360276799 ,4.45] //> 24
   ,[23 ,-999     ,-999     ,"Alhena"            ,"HR 2421" , "g" ,"Gem" ,"Alhena"           ,"HIP 31681" ,-6.74285099 ,99.11047785 ,16.39856993 ,99.433987651 ,1.90] //> 25  HR 2421 31681   γ Gem   Gem     Applied in recent times from the ind-A lunar mansion name al-bana, possibly meaning "the Mark on the Neck of a Camel," for γ and ξ Gem, or alternatively for γ, ξ, η, μ, and v Gem.     Arabic  Kunitzsch, Paul; Smart, Tim (2006). A Dictionary of Modern star Names: A Short Guide to 254 Star Names and Their Derivations (2nd rev. ed.). Cambridge, Massachusetts: Sky Pub.
   ,[24 ,95.72604 ,118.7353 ,"Alpherg"           ,"HR 437"  ,"p"  ,"Psc" ,"Alpherg"          ,"HIP 7097"  ,5.378117061 ,26.81899773 ,15.34735745 ,22.873628886 ,7.50] //> 26
   ,[24 ,-999     ,-999     ,"Propus"            ,"HR 2216" , "g" ,"Gem" ,"Propus"           ,"HIP 29655" ,-0.88798880 ,93.44149225 ,22.50679947 ,93.725164695 ,6.00] //> 27 HR 437   7097    η Psc   Psc              HR 2216        29655   η Gem   Gem     Applied in Renaissance times from the Greek word πρόπους, "forward foot", used by Ptolemy in the Almagest in describing this star.      Greek   Kunitzsch, Paul; Smart, Tim (2006). A Dictionary of Modern star Names: A Short Guide to 254 Star Names and Their Derivations (2nd rev. ed.). Cambridge, Massachusetts: Sky Pub.
   ,[25 ,116.5119 ,127.7836 ,""                  ,"HR 360"  ,"p"  ,"Psc" ,"φ Psc"            ,"HIP 5742"  ,15.50440164 ,26.46211602 ,24.58583222 ,18.439532440 ,4.65] //> 28
   ,[26 ,139.006  ,130.4405 ,""                  ,"HR 291"  ,"p"  ,"Psc" ,"σ Psc"            ,"HIP 4889"  ,23.08246361 ,27.21562523 ,31.80697757 ,15.706610523 ,5.5 ] //> 29
   ,[27 ,156.8717 ,121.4289 ,""                  ,"HR 226"  ,"p"  ,"And" ,"ν And"            ,"HIP 3881"  ,32.56464840 ,29.15283671 ,41.08248596 ,12.455510973 ,4.5 ] //> 30
   ,[27 ,-999     ,-999     ,"Elnath"            ,"HR 1791" , "g" ,"Tau" ,"Elnath"           ,"HIP 25428" ,5.383700043 ,82.58064369 ,28.60636790 ,81.579526761 ,1.65] //> 31 HR 1791  25428   β Tau   Tau
   ,[28 ,63.38372 ,133.7863 ,""                  ,"HR 392"  ,"p"  ,"Cet" ,"HIP 6432"         ,"HIP 6432"  ,-6.46643162 ,19.73315074 ,1.726187942 ,20.656586845 ,6.20] //> 32
   ,[28 ,-999     ,-999     ,""                  ,"HR 2287" , "g" ,"Ori" ,"HIP 30318"        ,"HIP 30318" ,-10.7591056 ,95.62021449 ,12.56987478 ,95.657125881 ,6.00] //> 33
   ,[29 ,85.68202 ,138.646  ,""                  ,"HR 294"  ,"p"  ,"Psc" ,"ε Psc"            ,"HIP 4906"  ,1.094383099 ,17.52672400 ,7.891193773 ,15.736929963 ,4.25] //> 34
   ,[29 ,-999     ,-999     ,""                  ,"HR 2159" , "g" ,"Ori" ,"ν Ori"            ,"HIP 29038" ,-8.65875821 ,91.85748091 ,14.76827729 ,91.899060953 ,4.40] //> 35
   ,[30 ,101.2925 ,141.9865 ,""                  ,"HR 211"  ,"p"  ,"Psc" ,"57 Psc"           ,"HIP 3632"  ,9.642026823 ,16.77406568 ,15.47672950 ,11.638382861 ,5.34] //> 36
   ,[30 ,-999     ,-999     ,""                  ,"HR 1990" , "g" ,"Tau" ,"130 Tau"          ,"HIP 27338" ,-5.67742169 ,86.99949122 ,17.72921298 ,86.865201882 ,5.45] //> 37
   ,[31 ,123.8151 ,145.3032 ,"Tianguan"          ,"HR 1910" , "g" ,"Tau" ,"Tianguan"         ,"HIP 26451" ,-2.19574353 ,84.79039795 ,21.14263598 ,84.417365391 ,2.95] //> 38 HR 1910  26451   ζ Tau   Tau     Chinese single star asterism, a celestial pass along the ecliptic which opens and closes        Chinese Rufus+Tien (1945) on the Suzhou Map, Sun and Kistemaker (1997) evaluating Han sources, Sun Shuwei (2022) on the Su Song Map
// ,[32 ,171.1209 ,60.48165 ,""                  ,""        ,""                                                                                                     ] //> 32
// ,[33 ,173.9899 ,93.61537 ,""                  ,""        ,""                                                                                                     ] //> 33
   ,[50 ,0        ,0        ,"Polaris"           ,"HIP 11767" ,"z","UMi" ,"Polaris"          ,"HIP 11767" ,66.10151875 ,88.58259182 ,89.26883221 ,38.253136404 ,1.95] //> Calendar
   ,[51 ,0        ,0        ,"Vega"              ,"HIP 91262" ,"z","Lyr" ,"Vega"             ,"HIP 91262" ,61.73672951 ,285.3068417 ,38.78692090 ,-80.77167827 ,0   ] //> Calendar
   ,[54 ,0        ,0        ,"Dubhe"             ,"HIP 54061" ,"z","UMa" ,"Big Dipper"       ,"HIP 54061" ,49.67750268 ,135.2017969 ,61.74708322 ,165.93325947 ,2   ] //> Calendar
   ,[55 ,0        ,0        ,"Merak"             ,"HIP 53910" ,"z","UMa" ,"Big Dipper"       ,"HIP 53910" ,45.13027309 ,139.4407262 ,56.37781083 ,165.46409787 ,2.30] //> Calendar
   ,[56 ,0        ,0        ,"Caph"              ,"HIP 746"   ,"z","Cas" ,"Caph"             ,"HIP 746"   ,51.22158910 ,35.12856093 ,59.15962753 ,2.2976013387 ,2.25] //> Calendar 
   ,[57 ,0        ,0        ,"Capella"           ,"HIP 24608" ,"z","Aur" ,"Capella"          ,"HIP 24608" ,22.86115616 ,81.86497229 ,45.99540741 ,79.182016772 ,0.04] //> Calendar
   ,[52 ,0        ,0        ,"Procyon"           ,"HIP 37279" ,"z","CMi" ,"Little Dog"       ,"HIP 37279" ,-16.0274910 ,115.7867482 ,5.217023103 ,114.82527538 ,0.40] //> Lunar Leap Year
   ,[53 ,0        ,0        ,"Gomeisa"           ,"HIP 36188" ,"z","CMi" ,"Little Dog"       ,"HIP 36188" ,-13.4869151 ,112.1969295 ,8.288834367 ,111.79279198 ,2.84] //> Lunar Leap Year
   ,[58 ,0        ,0        ,"Arcturus"          ,"HIP 69673" ,"z","Boo" ,"Arcturus"         ,"HIP 69673" ,30.71553411 ,204.2302913 ,19.16440114 ,-146.0959120 ,0.15] //> Bootes
   ,[59 ,0        ,0        ,"Altair"            ,"HIP 97649" ,"z","Aql" ,"Altair"           ,"HIP 97649" ,29.30697265 ,301.7761452 ,8.871712428 ,-62.30515852 ,0.75] //> Eagle?
   ,[60 ,0        ,0        ,"Asellus Australis" ,"HIP 42911" ,"z","Cnc" ,"Asellus Australis","HIP 42911" ,0.075414085 ,128.7268240 ,18.15134589 ,131.17567209 ,3.90] //> 1 Cancer
   ,[61 ,0        ,0        ,"Regulus"           ,"HIP 49669" ,"z","Leo" ,"Regulus"          ,"HIP 49669" ,0.464502247 ,149.8300113 ,11.96657981 ,152.09367882 ,1.35] //> 2 Leo
   ,[62 ,0        ,0        ,"Algenubi"          ,"HIP 47908" ,"z","Leo" ,"Algenubi"         ,"HIP 47908" ,9.714469470 ,140.7081828 ,23.77228787 ,146.46582854 ,2.95] //> 
   ,[63 ,0        ,0        ,"Denebola"          ,"HIP 57632" ,"z","Leo" ,"Denebola"         ,"HIP 57632" ,12.26329780 ,171.6151954 ,14.56971764 ,177.26124965 ,2.09] //> 
   ,[64 ,0        ,0        ,"Spica"             ,"HIP 65474" ,"z","Vir" ,"Spica"            ,"HIP 65474" ,-2.05468189 ,203.8387318 ,-11.1605214 ,-158.7043076 ,0.95] //> 3 Virgo
   ,[44 ,0        ,0        ,"Syrma"             ,"HIP 69701" ,"z","Vir" ,"Syrma"            ,"HIP 69701" ,7.196383901 ,213.7945103 ,-6.00259379 ,-145.9999239 ,4.05] //> 
   ,[65 ,0        ,0        ,"Zubenelgenubi"     ,"HIP 72622" ,"z","Lib" ,"Zubenelgenubi"    ,"HIP 72622" ,0.332309911 ,225.0778874 ,-16.0411028 ,-137.2853445 ,2.75] //> 4 Libra
   ,[66 ,0        ,0        ,"Sadalmelik"        ,"HIP 109074","z","Aqr" ,"Sadalmelik"       ,"HIP 109074",10.66238731 ,333.3500316 ,-0.31993785 ,-28.55654312 ,2.95] //> 5 Aquarius
   ,[44 ,0        ,0        ,"Ancha"             ,"HIP 110003","z","Aqr" ,"Ancha"            ,"HIP 110003",2.706448705 ,333.2617571 ,-7.78428350 ,-25.79298864 ,4.15] //> 
   ,[67 ,0        ,0        ,"Deneb Algedi"      ,"HIP 107556","z","Cap" ,"Deneb Algedi"     ,"HIP 107556",-2.60371939 ,323.5401637 ,-16.1300069 ,-33.24145134 ,2.84] //> 6 Capricon
   ,[44 ,0        ,0        ,"Dabih"             ,"HIP 100345","z","Cap" ,"Dabih"            ,"HIP 100345",4.588801104 ,304.0429685 ,-14.7822531 ,-54.75167582 ,3.05] //> 
   ,[68 ,0        ,0        ,"Nunki"             ,"HIP 92855" ,"z","Sgr" ,"Nunki"            ,"HIP 92855" ,-3.45006572 ,282.3797355 ,-26.2977879 ,-76.18978347 ,2.05] //> 7 Sagitarius
   ,[69 ,0        ,0        ,"Antares"           ,"HIP 80763" ,"z","Sco" ,"Antares"          ,"HIP 80763" ,-4.57000141 ,249.7567861 ,-26.4312042 ,-112.6541497 ,1.04] //> 8 Scorpio
   ,[44 ,0        ,0        ,"Acrab"             ,"HIP 78820" ,"z","Sco" ,"Acrab"            ,"HIP 78820" ,1.007570026 ,243.1848227 ,-19.8046451 ,-118.6461626 ,2.59] //> 
                                          ];                                                                                                                          //> 9 Pisces, 10 Aires, 11 Taurus, 12 Gemini


 var                    _iId            :Int                    = 1000;                                 //>
 function               iId(//////////////////////////////////////////////////////////////////////////////> Provide incrementing ID for SVG elements.
 ){                     //////////////////////////////////////////////////////////////////////////////////>
  _iId++;                                                                                               //>
 return ''+ _iId;                                                                                       //>
 }//iId///////////////////////////////////////////////////////////////////////////////////////////////////>


 function               sSvgFile_(////////////////////////////////////////////////////////////////////////> Create SVG file header.
 ){                     //////////////////////////////////////////////////////////////////////////////////>
  var                                   sId                     = ''+ iId();                            //>
 return  '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'                                       //>
       + '<!-- (c)2024 David C. Walley -->'                                                             //>
       + '<svg'  + ' id="svg'+ iId() +'"'                                                               //>
       +  ' width="'+ 210 +'mm"' + ' height="'+ 297 +'mm"' + ' viewBox="0 0 '+ 210 +' '+ 297 +'"'       //>
       +  ' version="1.1"'                                                                              //>
       +  ' inkscape:version="1.1.2 (0a00cf5339, 2022-02-04)"'                                          //>
       +  ' sodipodi:docname="drawing.svg"'                                                             //>
       +  ' xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"'                               //>
       +  ' xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"'                        //>
       +  ' xmlns="http://www.w3.org/2000/svg"'                                                         //>
       +  ' xmlns:svg="http://www.w3.org/2000/svg">'                                                    //>
       +  '<sodipodi:namedview'                                                                         //>
                                                                                                        //>
       +  ' inkscape:cx="'            + 241.722 +'"'         +' inkscape:cy="'    + 238.2009 +'"'       //>
       +  ' inkscape:window-width="'  + 3840    +'"'  +' inkscape:window-height="'+ 2123     +'"'       //>
       +  ' inkscape:document-units="'+'mm'     +'"'  +' inkscape:zoom="'         + 2.840039 +'"'       //>
                                                                                                        //>
       +  ' id="namedview'+ 7 +'"'         +' pagecolor="#ffffff"'                                      //>
       +  ' bordercolor="#666666"'         +' borderopacity="1.0"'                                      //>
       +  ' inkscape:pageshadow="2"'       +' inkscape:pageopacity="0.0"'                               //>
       +  ' inkscape:pagecheckerboard="0"' +' showgrid="false"'                                         //>
       +  ' inkscape:window-x="0"'         +' inkscape:window-y="0"'                                    //>
       +  ' inkscape:window-maximized="1"' +' inkscape:current-layer="'        +'layer'+ sId +'"'       //>
       +  '/>'                                                                                          //>
//     +  '<defs id="defs2" />'                                                                         //>
       +  '<defs id="defs2">'                                   
       +   '<filter id="'+ "filterWhiteLines" +'"'                                                      //> Filter to turn lines into bright lines.
       +   ' style="color-interpolation-filters:sRGB;"'
       +   ' inkscape:label="Colorize" x="0" y="0" width="1" height="1"'
       +   '>'
       +    '<feComposite   in2="SourceGraphic" operator="arithmetic" k1="0" k2="9.6" result="composite1" id="feComposite3422" />'
       +    '<feColorMatrix in="composite1" values="1" type="saturate" result="colormatrix1" id="feColorMatrix3424" />'
       +    '<feFlood flood-opacity="1" flood-color="rgb(240,255,197)" result="flood1" id="feFlood3426" />'
       +    '<feBlend in="flood1" in2="colormatrix1" mode="lighten" result="blend1" id="feBlend3428" />'
       +    '<feBlend in2="blend1" mode="screen" result="blend2" id="feBlend3430" />'
       +    '<feColorMatrix in="blend2" values="1" type="saturate" result="colormatrix2" id="feColorMatrix3432" />'
       +    '<feComposite in="colormatrix2" in2="SourceGraphic" operator="in" k2="1" result="composite2" id="feComposite3434" />'
       +   '</filter>'
       +  '</defs>'
 ;                                                                                                      //>
 }//sSvgFile_/////////////////////////////////////////////////////////////////////////////////////////////>
 function               sSvgFile_close(///////////////////////////////////////////////////////////////////> End the SVG file.
 ){                     //////////////////////////////////////////////////////////////////////////////////>
 return '</svg>';                                                                                       //>
 }//sSvgFile_close////////////////////////////////////////////////////////////////////////////////////////>


 function               sSvgLayer_g(//////////////////////////////////////////////////////////////////////>
                        a_s             :String                                                         //>
 ,                      a_sStyle        :String                                                         //> Additional CSS style(s)
 )                                      :String {/////////////////////////////////////////////////////////>
 return '<g id="layer'+ iId() +'" inkscape:groupmode="layer"'                                           //>
       +' inkscape:label="'+ a_s +'" style="display:none;'+ a_sStyle +'"'                               //>
       +'>';                                                                                            //>
 }//sSvgLayer_g///////////////////////////////////////////////////////////////////////////////////////////>


 function               sNew_SvgLayer_DiscPhoto(//////////////////////////////////////////////////////////> Add layer to SVG file, containing the photo of the disc.
 )                                      :String{//////////////////////////////////////////////////////////>
   var                                  sSvg                    = "";                                   //>
   sSvg += sSvgLayer_g("Disc Photo" ,"");                                                               //>
    sSvg += '<image id="image'+ iId() +'"'                                                              //>
          +  ' width="'                       + 4177/20    +'"'   +  ' height="'+ 3385/20 +'"'          //>
          +  ' x="'                           +    0       +'"'   +  ' y="'     +    0    +'"'          //>
          +  ' preserveAspectRatio="none"'    + ' xlink:href="'+ './'+ 'Nebra_disc_1.jpg' +'"'          //>
          + '/>';                                                                                       //>
   sSvg += '</g>';                                                                                      //>
 return sSvg;                                                                                           //>
 }//sNew_SvgLayer_DiscPhoto///////////////////////////////////////////////////////////////////////////////>


 function               sNew_SvgLayer_Image(//////////////////////////////////////////////////////////////> Add layer containing an image (generated by stellarium script lunascope.ssc).
                        a_sFile         :String                                                         //>
 ,                      a_sLayer        :String                                                         //> Layer name in Inkscape.
 ,                      a_sView         :String                                                         //> View name in Inkscape.
 ,                      a_sAttribute    :String                                                         //> Extra tag attribute.
 )                                      :String {/////////////////////////////////////////////////////////>
  var                                   sSvg                    = "";                                   //>
  sSvg += sSvgLayer_g( a_sLayer +"_"+ a_sView ,"" );                                                    //>
//sSvg += '<g id="layer'+ iId() +'" inkscape:label="scr_'+ a_sPass +'" inkscape:groupmode="layer"'      //>
//       +' style="'                    +'display:none' +';opacity:0.5"'                                //>
//       +'>';                                                                                          //>
  var                   dX              :Float                  = 0.;                                   //>
  var                   dY              :Float                  = 0.;                                   //>
  for( iPass in 0...4 ){                                                                                //>
   switch( iPass ){                                                                                     //>
   case 0: dX = 0. ; dY = 0. ;                                                                          //>
   case 1: dX = 0. ; dY = 0.2;                                                                          //>
   case 2: dX = 0.2; dY = 0. ;                                                                          //>
   case 3: dX = 0.2; dY = 0.2;                                                                          //>
   }//switch                                                                                            //>
   sSvg +=  '<image id="image'+ iId() +'"'                                                              //>
          + ' '+ a_sAttribute                                                                           //> 'style="filter:url(#'+ "filterWhiteLines" +')"'
          + ' xlink:href="'   +'./'+ a_sFile   +'"';                                                    //> Same directory as SVG output file, i.e. _sPATHsVGoUT
        //+ ' width="'                       + 356.3036     +'"'                                        //> For stereoscopic projection
        //+ ' height="'                      + 196.9876     +'"'                                        //>
        //+ ' x="'                           + -75.61064    +'"'                                        //>
        //+ ' y="'                           + -170.2824    +'"'                                        //>
        //+ ' transform="rotate('            + 60.89087     +')"'                                       //>
        //+ ' inkscape:transform-center-x="' + 0.03870656   +'"'                                        //>
        //+ ' inkscape:transform-center-y="' + 0.1698319    +'"'                                        //>
   if( "south" == a_sView ){                                                                            //> For stereoscopic projection, looking South.
    sSvg += ' width="'                       + 857.5414        +'"'                                     //> Co-ordinates to move Stellarium generated images to align with disc photo.
           +' height="'                      + 474.1041        +'"'                                     //>
           +' x="'                           + (-253.2147 +dX) +'"'                                     //>
           +' y="'                           + (-220.8342 +dY) +'"'                                     //>
           +' transform="rotate('            + 40.46659        +')"'                                    //>
           +' inkscape:transform-center-x="' + 35.14639        +'"'                                     //>
           +' inkscape:transform-center-y="' + 6.423362        +'"'                                     //>
          ;                                                                                             //>
   }else{// "pleiades"                                                                                  //>
    sSvg += ' width="'                       + 382.0232        +'"'                                     //> For stereoscopic projection
           +' height="'                      + 211.207         +'"'                                     //>
           +' x="'                           + (-88.46108 +dX) +'"'                                     //>
           +' y="'                           + (-177.3837 +dY) +'"'                                     //>
           +' transform="rotate('            + 60.89087        +')"'                                    //>
           +' inkscape:transform-center-x="' + 0.04149154      +'"'                                     //>
           +' inkscape:transform-center-y="' + 0.1820972       +'"'                                     //>
          ;                                                                                             //>
   }//if                                                                                                //>
   sSvg +=  ' preserveAspectRatio="'         + "none"          +'"'                                     //>
          + '/>'                                                                                        //>
         ;                                                                                              //>
   if( "lines" != a_sLayer ){                                                                    break;}//>
  }//for iPass                                                                                          //>
                                                                                                        //>
  sSvg += '</g>';                                                                                       //>
 return sSvg;                                                                                           //>
 }//New_sSvgLayer_Image///////////////////////////////////////////////////////////////////////////////////>


 function               sNew_SvgLayer_Numbers(////////////////////////////////////////////////////////////> Add layer to SVG file, containing numbers for the dots.
 )                                      :String{//////////////////////////////////////////////////////////>
  var                                   sSvg                    = "";                                   //>
  sSvg += sSvgLayer_g("Numbers" ,"");                                                                   //>
  var                                   iDot                    = 1;                                    //>
  for( av in g_a2vDOTS ){                                                                               //>
   if( av[1] < -990 ){                                                                        continue;}//>
   sSvg += '<text xml:space="preserve"'                                                                 //>
         + ' style="'                   +'font-size'                    +':5px'                         //>
         +                              ';line-height'                  +':1.25'                        //>
         +                              ';font-family'                  +':Arial'                       //>
         +                              ';-inkscape-font-specification' +':Arial'                       //>
         +                              ';word-spacing'                 +':0px'                         //>
         +                              ';stroke-width'                 +':0.2'                         //>
         + '"'                                                                                          //>
         + ' x="'+ av[g_iDOTS_x] +'" y="'+  av[g_iDOTS_y] +'" '                                         //>
         + ' id="text'+ iId() +'"'                                                                      //>
         + '>'                                                                                          //>
         +  '<tspan sodipodi:role="line" id="tspan'+ iId() +'"'                                         //>
         +  ' style="stroke-width:0.3"'                                                                 //>
         +  ' x="'+ av[g_iDOTS_x] +'" y="'+ av[g_iDOTS_y] +'"'                                          //>
         +  '>'                                                                                         //>
         +   av[0]                                                                                      //>
         +  '</tspan>'                                                                                  //>
         + '</text>';                                                                                   //>
   iDot++;                                                                                              //>
  }//for                                                                                                //>
  sSvg += '</g>';                                                                                       //>
 return sSvg;                                                                                           //>
 }//New_sSvgLayer_Numbers/////////////////////////////////////////////////////////////////////////////////>


 function               sNew_SvgLayers_Dots(//////////////////////////////////////////////////////////////> Add layers to SVG file, highlighting dots believed to be in various sets.
 )                                      :String{//////////////////////////////////////////////////////////>
  var                                   sSvg                    = "";                                   //>
  var                   sSTYLE          :String                 =                                       //>
                                      // "display"              +":none"                                //>
                                          'opacity'             +':0.5'                                 //>
                                        +';stroke'              +':none'                                //>
                                        +';stroke-width'        +':2'                                   //>
                                        +';stroke-linecap'      +':round'                               //>
                                        +';stroke-linejoin'     +':round'                               //>
                                        +';stroke-dashoffset'   +':4'                                   //>
                                        ;                                                               //>
  for( iPass in 0...3 ){                                                                                //>
   sSvg += sSvgLayer_g( "Dots_"+ ["south","pleiades","other"][iPass] ,"" );                             //>
 //var                                  iDot                    = 1;                                    //>
   for( av in g_a2vDOTS ){                                                                              //>
    if(       "g" == av[g_iDOTS_sView]                                  ){                              //>
     if( 0 == iPass ){  sSvg  +=  '<circle id="path'+ iId() +'"'                                        //>
                               +  ' style="'+ sSTYLE +';fill'+ ":#ffff00" +'"'                          //>
                               +  ' cx="'+ av[g_iDOTS_x] +'" cy="'+ av[g_iDOTS_y] +'" r="'+ 2.5 +'"'    //> (24 == iDot ?2 :2.5) +'" '
                               +  '/>';                                                                 //>
     }//if                                                                                              //>
    }else if( "p" == av[g_iDOTS_sView]   ||   "P"  == av[g_iDOTS_sView] ){                              //>
     if( 1 == iPass ){  sSvg  +=  '<circle id="path'+ iId() +'"'                                        //>
                               +  ' style="'+ sSTYLE +';fill'+ ":#00ffff" +'"'                          //>
                               +  ' cx="'+ av[g_iDOTS_x] +'" cy="'+ av[g_iDOTS_y] +'" r="'+ 2.5 +'"'    //> (24 == iDot ?2 :2.5) +'" '
                               +  '/>';                                                                 //>
     }//if                                                                                              //>
    }else{                                                                                              //>
     if( 2 == iPass ){  sSvg  +=  '<circle id="path'+ iId() +'"'                                        //>
                               +  ' style="'+ sSTYLE +';fill'+ ":#ff0000" +'"'                          //>
                               +  ' cx="'+ av[g_iDOTS_x] +'" cy="'+ av[g_iDOTS_y] +'" r="'+ 2.5 +'"'    //> (24 == iDot ?2 :2.5) +'" '
                               +  '/>';                                                                 //>
    }}//if//if                                                                                          //>
                                                                                                        //>
  //if(      "pg"== av[g_iDOTS_sView]   ){                                                              //>
  // if( 1 == iPass ){  sSvg +=  '<circle id="path'+ iId() +'"'                                         //>
  //                          +  ' style="'+ sSTYLE +';fill'+ ":#00ffff" +'"'                           //>
  //                          +  ' cx="'+ av[g_iDOTS_x] +'" cy="'+ av[g_iDOTS_y] +'" r="'+ 2.5 +'"'     //>
  //                          +  '/>';                                                                  //>
  //}}//if//if                                                                                          //>
  //iDot++;                                                                                             //>
   }//for                                                                                               //>
   sSvg += '</g>';                                                                                      //>
  }//for iPass                                                                                          //>
 return sSvg;                                                                                           //>
 }//New_sSvgLayers_Dots///////////////////////////////////////////////////////////////////////////////////>


 function               sNew_SvgLayer_Elements(///////////////////////////////////////////////////////////> Add layer to SVG file, containing outlines of the big elements.
 )                                      :String{//////////////////////////////////////////////////////////>
  var                   sSTYLE          :String = 'fill:none;stroke:#ff0000;stroke-opacity:1;stroke-width:0.3' //>
                                    //   "display"              +":none"                                //>
//   +                                    ";fill"                 +":none"
//   +                                    ";fill-opacity"         +":1"
//   +                                    ";stroke"               +":#ff0000"
//   +                                    ";stroke-width"         +":0.3"
//   +                                    ";stroke-linecap"       +":round"
//   +                                    ";stroke-linejoin"      +":round"
//   +                                    ";stroke-dashoffset"    +":4"
//   +                                    ";stroke-opacity"       +":1"
//   +                                    ";stroke-miterlimit"    +":4"
//   +                                    ";stroke-dasharray"     +":none"
                                    //+';opacity'              +':0.5'                                 //>
                                    //+';stroke'              +':none'                                //>
                                    //+';stroke-width'        +':2'                                   //>
                                    //+';stroke-linecap'      +':round'                               //>
                                    //+';stroke-linejoin'     +':round'                               //>
                                    //+';stroke-dashoffset'   +':4'                                   //>
                                        ;                                                               //>
  var                                   sSvg                    =                                       //>
  //'<g id="layer'+ iId() +'" inkscape:groupmode="layer" inkscape:label="Elements">'                    //>
     sSvgLayer_g("Elements" ,"")                                                                        //>
   + '<ellipse id="path'+ iId() +'" style="'+ sSTYLE      +'"'                                          //> Full Disc
   + ' cx="'+  103.3842   +'"'    +  ' cy="'+  84.31348   +'"'                                          //>
   + ' rx="'+  81.75872   +'"'    +  ' ry="'+  77.11446   +'"'                                          //>
   + '/>'                                                                                               //>
   + '<ellipse id="path'+ iId() +'" style="'+ sSTYLE      +'"'                                          //> Full Moon
   + ' cx="'+  82.65771   +'"'    +  ' cy="'+  84.61899   +'"'                                          //>
   + ' rx="'+  24.20713   +'"'    +  ' ry="'+  25.13237   +'" '                                         //>
   + '/>'                                                                                               //>
   + '<path id="path'+ iId() +'" style="'   + sSTYLE      +'"'                                          //> Crescent Moon
   + ' d="m 167.8521,83.778 c 0,17.1182 -15.3554,31.2155 -32.4736,31.2155'                                                 //>
   +  ' c -3.0581,0 -5.3254,-0.6632 -8.116,-1.488'             +' c 15.2141,-7.7883 21.6478,-17.76212 24.8598,-26.41889'   //>
   +  ' c 3.212,-8.65677 4.5852,-14.3926 -4.6523,-32.82457'    +' c 5.9302,2.19563 11.5953,6.13649 15.2167,11.33132'       //>
   +  ' c 3.5928,5.15381 5.1654,11.54387 5.1654,18.18464'      +' z"'                                                      //>
   + ' sodipodi:nodetypes="ssczcss" '                                                                                      //>
   + '/>'                                                                                                                  //>
   + '<path id="path'+ iId() +'" style="'   + sSTYLE      +'"'                                                             //> Left band
   + ' d="m 165.396,36.17269 c 0,0 7.8378,9.86074 12.575,21.26868'                                                         //>
   +  ' c 3.7403,9.00707 4.673,19.22159 4.3461,24.62663'       +' c -0.2985,4.93584 -0.5628,17.57263 -4.5298,27.5835'      //>
   +  ' c -4.3618,11.0075 -11.128,20.6711 -14.3297,24.9257'    +' c -1.1136,1.4798 -2.0695,1.9381 -2.0695,1.9381'          //>
   +  ' l -4.968,-3.7703 c 0,0 -0.039,0.048 0.627,-1.8668'     +' c 0.6657,-1.9146 9.4528,-9.7083 13.9401,-31.74958'       //>
   +  ' c 0.6483,-3.18462 1.0178,-6.38564 1.495,-9.66606'      +' c 0.4638,-3.18821 1.0465,-6.45176 0.9203,-9.82404'       //>
   +  ' c -0.1308,-3.49509 -1.6026,-7.65878 -2.2666,-10.94295' +' c -2.1493,-10.63172 -6.8595,-19.41701 -8.4027,-21.97789' //>
   +  ' c -0.5119,-0.84959 -0.784,-1.77282 -1.123,-2.34879'    +' c -1.6166,-2.74625 -1.868,-2.70993 -1.9313,-4.44372'     //>
   +  ' c -0.043,-1.17084 0.057,-1.16925 1.4698,-3.03948'      +' l 3.9623,-0.93236"'                                      //>
   + ' sodipodi:nodetypes="cssssccsssssssscc" '                                                                            //>
   + '/>'                                                                                                                  //>
   + '<path id="path'+ iId() +'" style="'   + sSTYLE      +'"'                                                             //> Right band
   + ' d="m 49.13698,28.62744 c 0,0 2.60694,3.32999 2.73849,3.94554 c 0.13153,0.61556 -0.0516,1.09459 -1.51937,2.66491'    //>
   +  ' c -0.60997,0.65259 -4.04316,4.88925 -6.63389,9.52989 c -3.64311,6.52573 -8.19196,18.22359 -9.07323,21.07348'       //>
   +  ' c -0.49657,1.60586 -0.81716,5.6611 -1.30958,10.18554 c -0.34166,3.13919 -0.96137,6.35265 -0.97043,9.75892'         //>
   +  ' c -0.0175,6.5928 1.19677,12.77346 1.75937,15.47988 c 0.56852,2.7349 1.92568,8.6335 3.90363,13.8563'                //>
   +  ' c 2.4483,6.4648 5.78044,12.3788 5.78044,12.3788 l -3.59432,3.6732 c 0,0 -7.12552,-8.465 -9.67949,-14.0331'         //>
   +  ' c -2.55394,-5.5682 -6.75043,-17.79742 -6.9713,-26.6736 c -0.22086,-8.87619 1.26914,-22.13744 4.08213,-30.68794'    //>
   +  ' c 1.51246,-4.59735 4.4651,-11.45063 8.33061,-17.32475 c 3.32389,-5.05106 7.63469,-9.44707 8.68096,-10.26578'       //>
   +  ' c 2.26301,-1.77081 4.5489,-3.66586 4.5489,-3.66586"'                                                               //>
   +  ' sodipodi:nodetypes="cssssssssccsssssc" '                                                                           //>
   + '/>'                                                                                                                  //>
   + '<path id="path'+ iId() +'" style="'   + sSTYLE      +'"'                                                             //> The boat
   + ' d="m 71.45021,125.0584 c 0,0 4.37513,15.1937 10.2979,19.0278 c 3.69533,2.3922 6.58566,5.8995 10.38389,7.4056'       //>
   +  ' c 9.2592,3.6715 24.0188,4.4144 32.9305,-2.5648 c 7.1446,-5.5953 10.5728,-9.5571 12.1875,-11.4463'                  //>
   +  ' c 1.3051,-1.527 1.4167,-1.4927 1.4167,-1.4927 l 3.041,3.5334 c 0,0 -3.7886,6.2686 -7.8643,10.8311'                 //>
   +  ' c -1.1974,1.3404 -2.0523,2.1699 -3.3303,3.0162 c -2.009,1.3304 -6.3183,4.4257 -10.9711,5.6127'                     //>
   +  ' c -9.1585,2.3364 -21.03003,2.2149 -29.18707,-1.1141 c -5.807,-2.3699 -13.38424,-8.7285 -17.50386,-15.613'          //>
   +  ' c -4.78206,-7.9914 -5.48623,-16.845 -5.48623,-16.845 z"'                                                           //>
   + ' sodipodi:nodetypes="cssssccssssscc"'                                                                                //>
   + '/>';                                                                                              //>
  sSvg += '</g>';                                                                                       //>
 return sSvg;                                                                                           //>
 }//New_sSvgLayer_Elements////////////////////////////////////////////////////////////////////////////////>


 function               sNew_SvgLayer_Holes(//////////////////////////////////////////////////////////////> Add layer to SVG file, showing the perimeter holes.
 )                                      :String {/////////////////////////////////////////////////////////>
  var                   sSTYLE          :String                 =                                       //>
                                         "display"              +":none"                                //>
                                        +'opacity'              +':0.5'                                 //>
                                        +';stroke'              +':none'                                //>
                                        +';stroke-width'        +':2'                                   //>
                                        +';stroke-linecap'      +':round'                               //>
                                        +';stroke-linejoin'     +':round'                               //>
                                        +';stroke-dashoffset'   +':4'                                   //>
                                        ;                                                               //>
  var                                   sSvg                    = "";                                   //>
  var                                   a2dHoles                = [                                     //> Table of positions of perimeter holes.
                 [104.774  ,10.7099 ] ,[119.3421 ,11.87575] ,[131.5833 ,14.65284] ,[141.2666 ,17.8867 ] //>
                ,[152.2471 ,25.24966] ,[160.2312 ,30.82213] ,[166.772  ,38.45915] ,[172.3079 ,45.40189] //>
                ,[176.839  ,55.28616] ,[180.6392 ,65.44449] ,[182.046  ,78.36165] ,[181.5162 ,90.85859] //>
                ,[179.1411 ,103.7392] ,[174.1532 ,117.1131] ,[166.7355 ,128.7514] ,[157.1801 ,139.3116] //>
                ,[147.8256 ,146.8025] ,[136.4432 ,153.4346] ,[124.3847 ,157.0156] ,[112.3263 ,159.61  ] //>
                ,[99.28123 ,159.5004] ,[86.18137 ,157.2166] ,[75.47493 ,153.6904] ,[64.20211 ,149.1046] //>
                ,[53.93415 ,142.6734] ,[44.59799 ,134.5431] ,[35.88302 ,124.4761] ,[29.65282 ,112.4542] //>
                ,[25.7795  ,99.24469] ,[23.86111 ,88.28247] ,[24.71982 ,75.47493] ,[26.85745 ,63.14243] //>
                ,[31.38851 ,51.08398] ,[48.27034 ,29.74418] ,[37.94757 ,40.7064 ] ,[58.66618 ,24.35441] //>
                ,[80.86469 ,14.23263] ,[92.63081 ,11.61996] ,[69.84765 ,18.94638]                       //>
                                                                  ];                                    //>
  sSvg += sSvgLayer_g("Holes" ,"");                                                                     //>
  var                                   iHoles                 = 1;                                     //>
  for( ad in a2dHoles ){                                                                                //>
   sSvg +=  '<circle id="path'+ iId() +'"'                                                              //>
         +  ' style="'+ sSTYLE +';fill'+':#ff0000' +'"'                                                 //>
         +  ' cx="'+ ad[0] +'"'         +  ' cy="'+ ad[1] +'"'         +  ' r="' + 0.6   +'"'           //>
         +  '/>'                                                                                        //>
         ;                                                                                              //>
  }//for ad                                                                                             //>
  sSvg += '</g>';                                                                                       //>
 return sSvg;                                                                                           //>
 }//New_sSvgLayer_Holes///////////////////////////////////////////////////////////////////////////////////>


 function               sNew_SvgSkyDiscLayers(////////////////////////////////////////////////////////////> Create SVG file showing alignments between Nebra Sky Disk and starts near Taurus and Gemini.
 )                                      :String {/////////////////////////////////////////////////////////>
  var                                   r_s                     = "";                                   //>
  r_s = sNew_SvgLayer_Image( "trans_scr_"+"stars"+"_"+"south"   +".png"  ,"stars" ,"south"   ,"") +r_s; //> Add layer containing an image (generated by stellarium script lunascope.ssc) - stars, looking south.
  r_s = sNew_SvgLayer_Image( "trans_scr_"+"lines"+"_"+"south"   +".png"  ,"lines" ,"south"              //>
                                                ,'style="filter:url(#'+ "filterWhiteLines" +')"') +r_s; //> " - constellation lines,
  r_s = sNew_SvgLayer_Image( "trans_scr_"+"path" +"_"+"south"   +".png"  ,"path"  ,"south"   ,"") +r_s; //> " - Moon's ecliptic
  r_s = sNew_SvgLayer_Image( "trans_scr_"+"dots" +"_"+"south"   +".png"  ,"dots"  ,"south"   ,"") +r_s; //> " - stars believed to be shown on Nebra Sky Disk,
  r_s = sNew_SvgLayer_Image(       "scr_"+"art"  +"_"+"south"   +".png"  ,"art"   ,"south"   ,"") +r_s; //> " - constellation artwork.
  r_s = sNew_SvgLayer_Image( "trans_scr_"+"stars"+"_"+"pleiades"+".png"  ,"stars" ,"pleiades","") +r_s; //> " - Stars, when looking at the Pleiades...
  r_s = sNew_SvgLayer_Image( "trans_scr_"+"lines"+"_"+"pleiades"+".png"  ,"lines" ,"pleiades"           //>
                                                ,'style="filter:url(#'+ "filterWhiteLines" +')"') +r_s; //> " - constellation lines,
  r_s = sNew_SvgLayer_Image( "trans_scr_"+"path" +"_"+"pleiades"+".png"  ,"path"  ,"pleiades","") +r_s; //> " - Moon's ecliptic
  r_s = sNew_SvgLayer_Image( "trans_scr_"+"dots" +"_"+"pleiades"+".png"  ,"dots"  ,"pleiades","") +r_s; //> " - stars believed to be shown on Nebra Sky Disk,
  r_s = sNew_SvgLayer_Image(       "scr_"+"art"  +"_"+"pleiades"+".png"  ,"art"   ,"pleiades","") +r_s; //> " - constellation artwork.
  r_s = sNew_SvgLayer_Holes(                                                                   ) + r_s; //> Add layer to SVG file, showing the perimeter holes.
  r_s = sNew_SvgLayers_Dots(                                                                   ) + r_s; //> Add layers to SVG file, highlighting dots believed to be in various sets.
  r_s = sNew_SvgLayer_Numbers(                                                                 ) + r_s; //> Add layer to SVG file, containing numbers for the dots.
  r_s = sNew_SvgLayer_Elements(                                                                ) + r_s; //> Add layer to SVG file, containing outlines of the big elements.
  r_s = sNew_SvgLayer_DiscPhoto(                                                               ) + r_s; //> Add layer to SVG file, containing the photo of the disc.
 return r_s;                                                                                            //>
 }//New_sSvgSkyDiscLayers/////////////////////////////////////////////////////////////////////////////////>


 function               new(//////////////////////////////////////////////////////////////////////////////> Construct a new object of this class (and run appropriate processing).
 )                                      :Void {///////////////////////////////////////////////////////////>
//New_ReadData();                                                                                       //> READING DATA:
  var                   sSvg            :String                 = sSvgFile_();                          //>
                                                                                                        //> Hardcoding! Choose output by commenting/uncommenting the following:
                                                                                                        //>
  sSvg += sNew_SvgSkyDiscLayers();                                                                      //> Create SVG for showing constellation alignments on Nebra Sky Disc.
                                                                                                        //>
  try{                                                                                                  //>
   sys.io.File.saveContent( _sPATHsVGoUT +_sSVGoUT ,sSvg );                                             //> Save the generated SVG file.
  }catch( e:haxe.Exception ){                                                                           //> If there is a problem, then
   trace(e.message);   trace(e.stack);                                                                  //> report it
  }//try                                                                                                //> .
  trace('Done');                                                                                        //>
 }//new///////////////////////////////////////////////////////////////////////////////////////////////////>


 static public function main(/////////////////////////////////////////////////////////////////////////////> Execution starts here.
 )                                      :Void {///////////////////////////////////////////////////////////>
  #if sys                                                                                               //> Just check.
   trace("OK. file system can be accessed");                                                            //>
  #end                                                                                                  //>
  new NebraDiscAlignment_svg();                                                                         //> Create and run and instance of this class.
 }//main//////////////////////////////////////////////////////////////////////////////////////////////////>


}//class NebraDiscAlignment_svg///////////////////////////////////////////////////////////////////////////>
//////////////////////////////////////////////////////////////////////////////////////////////////////////>


// End of file.
