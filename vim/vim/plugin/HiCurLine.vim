" HiCurLine : an attempt to highlight matching brackets as one moves
"  Author:  Charles E. Campbell, Jr.
"  Date:    Nov 22, 2005
"  Version: 6
"
" A Vim v6.0 plugin with menus for gvim
"
" GetLatestVimScripts: 555 1 :AutoInstall: HiCurLine.vim
" Usage: {{{1
"   \hcli : initialize highlighting of matching bracket
"   \hcls : stop       highlighting of matching bracket
"
"   Actually <Leader> is used, so you may set mapleader to change
"   the leading backslash to whatever you want in your <.vimrc>
"
" Method: {{{1
"	This script attempts to intercept most motion commands
"   and to to use the "match" command to highlight the current
"   line.  The HL_HiCurLine variable may be set by the user
"   to any highlighting group.  If no such variable is set,
"   then the Search highlighting group will be used.  Any
"   maps already assigned to the motion command keys will be
"   saved by \hcli and restored by \hcls.
"
"     Example: (of something that could be put into a <.vimrc>)
"       hi HL_HiCurLine ctermfg=blue ctermbg=cyan guifg=blue guibg=cyan
"		let HL_HiCurLine= "HL_HiCurLine"

" ---------------------------------------------------------------------
" Load Once: {{{1
if &cp || exists("g:loaded_HiCurLine")
 finish
endif
let s:keepcpo= &cpo
set cpo&vim
let g:loaded_HiCurLine= "v6"

" ---------------------------------------------------------------------
" Public Interface: {{{1
if !hasmapto('<Plug>HCLStart')
 map <unique> <Leader>hcli	<Plug>HCLStart
endif
if !hasmapto('<Plug>HCLStop')
 map <unique> <Leader>hcls	<Plug>HCLStop
endif
if !hasmapto('<Plug>HCLToggle')
 map <unique> <Leader>hclt	<Plug>HCLToggle
endif
com! HCLstart   set lz|call <SID>HCLStart()|set nolz
com! HCLstop    set lz|call <SID>HCLStop()|set nolz
com! HCL        set lz|call <SID>HCLToggle()|set nolz

" ---------------------------------------------------------------------
" Global Maps: {{{2
nmap <silent> <unique> <script> <Plug>HCLStart  :set lz<CR>:call <SID>HCLStart()<CR>:set nolz<CR>
nmap <silent> <unique> <script> <Plug>HCLStop   :set lz<CR>:call <SID>HCLStop()<CR>:set nolz<CR>
nmap <silent> <unique> <script> <Plug>HCLToggle :set lz<bar>if exists("b:dohicurline")<bar>call <SID>HCLStop()<bar>else<bar>call <SID>HCLStart()<bar>endif<bar>set nolz<CR>

" ---------------------------------------------------------------------
" DrChip Menu Support: {{{2
if has("gui_running") && has("menu") && &go =~ 'm'
 if !exists("g:DrChipTopLvlMenu")
  let g:DrChipTopLvlMenu= "DrChip."
 endif
 exe 'menu '.g:DrChipTopLvlMenu.'HiCurLine.Start<tab>\\hcli	<Leader>hcli'
endif

" =====================================================================
" Functions: {{{1

" HCLStart: {{{2
fun! <SID>HCLStart()
"  call Dfunc("HCLStart()")
  if exists("b:dohicurline")
"   call Dret("HCLStart : b:dohicurline already exists!")
   return
  endif

  call s:HCLHighlight()
"  call Decho("set up HCL_AUGROUP (CursorHold,FocusGained) events")
  augroup HCL_AUGROUP
    au!
    au CursorHold,FocusGained	*	silent call <SID>HCLHighlight()
  augroup END

  if exists("b:dohicurline") && b:dohicurline == 1
    " already in HiCurLine mode
    echo "[HiCurLine]"
"    call Dret("HCLStart : already in HiCurLine mode")
    return
  endif
  let b:dohicurline= 1
  let b:restoremap = ""
 
  augroup HCLTimer
   au!
   au CursorHold * silent call s:HiCurLine()
  augroup END
 
  " Save Maps (if any)
  call <SID>SaveMap("n","","<c-b>")
  call <SID>SaveMap("n","","<c-d>")
  call <SID>SaveMap("n","","<c-f>")
  call <SID>SaveMap("n","","<c-u>")
  call <SID>SaveMap("n","","<down>")
  call <SID>SaveMap("n","","<end>")
  call <SID>SaveMap("n","","<home>")
  call <SID>SaveMap("n","","<left>")
  call <SID>SaveMap("n","","<right>")
  call <SID>SaveMap("n","","<up>")
  call <SID>SaveMap("n","","webHMLEBjklh-+G")
  call <SID>SaveMap("i","","<down>")
  call <SID>SaveMap("i","","<end>")
  call <SID>SaveMap("i","","<home>")
  call <SID>SaveMap("i","","<left>")
  call <SID>SaveMap("i","","<right>")
  call <SID>SaveMap("i","","<up>")
  if has("gui_running") && has("menu")
   call <SID>SaveMap("n","","<leftmouse>")
   call <SID>SaveMap("i","","<leftmouse>")
   call <SID>SaveMap("i","","<CR>")
  endif
 
  " keep and set options
  let b:hicurline_vbkeep      = &vb
  let b:hicurline_t_vbkeep    = &t_vb
  let b:hicurline_utkeep      = &ut
  set vb t_vb=
  set ut=200
 
  " indicate in HiCurLine mode
  echo "[HiCurLine]"
 
  " Install HiCurLine maps
  inoremap <silent> <down>       <down><c-o>:silent call <SID>HiCurLine()<CR>
  inoremap <silent> <up>           <up><c-o>:silent call <SID>HiCurLine()<CR>
  inoremap <silent> <right>     <right><c-o>:silent call <SID>HiCurLine()<CR>
  inoremap <silent> <left>       <left><c-o>:silent call <SID>HiCurLine()<CR>
  inoremap <silent> <home>       <home><c-o>:silent call <SID>HiCurLine()<CR>
  inoremap <silent> <end>         <end><c-o>:silent call <SID>HiCurLine()<CR>
  inoremap <silent> <CR>           <CR><c-o>:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <down>                 j:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <up>                   k:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <right>                l:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <left>                 h:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <home>            <home>:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <end>              <end>:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> gg                    gg:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> G                      G:silent call <SID>HiCurLine()<CR>
  if has("gui_running") && has("menu")
   nnoremap <silent> <leftmouse> <leftmouse>:silent call <SID>HiCurLine()<CR>
   inoremap <silent> <leftmouse> <leftmouse><c-o>:silent call <SID>HiCurLine()<CR>
  endif
  nnoremap <silent>   w         w:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   b         b:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   B         B:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   e         e:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   E         E:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   H         H:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   M         M:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   L         L:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   j         j:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   k         k:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   l         l:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   h         h:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   %         %:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   -         -:silent call <SID>HiCurLine()<CR>
  nnoremap <silent>   +         +:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <c-f>   <c-f>:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <c-b>   <c-b>:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <c-d>   <c-d>:silent call <SID>HiCurLine()<CR>
  nnoremap <silent> <c-u>   <c-u>:silent call <SID>HiCurLine()<CR>
 
  " Insert stop  HiCurLine into menu
  " Delete start HiCurLine from menu
  if has("gui_running") && has("menu")
   exe 'unmenu '.g:DrChipTopLvlMenu.'HiCurLine.Start'
   exe 'menu '.g:DrChipTopLvlMenu.'HiCurLine.Stop<tab>\\hcls	<Leader>hcls'
  endif
 
  " highlight the current line
  silent call s:HiCurLine()

"  call Dret("HCLStart")
endfun

" ---------------------------------------------------------------------
" HCLStop: {{{2
fun! <SID>HCLStop()
"  call Dfunc("HCLStop()")

  if !exists("b:dohicurline")
"   call Dret("HCLStop : b:dohicurline doesn't exist")
   return
  endif


  " delete the dohicurline variable
  " remove any match
  " remove CursorHold autocmd event
  match none
  augroup HCLTimer
   au!
  augroup END
  silent! augroup! HCLTimer
  augroup HCL_AUGROUP
    au!
  augroup END
  silent! augroup! HCL_AUGROUP

  if !exists("b:dohicurline")
   echo "[HiCurLine off]"
"   call Dfunc("HCLStop : already off")
   return
  else
  unlet b:dohicurline
  endif

  echo "[HiCurLine off]"
  iunmap <down>
  iunmap <end>
  iunmap <home>
  iunmap <left>
  iunmap <right>
  iunmap <up>
  nunmap <down>
  nunmap <end>
  nunmap <home>
  nunmap <left>
  nunmap <right>
  nunmap <up>
  nunmap   w
  nunmap   e
  nunmap   b
  nunmap   E
  nunmap   H
  nunmap   M
  nunmap   L
  nunmap   B
  nunmap   j
  nunmap   k
  nunmap   l
  nunmap   h
  nunmap   %
  nunmap   -
  nunmap   +
  nunmap <c-b>
  nunmap <c-d>
  nunmap <c-f>
  nunmap <c-u>
  if has("gui_running") && has("menu")
   nunmap <leftmouse>
  iunmap <leftmouse>
  endif

  " restore user map(s), if any
  if b:restoremap != ""
   exe b:restoremap
   unlet b:restoremap
  endif

  " restore user options
  let &vb   = b:hicurline_vbkeep
  let &t_vb = b:hicurline_t_vbkeep
  let &ut   = b:hicurline_utkeep
  unlet b:hicurline_vbkeep
  unlet b:hicurline_t_vbkeep
  unlet b:hicurline_utkeep

  " Insert start HiCurLine into menu
  " Delete stop  HiCurLine from menu
  if has("gui_running") && has("menu")
   exe 'unmenu '.g:DrChipTopLvlMenu.'HiCurLine.Stop'
   exe 'menu '.g:DrChipTopLvlMenu.'HiCurLine.Start<tab>\\hcli	<Leader>hcli'
  endif
"  call Dfunc("HCLStop")
endfun

" ---------------------------------------------------------------------
" HiCurLine: {{{2
fun! <SID>HiCurLine()
  if exists("b:dohicurline")
   " just making sure that a match isn't activated by a CursorHold
   " after HiCurLine has been "turned off"
   let curline   = line('.')
"   call Dfunc("HiCurLine() curline#".curline)
   exe 'match '.g:HL_HiCurLine.' /\%'.curline.'l/'
"   call Dret("HiCurLine")
  endif
endfun

" ---------------------------------------------------------------------

" SaveMap: this function sets up a buffer-variable (b:restoremap) {{{2
"          which will be used by HCLStop to restore user maps
"          mapchx: either <something>  which is handled as one map item
"                  or a string of single letters which are multiple maps
"                  ex.  mapchx="abc" and maplead='\': \a \b and \c are saved
fun! <SID>SaveMap(mapmode,maplead,mapchx)
"  call Dfunc("SaveMap(mapmode<".a:mapmode."> maplead<".a:maplead."> mapchx<".a:mapchx.">)")

  if strpart(a:mapchx,0,1) == ':'
   " save single map :...something...
   let amap=strpart(a:mapchx,1)
"   call Decho("amap<".amap."> save singlemap :...something")
   if maparg(amap,a:mapmode) != ""
    let b:restoremap= a:mapmode."map ".amap." ".maparg(amap,a:mapmode)."|".b:restoremap
    exe a:mapmode."unmap ".amap
   endif
 
  elseif strpart(a:mapchx,0,1) == '<'
   " save single map <something>
"   call Decho("amap<".strpart(a:mapchx,0,1)."> save singlemap <...something")
   if maparg(a:mapchx,a:mapmode) != ""
    let b:restoremap= a:mapmode."map ".a:mapchx." ".maparg(a:mapchx,a:mapmode)."|".b:restoremap
    exe a:mapmode."unmap ".a:mapchx
   endif
 
  else
   " save multiple maps
   let i= 1
   while i <= strlen(a:mapchx)
    let amap=a:maplead.strpart(a:mapchx,i-1,1)
"    call Decho("amap<".amap."> save singlemap  i=".i)
    if maparg(amap,a:mapmode) != ""
     let b:restoremap= a:mapmode."map ".amap." ".maparg(amap,a:mapmode)."|".b:restoremap
     exe a:mapmode."unmap ".amap
    endif
    let i= i + 1
   endwhile
  endif

"  call Dret("SaveMap")
endfun

" ---------------------------------------------------------------------
" HCLHighlight: sets up HL_HiCurLine highlighting {{{2
fun! s:HCLHighlight()
"  call Dfunc("HCLHighlight()")

  if !exists("g:HL_HiCurLine")
   let g:HL_HiCurLine= "HL_HiCurLine"
  endif
  if g:HL_HiCurLine == "HL_HiCurLine" && !s:HLTest("HL_HiCurLine")
   if &bg == "dark"
    hi HL_HiCurLine ctermfg=blue ctermbg=cyan guifg=cyan guibg=blue
   else
    hi HL_HiCurLine ctermbg=blue ctermfg=cyan guibg=cyan guifg=blue
   endif
  endif

"  call Dret("HCLHighlight : g:HL_HiCurLine<".g:HL_HiCurLine.">")
endfun

" ---------------------------------------------------------------------
" HLTest: tests if a highlighting group has been set up {{{2
fun! s:HLTest(hlname)
"  call Dfunc("HLTest(hlname<".a:hlname.">)")

  let id_hlname= hlID(a:hlname)
"  call Decho("hlID(".a:hlname.")=".id_hlname)
  if id_hlname == 0
"   call Dret("HLTest 0")
   return 0
  endif

  let id_trans = synIDtrans(id_hlname)
"  call Decho("id_trans=".id_trans)
  if id_trans == 0
"   call Dret("HLTest 0")
   return 0
  endif

  let fg_hlname= synIDattr(id_trans,"fg")
  let bg_hlname= synIDattr(id_trans,"bg")
"  call Decho("fg_hlname<".fg_hlname."> bg_hlname<".bg_hlname.">")

  if fg_hlname == "" && bg_hlname == ""
"   call Dret("HLTest 0")
   return 0
  endif
"  call Dret("HLTest 1")
  return 1
endfun

let &cpo= s:keepcpo
" ---------------------------------------------------------------------
"  vim: fdm=marker
" HelpExtractor:
"  Author:	Charles E. Campbell, Jr.
"  Version:	3
"  Date:	May 25, 2005
"
"  History:
"    v3 May 25, 2005 : requires placement of code in plugin directory
"                      cpo is standardized during extraction
"    v2 Nov 24, 2003 : On Linux/Unix, will make a document directory
"                      if it doesn't exist yet
"
" GetLatestVimScripts: 748 1 HelpExtractor.vim
" ---------------------------------------------------------------------
set lz
let s:HelpExtractor_keepcpo= &cpo
set cpo&vim
let docdir = expand("<sfile>:r").".txt"
if docdir =~ '\<plugin\>'
 let docdir = substitute(docdir,'\<plugin[/\\].*$','doc','')
else
 if has("win32")
  echoerr expand("<sfile>:t").' should first be placed in your vimfiles\plugin directory'
 else
  echoerr expand("<sfile>:t").' should first be placed in your .vim/plugin directory'
 endif
 finish
endif
if !isdirectory(docdir)
 if has("win32")
  echoerr 'Please make '.docdir.' directory first'
  unlet docdir
  finish
 elseif !has("mac")
  exe "!mkdir ".docdir
 endif
endif

let curfile = expand("<sfile>:t:r")
let docfile = substitute(expand("<sfile>:r").".txt",'\<plugin\>','doc','')
exe "silent! 1new ".docfile
silent! %d
exe "silent! 0r ".expand("<sfile>:p")
silent! 1,/^" HelpExtractorDoc:$/d
exe 'silent! %s/%FILE%/'.curfile.'/ge'
exe 'silent! %s/%DATE%/'.strftime("%b %d, %Y").'/ge'
norm! Gdd
silent! wq!
exe "helptags ".substitute(docfile,'^\(.*doc.\).*$','\1','e')

exe "silent! 1new ".expand("<sfile>:p")
1
silent! /^" HelpExtractor:$/,$g/.*/d
silent! wq!

set nolz
unlet docdir
unlet curfile
"unlet docfile
let &cpo= s:HelpExtractor_keepcpo
unlet s:HelpExtractor_keepcpo
finish

" ---------------------------------------------------------------------
" Put the help after the HelpExtractorDoc label...
" HelpExtractorDoc:
*hicurline.txt*	The HiCurLine Tool		Nov 22, 2005

Author:  Charles E. Campbell, Jr.  <NdrOchip@ScampbellPfamily.AbizM>
	  (remove NOSPAM from Campbell's email first)
Copyright: (c) 2004-2005 by Charles E. Campbell, Jr.	*hicurline-copyright*
           The VIM LICENSE applies to HiCurLine.vim and HiCurLine.txt
           (see |copyright|) except use "HiCurLine" instead of "Vim"
	   No warranty, express or implied.  Use At-Your-Own-Risk.

==============================================================================
1. Contents						*hicurline-contents*

	1. Contents......................: |hicurline-contents|
	2. HiCurLine Manual..............: |hicurline|
	3. HiCurLine Usage...............: |hicurline-usage|
	     Starting....................: |hicurline-start|
	     Stopping....................: |hicurline-stopping|
	     User Map Protection.........: |hicurline-protect|
	     Highlighting Options........: |hicurline-option|
	4. HiCurLine History.............: |hicurline-history|


==============================================================================

2. HiCurLine Manual					*hicurline*
							*hicurline-manual*
	To Enable:

   /===============+=========================================================\
   || Starting &   |                                                        ||
   || Stopping     | Explanation                                            ||
   ++--------------+--------------------------------------------------------++
   || <Leader>hcli | start  HiCurLine                                       ||
   || :HCLstart    | start  HiCurLine                                       ||
   || <Leader>hcls | stop   HiCurLine                                       ||
   || :HCLstop     | stop   HiCurLine                                       ||
   || :HCL         | toggle HiCurLine                                       ||
   ++==============+========================================================++

 You may also choose from the DrChip.HiCurLine menu items if you're running
 gvim.  Check on vim's help for mapleader |mapleader| to learn how to set
 <Leader>; by default its the backslash - ie. by default \hcli will start and
 \hcls will stop HiCurLine.


==============================================================================

3. HiCurLine Usage					*hicurline-usage*

    See |hicurline-start| and |hicurline-stop| for how to start and
    stop HiCurLine.

    The HiCurLine plugin attempts to highlight the current line.

    As of version 4, such overloaded motions include:

		-  h  L      <c-d>   <home>
		+  H  M      <c-f>   <left>
		b  j  w      <c-u>   <leftmouse>
		B  k  <cr>   <down>  <right>
		e  l  <c-b>  <end>   <up>
		E

    Because vim is rich with commands that can move the cursor, the
    script also uses the CursorHold event (see |cursorhold| and
    |'updatetime'|) to highlight the current line whenever the
    cursor is left still for awhile.

STARTING						*hicurline-start*
    <Leader>hcli

    Typically one puts <hicurline.vim> into the .vim/plugin directory
    (vimfiles\plugin for MS) where it becomes always available.  It uses a
    minimal interface:

	<Leader>hcli : initialize highlighting of matching brackets
	            (by default its \hcli)

    A message, "[HiCurLine]", will appear on the message line.

STOPPING						*hicurline-stopping*
    <Leader>[hcls

    When you are done with HiCurLine, use

	    <Leader>[hcls : stop highlighting of matching brackets
	            	(by default its \hcls)

    will restore your usual options and remove the maps HiCurLine set up.

    A message, "[HiCurLine off]", will appear on the message line.

USER MAP PROTECTION					*hicurline-protect*

    Starting HiCurLine causes it to set up a number of maps which enables
    the highlighting of matching brackets in normal mode.  A few keypad
    entries in insert mode are also supported (up, down, right, left, home,
    and end).  Upon termination these maps are deleted and any previously
    defined mappings are restored.

HIGHLIGHTING CURRENT LINE OPTIONS			*hicurline-option*

    g:DrChipTopLvlMenu: by default its "DrChip"; you may set this to whatever
                        you like in your <.vimrc>.  This variable controls
			where HiCurLine's menu items are placed.
    HL_HiCurLine      : syntax highlighting group used for the current
                        line.  One may specify it or link it to another
                        highlighting group.  Default: Search >
			    ex. hi link HL_HiCurLine Statement
<
    HL_HiCurLine      : As an alternative to using the syntax group named
                        above; its a variable holding a highlighting group
			name (see |highlight-groups| for a standard list). >
			    ex. let HL_HiCurLine= "Special"
<

==============================================================================
4. History						*hicurline-history*
	
	v6   07/26/04 * Had fold markers; now also has fdm=marker in modeline
	              * \hclt will toggle between highlighting the current
	                line and not
	              * Cursorhold/FocusGained update time now set to 200ms
	     02/18/05 * Some cosmetic folding changes
	              * go =~ 'm' now used in test to see if menus are to be
	                generated
	     11/22/05 * commands changed to remove <cr>s
	v5   07/13/04 * Now uses CursorHold to check if the colorscheme
	                has been changed and, if so, to make sure HL_HiCurLine
	                is defined.  Included support for gg and G motions.
	                More debugging commands included, albeit commented
	                out for release.
	v4   06/23/03 * HL_HiCurLine : now holds the highlighting
	                group (by default, Search); allows the user
	                to override it
	v3   02/10/03 * same as v2, but got submitted somehow as v3
	                to vim.sf.net
	v2   02/06/03 * removed some unnecessary maps (f( f) $ 0 etc)
	                that were "leftover" from HiMtchBrkt
	                includes more motions: (+-HML)
	                uses CurSorHold to catch what I've missed so far
	v1   epoch    * modified <HiMtchBrkt.vim>

==============================================================================
vim:tw=78:ts=8:ft=help:sts=4
