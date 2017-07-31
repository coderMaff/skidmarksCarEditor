/* Skidmarks Car Editor v1.02  ßeta */
/*   (c)1995 Maffia / Nerve Axis    */

OPT     OSVERSION=37

ENUM    NONE,ER_OPENLIB,ER_WB,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW,
        ER_ALLOC,ER_FILE

MODULE  'intuition/intuition',
        'gadtools',
        'libraries/gadtools',
        'intuition/gadgetclass',
        'exec/nodes',
        'intuition/screens',
        'tools/file',
        'dos/dos',
        'exec/memory',
        'graphics/text'

DEF     scr=NIL:PTR TO screen,
        wnd=NIL:PTR TO window,
        mes:PTR TO intuimessage,
        glist=NIL,
        g:PTR TO gadget,
        offy,
        visual=NIL,
        type,
        infos,
        porsche[8]:ARRAY OF INT,
        truck[8]:ARRAY,
        camaro[8]:ARRAY,
        buggy[8]:ARRAY,
        topaz

PROC main() HANDLE
        initarrays()
        topaz:=['topaz.font',8,0,FPF_ROMFONT]:textattr
        IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_OPENLIB)
        IF (scr:=LockPubScreen('Workbench'))=NIL THEN Raise(ER_WB)
        IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN Raise(ER_VISUAL)
start:  openinterface()
        REPEAT
                TextF(245,206,'  »»INFoRMATioN««')
                wait4message()
                TextF(240,216,'   Value:  \h[5]  ',mes.code)
                TextF(240,224,'   Id...:  \h[5]  ',g.gadgetid)
                TextF(240,232,'   Addr.:\h[7]  ',mes.iaddress)
                TextF(240,240,'   Class:  \h[5]  ',mes.class)

                g:=mes.iaddress

                IF g.gadgetid=1 THEN porsche[1]:=mes.code
                IF g.gadgetid=2 THEN porsche[2]:=mes.code
                IF g.gadgetid=3 THEN porsche[3]:=mes.code
                IF g.gadgetid=4 THEN porsche[4]:=mes.code
                IF g.gadgetid=5 THEN porsche[5]:=mes.code
                IF g.gadgetid=6 THEN porsche[6]:=mes.code
                IF g.gadgetid=7 THEN porsche[7]:=mes.code
                IF g.gadgetid=8 THEN porsche[8]:=mes.code
                IF g.gadgetid=9 THEN truck[1]:=mes.code
                IF g.gadgetid=10 THEN truck[2]:=mes.code
                IF g.gadgetid=11 THEN truck[3]:=mes.code
                IF g.gadgetid=12 THEN truck[4]:=mes.code
                IF g.gadgetid=13 THEN truck[5]:=mes.code
                IF g.gadgetid=14 THEN truck[6]:=mes.code
                IF g.gadgetid=15 THEN truck[7]:=mes.code
                IF g.gadgetid=16 THEN truck[8]:=mes.code
                IF g.gadgetid=17 THEN camaro[1]:=mes.code
                IF g.gadgetid=18 THEN camaro[2]:=mes.code
                IF g.gadgetid=19 THEN camaro[3]:=mes.code
                IF g.gadgetid=20 THEN camaro[4]:=mes.code
                IF g.gadgetid=21 THEN camaro[5]:=mes.code
                IF g.gadgetid=22 THEN camaro[6]:=mes.code
                IF g.gadgetid=23 THEN camaro[7]:=mes.code
                IF g.gadgetid=24 THEN camaro[8]:=mes.code
                IF g.gadgetid=25 THEN buggy[1]:=mes.code
                IF g.gadgetid=26 THEN buggy[2]:=mes.code
                IF g.gadgetid=27 THEN buggy[3]:=mes.code
                IF g.gadgetid=28 THEN buggy[4]:=mes.code
                IF g.gadgetid=29 THEN buggy[5]:=mes.code
                IF g.gadgetid=30 THEN buggy[6]:=mes.code
                IF g.gadgetid=31 THEN buggy[7]:=mes.code
                IF g.gadgetid=32 THEN buggy[8]:=mes.code
                IF g.gadgetid=33 THEN saveporsche()
                IF g.gadgetid=34 THEN savetruck()
                IF g.gadgetid=35 THEN savecamaro()
                IF g.gadgetid=36 THEN savebuggy()
                IF g.gadgetid=37
                        loadporsche()
                        closeinterface()
                        JUMP start
                ENDIF
                IF g.gadgetid=38
                        loadtruck()
                        closeinterface()
                        JUMP start
                ENDIF
                IF g.gadgetid=39
                        loadcamaro()
                        closeinterface()
                        JUMP start
                ENDIF
                IF g.gadgetid=40
                        loadbuggy()
                        closeinterface()
                        JUMP start
                ENDIF
                IF g.gadgetid=41
                        saveporsche()
                        savetruck()
                        savecamaro()
                        savebuggy()
                ENDIF
                IF g.gadgetid=42
                        initarrays()
                        closeinterface()
                        JUMP start
                ENDIF
                IF g.gadgetid=43
                        loadporsche()
                        loadtruck()
                        loadcamaro()
                        loadbuggy()
                        closeinterface()
                        JUMP start
                ENDIF
                IF g.gadgetid=44 THEN brag()

        UNTIL type=IDCMP_CLOSEWINDOW
        Raise(NONE)
        CleanUp(0)
EXCEPT
        closeall()
        IF exception>0 THEN WriteF('Could not \s !\n',
         ListItem(['','open "gadtools.library" v37','lock workbench',
         'get visual infos','create context','create gadget',
         'open window','allocate alloc','file it!'],exception))
ENDPROC

PROC openinterface()
        IF (g:=CreateContext({glist}))=NIL THEN Raise(ER_CONTEXT)

/* Porsche */


        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,20,255,10,'   Speed   ',NIL,1,PLACETEXT_RIGHT,visual,30]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,porsche[1],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,30,255,10,'   BDist   ',NIL,2,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,porsche[2],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,40,255,10,'   Gravi',NIL,3,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,porsche[3],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,50,255,10,'   TurnS  ',NIL,4,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,porsche[4],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,60,255,10,'   JumpH   ',NIL,5,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,porsche[5],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,70,255,10,'   BounH  ',NIL,6,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,porsche[6],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,80,255,10,'   ShadX  ',NIL,7,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,porsche[7],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
         IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,90,255,10,'   ShadY  ',NIL,8,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,porsche[8],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
/* Porsche End */

/* Truck */

        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,20,255,10,'',NIL,9,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,truck[1],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,30,255,10,'',NIL,10,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,truck[2],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,40,255,10,'',NIL,11,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,truck[3],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,50,255,10,'',NIL,12,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,truck[4],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,60,255,10,'',NIL,13,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,truck[5],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,70,255,10,'',NIL,14,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,truck[6],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,80,255,10,'',NIL,15,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,truck[7],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
         IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,90,255,10,'',NIL,16,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,truck[8],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
/* Truck End */

/* Camaro */

        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,110,255,10,'   Speed   ',NIL,17,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,camaro[1],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,120,255,10,'   BDist    ',NIL,18,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,camaro[2],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,130,255,10,'   Gravi  ',NIL,19,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,camaro[3],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,140,255,10,'   TurnS  ',NIL,20,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,camaro[4],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,150,255,10,'   JumpH  ',NIL,21,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,camaro[5],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,160,255,10,'   BounH  ',NIL,22,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,camaro[6],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,170,255,10,'   ShadX  ',NIL,23,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,camaro[7],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
         IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,180,255,10,'   ShadY  ',NIL,24,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,camaro[8],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
/* Camaro End */

/* Buggy */

        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,110,255,10,'',NIL,25,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,buggy[1],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,120,255,10,'',NIL,26,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,buggy[2],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,130,255,10,'',NIL,27,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,buggy[3],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,140,255,10,'',NIL,28,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,buggy[4],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,150,255,10,'',NIL,29,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,buggy[5],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,160,255,10,'',NIL,30,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,buggy[6],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,170,255,10,'',NIL,31,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,buggy[7],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[375,180,255,10,'',NIL,32,PLACETEXT_RIGHT,visual,0]:newgadget,
                [GTSL_MIN,0,
                 GTSL_MAX,255,
                 GTSL_LEVEL,buggy[8],
                 PGA_FREEDOM,LORIENT_HORIZ,
                 GA_RELVERIFY,TRUE,
                 GA_IMMEDIATE,TRUE,0]))=NIL THEN Raise(ER_GADGET)
/* Buggy End */

        IF (g:=CreateGadgetA(BUTTON_KIND,g,[10,190,110,15,'Save Porsche',NIL,33,16,visual,0]:newgadget,
                [NIL]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[10,205,110,15,'Save Truck',NIL,34,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[10,220,110,15,'Save Camaro',NIL,35,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[10,235,110,15,'Save Buggy',NIL,36,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[520,190,110,15,'Load Porsche',NIL,37,16,visual,0]:newgadget,
                [NIL]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[520,205,110,15,'Load Truck',NIL,38,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[520,220,110,15,'Load Camaro',NIL,39,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[520,235,110,15,'Load Buggy',NIL,40,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[120,190,109,30,'Save All',NIL,41,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[120,220,109,30,'Defaults',NIL,42,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[411,190,109,30,'Load All',NIL,43,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[411,220,109,30,'  About',NIL,44,16,visual,0]:newgadget,
                [0]))=NIL THEN Raise(ER_GADGET)
        IF (wnd:=OpenW(0,0,640,256,$304 OR SCROLLERIDCMP,$E,
                'SkidMarks Car Editor v1.02 ßeta  by Maffia / Nerve Axis in 95',NIL,1,glist))=NIL THEN Raise(ER_WINDOW)
        Line(230,190,410,190,2)
        Line(230,190,230,250,2)
        Line(230,250,410,250)
        Line(410,190,410,250)

        Line(235,195,405,195)
        Line(235,195,235,245)
        Line(405,245,235,245,2)
        Line(405,245,405,195,2)

        Colour(1,0)
        TextF(10,18,'          Porsche                 Attribute             Truck')
        TextF(10,108,'          Camaro                  Attribute             Buggy')
ENDPROC

PROC closeinterface()
         IF glist THEN FreeGadgets(glist)
            WriteF('dun glist during proggy\n')
         IF wnd THEN CloseWindow(wnd)
            WriteF('dun wnd during proggy\n')
ENDPROC

PROC closeall()
  IF wnd THEN ClearMenuStrip(wnd)
  IF visual THEN FreeVisualInfo(visual)
  StripFont(topaz)
  IF wnd THEN CloseWindow(wnd)
  IF glist THEN FreeGadgets(glist)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
/*  IF wnd THEN CloseWindow(wnd)
     WriteF('dun wnd\n')
  IF glist THEN FreeGadgets(glist)
     WriteF('Dun Glist\n')
  IF visual THEN FreeVisualInfo(visual)
     WriteF('dun visual\n')
  IF scr THEN UnlockPubScreen(NIL,scr)
     WriteF('dun scr\n')
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
      WriteF('did dun gadtools\n')
  StripFont(topaz)
     WriteF('dun topaz\n') */
ENDPROC



PROC initarrays()
        porsche[1]:=$02
        porsche[2]:=$fc
        porsche[3]:=$fc
        porsche[4]:=$01
        porsche[5]:=$0c
        porsche[6]:=$0a
        porsche[7]:=$14
        porsche[8]:=$0a
        truck[1]:=$06
        truck[2]:=$fc
        truck[3]:=$fa
        truck[4]:=$00
        truck[5]:=$09
        truck[6]:=$0a
        truck[7]:=$16
        truck[8]:=$0d
        camaro[1]:=$06
        camaro[2]:=$fc
        camaro[3]:=$fb
        camaro[4]:=$00
        camaro[5]:=$08
        camaro[6]:=$0a
        camaro[7]:=$16
        camaro[8]:=$0d
        buggy[1]:=$04
        buggy[2]:=$fe
        buggy[3]:=$fa
        buggy[4]:=$00
        buggy[5]:=$08
        buggy[6]:=$08
        buggy[7]:=$16
        buggy[8]:=$08
ENDPROC


PROC saveporsche()

DEF name
        name:=Open('Porsche.DeF',MODE_NEWFILE)
        Out(name,$00)
        Out(name,porsche[1])
        Out(name,$FF)
        Out(name,porsche[2])
        Out(name,$FF)
        Out(name,porsche[3])
        Out(name,00)
        Out(name,porsche[4])
        Out(name,00)
        Out(name,porsche[5])
        Out(name,00)
        Out(name,porsche[6])
        Out(name,00)
        Out(name,porsche[7])
        Out(name,00)
        Out(name,porsche[8])
        Write(name,'MaF/NvX95',9)
        Close(name)
        TextF(240,216,'HEX:\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]',porsche[1],porsche[2],porsche[3],porsche[4],porsche[5],porsche[6],porsche[7],porsche[8])
        TextF(240,224,'ASC:\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]',porsche[1],porsche[2],porsche[3],porsche[4],porsche[5],porsche[6],porsche[7],porsche[8])
        TextF(240,232,'      Porsche    ')
        TextF(240,240,'      Saved!!    ')
ENDPROC

PROC savetruck()

DEF name
        name:=Open('Truck.DeF',MODE_NEWFILE)
        Out(name,00)
        Out(name,truck[1])
        Out(name,$FF)
        Out(name,truck[2])
        Out(name,$FF)
        Out(name,truck[3])
        Out(name,00)
        Out(name,truck[4])
        Out(name,00)
        Out(name,truck[5])
        Out(name,00)
        Out(name,truck[6])
        Out(name,00)
        Out(name,truck[7])
        Out(name,00)
        Out(name,truck[8])
        Write(name,'MaF/NvX95',9)
        Close(name)
        TextF(240,216,'HEX:\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]',truck[1],truck[2],truck[3],truck[4],truck[5],truck[6],truck[7],truck[8])
        TextF(240,224,'ASC:\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]',truck[1],truck[2],truck[3],truck[4],truck[5],truck[6],truck[7],truck[8])
        TextF(240,232,'       Truck     ')
        TextF(240,240,'      Saved!!    ')
ENDPROC

PROC savecamaro()

DEF name
        name:=Open('Camaro.DeF',MODE_NEWFILE)
        Out(name,00)
        Out(name,camaro[1])
        Out(name,$FF)
        Out(name,camaro[2])
        Out(name,$FF)
        Out(name,camaro[3])
        Out(name,00)
        Out(name,camaro[4])
        Out(name,00)
        Out(name,camaro[5])
        Out(name,00)
        Out(name,camaro[6])
        Out(name,00)
        Out(name,camaro[7])
        Out(name,00)
        Out(name,camaro[8])
        Write(name,'MaF/NvX95',9)
        Close(name)
        TextF(240,216,'HEX:\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]',camaro[1],camaro[2],camaro[3],camaro[4],camaro[5],camaro[6],camaro[7],camaro[8])
        TextF(240,224,'ASC:\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]',camaro[1],camaro[2],camaro[3],camaro[4],camaro[5],camaro[6],camaro[7],camaro[8])
        TextF(240,232,'      Camaro     ')
        TextF(240,240,'      Saved!     ')
ENDPROC

PROC savebuggy()

DEF name
        name:=Open('Buggy.DeF',MODE_NEWFILE)
        Out(name,00)
        Out(name,buggy[1])
        Out(name,$FF)
        Out(name,buggy[2])
        Out(name,$FF)
        Out(name,buggy[3])
        Out(name,00)
        Out(name,buggy[4])
        Out(name,00)
        Out(name,buggy[5])
        Out(name,00)
        Out(name,buggy[6])
        Out(name,00)
        Out(name,buggy[7])
        Out(name,00)
        Out(name,buggy[8])
        Write(name,'MaF/NvX95',9)
        Close(name)
        TextF(240,216,'HEX:\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]',buggy[1],buggy[2],buggy[3],buggy[4],buggy[5],buggy[6],buggy[7],buggy[8])
        TextF(240,224,'ASC:\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]',buggy[1],buggy[2],buggy[3],buggy[4],buggy[5],buggy[6],buggy[7],buggy[8])
        TextF(240,232,'       Buggy     ')
        TextF(240,240,'      Saved!!    ')
ENDPROC


PROC loadporsche()

DEF name

        IF (name:=Open('Porsche.DeF',MODE_OLDFILE))=NIL
                TextF(240,216,'                 ')
                TextF(240,224,'     Load Failed ')
                TextF(240,232,'                 ')
                TextF(240,240,'                 ')
        ELSE
                Inp(name)
                porsche[1]:=Inp(name)
                Inp(name)
                porsche[2]:=Inp(name)
                Inp(name)
                porsche[3]:=Inp(name)
                Inp(name)
                porsche[4]:=Inp(name)
                Inp(name)
                porsche[5]:=Inp(name)
                Inp(name)
                porsche[6]:=Inp(name)
                Inp(name)
                porsche[7]:=Inp(name)
                Inp(name)
                porsche[8]:=Inp(name)
                Close(name)
                TextF(240,216,'HEX:\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]',porsche[1],porsche[2],porsche[3],porsche[4],porsche[5],porsche[6],porsche[7],porsche[8])
                TextF(240,224,'ASC:\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]',porsche[1],porsche[2],porsche[3],porsche[4],porsche[5],porsche[6],porsche[7],porsche[8])
                TextF(240,232,'      Porsche    ')
                TextF(240,240,'      Loaded!    ')
        ENDIF
ENDPROC


PROC loadtruck()

DEF name

        IF (name:=Open('truck.DeF',MODE_OLDFILE))=NIL
                TextF(240,216,'                 ')
                TextF(240,224,'     Load Failed ')
                TextF(240,232,'                 ')
                TextF(240,240,'                 ')
        ELSE
                Inp(name)
                truck[1]:=Inp(name)
                Inp(name)
                truck[2]:=Inp(name)
                Inp(name)
                truck[3]:=Inp(name)
                Inp(name)
                truck[4]:=Inp(name)
                Inp(name)
                truck[5]:=Inp(name)
                Inp(name)
                truck[6]:=Inp(name)
                Inp(name)
                truck[7]:=Inp(name)
                Inp(name)
                truck[8]:=Inp(name)
                Close(name)
                TextF(240,216,'HEX:\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]',truck[1],truck[2],truck[3],truck[4],truck[5],truck[6],truck[7],truck[8])
                TextF(240,224,'ASC:\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]',truck[1],truck[2],truck[3],truck[4],truck[5],truck[6],truck[7],truck[8])
                TextF(240,232,'       Truck     ')
                TextF(240,240,'      Loaded!    ')
        ENDIF
ENDPROC


PROC loadcamaro()

DEF name

        IF (name:=Open('camaro.DeF',MODE_OLDFILE))=NIL
                TextF(240,216,'                 ')
                TextF(240,224,'     Load Failed ')
                TextF(240,232,'                 ')
                TextF(240,240,'                 ')
        ELSE
                Inp(name)
                camaro[1]:=Inp(name)
                Inp(name)
                camaro[2]:=Inp(name)
                Inp(name)
                camaro[3]:=Inp(name)
                Inp(name)
                camaro[4]:=Inp(name)
                Inp(name)
                camaro[5]:=Inp(name)
                Inp(name)
                camaro[6]:=Inp(name)
                Inp(name)
                camaro[7]:=Inp(name)
                Inp(name)
                camaro[8]:=Inp(name)
                Close(name)
                TextF(240,216,'HEX:\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]',camaro[1],camaro[2],camaro[3],camaro[4],camaro[5],camaro[6],camaro[7],camaro[8])
                TextF(240,224,'ASC:\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]',camaro[1],camaro[2],camaro[3],camaro[4],camaro[5],camaro[6],camaro[7],camaro[8])
                TextF(240,232,'      Camaro     ')
                TextF(240,240,'      Loaded     ')
        ENDIF
ENDPROC


PROC loadbuggy()

DEF name

        IF (name:=Open('buggy.DeF',MODE_OLDFILE))=NIL
                TextF(240,216,'                 ')
                TextF(240,224,'     Load Failed ')
                TextF(240,232,'                 ')
                TextF(240,240,'                 ')
        ELSE
                Inp(name)
                buggy[1]:=Inp(name)
                Inp(name)
                buggy[2]:=Inp(name)
                Inp(name)
                buggy[3]:=Inp(name)
                Inp(name)
                buggy[4]:=Inp(name)
                Inp(name)
                buggy[5]:=Inp(name)
                Inp(name)
                buggy[6]:=Inp(name)
                Inp(name)
                buggy[7]:=Inp(name)
                Inp(name)
                buggy[8]:=Inp(name)
                Close(name)
                TextF(240,216,'HEX:\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]\h[2]',buggy[1],buggy[2],buggy[3],buggy[4],buggy[5],buggy[6],buggy[7],buggy[8])
                TextF(240,224,'ASC:\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]\s[2]',buggy[1],buggy[2],buggy[3],buggy[4],buggy[5],buggy[6],buggy[7],buggy[8])
                TextF(240,232,'       Buggy     ')
                TextF(240,240,'      Loaded!    ')
        ENDIF
ENDPROC




PROC wait4message()
  DEF g:PTR TO gadget
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(wnd.userport)
      type:=mes.class
      IF type=IDCMP_MENUPICK
        infos:=mes.code
      ELSEIF (type=IDCMP_GADGETDOWN) OR (type=IDCMP_GADGETUP)
        g:=mes.iaddress
        infos:=g.gadgetid
      ELSEIF type=IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(wnd)
        Gt_EndRefresh(wnd,TRUE)
        type:=0
      ELSEIF type<>IDCMP_CLOSEWINDOW
        type:=0
      ENDIF
      Gt_ReplyIMsg(mes)
    ELSE
      Wait(-1)
    ENDIF
  UNTIL type
ENDPROC

PROC brag()

DEF bragwnd           
        IF (bragwnd:=OpenW(100,20,540,200,$304 OR SCROLLERIDCMP,$800,
                '',NIL,1,NIL))=NIL THEN Raise(ER_WINDOW)
        TextF(10,10,' "°×x×°" ')
        REPEAT 
        UNTIL Mouse()=2
        CloseW(bragwnd)
ENDPROC

        