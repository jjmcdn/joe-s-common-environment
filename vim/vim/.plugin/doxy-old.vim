" doxygen.vim
" Written by:  Joe MacDonald <joe@seawaynetworks.com>
"
" Notes:
"  Suggested by Salman Halim (salman@hp.com)

" Mappings (in use: cdefghsuvx). . . {{{

" New function
map <F2>f :call JDoxFunc()
imap <F2>f <esc>:call JDoxFunc()

" New Struct
map <F2>s :call JDoxStruct()
imap <F2>s <esc>:call JDoxStruct()

" New Define
map <F2>d :call JDoxDefn()
imap <F2>d <esc>:call JDoxDefn()

" New Enumerated type
map <F2>e :call JDoxEnum()
imap <F2>e <esc>:call JDoxEnum()

" Comment block
map <F2>c :call JDoxComment()
imap <F2>c <esc>:call JDoxComment()

" New header file
map <F2>h :call JDoxHeader()
imap <F2>h <esc>:call JDoxHeader()

" New union
map <F2>u :call JDoxUnion()
imap <F2>u <esc>:call JDoxUnion()

" New union
map <F2>v :call JDoxVar()
imap <F2>v <esc>:call JDoxVar()

" New group
map <F2>g :call JDoxGroup()
imap <F2>g <esc>:call JDoxGroup()

" New generic header block
map <F2>x :call JDoxX()
imap <F2>x <esc>:call JDoxX()

" }}}

" JDoxFunc() {{{
function! JDoxFunc()
   let funcProto = input("Enter the function prototype:  ")
   let returnType = input("Return info:  ")
   let funcBrief = input("Brief description: ")
   let funcFull = input("Full description (no newlines): ")

   " Sanity stuff . . .
   if (funcProto == "")
      let funcProto = "void func(void)"
   endif

   if (funcBrief == "")
      let funcBrief = "<b>default brief function description</b>"
   endif

   if (funcFull == "")
      let funcFull = "<b>default full function description</b>"
   endif

   " Now we print out our header
   Addline '/*! @fn ' . funcProto
   Addline ' *  '
   Addline ' *  @brief  ' . funcBrief
   Addline ' *  '
   Addline ' *  @li ' . funcFull
   Addline ' *  '

   let funcParamName = input("parameter name: ")
   while (funcParamName != "")
      let funcParamDesc = input("parameter description: ")
      Addline ' *  @param ' . funcParamName . ': ' . funcParamDesc
      let funcParamName = input("parameter name: ")
   endwhile

   if ( returnType != "" )
      Addline ' *  @return ' . returnType
   endif

   let funcExceptionName = input("exception: ")
   while (funcExceptionName != "")
      let funcExceptionDesc = input("exception description: ")
      Addline ' *  @Exception ' . funcExceptionName . ': ' . funcExceptionDesc
      let funcExceptionName = input("exception name: ")
   endwhile

   Addline ' */'

   Addline '/* ' . funcProto . ' {{{ */'
   " and finally print out our function information
   Addline funcProto
   Addline '{'
   Addline ''
   Addline '}'
   Addline '/* }}} */'
endfunction
" }}}

" JDoxStruct() {{{
function! JDoxStruct()
   let structName = input("Structure name: ")

   " Sanity stuff . . .
   if (structName != "")
      " Without a structure name, we don't have anything.
      let structBrief = input("Brief description: ")
      let structFull = input("Full description (no newlines): ")

      if (structBrief == "")
         let structBrief = "<b>default brief structure description</b>"
      endif 

      if (structFull == "")
         let structFull = "<b>default full structure description</b>"
      endif 

      Addline '/*! @struct ' . structName
      Addline ' *  @brief ' . structBrief
      Addline ' *  '
      Addline ' *  @li ' . structFull
      Addline ' */'
      Addline 'typedef struct ' . structName
      Addline '{'
      Addline '   //! per-member descriptions for doxygen go above the member'
      Addline '} ' . structName . '_t;' 
   endif
endfunction
" }}}

" JDoxDefn() {{{
function! JDoxDefn()
   let defName = input("#define: ")

   if (defName != "")
      " without a define name, we don't have anything
      let defBrief = input("Brief description: ")
      let defFull = input("Full description (no newlines): ")
      let defVal = input("define value: ")

      if (defBrief == "")
         let defBrief = "<b>default brief definition description</b>"
      endif 

      if (defFull == "")
         let defFull = "<b>default full definition description</b>"
      endif 

      if (defVal == "")
         let defVal = "/* no value */"
      endif

      Addline '/*! @def ' . defName
      Addline ' *  @brief ' . defBrief
      Addline ' *  '
      Addline ' *  @li ' . defFull
      Addline ' */'
      Addline '#define ' . defName . ' \'
      Addline '   ' . defVal
   endif
endfunction
" }}}

" JDoxEnum() {{{
function! JDoxEnum()
   let enumName = input("enumerated type name: ")

   if (enumName != "")
      let enumBrief = input("Brief description: ")
      let enumFull = input("Full description (no newlines): ")

      if (enumBrief == "")
         let enumBrief = "<b>default brief enumerated type description</b>"
      endif 

      if (enumFull == "")
         let enumFull = "<b>default full enumerated type description</b>"
      endif 

      Addline '/*! @enum ' . enumName
      Addline ' *  @brief ' . enumBrief
      Addline ' *  '
      Addline ' *  @li ' . enumFull
      Addline ' */'

      Addline 'typedef enum ' . enumName
      Addline '{'
      let enumSymbolicName = input("name: ")
      while(enumSymbolicName != "")
         let enumVal = input ("value: ")
         if (enumVal != "")
            Addline '   ' . enumSymbolicName . '   = ' . enumVal . ','
         else
            Addline '   ' . enumSymbolicName . ','
         endif
         let enumSymbolicName = input("name: ")
      endwhile
      Addline '} ' . enumName . '_t;'
   endif
endfunction
" }}}

" JDoxComment() {{{
function! JDoxComment()
   Addline '#ifndef DOXYGEN_SHOULD_SKIP_THIS'
   Addline '/*!'
   Addline ' * '
   Addline ' */'
   Addline '#endif /* DOXYGEN_SHOULD_SKIP_THIS */'
endfunction
" }}}

" JDoxHeader() {{{
function! JDoxHeader()
   let hGuard = input("header guard: ")

   Addline '#ifndef ' . hGuard
   Addline '#define ' . hGuard

   call JDoxX()

   Addline '#ifdef __cplusplus'
   Addline 'extern "C"'
   Addline '{'
   Addline '#endif /* __cplusplus */'
   Addline ''
   Addline ''
   Addline '#ifdef __cplusplus'
   Addline '}'
   Addline '#endif /* __cplusplus */'
   Addline '#endif /* ' . hGuard . '*/'

endfunction
" }}}

" JDoxUnion() {{{
function! JDoxUnion()
   let unionName = input("union name: ")

   " Sanity stuff . . .
   if (unionName != "")
      " Without a unionure name, we don't have anything.
      let unionBrief = input("Brief description: ")
      let unionFull = input("Full description (no newlines): ")

      if (unionBrief == "")
         let unionBrief = "<b>default brief union description</b>"
      endif 

      if (unionFull == "")
         let unionFull = "<b>default full union description</b>"
      endif 

      Addline '/*! @union ' . unionName
      Addline ' *  @brief ' . unionBrief
      Addline ' *  '
      Addline ' *  @li ' . unionFull
      Addline ' */'
      Addline 'typedef union ' . unionName
      Addline '{'
      Addline '   //! per-member descriptions for doxygen go above the member'
      Addline '} ' . unionName . '_t;' 
   endif
endfunction
" }}}

" JDoxVar() {{{
function! JDoxVar()
   let varName = input("variable name: ")

   " Sanity stuff . . .
   if (varName != "")
      " Without a varure name, we don't have anything.
      let varBrief = input("Brief description: ")
      let varFull = input("Full description (no newlines): ")

      if (varBrief == "")
         let varBrief = "<b>default brief variable description</b>"
      endif 

      if (varFull == "")
         let varFull = "<b>default full variable description</b>"
      endif 

      Addline '/*! @var ' . varName
      Addline ' *  @brief ' . varBrief
      Addline ' *  '
      Addline ' *  @li ' . varFull
      Addline ' */'
      Addline '<type> ' . varName . ';'
   endif
endfunction
" }}}

" JDoxGroup() {{{
function! JDoxGroup()
   let groupName = input("group name: ")

   " Sanity stuff . . .
   if (groupName != "")
      let groupParent = input("parent group: ")
      let groupBrief = input("Brief description: ")
      let groupFull = input("Full description (no newlines): ")

      if (groupBrief == "")
         let groupBrief = "<b>default brief groupiable description</b>"
      endif 

      if (groupFull == "")
         let groupFull = "<b>default full groupiable description</b>"
      endif 

      Addline '/*! @ingroup ' . groupParent
      Addline ' *  @defgroup ' . groupName
      Addline ' *  @brief ' . groupBrief
      Addline ' *  '
      Addline ' *  @li ' . groupFull
      Addline ' */'
   endif
endfunction
" }}}

" JDoxX() {{{
function! JDoxX()
   Addline ''
   Addline '/* headers {{{ */'
   let hGroup = input("group? ")
   if (hGroup != "")
      Addline '/*! @ingroup ' . hGroup
      Addline ' *  @file ' . expand("%")
   else
      Addline '/*! @file ' . expand("%")
   endif

   let hInput = input("brief description: ")
   if ( hInput != "")
      Addline ' *'
      Addline ' *  @brief ' . hInput
   endif

   let hInput = input("full description: ")
   if ( hInput != "")
      Addline ' *'
      Addline ' *  @li ' . hInput
   endif

   Addline ' *'
   Addline ' *  @e External @e Function @e Interfaces :'
   let hInput = input("external interface: ")
   while (hInput != "")
      let hInput2 = input("description: ")
      Addline ' *  @li ' . hInput . ' - ' . hInput2
      let hInput = input("external interface: ")
   endwhile

   Addline ' *'
   Addline ' *  @e External @e Data @e Interfaces :'
   let hInput = input("external data interface: ")
   while (hInput != "")
      let hInput2 = input("description: ")
      Addline ' *  @li ' . hInput . ' - ' . hInput2
      let hInput = input("external data interface: ")
   endwhile

   Addline ' *'
   Addline ' *  @e Use @e lists :'
   let hInput = input("uses: ")
   while (hInput != "")
      let hInput2 = input("purpose: ")
      Addline ' *  @li ' . hInput . ' - ' . hInput2
      let hInput = input("uses: ")
   endwhile

   Addline ' *'
   if (g:Header_name == "")
      let hInput = input("author: ")
      if ( hInput != "")
         Addline ' *  @author: ' . hInput
      endif
   else
      Addline ' *  @author: ' . g:Header_name 
   endif

   let hInput = input("version: ")
   if ( hInput != "")
      Addline ' *  @version: ' . hInput
   endif

   let hInput = strftime("%b %d %Y")
   if ( hInput != "")
      Addline ' *  @date: ' . hInput
   endif

   Addline ' *'
   Addline ' *  $Id$'
   Addline ' *  $Log$'
   Addline ' *'
   Addline ' *  (c) COPYRIGHT 2002-Present  Seaway Networks, INC.'
   Addline ' *  (c) COPYRIGHT 2001-2002  Camelot Content, INC.'
   Addline ' */'
   Addline '/* }}} */'
   Addline ''

endfunction
" }}}

" inserts the specified expression just above the cursor
" (call with '' to insert a blank line)
" MUST call with a valid EXPRESSION, not a literal string
com! -nargs=? Addline call append(line('.') - 1, <args>)
