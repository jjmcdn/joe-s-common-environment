" EnhancedCommentify.vim
" Maintainer:	Meikel Brandmeyer <Brandels_Mikesh@web.de>
" Version:		1.5
" Last Change:	Friday, 12th October 2001

" Disription: 
" This is a simple script to comment lines in a program.
" Currently supported languages are C, C++, PHP, the vim scripting
" language, python, HTML, Perl, LISP, Tex, Shell, CAOS and others.
" It's easy to add new languages. Refer to the comments later in the
" file.

" Bugfixes:
"   1.3
"   hlsearch was set unconditionally (thanks to Mary Ellen Foster)
"   made function silent	     (thanks to Mare Ellen Foster)

" Changelog:
"   1.6
"   Now supports 'm4', 'config', 'automake'
"   'vb', 'aspvbs', 'plsql' (thanks to Zak Beck)
"   1.5
"   Now supports 'java', 'xml', 'jproperties'. (thanks to Scott Stirling)
"   1.4
"   Lines containing only whitespace are now considered empty.
"   Added Tcl support.
"   Multipart comments are now escaped with configurable alternative
"   strings. Prevents nesting errors (eg. /**/*/ in C)
"   1.3
"   Doesn't break lines like
"	foo(); /* bar */
"   when doing commentify.

" Install Details:
" Simply drop this file into your $HOME/.vim/plugin directory
"
" For configuration of keymappings and commentification of empty lines, please
" refer to the end of the file.
"
" Note: some people have reported that <M-c> doesn't work for them ...
" try <\-c> instead.

if exists("DidToggleCommentify")
    finish
endif
let DidToggleCommentify = 1

" Change the Replacement strings here.
if !exists("*s:AltOpen")
    let s:AltOpen = "|+"
endif

if !exists("*s:AltClose")
    let s:AltClose = "+|"
endif

"
" ToggleCommentify(emptyLines)
"	emptyLines	-- commentify empty lines
"			   may be 'yes' or 'no'
"
" Commentifies the current line.
"
function s:ToggleCommentify(emptyLines)
    let lineString = getline(".")

    if lineString !~ "^[ \t]*$" || a:emptyLines == 'yes' " don't comment empty lines
	let fileType = &ft  " finding out the file-type, and specifying the
			    " comment symbol
	
	" First handle multipart languages, then -- after the 'else' --
    	" handle singlepart languages.
	if fileType == 'c' || fileType == 'css'
	    call s:CommentifyMultiPart(lineString, '/*', '*/')
	elseif fileType == 'html' || fileType == 'xml'
	    call s:CommentifyMultiPart(lineString, '<!--', '-->')
	else
	    " For single part languages, simply add here the filetype
	    " and the corresponding commentSymbol. (Or add the filetype
	    " to the appropriate if-clause)
	    if fileType == 'ox' || fileType == 'cpp' || fileType == 'php' 
		    \ || fileType == 'java'
		let commentSymbol = '//'
	    elseif fileType == 'vim'
		let commentSymbol = '"'
	    elseif fileType == 'python' || fileType == 'perl'
			\ || fileType =~ '[^w]sh$' || fileType == 'tcl' 
			\ || fileType == 'jproperties'
		let commentSymbol = '#'
	    elseif fileType == 'lisp' || fileType == 'scheme'
		let commentSymbol = ';'
	    elseif fileType == 'tex'
		let commentSymbol = '%'
	    elseif fileType == 'caos'
		let commentSymbol = '*'
	    elseif fileType == 'm4' || fileType == 'config'
			\ || fileType == 'automake'
		let commentSymbol = 'dnl '
	    elseif fileType == 'vb' || fileType == 'aspvbs'
		let commentSymbol == "\'"
	    elseif fileType == 'plsql'
		let commensSymbol == '--'
	    else
		execute 'echo "ToggleCommentify has not (yet) been implemented for this file-type"'
		let commentSymbol = ''
	    endif
	    
	    " If the language is not supported, we do nothing.
	    if commentSymbol != ''
		call s:CommentifySinglePart(lineString, commentSymbol)
	    endif
	endif
    endif
endfunction

"
" CommentifyMultiPart(lineString, commentStart, commentEnd)
"	lineString	-- line to commentify
"	commentStart	-- comment-start string, eg '/*'
"	commentEnd	-- comment-end string, eg. '*/'
"
" This function commentifies code of languages, which have multipart
" comment strings, eg. '/*' - '*/' of C.
"
function s:CommentifyMultiPart(lineString, commentStart, commentEnd)
    let isCommented = strpart(a:lineString,0,strlen(a:commentStart))
    let isCommentedEnd = strpart(a:lineString,
		\ strlen(a:lineString)-strlen(a:commentEnd),
		\ strlen(a:commentEnd))

    if isCommented == a:commentStart && isCommentedEnd == a:commentEnd
	silent call s:UnCommentify(s:EscapeString(a:commentStart),
		    \ s:EscapeString(a:commentEnd))
    else
	silent call s:Commentify(a:commentStart, a:commentEnd)
    endif
endfunction

"
" CommentifySinglePart(lineString, commentSymbol)
"	lineString	-- line to commentify
"	commentSymbol	-- comment string, eg '#'
"
" This function is used for all languages, whose comment strings
" consist only of one string at the beginning of a line.
"
function s:CommentifySinglePart(lineString, commentSymbol)
    let isCommented = strpart(a:lineString,0,strlen(a:commentSymbol))

    if isCommented == a:commentSymbol
	silent call s:UnCommentify(s:EscapeString(a:commentSymbol))
    else
	silent call s:Commentify(a:commentSymbol)
    endif
endfunction

"
" Commentify(commentSymbol, [commentEnd])
"	commentSymbol	-- string to insert at the beginning of the line
"	commentEnd	-- string to insert at the end of the line
"			   may be omitted
"
" This function inserts the start- (and if given the end-) string of the
" comment in the current line.
"
function s:Commentify(commentSymbol, ...)
    let s:rescue_hls = &hlsearch  
    set nohlsearch
    
    " If a end string is present, insert it too.
    if a:0 == 1
	" First we have to escape any comment already contained in the line, since
	" (at least for C) comments are not allowed to nest.

	silent! execute ':s~'. s:EscapeString(a:commentSymbol) .'~'.
		    \ s:AltOpen .'~g'
	silent! execute ':s~'. s:EscapeString(a:1) .'~'.
		    \ s:AltClose .'~g'
	
	execute ':s~$~'. a:1 .'~'
    endif
    
    " insert the comment symbol
    execute ':s~^~'. a:commentSymbol .'~'

    let &hlsearch = s:rescue_hls
endfunction

"
" UnCommentify(commentSymbol, [commentEnd])       
"	commentSymbol	-- string to remove at the beginning of the line
"	commentEnd	-- string to remove at the end of the line
"			   may be omitted
"
" This function removes the start- (and if given the end-) string of the
" comment in the current line.
"
function s:UnCommentify(commentSymbol, ...)
    let s:rescue_hls = &hlsearch 
    set nohlsearch

    " remove the first comment symbol found on a line
    execute ':s~'. a:commentSymbol .'~~'

    " If a end string is present, we have to remove it, too.
    if a:0 == 1
	" First, we remove the trailing comment symbol. We can assume, that it
	" is there, because we check for it.
	execute ':s~'. a:1 .'$~~'

	" Remove any escaped inner comments.
	silent! execute ':s~|+~'. a:commentSymbol .'~g'
	silent! execute ':s~+|~'. a:1 .'~g'
    endif

    let &hlsearch = s:rescue_hls
endfunction

"
" EscapeString(string)
"	string	    -- string to process
"
" Escapes characters in 'string', which have some function in
" regular expressions, with a '\'.
"
" Returns the escaped string.
"
function s:EscapeString(string)
    return escape(a:string, "\\*+{}[]()$^")
endfunction

"
" IndentEmptyLines(ft)
"	ft	    -- filetype of current buffer
"
" Decides, if empty lines should be indented or not. Add the filetype, you want
" to change, to the apropriate if-clause.
"
function s:IndentEmptyLines(ft)
    if (a:ft == 'vim' || a:ft == 'perl' || a:ft == 'caos' || a:ft == 'python'
       	\ || a:ft == 'ox' || a:ft == 'cpp' || a:ft == 'php' || a:ft == 'tex'
	\ || a:ft =~ '[^w]sh$' || a:ft == 'lisp' || a:ft == 'scheme' || a:ft == 'java')
	return 'yes'
    elseif (a:ft == 'c' || a:ft == 'html' || a:ft == 'xml')
	return 'no'
    else " Default behaviour
	return 'no'
    endif
endfunction

"
" Keyboard mappings.

noremap <Plug>Commentify :call <SID>ToggleCommentify(<SID>IndentEmptyLines(&ft))<CR>

"
" Uncomment the following lines for compliance with vim plugin scheme.
"
"nmap <silent> <unique> <Leader>c <Plug>Commentifyj
"nmap <silent> <unique> <Leader>x <Plug>Commentify
"
nmap <silent> <unique> <M-c> <Plug>Commentifyj
nmap <silent> <unique> <M-x> <Plug>Commentify

"imap <silent> <unique> <Leader>c <Esc><Plug>Commentifyji
"imap <silent> <unique> <Leader>x <Esc><Plug>Commentifyi
"
imap <silent> <unique> <M-c> <Esc><Plug>Commentifyji
imap <silent> <unique> <M-x> <Esc><Plug>Commentifyi

"vmap <silent> <unique> <Leader>c <Plug>Commentify
"
vmap <silent> <unique> <M-c> <Plug>Commentify

