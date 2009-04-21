" File: Ispell.vim
"
" Purpose: mappings and functions for using ispell
"
" Desciption: You can easily use Ispell with these funtions and mappings. You
" can check the whole buffer, a single word or heighlight the spelling
" mistakes. If you check a single word you can have a menu from which you
" choose the correct spelling. At the moment English, British, American and
" German are supported, but adding other languages is easy.
"
" End of Description.
"
" Author: Ralf Arens <ralf.arens@gmx.net>
"
" Last Modified: 2001-06-06 22:24:09 CEST
" + Problems with Slackware's and Debian's ispell, the option "-T" doesn't
" + work. A backup of the old version is in Ispell.vim.bak0 on my harddisk.
" + Please contact me if you find bugs or other things.


" Usage:
"
" There are four functions:
" IspellBuffer(language)	check the whole buffer
" IspellWord(language)		check a single word
" IspellWordAndChoose(language)	check a single word and open a menu to choose
"				from
" IspellHiErrors(language)	highlight the errors, filetype mail is handled
"				specially (don't spell quoted text)
"
" The parameter "language" is optional. If it is not given, defaults or last
" employed will used. At the moment "American", "British", "English" and
" "German" are available.
"
" Adding a new language is quite simple, let my examples guide you.


" Ispell
" ¯¯¯¯¯¯
" options for ispell
"	-S: sort result by probability
"	-t: TeX/LaTeX
"	-n: nroff/troff
"	-d deutsch: use german dictionary
"		$DICTIONARY is the according env-variable in ispell
"	-T latin1: use charset Latin1 (Westeurope)
"		$CHARSET is the according env-variable in ispell


" Default Options
" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
" set defaults, they'll be overwritten by calling
highlight Debug term=reverse ctermfg=black ctermbg=yellow guifg=black guibg=yellow
let g:IspellOps = "-S"
if exists("$DICTIONARY")
	let g:IspellDic = $DICTIONARY
else
	let g:IspellDic = "english"
endif
"if exists("$CHARSET")
"	let g:IspellChar = $CHARSET
"else
"	let g:IspellChar = "latin1"
"endif


" Functions
" ¯¯¯¯¯¯¯¯¯

" set general ispell options
fun! IspellOps()
	if &ft == "tex"
		let g:IspellOps = "-t -S"
	elseif &ft == "nroff"
		let g:IspellOps = "-n -S"
	else
		let g:IspellOps = "-S"
	endif
endfun


"check word
fun! IspellWord(...)
	if a:0 > 0
		exe "call Ispell".a:1."Ops()"
	endif
	call IspellOps()
	let com = "!echo <cword> \| ispell -a -d ".g:IspellDic." ".g:IspellChar
	exe com
endfun


" check whole file
"	writes file, checks it, reads it, no undo possible
"	does it work in GUI Version?
fun! IspellBuffer(...)
	if a:0 > 0
		exe "call Ispell".a:1."Ops()"
	endif
	call IspellOps()
	write
	let com = "!ispell ".g:IspellOps." -d ".g:IspellDic." ".g:IspellChar." %"
	exe com
	edit %
endfun


" highlight spelling errors
"	by (Smylers) smylers@scs.leeds.ac.uk Fri Sep  3 05:11:59 1999
"	edited by Ralf Arens
fun! IspellHiErrors(...)
	if a:0 > 0
		exe "call Ispell".a:1."Ops()"
	endif
	call IspellOps()
	let ErrorsFile = tempname()
	let co = 'write ! '
	if &ft == "mail"
		let co = co.'grep -v "^> " | egrep -v "^[[:alpha:]]-]+: " | '
	endif
	let co = co."ispell -l ".g:IspellOps." -d ".g:IspellDic." ".g:IspellChar
	let co = co.' | sort | uniq > '.ErrorsFile
	exe co
	exe 'split ' . ErrorsFile
	%s/^/syntax match SpellError #\\</
	%s/$/\\>#/
	exit
	syntax case match
	exe 'source ' . ErrorsFile
	hi link SpellError ErrorMsg
	call delete(ErrorsFile)
endfun


" check word under cursor
"	for testing purposes, "ispell -a gon" has 23 corrections
"	for german, "ispell -a gähen" has 10
fun! IspellWordAndChoose(...)
	if a:0 > 0
		exe "call Ispell".a:1."Ops()"
	endif
	call IspellOps()
	let tmpfile = "/tmp/vim"
	let word = expand("<cword>")
	exe "!echo <cword> | ispell ".g:IspellOps." -d ".g:IspellDic." ".g:IspellChar." -a > ".tmpfile
	exe "split ".tmpfile
	let spell = getline(2)
	bdelete
	call delete(tmpfile)
	if spell =~ '^*'
		echo "\n".word." is correct."
	elseif spell =~ '^+'
		let spell = substitute(spell, '^+ ', "", "")
		echo '\n'.word." is correct because of root ".spell
	elseif spell =~ '^#'
		echo '\nNo guess for '.word
	elseif spell =~ '^&'
		" how many possibilities
		let amount = substitute(spell, '^& [^ ]* \(\d\+\) .*$', '\1', "")
		" construct string for asking
		"		remove everything but possible answers
		let spell = substitute(spell, '^&.*: ', "", "")
		"		apend ", foo"
		let spell = spell.", foo"
		"	OK, now have something like
		"		eg: "con, don, gin, foo"
		"	construct string "ask" for confirm()
		let loop = 1
		let ask = ""
		while loop <= amount
			if loop <= 9
				" insert identifier
				let ask = ask."\n&".loop." "
			else
				let ask = ask."\n&".nr2char(loop+87)." "
			endif
			" append possibility to ask
			let ask = ask.substitute(spell, ',.*$', "", "")
			" delete possibility from spell
			let spell = substitute(spell, '^[^,]*, ', "", "")
			let loop = loop+1
		endwhile
		let ask = "&0 Leave unchanged".ask
		" get choice
		let choice = confirm(word, ask, 1, "Q") - 1
		if choice > 0
			if choice <= 9
				let ask = substitute(ask, "^.*\n&".choice." ", "", "")
				let ask = substitute(ask, "\n&.*$", "", "")
			else
				let ask = substitute(ask, "^.*\n&".nr2char(choice+87)." ", "", "")
				let ask = substitute(ask, "\n&.*$", "", "")
			endif
			let ask = ask.''
			exe "normal ciw".ask
		endif
	endif
endfun


"	Language Options
"	¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯
" german
fun! IspellGermanOps()
"	let g:IspellDic = "deutsch"
"	let g:IspellDic = "ndeutsch"
"	let g:IspellDic = "ngerman"
	let g:IspellDic = "german"
	let g:IspellChar = "-T latin1 -w 'äöüßÄÖÜ'"
endfun

" english
fun! IspellEnglishOps()
	let g:IspellDic = "english"
	let g:IspellChar = ""
endfun

" british
fun! IspellBritishOps()
	let g:IspellDic = "british"
	let g:IspellChar = ""
endfun

" american
fun! IspellAmericanOps()
	let g:IspellDic = "american"
	let g:IspellChar = ""
endfun



" mappings
" ¯¯¯¯¯¯¯¯
" conventions:
"	all mappings for ispell start with `ä'
"map <F3>wa :call IspellWordAndChoose("American")<CR><CR>
"map <F3>wb :call IspellWordAndChoose("British")<CR><CR>
map <F3>w :call IspellWordAndChoose("English")<CR><CR>
"map <F3>wg :call IspellWordAndChoose("German")<CR><CR>

"map <F3>ta :call IspellBuffer("American")<CR>
"map <F3>tb :call IspellBuffer("British")<CR>
map <F3>b :call IspellBuffer("English")<CR>
"map <F3>tg :call IspellBuffer("German")<CR>

"map <F3>a :call IspellHiErrors("American")<CR><CR>
"map <F3>b :call IspellHiErrors("British")<CR><CR>
map <F3>h :call IspellHiErrors("English")<CR><CR>
"map <F3>g :call IspellHiErrors("German")<CR><CR>

map <F3><F3> :syntax clear SpellError<CR>


" vim:noet:ts=8:sw=8:sts=8
