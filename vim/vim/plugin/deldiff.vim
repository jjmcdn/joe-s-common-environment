" DelDiff
" Version 1.0 by Tilmann Bitterberg
" Sat Oct 12 17:35:29 CEST 2002
" 
" Deletes blocks from unified diffs
" default mapping are 
"      did = Delete inner diff = DelDiffBlock()
"      dad = delete outer diff
"
" A unified diff looks like
" 1 diff -u old new
" 2 --- old
" 3 +++ new
" 4 @@ -159,8 +159,8 @@
" 5  Text1
" 6 @@ -783,6 +794,8 @@
" 7  Text2
" 8 diff -u old2 new2
" 9  ..

" If the cursor is on line 5 or on line 4 and you call DelDiffBlock() the block
" from line 4 to line 5 will be deleted.
" If you call DelComplDiff(), the text block from line 1 up to line 7 will be
" deleted.
" If you are on Line 1, 2 or 3 and call DelDiffBlock(), the same text block will
" be deleted like when you call DelComplDiff().
" If there is only one diff for a particular file, the diff header will be
" deleted too
" 

function! DelDiffBlock()
  " search backward
  let start_line = line ( '.' )
  let result = 0
  while ( !result )
    let cur_line = getline ( start_line )

    if ( !match (cur_line, "^--- " ) || !match (cur_line, "^diff ") || !match (cur_line, "^+++ "))
       call DelComplDiff()
       return
    endif
    if ( !match (cur_line, "^@@ " ) || start_line == 1)
      let result = 1
      if (start_line == 1)
	 return 
      endif
    else
      let start_line = start_line - 1
    endif
  endwhile

  " search forward
  let end_line = start_line + 1
  let result = 0
  while ( !result )
    let cur_line = getline ( end_line )
    if ( !match (cur_line, "^@@ " ) || end_line == line ( "$" ) || !match (cur_line, "^diff ") || !match(cur_line, "^--- ") )
      let result = 1
    else
      let end_line = end_line + 1
    endif
  endwhile

  if (end_line != line ( "$" ) )
    let end_line = end_line - 1
  endif

  " if this was the only diff of the file
  " delete the diff header too
  let diff_start = 0
  let diff_end   = end_line + 1
  let line_end   = getline(diff_end)
  if ( !match(getline(start_line - 1), "^+++ ")  && !match(getline(start_line - 2), "^--- ") )
    if ( !match(getline(start_line - 3), "^diff ") )
      let diff_start = start_line - 3
    else
      let diff_start = start_line - 2
    endif
    if ( !match(line_end, "^diff ") || !match(line_end, "^--- ") || end_line == line ("$") )
       let diff_end   = end_line
    else
       let diff_start = 0
    endif 
  endif


  if (diff_start)
    execute diff_start.",".diff_end."d"
     "echo diff_start.",".diff_end."d"
  else
    execute start_line.",".end_line."d"
    " echo start_line.",".end_line."d"
  endif
endfunction

function! DelComplDiff()
  " search backward
  let diff_start = 0
  let start_line = line ( '.' )
  let result = 0
  while ( !result )
    let cur_line = getline ( start_line )
    if ( !match (cur_line, "^--- " ) || !match (cur_line, "^diff ") || start_line == 1 )
      if ( !match(getline(start_line - 1), "^diff ") )
        let start_line = start_line - 1
      endif
      let result = 1
    else
      let start_line = start_line - 1
    endif
  endwhile

  " search forward
  let end_line = start_line + 1
  let result = 0
  while ( !result )
    let cur_line = getline ( end_line )
    if ( !match(cur_line, "^diff ") || (end_line != start_line + 1 && !match(cur_line, "^--- ") ))
       let result = 1
    else
      let end_line = end_line + 1
    endif
    if ( end_line == line ("$") )
       let result = 1
    endif
  endwhile

  if (end_line != line ( "$" ) )
    let end_line = end_line - 1
  endif

   execute start_line.",".end_line."d"
  "echo start_line.",".end_line."d"
endfunction

noremap <silent> did :call DelDiffBlock()<CR>
noremap <silent> dad :call DelComplDiff()<CR>
