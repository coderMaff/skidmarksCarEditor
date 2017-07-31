/** SkidMarks Car Editor V2.00 **/
/** Code : Maffia / Nerve Axis **/


OPT     OSVERSION=37

ENUM    NONE,ER_OPENLIB,ER_WB,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW,
        ER_MENUS,ER_ALLOC,ER_FILE

CONST   ZERO=0

MODULE  'intuition/intuition',
        'intuition/screens',
        'intuition/gadgetclass',
        'gadtools',
        'libraries/gadtools',
        'reqtools',
        'libraries/reqtools',
        'exec/nodes',
        'tools/file',
        'dos/dos',
        'exec/memory',
        'graphics/text'

DEF     scr=NIL:PTR TO screen,
        wnd=NIL:PTR TO window,
        mes:PTR TO intuimessage,
        glist=NIL,
        g:PTR TO gadget,
        req:PTR TO rtfilerequester,
        info:fileinfoblock,size,lock,handle,mem,read,
        dafile[120]:STRING,
        buf[120]:STRING, count,menu,visual=NIL,
        type,infos,
        topaz:PTR TO textattr,
        pscr=NIL:PTR TO screen,
        itsname[16]:STRING,
        data[8]:ARRAY OF INT,
        data2[8]:ARRAY OF INT


PROC main() HANDLE

DEF     class,code,address
        openinterface()
        REPEAT
               wait4message()
                SetAPen(wnd.rport,0)
                class:=mes.class
                code:=mes.code
                address:=mes.iaddress
                g:=address
           /*     WriteF('-\n')
                WriteF('Class:\h\n',class)
                WriteF('code.:\h\n',code)
                WriteF('addre:\h\n',address)
                WriteF('G.Gad:\h\n',g.gadgetid)
                WriteF('Infos:\h\n',infos) */

                IF (infos=$FFFFF820) OR (infos=2) THEN savevehicle(0)
                IF (infos=$FFFFF840) OR (infos=3) THEN savevehicle(1)
                IF (infos=$FFFFF880) OR (infos=5) THEN
                        RtEZRequestA('  SkidMarks Car Editor V2.00        \n'+
                                     '      (c)1995 Maffia / Nerve Axis   \n\n'+
                                     '  Many thanx  to  all those who made\n'+
                                     '  this possible, through their ideas\n'+
                                     '  and testing. Special thanx to ....\n'+
                                     '  "Wil$h / Nerve Axis",  for all his\n'+
                                     '  help after my HD crashed.         \n'+
                                     '                                    \n'+
                                     ' Send BUG! reports to me! See da dox!\n','_lET mE oUT|_eNUFF',0,0,[RT_UNDERSCORE,"_",RT_TEXTATTR,topaz,RT_WINDOW,wnd,RT_PUBSCRNAME,'SCE Screen'])
                IF (infos=$FFFFF8A0) OR (infos=6) THEN
                       IF RtEZRequestA('sURE tO qUIT?','_i`M gONE!|_eR...nAH!',0,0,[RT_WINDOW,wnd,RT_PUBSCRNAME,'SCE Screen',RT_UNDERSCORE,"_",RT_TEXTATTR,topaz]) THEN JUMP quit
                IF infos=7
                        data[1]:=mes.code
                        RectFill(wnd.rport,220,33,240,43)
                        doint(wnd.rport,220,35,1,code,2)
                ENDIF
                IF g.gadgetid=8
                        data[2]:=mes.code
                        RectFill(wnd.rport,220,53,240,63)
                        doint(wnd.rport,220,55,1,code,2)
                ENDIF
                IF g.gadgetid=9
                        data[3]:=mes.code
                        RectFill(wnd.rport,220,73,240,83)
                        doint(wnd.rport,220,75,1,code,2)
                ENDIF
                IF g.gadgetid=10
                        data[4]:=mes.code
                        RectFill(wnd.rport,220,93,240,103)
                        doint(wnd.rport,220,95,1,code,2)
                ENDIF
                IF g.gadgetid=11
                        data[5]:=mes.code
                        RectFill(wnd.rport,220,113,240,123)
                        doint(wnd.rport,220,115,1,code,2)
                ENDIF
                IF g.gadgetid=12
                        data[6]:=mes.code
                        RectFill(wnd.rport,220,133,240,143)
                        doint(wnd.rport,220,135,1,code,2)
                ENDIF
                IF g.gadgetid=13
                        data[7]:=mes.code
                        RectFill(wnd.rport,220,153,240,163)
                        doint(wnd.rport,220,155,1,code,2)
                ENDIF
                IF g.gadgetid=14
                        data[8]:=mes.code
                        RectFill(wnd.rport,220,173,240,183)
                        doint(wnd.rport,220,175,1,code,2)
                ENDIF

        UNTIL type=IDCMP_CLOSEWINDOW
quit:   Raise(NONE)
        closeinterface()
        CleanUp(0)
EXCEPT
        closeinterface()
        IF exception>0 THEN WriteF('Could not \s !\n',
         ListItem(['','open "gadtools.library" v37','lock workbench',
         'get visual infos','create context','create gadget',
         'open window','allocate menus'],exception))
ENDPROC


PROC openinterface()

        topaz:=['topaz.font',8,0,FPF_ROMFONT]:textattr
        IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ER_OPENLIB)
        IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN Raise(ER_OPENLIB)
        IF (req:=RtAllocRequestA(req,0))=NIL THEN Raise(ER_ALLOC)
        loadvehicle()
        scr:=OpenScreenTagList(0,
        [SA_TITLE,      'SkidMarks Car Editor (SCE) v2.00  by Maffia / Nerve Axis',
         SA_PUBNAME,    'SCE Screen',
         SA_PENS,       [$ffff]:INT,
         SA_FONT,       topaz,
         SA_FULLPALETTE,TRUE,
         SA_DEPTH,      2,
         SA_DISPLAYID,  $8000,
         SA_TYPE,       CUSTOMSCREEN,0])
        PubScreenStatus(scr,0)
        IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN Raise(ER_VISUAL)
        IF (g:=CreateContext({glist}))=NIL THEN Raise(ER_CONTEXT)
        IF (menu:=CreateMenusA([NM_TITLE,0,'fILE ',0,$0,0,0,
                NM_ITEM,0,'xxxxxxxxxxxxxxxxxxx','x',0,0,0,
                NM_ITEM,0,'Save Current Car...','s',0,0,0,
                NM_ITEM,0,'Save Current Car To','t',0,0,0,
                NM_ITEM,0,'xxxxxxxxxxxxxxxxxxx','x',0,0,0,
                NM_ITEM,0,'About..............','?',0,0,0,
                NM_ITEM,0,'Quit Out...........','q',0,0,0,
                0,0,0,0,0,0,0]:newmenu,0))=NIL THEN Raise(ER_MENUS)
        IF LayoutMenusA(menu,visual,[GTMN_TEXTATTR,topaz,
                                     GTMN_NEWLOOKMENUS,TRUE,GTMN_FRONTPEN,1,GTMN_FULLMENU,TRUE])=FALSE THEN Raise(ER_MENUS)
        g:=CreateContext({glist})
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[420,5,210,30,'Load new car',topaz,1,16,visual,0]:newgadget,
                [GT_UNDERSCORE,"_",GA_DISABLED,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[420,35,210,30,'Save current car',topaz,2,16,visual,0]:newgadget,
                [GT_UNDERSCORE,"_",0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[420,65,210,30,'Save current car to',topaz,3,16,visual,0]:newgadget,
                [GT_UNDERSCORE,"_",0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[420,95,210,30,'Reload',topaz,4,16,visual,0]:newgadget,
                [GT_UNDERSCORE,"_",GA_DISABLED,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[420,125,210,30,'About',topaz,5,16,visual,0]:newgadget,
                [GT_UNDERSCORE,"_",0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(BUTTON_KIND,g,[420,155,210,35,'Quit out',topaz,6,16,visual,0]:newgadget,
                [GT_UNDERSCORE,"_",0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,30,200,20,'Speed',topaz,7,16,visual,0]:newgadget,
               [GTSL_MIN,1,
                GTSL_MAX,$FF,
                GTSL_LEVEL,data[1],
                PGA_FREEDOM,LORIENT_HORIZ,
                GA_IMMEDIATE,TRUE,
                GA_RELVERIFY,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,50,200,20,'BDist',topaz,8,16,visual,0]:newgadget,
               [GTSL_MIN,1,
                GTSL_MAX,$FF,
                GTSL_LEVEL,data[2],
                PGA_FREEDOM,LORIENT_HORIZ,
                GA_IMMEDIATE,TRUE,
                GA_RELVERIFY,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,70,200,20,'Gravi',topaz,9,16,visual,0]:newgadget,
               [GTSL_MIN,1,
                GTSL_MAX,$FF,
                GTSL_LEVEL,data[3],
                PGA_FREEDOM,LORIENT_HORIZ,
                GA_IMMEDIATE,TRUE,
                GA_RELVERIFY,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,90,200,20,'TurnS',topaz,10,16,visual,0]:newgadget,
               [GTSL_MIN,1,
                GTSL_MAX,$FF,
                GTSL_LEVEL,data[4],
                PGA_FREEDOM,LORIENT_HORIZ,
                GA_IMMEDIATE,TRUE,
                GA_RELVERIFY,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,110,200,20,'JumpH',topaz,11,16,visual,0]:newgadget,
               [GTSL_MIN,1,
                GTSL_MAX,$FF,
                GTSL_LEVEL,data[5],
                PGA_FREEDOM,LORIENT_HORIZ,
                GA_IMMEDIATE,TRUE,
                GA_RELVERIFY,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,130,200,20,'BounH',topaz,12,16,visual,0]:newgadget,
               [GTSL_MIN,1,
                GTSL_MAX,$FF,
                GTSL_LEVEL,data[6],
                PGA_FREEDOM,LORIENT_HORIZ,
                GA_IMMEDIATE,TRUE,
                GA_RELVERIFY,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,150,200,20,'ShadX',topaz,13,16,visual,0]:newgadget,
               [GTSL_MIN,1,
                GTSL_MAX,$FF,
                GTSL_LEVEL,data[7],
                PGA_FREEDOM,LORIENT_HORIZ,
                GA_IMMEDIATE,TRUE,
                GA_RELVERIFY,TRUE,0]))=NIL THEN Raise(ER_GADGET)
        IF (g:=CreateGadgetA(SLIDER_KIND,g,[10,170,200,20,'ShadY',topaz,14,16,visual,0]:newgadget,
               [GTSL_MIN,1,
                GTSL_MAX,$FF,
                GTSL_LEVEL,data[8],
                PGA_FREEDOM,LORIENT_HORIZ,
                GA_IMMEDIATE,TRUE,
                GA_RELVERIFY,TRUE,0]))=NIL THEN Raise(ER_GADGET)

        IF (wnd:=OpenWindowTagList(NIL,
                 [WA_LEFT,0,
                  WA_TOP,11,
                  WA_WIDTH,640,
                  WA_HEIGHT,245,
                  WA_IDCMP,IDCMP_MOUSEBUTTONS OR IDCMP_MENUPICK OR
                           IDCMP_GADGETUP OR IDCMP_RAWKEY,
                  WA_FLAGS,WFLG_SMART_REFRESH OR WFLG_ACTIVATE OR
                           WFLG_NEWLOOKMENUS OR WFLG_BACKDROP,
                  WA_CUSTOMSCREEN,scr,
                  WA_GADGETS,glist,
                  NIL]))=NIL THEN Raise(ER_WINDOW)

        IF SetMenuStrip(wnd,menu)=FALSE THEN Raise(ER_MENUS)
        Gt_RefreshWindow(wnd,NIL)
        DrawBevelBoxA(wnd.rport,10,5,410,25,[GT_VISUALINFO,visual])
        DrawBevelBoxA(wnd.rport,10,190,620,50,[GT_VISUALINFO,visual])
        dotext(wnd.rport,040,010,1,'Editing Car:')
        dotext(wnd.rport,150,010,1,itsname)
        dotext(wnd.rport,270,035,1,'Speed')
        dotext(wnd.rport,270,055,1,'Bounce Distance')
        dotext(wnd.rport,270,075,1,'Gravity')
        dotext(wnd.rport,270,095,1,'Rotation Speed')
        dotext(wnd.rport,270,115,1,'Jump Hight')
        dotext(wnd.rport,270,135,1,'Bounce Hight')
        dotext(wnd.rport,270,155,1,'Shadow X')
        dotext(wnd.rport,270,175,1,'Shadow Y')
        doint(wnd.rport,220,035,1,data[1],2)
        doint(wnd.rport,220,055,1,data[2],2)
        doint(wnd.rport,220,075,1,data[3],2)
        doint(wnd.rport,220,095,1,data[4],2)
        doint(wnd.rport,220,115,1,data[5],2)
        doint(wnd.rport,220,135,1,data[6],2)
        doint(wnd.rport,220,155,1,data[7],2)
        doint(wnd.rport,220,175,1,data[8],2)
        dotext(wnd.rport,039,195,1,'  _/\\_______/\\_____/\\____        +------------------------------------+')
        dotext(wnd.rport,039,203,1,'  \\  ______/  ____/  ___/        |  SkidMarks Car Editor v2.oO        |')
        dotext(wnd.rport,039,211,1,'  /\\____ \\     | \\   _j\\         |   Code : Maffia / Nerve Axis       |')
        dotext(wnd.rport,039,219,1,'_/        \\_   |  \\     \\_       |   Idea : Maffia / NVX & Matt Indy  |')
        dotext(wnd.rport,039,227,1,'\\__________/______/______/v2.oO  +------------------------------------+')
ENDPROC





PROC closeinterface()
  IF wnd THEN ClearMenuStrip(wnd)
  IF menu THEN FreeMenus(menu)
  IF visual THEN FreeVisualInfo(visual)
  StripFont(topaz)
  IF wnd THEN CloseWindow(wnd)
  IF glist THEN FreeGadgets(glist)
  IF scr THEN CloseScreen(scr)
  IF pscr THEN UnlockPubScreen(NIL,pscr)
  RtFreeRequest(req)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
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


PROC loadvehicle()

DEF name,n,tems[1]:STRING,conv

        buf[0]:=0
        itsname:='                          '
        IF RtFileRequestA(req,buf,'Select Car to Load',[RT_TEXTATTR,topaz,
                                                        RT_WINDOW,wnd,
                                                        RT_PUBSCRNAME,'SCE Screen',
                                                        RTFI_FLAGS,FALSE])
                        StrCopy(dafile,req.dir)
                        count:=StrLen(dafile)
                        StrCopy(itsname,buf,16)
                        IF StrCmp(dafile,'')
                                StrCopy(dafile,buf)
                        ELSE
                                IF dafile[count-1]=58
                                        StrCopy(dafile,req.dir)
                                        StrAdd(dafile,buf)
                                ELSE
                                        StrCopy(dafile,req.dir)
                                        StrAdd(dafile,'/',1)
                                        StrAdd(dafile,buf)
                                ENDIF
                        ENDIF
                ELSE
                        JUMP quit
                ENDIF
        IF (name:=Open(dafile,MODE_OLDFILE))=NIL
                JUMP quit
        ELSE
                data2[1]:=Inp(name)
                data[1]:=Inp(name)
                data2[2]:=Inp(name)
                data[2]:=Inp(name)
                data2[3]:=Inp(name)
                data[3]:=Inp(name)
                data2[4]:=Inp(name)
                data[4]:=Inp(name)
                data2[5]:=Inp(name)
                data[5]:=Inp(name)
                data2[6]:=Inp(name)
                data[6]:=Inp(name)
                data2[7]:=Inp(name)
                data[7]:=Inp(name)
                data2[8]:=Inp(name)
                data[8]:=Inp(name)
                Close(name)

        ENDIF
ENDPROC

PROC savevehicle(requester)

DEF name,n,tems[1]:STRING,conv

IF requester=1
        buf[0]:=0
        itsname:='                          '
        IF RtFileRequestA(req,buf,'Select Car to Save',[RT_TEXTATTR,topaz,
                                                        RT_WINDOW,wnd,
                                                        RT_PUBSCRNAME,'SCE Screen',
                                                        RTFI_FLAGS,FREQF_SAVE])
                        StrCopy(dafile,req.dir)
                        count:=StrLen(dafile)
                        StrCopy(itsname,buf,16)
                        IF StrCmp(dafile,'')
                                StrCopy(dafile,buf)
                        ELSE
                                IF dafile[count-1]=58
                                        StrCopy(dafile,req.dir)
                                        StrAdd(dafile,buf)
                                ELSE
                                        StrCopy(dafile,req.dir)
                                        StrAdd(dafile,'/',1)
                                        StrAdd(dafile,buf)
                                ENDIF
                        ENDIF
                ELSE
                        JUMP out
                ENDIF

ENDIF
        RectFill(wnd.rport,150,10,300,20)
        dotext(wnd.rport,150,010,1,itsname)
        name:=Open(dafile,MODE_NEWFILE)
        Out(name,data2[1])
        Out(name,data[1])
        Out(name,data2[2])
        Out(name,data[2])
        Out(name,data2[3])
        Out(name,data[3])
        Out(name,data2[4])
        Out(name,data[4])
        Out(name,data2[5])
        Out(name,data[5])
        Out(name,data2[6])
        Out(name,data[6])
        Out(name,data2[7])
        Out(name,data[7])
        Out(name,data2[8])
        Out(name,data[8])
        Write(name,'SCEv2 NVX~95',9)
        Close(name)

out:

ENDPROC


PROC dotext(rast,xcor,ycor,cula,crap)
        PrintIText(rast,[cula,0,0,0,0,topaz,crap,NIL]:intuitext,xcor,ycor)
ENDPROC

PROC doint(rast,xcor,ycor,cula,crap,tipe)
DEF     conv[15]:STRING
        IF tipe=1 THEN StringF(conv,'\d',crap)
        IF tipe=2 THEN StringF(conv,'\z\h[2]',crap)
        PrintIText(rast,[cula,0,0,0,0,topaz,conv,NIL]:intuitext,xcor,ycor)
ENDPROC

CHAR '$VER: SCE 2.00 (xx.03.95)'