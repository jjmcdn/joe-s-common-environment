" Vim syntax file
" Language:     Standard C
" Maintainer:   Mike Williams <mrw@netcomuk.co.uk>
" Filenames:    *.c,*.h
" Last Change:  21st February 2002
" URL:          http://www.netcomuk.co.uk/~mrw/vim/syntax
"
" Notes:
" Attempt at a pure Standard C syntax highlighting file based on Schildt's
" Annotated Standard C Standard, with corrections from
"     http://www.lysator.liu.se/c/schildt.html
" and additions form the Normative Addendum 1, 1994 from
"     http://www.lysator.liu.se/c/na1.html
" except that the use of trigraphs and digraphs is not supported beyond
" highlighting as warnings of possible problems.
" C99 language features from ISO/IEC 9899:1999 (E) Programming languages - C
"
" THIS FILE CANNOT BE USED FOR INCLUSION FROM CPP.VIM!
"
" Options Flags:
" These options are (almost) as per distribution:
" c_comment_strings     - highlight strings within comments.
" c_space_errors        - highlight both types of space errors (i.e. trailing and mixed).
" c_no_trail_space_error - no highlighting of trailing white space as error.
" c_no_tab_space_error  - no highlighting of mixed tabs and spaces as error.
" c_no_ansi             - no ANSI typedefs, constants, or impl defined highlighting, unless ...
" c_ansi_typedefs       - highlight ANSI defined typedefs.
" c_ansi_constants      - highlight ANSI defined constants.
" c_syntax_for_h        - use C syntax for *.h files, instead of C++.
" c_minlines            - define minlines to sync comments over.
" c_no_cformat          - do not highlight printf and scanf style formats in strings.
"
" These options in the distribution are not supported:
" c_no_utf              - not part of Standard C, maybe later.
" c_no_if0              - NYI
"
" These options are extra to distribution:
" c_c_vim_compatible    - same type of highlighting (almost) as c.vim in distribution.
" c_no_bracket_error    - no highlighting of [] content errors.
" c_no_names            - no highlighting of identifiers, functions, and macros.
" c_conditional_is_operator - highlight ?: as operator instead of conditional.
" c_cpp_comments        - allow cpp style comment lines.
" c_cpp_warn            - highlight C++ reserved words as errors.
" c_comment_numbers     - highlight numbers in comments.
" c_comment_types       - highlight types in comments (useful for code in comments).
" c_comment_date_time   - highlight dates and times in comments.
" c_no_octal            - highlight octal integers as errors (warning really).
" c_impl_defined        - highlight compiler implementation defined macro costants.
" c_warn_trigraph       - highlight trigraphs as errors.
" c_char_is_integer     - highlight character constants as a number.
" c_C94                 - enables following options.
" c_C94_warn            - highlight C94 reserved symbols as errors.
" c_warn_digraph        - highlight digraphs as errors.
" c_C99                 - enables following options.
" c_C99_warn            - highlight C99 reserved symbols as errors.
" c_posix               - highlight Posix signals and errors.
" c_math                - highlight math.h constants.
" c_warn_8bitchars      - highlight octal and hex char constants with top bit set.
"
" These distribution options are used when c_c_vim_compatible is set:
" c_gnu                 - highlight GCC specific extensions.
" c_no_c99              - don't highlight C99 standard items.
"
" Acknowledgements:
" Based on Bram's c.vim syntax file in VIM distribution.
" Ideas and additions from the following, in no particular order;
"   Dr. Charles E. Campbell
"   Michael Geddes
"   Pablo Ariel Kohan
"   Richard Robinson
"   A.N.Y. Others who I may have missed
"
" History:
" 1.1 Better handling of conditional operator, plus choice of highlighting for it.
" 1.2 Allow multibyte character and string constants (i.e. start with L) apart from #include.
" 1.3 Rework character constants to allow for character sequences.
" 1.4 Add functions - catches macros, including defines like #define myconst (0).
" 1.5 Add macro functions and correct #define to use Define, not Macro.
" 1.6 Add missing hi link for cComment2String.
" 1.7 Add cComment[2]String to exclude cluster for parens.
"
" 2.1 Remove cPPOperator(defined) from parens exclusion, but does add it to normal code.
" 2.2 Start adding patterns for pointer dereference '*', and address of '&'.
" 2.3 Tidy up character constant handling.
" 2.4 Add cCommentSkip to exclusion list for paren group.
"
" 3.1 Removed code to pull in extensions, can now be done with au Syntax ...
" 3.2 Add cCharacterNoError to exclusion list for paren group.
" 3.3 Allow trailing dots on fp number to be part of fp number.
" 3.4 Allow u and/or l suffixes for octal numbers.
" 3.5 Move erroneous octal numbers to highlight only if allowed octals.
" 3.6 Add printf and scanf format string highlighting.
" 3.7 Add Notes and Acknowledgements.
" 3.8 Macros starting with SIG followed by upper or _ claimed by implementation.
" 3.9 ... as are all macros starting with and _ and followed by _ or upper case.
" 3.10 Moved Standard typedefs and constants to end to override all else.
" 3.11 Rework option flags to be closer to current distribution.
" 3.12 Fix cCharacter to use smallest string upto next '.
" 3.13 Improve working of cConditionalOperator.
" 3.14 Replaced ALLBUTs with explicit groups - fewer surprises in store.
" 3.15 Split types of space error as trailing ws in pp lines already handled.
" 3.16 Add common C extensions a la c.vim (asm, #warn(ing)).
" 3.17 Add flag to allow switching to c.vim level of highlighting.
" 3.18 Add bracket content error highlighting a la c.vim
"
" 4.1 Highlight arg to goto as label, not identifier.
" 4.2 Add support to optionally flag trigraphs as errors.
" 4.3 Additions for C94 - types, constants, macros, and format specifiers.
" 4.4 Allow highlighting of character constants as integers.
" 4.5 Fix #define highlighting when line start with whitespace.
"
" 5.1 Highlight integer literal constant 0 as octal, since it is.
" 5.2 Simplify string and comment highlighting a bit.
" 5.3 Fix two or more cCharacter's on a line, where '\\' is not the last one
"
" 6.1 Fix octal zeroes with more than one 0!
" 6.2 Hex numbers ending with 'e' and followed by [-+] is invalid!
" 6.3 Correct C99 hex float constants - were horribly wrong.
" 6.4 Add C99 reserved namespaces.
" 6.5 Rework C99 integer types and constants.
" 6.6 Add C94 feature warning.
" 6.7 Rework handling of C94 and C99 warnings.
" 6.8 Update to ViM 6 standard.
" 6.9 Change trigraph pattern for ?? following change to regexp syntax.
" 6.10 Remove digraph warnings from comments and strings.
"
" 7.1 Highlight floats of the form 10f as errors - invalid Standard C!
" 7.2 Sort out C99 reserved function name warnings.
" 7.3 Add C99 printf/scanf intger format spcicifers.
" 7.4 Change references from ANSI to Standard.
" 7.5 Fix C94 & C99 error highlighting.
" 7.6 Add support for c_gnu in VIM compatible mode, else warnings!
" 7.7 Correct highlighting of contained C94, C99, and GNU language features.
" 7.8 Use cCommentGroup as per distribution.
" 7.9 Fix highlighting of Octal numbers.
" 7.10 Add Posix and Maths constants from distribution as options.
" 7.11 Flag hex/octal char constants in strings as non-portable.
" 7.12 Missed __STDC_HOSTED__ from list of C99 constants.
" 7.13 Add C99 #pragma STDC commands.
" 7.14 Add handling for ... in function arg lists.
" 7.15 Make numbers and types in comments switchable.
" 7.16 Optionally highlight C++ keywords as errors.
" 7.17 Highlight common date/time formats in comments. 
"
" 8.1 Fix matching of months in date patterns - just alphabetics!
" 8.2 Correct matching exact width C99 integer typedefs.
" 8.3 Correct highlighting of C99 min/max width constant macros.
" 8.4 Add more C99 library types and macro constants I missed. 
" 8.5 Oops, I is a constant in C99, not a type.

" TODO
" 1. Add #if 0/1 comment highlighting
" 2. Fix macro continuation \ highlighting within parens
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" C is case sensitive
syn case match

" Use default keyword chars
set isk&

" Turn off C99 if VIM compatible and no C99
if exists("c_c_vim_compatible") && exists("c_no_c99")
  unlet c_C99
  unlet c_C99_warn
endif

" C99 must be on for warnings.
if exists("c_C99_warn")
  let c_C99 = 1
endif

" Turn on C94 if C99 wanted or warnings.
if (exists("c_C99") && !exists("c_C94")) || exists("c_C94_warn")
  let c_C94 = 1
endif


" C language keywords.
syn keyword       c89Statement      goto break return continue
syn cluster       cStatement        contains=c89Statement
" For compilers with asm keyword - error if not c_c_vim_compatible.
syn keyword       cASMStatement     asm
syn cluster       cStatement        add=cASMStatement
if !exists("c_c_vim_compatible") || exists("c_gnu")
  syn keyword     cGNUStatement     __asm__
  syn cluster     cStatement        add=cGNUStatement
endif
syn keyword       cLabel            case default
syn keyword       cConditional      if else switch
syn keyword       cRepeat           while for do
syn cluster       cStatement        add=cLabel,cConditional,cRepeat


" C data types
syn keyword       c89Type           int long short char void signed unsigned float double
syn cluster       cType             contains=c89Type
if exists("c_C99")
  syn keyword     c99Type           _Complex _Imaginary _Bool
  " These are actually macros that expand to the above.
  syn keyword     c99Type           bool complex imaginary
  syn cluster     cType             add=c99Type
endif
if !exists("c_c_vim_compatible") || exists("c_gnu")
  syn keyword     cGnuType          __label__ __complex__ __volatile__
  syn cluster     cType             add=cGNUType
endif


" C language structures
syn keyword       cStructureType    typedef
syn keyword       cStructure        struct union enum


" C storage modifiers
syn keyword       c89StorageClass   static register auto volatile extern const
syn cluster       cStorageClass     contains=c89StorageClass
if exists("c_C99")
  syn keyword     c99StorageClass   restrict inline
  syn cluster     cStorageClass     add=c99StorageClass
else
  syn keyword     cGNUStorageClass  inline
  syn cluster     cStorageClass     add=cGNUStorageClass
endif
if !exists("c_c_vim_compatible") || exists("c_gnu")
  syn keyword     cGNUStorageClass  __attribute__
  syn cluster     cStorageClass     add=cGNUStorageClass
endif


" C operators
syn keyword       cSizeofOperator   sizeof
syn cluster       cOperator         contains=cSizeofOperator
if !exists("c_c_vim_compatible")
  " C math operators
  syn match       cMathOperator     "[-+\*/%=]"
  " C pointer operators - address of and dereference are context sensitive
  syn match       cPointerOperator  "\(->\|\.\)"
  " C logical   operators - boolean results
  syn match       cLogicalOperator  "[!<>]=\="
  syn match       cLogicalOperator  "=="
  " C bit operators
  syn match       cBinaryOperator   "\(&\||\|\^\|\~\|<<\|>>\)=\="
  " More C logical operators - highlight in preference to binary
  syn match       cLogicalOperator  "\(&&\|||\)"
  syn match       cLogicalOperatorError "\(&&\|||\)="

  syn cluster     cOperator         add=cMathOperator,cPointerOperator,cLogicalOperator,cBinaryOperator,cLogicalOperatorError
endif
if !exists("c_c_vim_compatible") || exists("c_gnu")
  syn keyword     cGNUOperator      typeof __real__ __imag__
  syn cluster     cOperator         add=cGNUOperator
endif


" C identifiers - variables and functions
if !exists("c_no_names") && !exists("c_c_vim_compatible")
  syn match       cIdentifier       "\<\h\w*\>"
  syn match       cFunction         "\<\h\w*\>\s*("me=e-1
  " Ellipses can only occur appear within function argument lists!
  syn match       cEllipses         contained ",\s*\.\.\.\s*)"ms=s+1,me=e-1
  syn match       cEllipsesError    "\.\{2,}"
endif


" C Character constants
" Escaped characters
syn match         cEscapeCharError  contained "\\[^'\"?\\abfnrtv]"
syn match         cEscapeChar       contained "\\['\"?\\abfnrtv]"
if exists("c_c_vim_compatible") && exists("c_gnu")
  syn match       cEscapeChar       contained "\\e"
endif
" Octal characters
syn match         cOctalChar        contained "\\\o\{1,3}"
" Hex characters
syn match         cHexChar          contained "\\x\x\+"
" Useful groupings of character types
syn cluster       cSpecialChar      contains=cEscapeCharError,cEscapeChar,cOctalChar,cHexChar
syn cluster       cSpecialCharNoError contains=cEscapeChar,cOctalChar,cHexChar
if !exists("c_c_vim_compatible") && exists("c_C99")
  " C99 universal chars - hmm, can appear anywhere!
  syn match       c99UniversalChar  contained "\\u\x\{4}"
  syn match       c99UniversalChar  contained "\\u\x\{8}"
  syn cluster     cSpecialChar      add=cUniversalChar
  syn cluster     cSpecialCharNoError add=cUniversalChar
endif
syn match         cCharacter        "L\='\(\\.\|.\)\{-}'" contains=@cSpecialChar
syn match         cCharacterError   "L\='\([^']*$\|'\)"
syn match         cCharacterNoError contained "L\='\(\\.\|.\)\{-}'" contains=@cSpecialCharNoError


" C String constants
syn cluster       cStringContents   contains=@cSpecialChar,cPPLineJoin
if exists("c_warn_8bitchars")
  " Octal and hex chars in strings not portable if top bit set.
  syn match       cOctalCharError   contained "\\\(2\|3\)\o\{1,2}"
  syn match       cHexCharError     contained "\\x[89a-f]\x\+"
  syn cluster     cStringContents   add=cHexCharError,cOctalCharError
endif
if !exists("c_no_cformat")
  " Where behaviour is undefined in a format string it will not be highlighted!
  " This explains why the 0 flag is omitted for string print format etc.

  " Anything other than the following patterns are undefined format strings
  syn match       cFormatError      contained "%[^"]"
  syn match       cFormatError      contained "%\""me=e-1

  " octal and hex print formats (can have precision and h or l size specifier)
  syn match       cPrintFormat      contained "%[-+0 #]*\(\*\|\d\+\)\=\(\.\(\*\|\d*\)\)\=[hl]\=[oxX]"
  " intger print formats (can have precision and h or l size specifier, but no # flag)
  syn match       cPrintFormat      contained "%[-+0 ]*\(\*\|\d\+\)\=\(\.\(\*\|\d*\)\)\=[hl]\=[diu]"
  " fp print formats (can have precision but only L size specfier)
  syn match       cPrintFormat      contained "%[-+0 #]*\(\*\|\d\+\)\=\(\.\(\*\|\d*\)\)\=L\=[eEfgG]"
  " string print formats (can have precision but no 0 or # flags)
  syn match       cPrintFormat      contained "%[-]*\(\*\|[1-9]\d*\)\=\(\.\(\*\|\d*\)\)\=s"
  " number chars so far print formats (h or l size specifiers but no precision 0, or # flags, should allow optional parts?)
  syn match       cPrintFormat      contained "%[-]*\(\*\|[1-9]\d*\)\=[hl]\=n"
  " character and pointer print formats (no size specifiers, precision, 0, or # flags)
  syn match       cPrintFormat      contained "%[-]*\(\*\|[1-9]\d*\)\=[cp]"
  syn match       cPrintFormat      contained "%%"

  " scanf formats may not have zero integer field width!
  " integer, octal and hex scan formats
  syn match       cScanFormat       contained "%\*\=\(0*[1-9]\d*\)\=[hl]\=[oxXdinu]"
  " fp scan formats
  syn match       cScanFormat       contained "%\*\=\(0*[1-9]\d*\)\=[lL]\=[eEfgG]"
  " char string scan format
  syn match       cScanFormat       contained "%\*\=\(0*[1-9]\d*\)\=\[\^\=.[^]]*\]"
  " character, string and pointer scan formats
  syn match       cScanFormat       contained "%\*\=\(0*[1-9]\d*\)\=[csp]"

  syn cluster     cFormat           contains=cPrintFormat,cScanFormat,cFormatError
  syn cluster     cStringContents   add=@cFormat

  if !exists("c_c_vim_compatible") && exists("c_C94")
    " C94 has new format codes for wide chars and strings (no 0 or # flags)
    syn match     c94PrintFormat    contained "%[-]*\(\*\|[1-9]\d*\)\=\(\.\(\*\|\d*\)\)\=ls"
    syn match     c94PrintFormat    contained "%[-]*\(\*\|[1-9]\d*\)\=lc"

    syn match     c94ScanFormat     contained "%\*\=\(0*[1-9]\d*\)\=l\[\^\=.[^]]*\]"
    syn match     c94ScanFormat     contained "%\*\=\(0*[1-9]\d*\)\=l[cs]"
    syn cluster   cFormat           add=c94PrintFormat,c94ScanFormat
  endif
endif
syn region        cString           start=+L\="+ skip=+\\"+ end=+"+ contains=@cStringContents

" C numeric constants.
syn case ignore
" Integer
syn match         cDecimal          "\<\d\+\(u\=l\=\|lu\)\>"
" Hex integer
syn match         cHex              "\<0x\x\+\(u\=l\=\|lu\)\>"
" But there is one illegal form of hex ...
syn match         cHexError         "\<0x\x*e[-+]"
" Octal integers
syn match         cOctalZero        contained "0"
syn match         cOctal            "\<0\+\>" contains=cOctalZero
if exists("c_no_octal")
  syn match       cOctalError       "\<0\+[1-9]\d*\(u\=l\=\|lu\)\>"
else
  syn match       cOctal            "\<0\o*\(u\=l\=\|lu\)\>" contains=cOctalZero
  syn match       cOctalError       "\<0\o*[89]\d*\(u\=l\=\|lu\)\>"
endif
syn cluster       cInteger          contains=cDecimal,cHex,cHexError,cOctal,cOctalError
syn cluster       cIntegerNoOctalErr contains=cDecimal,cHex,cHexError,cOctal
" Fp with dot, optional exponent
syn match         c89Float          "\<\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
" FP starting with a dot, optional exponent
syn match         c89Float          "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
" FP without dot, with exponent
syn match         c89Float          "\<\d\+e[-+]\=\d\+[fl]\=\>"
syn cluster       cFloat            contains=c89Float
" Fp with no dp or exponent is invalid
syn match         cFloatError       "\<\d\+f\>"

if !exists("c_c_vim_compatible") && exists("c_C99")
  " Integers have new length qualifiers.
  syn match       c99Decimal        "\<\d\+\(u\=ll\|llu\)\>"
  syn match       c99Hex            "\<0x\x\+\(u\=ll\|llu\)\>"
  syn cluster     cInteger          add=c99Decimal,c99Hex
  if exists("c_no_octal")
    syn match     c99OctalError     "\<0\+[1-9]\d*\(u\=ll\=\|llu\)\>"
  else
    syn match     c99Octal          "\<0\o*\(u\=ll\=\|llu\)\>" contains=cOctalZero
    syn match     c99OctalError     "\<0\o*[89]\d*\(u\=ll\=\|llu\)\>"
    syn cluster   cInteger          add=c99Octal
    syn cluster   cIntegerNoOctalErr contains=c99Octal
  endif
  syn cluster     cInteger          add=c99OctalError
  " Fp now has a hexadecimal format
  " Fp with dot, optional fractional part
  syn match       c99Float          "\<0x\x\+\(\.\x*\)\=p[-+]\=\d\+[fl]\="
  " FP starting with a dot
  syn match       c99Float          "0x\.\x\+p[-+]\=\d\+[fl]\=\>"
  syn cluster     cFloat            add=c99Float
endif

" Turn case matching back on
syn case match


" Highlight trailing and/or mixed space errors
if exists("c_space_errors") || !exists("c_no_trail_space_error")
  syn match       cTrailSpaceError  contained "\s\+$"
endif
if exists("c_space_errors") || !exists("c_no_tab_space_error")
  syn match       cMixedSpaceError  contained " \+\t"me=e-1
endif
syn cluster       cSpaceError       contains=cTrailSpaceError,cMixedSpaceError


" C comments
syn keyword       cTodo             contained TODO FIXME XXX
syn cluster       cCommentGroup     contains=cTodo,@cSpaceError
if exists("c_comment_strings")
  " A comment can contain cString, but a "*/" inside a cString in a cComment
  " DOES end the comment!  So we need to use a special type of cString:
  " cCommentString, which also ends on "*/", and sees a "*" at the start of
  " the line as comment again.
  syn match       cCommentSkip      contained "^\s*\*\($\|\s\+\)"
  syn cluster     cCommentStringContents contains=cCharacterNoError,@cSpecialCharNoError,cCommentSkip
  syn region      cCommentString    contained start=+L\="+ skip=+\\"+ end=+"+ end=+\*/+me=s-1 contains=@cCommentStringContents
  if !exists("c_c_vim_compatible") && exists("c_comment_numbers")
    syn cluster   cCommentGroup     add=@cIntegerNoOctalErr,@cFloat,cFloatError,@cConstant
  endif
  if !exists("c_c_vim_compatible") && exists("c_comment_types")
    syn cluster   cCommentGroup     add=cType,@cTypedef
  endif
  if !exists("c_c_vim_compatible") && exists("c_comment_date_time")
    " Time formats: hh:mm[:ss]
    syn match     cTime             contained "\d\{2}\(:\d\{2}\)\{1,2}"
    " Date formats: dd mmm yy[yy], dd/mmm/yy[yy], dd-mmm-yy[yy]
    syn match     cDate             contained "\d\{1,2}[ -/]\a\{3}[ -/]\(\d\{2}\)\{1,2}"
    " Date formats: dd/mm/yy[yy], dd-mm-yy[yy]
    syn match     cDate             contained "\d\{1,2}[-/]\d\{1,2}[-/]\(\d\{2}\)\{1,2}"
    " Date formats: mmm dd yyyy
    syn match     cDate             contained "\a\{3} \d\{2} \d\{4}"
    " Date formats: ISO yyyy/mm/dd
    syn match     cDate             contained "\d\{4}/\d\{2}/\d\{2}"
    syn cluster   cCommentGroup     add=cTime,cDate
  endif
endif
syn region        cComment          start="/\*" end="\*/" contains=cCommentString,cCharacterNoError,@cCommentGroup
syn match         cCommentError     "\*/"
if exists("c_cpp_comments") || exists("c_c_vim_compatible") || (exists("c_C99") && !exists("c_C99_warn"))
  if exists("c_comment_strings")
    " Unfortunately this doesn't very well work for // type of comments :-(
    syn region    cComment2String   contained start=+L\="+ skip=+\\"+ end=+"+ end="$" contains=@cCommentStringContents
  endif
  syn match       cComment          "//.*$" contains=cComment2String,cCharacterNoError,@cCommentGroup
else
  syn match       cCommentError     "//.*$"
endif

" C Conditional operatior - ?:
if !exists("c_c_vim_compatible")
  syn cluster     cConditionalContents contains=@cInteger,cOctalError,@cFloat,cFloatError,cString,cCharacter,cCharacterError,@cConstant
  syn cluster     cConditionalContents add=cIdentifier,cFunction,@cMacro
  syn cluster     cConditionalContents add=@cType,@cTypedef,cStructure,cConditionalOperator,@cOperator,cOperatorError
  syn cluster     cConditionalContents add=cComment,cCommentError,@cSpaceError,cParen,cBracket
  syn cluster     cConditionalContents add=@cPPCommands
  syn region      cConditionalOperator start="?" end=":" contains=@cConditionalContents
endif


" C pre-processor commands
syn cluster       cPPCommands     contains=cPPEmptyLine,cInclude,cPreCondit,cDefine,cUndef,cLine,cPragma,cPreProc

" Pre-processor commands only allowed spaces and tabs as whitespace
syn match         cPPWhiteSpace   contained "\s*"
syn match         cPPSpaceError   contained "\(\e\|\r\|\b\)\+"

" Highlight cpp joined lines and those done incorrectly
syn match         cPPLineJoin     contained "\\$"
syn match         cPPLineJoinError contained "\\\s\+$"

" Empty cpp lines which are not join or paste operations
syn match         cPPTokenOperator contained "#\{1,2}"
syn match         cPPEmptyLine    "^\s*#.*$" contains=cComment,cPPWhiteSpace,cPPSpaceError

" Almost all pre-processor lines (not include) contain the following
syn cluster       cPPCommon       contains=cComment,cCommentError,cPPSpaceError,cPPEmptyLine,cPPLineJoin,cPPLineJoinError

" File inclusion
syn match         cPPInclude      contained "^\s*#\s*include\>"
syn region        cPPIncludeFile  contained start=+"+ skip=+\\"+ end=+"+ contains=cPPLineJoin,cPPLineJoinError
syn match         cPPIncludeFile  contained "<[^>]*>"
syn match         cInclude        "^\s*#\s*include\>\s*["<]" contains=cPPSpaceError,cPPInclude,cPPIncludeFile

" Conditional code
syn match         cPPIf           contained "^\s*#\s*\(if\|ifdef\|ifndef\|elif\|else\|endif\)\>"
syn region        cPPIfParen      transparent start='(' end=')' contains=@cPPIfInteger,cPPIfParen
syn keyword       cPPOperator     contained defined
syn cluster       cPPIfInteger    contains=@cInteger,cOctalError,cCharacter,cCharacterError,@cConstant,@cMacro,cIdentifier
syn cluster       cPPIfInteger    add=cMathOperator,cLogicalOperator,cBinaryOperator,cPPOperator
syn region        cPreCondit      start="^\s*#\s*\(if\|elif\)\>" skip="\\$" end="$" contains=cPPIf,@cPPIfInteger,cPPIfParen,@cPPCommon
syn cluster       cPPIfIdentifer  contains=cIdentifier,@cMacro
syn region        cPreCondit      start="^\s*#\s*\(ifdef\|ifndef\)\>" skip="\\$" end="$" contains=cPPIf,@cPPIfIdentifier,@cPPCommon
syn region        cPreCondit      start="^\s*#\s*\(else\|endif\)\>" skip="\\$" end="$" contains=cPPIf,@cPPCommon

" Macros
syn cluster       cDefineContents contains=@cInteger,cOctalError,@cFloat,cFloatError,cString,cCharacter,cCharacterError,@cConstant
syn cluster       cDefineContents add=cIdentifier,cFunction,cMacro,cUserCont,@cStatement
syn cluster       cDefineContents add=@cType,@cTypedef,cStructure,cStructureType,@cStorageClass,cStorageClassError
syn cluster       cDefineContents add=cConditionalOperator,@cOperator,cOperatorError,cPPTokenOperator
syn cluster       cDefineContents add=cMixedSpaceError,cParen,cBracket
syn match         cPPDefine       contained "^\s*#\s*define\>"
syn region        cDefine         start="^\s*#\s*define\>" skip="\\$" end="$" contains=cPPDefine,cPPSpaceError,@cDefineContents,@cPPCommon

syn match         cPPUndef        contained "^\s*#\s*undef\>"
syn region        cUndef          start="^\s*#\s*undef\>" skip="\\$" end="$" contains=cPPUndef,cIdentifer,@cMacro,@cPPCommon

if !exists("c_no_names") && !exists("c_c_vim_compatible")
  syn match       cCMacro         "\<\u[[:upper:][:digit:]_]*\s*("me=e-1
  syn cluster     cMacro          contains=cCMacro
endif

" Line control
syn match         cPPLineNumber   contained "\<\d\+\>"
syn match         cPPLineNumberError contained "\<0\+\>"
syn match         cPPLine         contained "^\s*#\s*line\>"
syn region        cLine           start="^\s*#\s*line\>" skip="\\$" end="$" contains=cPPLine,cPPLineNumber,cPPLineNumberError,cString,@cMacro,cIdentifier,@cPPCommon

" Error
syn match         cPPMisc         contained "^\s*#\s*error\>"
syn cluster       cPPTokens       contains=cIdentifier,cString,@cInteger
syn region        cPreProc        start="^\s*#\s*error\>" skip="\\$" end="$" contains=cPPMisc,@cPPTokens,@cPPCommon

" Pragma
syn match         cPPPragma       contained "^\s*#\s*pragma\>"
syn region        cPragma         start="^\s*#\s*pragma\>" skip="\\$" end="$" contains=cPPMisc,@cPPTokens,@cPPCommon
if exists("c_C99")
  " C99 has a fixed form of #pragma also.
  syn match       c99PPPragmaError contained "[^[:space:]]\+"
  syn match       c99PPPragmaSTDC contained "^\s*#\s*pragma STDC\>"
  syn keyword     c99PPPragmaOperator contained FP_CONTRACT FENV_ACCESS CX_LIMITED_RANGE ON OFF DEFAULT
  syn region      c99Pragma       start="^\s*#\s*pragma STDC\>" skip="\\$" end="$" contains=c99PPPragmaSTDC,c99PPPragmaOperator,c99PPPragmaError
  syn keyword     c99Pragma       _Pragma
  syn cluster     cPPCommands     add=c99Pragma
endif

if exists("c_c_vim_compatible")
  " Some compilers may support these pp commands
  syn match       cPPWarn         contained "^\s*#\s*\(warn\|warning\)\>"
  syn region      cPreProc        start="^\s*#\s*\(warn\|warning\)\>" skip="\\$" end="$" contains=cPPMisc,@cPPTokens,@cPPCommon
endif


" C line labels
syn match         cUserLabel      contained "\h\w*"
syn match         cUserCont       "^\s*\h\w*\s*:\s*" contains=cUserLabel
syn match         cUserCont       ";\s*\h\w*\s*:\s*" contains=cUserLabel
syn match         cUserCont       "goto\s\+\h\w*"lc=4 contains=cUserLabel


" C bitfield definitions
syn match         cBitField       "^\s*\h\w*\s*:\s*[1-9]"me=e-1 contains=cIdentifier
syn match         cBitField       ";\s*\h\w*\s*:\s*[1-9]"me=e-1 contains=cIdentifier


" Catch errors caused by wrong parenthesis and bracketing
syn cluster       cParenContents  contains=@cInteger,cOctalError,@cFloat,cFloatError,cString,cCharacter,cCharacterError,@cConstant
syn cluster       cParenContents  add=cIdentifier,cFunction,cEllipses,cEllipsesError,@cMacro,@cType,@cTypedef,cStructure,@cStorageClass,cStorageClassError
syn cluster       cParenContents  add=@cOperator,cOperatorError,cConditionalOperator
syn cluster       cParenContents  add=cComment,cCommentError,@cSpaceError
syn cluster       cParenContents  add=@cPPCommands
if exists("c_no_bracket_error")
  syn match       cErrInParen     contained "[{}]"
  syn region      cParen          transparent start='(' end=')' contains=@cParenContents,cParen,cErrInParen
  syn match       cParenError     ")"
else
  syn match       cErrInParen     contained "[\]{}]"
  syn region      cParen          transparent start='(' end=')' contains=@cParenContents,cParen,cBracket,cErrInParen
  syn match       cParenError     "[\])]"
  syn match       cErrInBracket   contained "[);{}]"
  syn region      cBracket        transparent start='\[' end=']' contains=@cParenContents,cBracket,cParen,cErrInBracket
endif


" C typedefs
if !exists("c_no_ansi") || exists("c_ansi_typedefs")
  syn keyword     c89Typedef      size_t wchar_t ptrdiff_t sig_atomic_t fpos_t div_t ldiv_t
  syn keyword     c89Typedef      clock_t time_t va_list jmp_buf FILE
  syn cluster     cTypedef        contains=c89Typedef

  if !exists("c_c_vim_compatible")
    if exists("c_C94")
      " C94 new typedefs
      syn keyword c94Typedef      wint_t wctrans_t wctype_t mbstate_t
      syn cluster cTypedef        add=c94Typedef
    endif

    if exists("c_C99")
      " C99 new typedefs
      syn keyword c99Typedef      fenv_t fexcept_t float_t double_t
      syn match   c99Typedef      "\<u\=int\(_least\|_fast\)\=\d\+_t\>"
      syn keyword c99Typedef      intptr_t uintptr_t intmax_t uintmax_t
      syn keyword c99Typedef      lldiv_t imaxdiv_t
      syn cluster cTypedef        add=c99Typedef
    endif
  endif
endif


" C constants
if !exists("c_no_ansi") || exists("c_ansi_constants")
  syn keyword     c89Constant     __LINE__ __FILE__ __DATE__ __TIME__ __STDC__
  syn keyword     c89Constant     CHAR_BIT MB_LEN_MAX MB_CUR_MAX
  syn keyword     c89Constant     UCHAR_MAX UINT_MAX ULONG_MAX USHRT_MAX
  syn keyword     c89Constant     INT_MIN LONG_MIN SHRT_MIN
  syn keyword     c89Constant     CHAR_MAX INT_MAX LONG_MAX SHRT_MAX
  syn keyword     c89Constant     SCHAR_MIN SINT_MIN SLONG_MIN SSHRT_MIN
  syn keyword     c89Constant     SCHAR_MAX SINT_MAX SLONG_MAX SSHRT_MAX
  syn keyword     c89Constant     FLT_RADIX FLT_ROUNDS FLT_DIG FLT_MANT_DIG FLT_EPSILON
  syn keyword     c89Constant     FLT_MIN FLT_MAX FLT_MIN_EXP FLT_MAX_EXP FLT_MIN_10_EXP FLT_MAX_10_EXP
  syn keyword     c89Constant     DBL_MIN DBL_MAX DBL_MIN_EXP DBL_MAX_EXP DBL_MIN_10_EXP DBL_MAX_10_EXP
  syn keyword     c89Constant     DBL_DIG DBL_MANT_DIG DBL_EPSILON
  syn keyword     c89Constant     LDBL_MIN LDBL_MAX LDBL_MIN_EXP LDBL_MAX_EXP LDBL_MIN_10_EXP LDBL_MAX_10_EXP
  syn keyword     c89Constant     LDBL_DIG LDBL_MANT_DIG LDBL_EPSILON
  syn keyword     c89Constant     HUGE_VAL EDOM ERANGE CLOCKS_PER_SEC NULL
  syn keyword     c89Constant     LC_ALL LC_COLLATE LC_CTYPE LC_MONETARY LC_NUMERIC LC_TIME
  syn keyword     c89Constant     SIG_DFL SIG_ERR SIG_IGN SIGABRT SIGFPE SIGILL SIGINT SIGSEGV SIGTERM
  syn keyword     c89Constant     _IOFBF _IOLBF _IONBF BUFSIZ EOF FOPEN_MAX FILENAME_MAX L_tmpnam
  syn keyword     c89Constant     SEEK_CUR SEEK_END SEEK_SET TMP_MAX stderr stdin stdout
  syn keyword     c89Constant     EXIT_FAILURE EXIT_SUCCESS RAND_MAX
  syn cluster     cConstant       contains=c89Constant

  if !exists("c_c_vim_compatible")
    " C94 additional constants
    if exists("c_C94")
      syn keyword c94Constant     EILSEQ WEOF WCHAR_MAX WCHAR_MIN __STDC_VERSION__
      syn cluster cConstant       add=c94Constant
    endif

    " C99 additional constants
    if exists("c_C99")
      syn keyword c99Constant     __STDC_HOSTED__ __STDC_IEC_559__ __STDC_IEC_559_COMPLEX__ __STDC_ISO_10646__
      syn keyword c99Constant     __VA_ARGS__
      syn keyword c99Constant     __func__ __bool_true_false_are_defined true false
      syn keyword c99Constant     FE_DIVBYZERO FE_INEXACT FE_INVALID FE_OVERFLOW FE_UNDERFLOW FE_ALL_EXCEPT
      syn keyword c99Constant     FE_DOWNWARD FE_TONEAREST FE_TOWARDZERO FE_UPWARD FE_DFL_ENV
      syn keyword c99Constant     HUGE_VALF HUGE_VALL INFINITY NAN
      syn keyword c99Constant     FP_INFINITE FP_NAN FP_NORMAL FP_SUBNORMAL FP_ZERO
      syn keyword c99Constant     FP_FAST_FMA FP_FAST_FMAF FP_FAST_FMAL FP_ILOGB0 FP_ILOGBNAN
      syn keyword c99Constant     MATH_ERRNO MATH_ERREXCEPT math_errhandling
      syn match   c99Constant     "\<INT\(_LEAST\|_FAST\)\=\d\+_\(MIN\|MAX\)\>"
      syn match   c99Constant     "\<UINT\(_LEAST\|_FAST\)\=\d\+_MAX\>"
      syn keyword c99Constant     INTPTR_MIN INTPTR_MAX UINTPTR_MAX INTMAX_MIN INTMAX_MAX UINTMAX_MAX
      syn keyword c99Constant     PTRDIFF_MIN PTRDIFF_MAX SIG_ATOMIC_MIN SIG_ATOMIC_MAX SIZE_MAX
      syn keyword c99Constant     WINT_MIN WINT_MAX LLONG_MIN LLONG_MAX ULLONG_MAX
      syn keyword c99Constant     _Complex_I _Imaginary_I I
      syn cluster cConstant       add=c99Constant
    endif
  endif
  if !exists("c_c_vim_compatible") || exists("c_gnu")
    " GNU constants
    syn keyword   cGNUConstant    __GNUC__ __FUNCTION__ __PRETTY_FUNCTION__
    syn cluster   cConstant       add=cGNUConstant
  endif
  if exists("c_c_vim_compatible") || exists("c_posix")
    " POSIX signals and errors
    syn keyword cPosixConstant    SIGALRM SIGCHLD SIGCONT SIGHUP SIGKILL SIGPIPE SIGQUIT
    syn keyword cPosixConstant    SIGSTOP SIGTRAP SIGTSTP SIGTTIN SIGTTOU SIGUSR1 SIGUSR2
    syn keyword cPosixConstant    E2BIG EACCES EAGAIN EBADF EBADMSG EBUSY
    syn keyword cPosixConstant    ECANCELED ECHILD EDEADLK EEXIST EFAULT
    syn keyword cPosixConstant    EFBIG EINPROGRESS EINTR EINVAL EIO EISDIR
    syn keyword cPosixConstant    EMFILE EMLINK EMSGSIZE ENAMETOOLONG ENFILE ENODEV
    syn keyword cPosixConstant    ENOENT ENOEXEC ENOLCK ENOMEM ENOSPC ENOSYS
    syn keyword cPosixConstant    ENOTDIR ENOTEMPTY ENOTSUP ENOTTY ENXIO EPERM
    syn keyword cPosixConstant    EPIPE EROFS ESPIPE ESRCH ETIMEDOUT EXDEV
    syn cluster cConstant         add=cPosixConstant
  endif
  if exists("c_c_vim_compatible") || exists("c_math")
    " Math.h constants
    syn keyword cMathConstant     M_E M_LOG2E M_LOG10E M_LN2 M_LN10 M_PI M_PI_2 M_PI_4
    syn keyword cMathConstant     M_1_PI M_2_PI M_2_SQRTPI M_SQRT2 M_SQRT1_2
    syn cluster cConstant         add=cMathConstant
  endif
endif

if !exists("c_no_ansi") && !exists("c_c_vim_compatible")
  if !exists("c_no_names") || exists("c_impl_defined")
    " Highlight compiler implemented reserved macros
    syn match     c89Macro        "\<_[[:upper:]_]\w*\>"
    syn match     c89Macro        "\<\(LC_\|SIG_\)\u\w*\>"
    syn cluster   cMacro          add=c89Macro
    if exists("c_C99")
      syn match   c99Macro        "\<U\=INT\d\+_C\>"
      syn keyword c99Macro        INTMAX_C UINTMAX_C
      syn match   c99Macro        "\<E@\(\u\|\d\)\w*\>"
      " printf/scanf format conversion macros
      syn match   c99Macro        "\(PRI\|SCN\)[diouxX]\(LEAST\|FAST\)\d\+"
      syn match   c99Macro        "\(PRI\|SCN\)[diouxX]\(MAX\|PTR\)"
      syn cluster cMacro          add=c99Macro
      syn match   c99MacroError   "\(PRI\|SCN\)[^diouxX]\(LEAST\|FAST\)\d\+"
      syn match   c99MacroError   "\(PRI\|SCN\)[^diouxX]\(MAX\|PTR\)"
    endif
    if exists("c_C99_warn")
      " C99 reserved function identifiers!
      syn keyword cFunction       strcpy strncpy strcat strncat strcmp strcoll strncmp strxfrm
      syn keyword cFunction       strchr strcspn strpbrk strrchr strspn strstr strtok strerror strlen
      syn keyword cFunction       strtoimax strtoumax
      syn keyword cFunction       memcpy memmove memcmp memchr memset
      syn keyword cFunction       wcstod wcstof wcstold wcstol wcstoll wcstoull
      syn keyword cFunction       wcscpy wcsncpy wcscat wcsncat wcscmp wcscoll wcsncmp wcsxfrm
      syn keyword cFunction       wcschr wcscspn wcspbrk wcsrchr wcsspn wcsstr wcstok wcserror wcslen
      syn keyword cFunction       wcstoimax wcstoumax
      syn keyword cFunction       tolower toupper
      syn keyword cFunction       towlower towupper towctrans
      syn keyword cFunction       isalnum isalpha isblank iscntrl isdigit isgraph islower isprint ispunct isspace isupper isxdigit
      syn keyword cFunction       isfinite isinf isnan isnormal
      syn keyword cFunction       isgreater isgreaterequal isless islessequal islessgreater isunordered
      syn keyword cFunction       iswalnum iswalpha iswblank iswcntrl iswdigit iswgraph iswlower iswprint iswpunct iswspace iswupper iswxdigit
      syn keyword cFunction       iswctype
      " Try and catch future Standard library function names.
      syn match   cC99Error       "\<\(str\|mem\|wcs\|to\|is\)\l\w*\>\s*("he=e-1
      syn keyword cC99Error       cerf cerfc cexp2 cexpm1 clog10 clog1p clog2 clgamme ctgamma
      syn keyword cC99Error       cerff cerfcf cexp2f cexpm1f clog10f clog1pf clog2f clgammef ctgammaf
      syn keyword cC99Error       cerfl cerfcl cexp2l cexpm1l clog10l clog1pl clog2l clgammel ctgammal
    endif
  endif
endif

if !exists("c_c_vim_compatible") && exists("c_warn_trigraph")
  " Highlight trigraphs as errors
  "syn match       cTrigraphError    "\?\?[=(/)'<!>-]"
  syn match     cTrigraphError    "??[=(/)'<!>-]"
  syn cluster   cParenContents    add=cTrigraphError
  syn cluster   cDefineContents   add=cTrigraphError
  syn cluster   cConditionalContents add=cTrigraphError
  syn cluster   cCommentGroup     add=cTrigraphError
  syn cluster   cCommentStringContents add=cTrigraphError
  syn cluster   cStringContents   add=cTrigraphError
endif

if !exists("c_c_vim_compatible") && exists("c_C94") && exists("c_warn_digraph")
  " Highlight digraphs as errors
  syn match     cDigraphError     "\(<[:%]\|[:%]>\)"
  syn match     cDigraphError     "\(%:\)\{1,2}"
  syn cluster   cParenContents    add=cDigraphError
  syn cluster   cDefineContents   add=cDigraphError
  syn cluster   cConditionalContents add=cDigraphError
endif

if !exists("c_c_vim_compatible") && exists("c_C94")
  " C94 iso646 macros
  syn keyword   c94Macro          and and_eq bitand bitor compl not not_eq or or_eq xor xor_eq

  " Add iso646 errors to appropriate highlight clusters
  syn cluster   cParenContents    add=c94Macro
  syn cluster   cDefineContents   add=c94Macro
  syn cluster   cConditionalContents add=c94Macro
endif


if exists("c_cpp_warn")
  " C++ reserved words that must not be used if compiling with a C++ compiler
  syn keyword   cCPPError         new delete this throw try catch namespace using public protected private friend
  syn keyword   cCPPError         mutable class template typename virtual explicit operator typeid
  syn match     cCPPError         "\<\(const\|static\|dynamic\|reinterpret\)_cast\>"

  " Add to contained groups
  syn cluster   cParenContents    add=cCPPError
  syn cluster   cDefineContents   add=cCPPError
  syn cluster   cConditionalContents add=cCPPError
endif


" Highlight re-syncing distance.
if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  let b:c_minlines = 15
endif
exec "syn sync ccomment cComment minlines=" . b:c_minlines


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_c_syntax_inits")
  if version < 508
    let did_c_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cTodo      Todo

  HiLink c89Statement           Statement
  if exists("c_c_vim_compatible")
    HiLink cASMStatement        Statement
  else
    HiLink cASMStatement        cError
  endif
  HiLink cLabel                 Label
  HiLink cUserLabel             cLabel
  HiLink cConditional           Conditional
  HiLink cRepeat                Repeat

  HiLink cOperator              Operator
  HiLink cSizeofOperator        cOperator
  HiLink cMathOperator          cOperator
  HiLink cPointerOperator       cOperator
  HiLink cLogicalOperator       cOperator
  HiLink cBinaryOperator        cOperator
  if exists("c_conditional_is_operator")
    HiLink cConditionalOperator cOperator
  else
    HiLink cConditionalOperator cConditional
  endif

  HiLink cType                  Type
  HiLink c89Type                cType
  HiLink cTypedef               Typedef
  HiLink c89Typedef             cTypedef
  HiLink cStructure             Structure
  HiLink cStructureType         cStructure
  HiLink cStorageClass          StorageClass
  HiLink c89StorageClass        cStorageClass
  HiLink cIdentifier            Identifier
  HiLink cEllipses              cIdentifier
  HiLink cFunction              Function

  if exists("c_char_is_integer")
    HiLink cCharacter           cInteger
  else
    HiLink cCharacter           Character
  endif
  HiLink cCharacterNoError      cCharacter
  HiLink cSpecialChar           SpecialChar
  HiLink cEscapeChar            cSpecialChar
  HiLink cOctalChar             cSpecialChar
  HiLink cHexChar               cSpecialChar
  HiLink cString                String
  HiLink cSpecial               cSpecialChar
  HiLink cFormat                cSpecial
  HiLink cPrintFormat           cFormat
  HiLink cScanFormat            cFormat

  HiLink cNumber                Number
  HiLink cInteger               cNumber
  HiLink cDecimal               cInteger
  HiLink cOctal                 cInteger
  HiLink cOctalZero             PreProc
  HiLink cHex                   cInteger
  HiLink cFloat                 Float
  HiLink c89Float               cFloat

  HiLink cConstant              Constant
  HiLink c89Constant            cConstant

  HiLink cComment               Comment
  HiLink cCommentString         cString
  HiLink cComment2String        cString
  HiLink cCommentSkip           cComment
  HiLink cTime                  cNumber
  HiLink cDate                  cString

  HiLink cError                 Error
  HiLink cStatementError        cError
  HiLink cStorageClassError     cError
  HiLink cOperatorError         cError
  HiLink cOctalError            cError
  HiLink cFloatError            cError
  HiLink cParenError            cError
  HiLink cErrInParen            cError
  HiLink cErrInBracket          cError
  HiLink cCommentError          cError
  HiLink cTrailSpaceError       cError
  HiLink cMixedSpaceError       cError
  HiLink cCharacterError        cError
  HiLink cEscapeCharError       cError
  HiLink cOctalCharError        cError
  HiLink cHexCharError          cError
  HiLink cLogicalOperatorError  cError
  HiLink cTrigraphError         cError
  HiLink cISO646Error           cError
  HiLink cDigraphError          cError
  HiLink cFormatError           cError
  HiLink cHexError              cError
  HiLink cEllipsesError         cError

  HiLink cPreProc               PreProc
  HiLink cPPEmptyLine           cPreProc
  HiLink cPPLineJoin            cPreProc
  HiLink cPPMisc                cPreProc
  HiLink cPPPragma              cPreProc
  HiLink cPPWarn                cPreProc
  HiLink cInclude               Include
  HiLink cPPInclude             cInclude
  HiLink cPPIncludeFile         cString
  HiLink cDefine                Define
  HiLink cPPDefine              cDefine
  HiLink cUndef                 cDefine
  HiLink cPPUndef               cUndef
  HiLink cPragma                cPreProc
  HiLink cMacro                 Macro
  HiLink cCMacro                cMacro
  HiLink c89Macro               cMacro
  HiLink cPreCondit             PreCondit
  HiLink cPPIf                  cPreCondit
  HiLink cLine                  PreProc
  HiLink cPPLine                cLine
  HiLink cPPLineNumber          cInteger
  HiLink cPPOperator            cOperator
  HiLink cPPTokenOperator       cPPOperator
  HiLink cPPPragmaOperator      cPPOperator
  HiLink cPPOut                 cComment
  HiLink cPPOut2                cPPOut
  HiLink cPPSkip                cPPOut

  HiLink cPPError               cError
  HiLink cPreProcError          cPPError
  HiLink cPPLineNumberError     cPPError
  HiLink cPPSpaceError          cPPError
  HiLink cPPLineJoinError       cPPError
  HiLink cPPWarnError           cPPError
  HiLink cPPPragmaError         cPPError

  if exists("c_cpp_warn")
    HiLink cCPPError            cError
  endif

  if exists("c_C94")
    if !exists("c_C94_warn")
      HiLink c94Macro           cMacro
      HiLink c94Constant        cConstant
      HiLink c94PrintFormat     cPrintFormat
      HiLink c94ScanFormat      cScanFormat
      HiLink c94Typedef         cTypedef

    else
      HiLink cC94Error          cError
      HiLink c94Macro           cC94Error
      HiLink c94Constant        cC94Error
      HiLink c94PrintFormat     cC94Error
      HiLink c94ScanFormat      cC94Error
      HiLink c94Typedef         cC94Error
    endif
  endif

  if exists("c_C99")
    if !exists("c_C99_warn")
      HiLink c99Type            cType
      HiLink c99Typedef         cTypedef
      HiLink c99StorageClass    cStorageClass
      HiLink c99Macro           cMacro
      HiLink c99MacroError      cError
      HiLink c99UniversalChar   cSpecialChar
      HiLink c99Decimal         cDecimal
      HiLink c99Hex             cHex
      HiLink c99OctalError      cOctalError
      HiLink c99Octal           cOctal
      HiLink c99Float           cFloat
      HiLink c99Constant        cConstant
      HiLink c99Pragma          cPreProc
      HiLink c99PPPragmaSTDC    cPreProc
      HiLink c99PPPragmaOperator cPPOperator
      HiLink c99PPPragmaError   cPPError

    else
      HiLink cC99Error          cError
      HiLink c99Type            cC99Error
      HiLink c99Typedef         cC99Error
      HiLink c99StorageClass    cC99Error
      HiLink c99Macro           cC99Error
      HiLink c99MacroError      cC99Error
      HiLink c99UniversalChar   cC99Error
      HiLink c99Decimal         cC99Error
      HiLink c99Hex             cC99Error
      HiLink c99OctalError      cC99Error
      HiLink c99Octal           cC99Error
      HiLink c99Float           cC99Error
      HiLink c99Constant        cC99Error
      HiLink c99Constant        cC99Error
      HiLink c99Pragma          cC99Error
      HiLink c99PPPragmaSTDC    cC99Error
      HiLink c99PPPragmaOperator cC99Error
      HiLink c99PPPragmaError   cC99Error
    endif
  endif

  if exists("c_c_vim_compatible")
    if exists("c_gnu")
      HiLink cGNUType           cType
      HiLink cGNUStatement      c89Statement
      HiLink cGNUOperator       cOperator
      HiLink cGNUStorageClass   cStorageClass
      HiLink cGNUConstant       cConstant
    endif
    HiLink cPosixConstant       cConstant
    HiLink cMathConstant        cConstant

  else
    HiLink cGNUError            cError
    HiLink cGNUStatement        cGNUError
    HiLink cGNUOperator         cGNUError
    HiLink cGNUType             cGNUError
    HiLink cGNUStorageClass     cGNUError
    HiLink cGNUConstant         cGNUError
  endif

  delcommand HiLink
endif

let b:current_syntax = "c"

" vim:et:ff=unix:
" EOF c.vim
