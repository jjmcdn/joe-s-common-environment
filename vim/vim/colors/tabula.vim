" ------------------------------------------------------------------
" Filename:	 tabula.vim
" Last Modified: 2006-11-22
" Version:       0.1
" Maintainer:	 Bernd Pol (bernd.pol AT online DOT de)
" Copyright:	 2006 Bernd Pol
"                This script is free software; you can redistribute it and/or 
"                modify it under the terms of the GNU General Public License as 
"                published by the Free Software Foundation; either version 2 of 
"                the License, or (at your option) any later version. 
" Description:   Vim colorscheme based on marklar.vim by SM Smithfield,
" 		 slightly modified for lower contrast and xterm 256 color
" 		 usability.
" Install:       Put this file in the users colors directory (~/.vim/colors)
"                then load it with :colorscheme tabula
" ------------------------------------------------------------------
hi clear
set background=dark
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "tabula"
if version >= 700
    hi SpellBad        	guisp=#FF0000
    hi SpellCap        	guisp=#0000FF
    hi SpellRare       	guisp=#ff4046
    hi SpellLocal     	guisp=#000000							ctermbg=0
    hi Pmenu		guifg=#00ffff	guibg=#000000			ctermfg=51	ctermbg=0
    hi PmenuSel       	guifg=#ffff00	guibg=#000000	gui=bold	ctermfg=226			cterm=bold
    hi PmenuSbar       			guibg=#204d40					ctermbg=6
    hi PmenuThumb      	guifg=#38ff56					ctermfg=3
    hi CursorColumn		    	guibg=#096354					ctermbg=29
    hi CursorLine		      	guibg=#096354					ctermbg=29
    hi Tabline         	guifg=bg	guibg=fg	gui=NONE	ctermfg=NONE	ctermbg=NONE	cterm=reverse,bold
    hi TablineSel      	guifg=#20012e	guibg=#00a675	gui=bold
    hi TablineFill     	guifg=#689C7C
    hi MatchParen      	guifg=#38ff56	guibg=#0000ff	gui=bold	ctermfg=14	ctermbg=21	cterm=bold
endif

hi Comment		guifg=#00BBBB	guibg=NONE			ctermfg=6 	cterm=none
hi Constant		guifg=#D0D0D0	guibg=NONE		 	ctermfg=254
hi Cursor		guifg=NONE	guibg=#FF0000
hi DiffAdd		guifg=NONE	guibg=#136769 			ctermfg=4	ctermbg=7	cterm=none
hi DiffDelete		guifg=NONE	guibg=#50694A 			ctermfg=1 	ctermbg=7	cterm=none
hi DiffChange		guifg=fg	guibg=#00463c	gui=None	ctermfg=4 	ctermbg=2	cterm=none
hi DiffText		guifg=#7CFC94	guibg=#00463c	gui=bold 	ctermfg=4 	ctermbg=3	cterm=none
hi Directory		guifg=#25B9F8	guibg=NONE							ctermfg=2
hi Error		guifg=#FFFFFF	guibg=#000000			ctermfg=7 	ctermbg=0	cterm=bold
hi ErrorMsg		guifg=#8eff2e	guibg=#204d40
hi FoldColumn		guifg=#00BBBB	guibg=#4E4E4E			ctermfg=14 	ctermbg=240
hi Folded		guifg=#44DDDD	guibg=#4E4E4E			ctermfg=14 	ctermbg=240
hi Identifier		guifg=#FFAF00	ctermfg=214			cterm=none
" completely invisible Ignore group
hi Ignore		guifg=bg	guibg=NONE			ctermfg=23 
" nearly invisible Ignore group
" hi Ignore		guifg=#467C5C	guibg=NONE			ctermfg=0 
hi IncSearch				guibg=#52891f	gui=bold
hi LineNr		guifg=#38ff56	guibg=#204d40
hi ModeMsg		guifg=#FFFFFF	guibg=#0000FF			ctermfg=7	ctermbg=4	cterm=bold
hi MoreMsg		guifg=#FFFFFF	guibg=#00A261			ctermfg=7	ctermbg=2	cterm=bold
"hi NonText		guifg=#00bbbb	guibg=#204d40
hi NonText		guifg=bg					ctermfg=23
hi Normal		guifg=#71C293	guibg=#06544a			ctermfg=84	ctermbg=23 
hi PreProc		guifg=#25B9F8	guibg=bg			ctermfg=39
hi Question		guifg=#FFFFFF	guibg=#00A261			ctermfg=15	ctermbg=35
hi Search		guifg=NONE	guibg=#0B7260			ctermfg=NONE	ctermbg=36
hi SignColumn		guifg=#00BBBB	guibg=#204d40
hi Special		guifg=#00FFFF	guibg=NONE	gui=none	ctermfg=51
hi SpecialKey		guifg=#00FFFF	guibg=#266955
hi Statement		guifg=#D7FF00			gui=none	ctermfg=11
hi StatusLine		guifg=#245748	guibg=#71C293	gui=none					cterm=reverse
hi StatusLineNC		guifg=#245748	guibg=#689C7C	gui=none
hi Title		guifg=#7CFC94	guibg=NONE	gui=none	ctermfg=2			cterm=bold
hi Todo			guifg=#00FFFF	guibg=#0000FF			ctermfg=6	ctermbg=4	cterm=none
hi Type			guifg=#FF80FF	guibg=bg	gui=none	ctermfg=2
hi Underlined		guifg=#df820c	guibg=NONE	gui=underline	ctermfg=8	cterm=underline
hi Visual 				guibg=#0B7260	gui=none
hi WarningMsg		guifg=#FFFFFF	guibg=#FF0000			ctermfg=7	ctermbg=1	cterm=bold
hi WildMenu		guifg=#20012e	guibg=#00a675	gui=bold	ctermfg=none	ctermbg=none	cterm=bold
"
hi pythonPreCondit							ctermfg=2	cterm=none
hi tkWidget		guifg=#D5B11C	guibg=bg	gui=bold	ctermfg=7	cterm=bold
hi tclBookends		guifg=#7CFC94	guibg=NONE	gui=bold	ctermfg=2	cterm=bold

" ------------------------------------------------------------------------------------------------
" Common groups that link to other highlight definitions.

highlight link Constant     Character
highlight link Constant     Number
highlight link Constant     Boolean
highlight link Constant     String

highlight link LineNr       Operator

highlight link Number       Float

highlight link PreProc      Define
highlight link PreProc      Include
highlight link PreProc      Macro
highlight link PreProc      PreCondit

highlight link Question     Repeat

highlight link Repeat       Conditional

highlight link Special      Delimiter
highlight link Special      SpecialChar
highlight link Special      SpecialComment
highlight link Special      Tag

highlight link Statement    Exception
highlight link Statement    Keyword
highlight link Statement    Label

highlight link Type         StorageClass
highlight link Type         Structure
highlight link Type         Typedef


