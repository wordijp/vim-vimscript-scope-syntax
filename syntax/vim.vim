" Vim syntax file
" Language:     Vim 8.0 script
" Maintainer:   wordijp <wordijp@gmail.com>
" URL:          https://github.com/wordijp/vim-vimscript-scope-syntax

" Run after original syntax/vim.vim {{{
function! s:lazy(_)
  syn match vimGlobalVar /g:\h[a-zA-Z0-9#_]*/ containedin=vimVar,vimFBVar,vimOperParen
  syn match vimScriptVar /s:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimLocalVar  /l:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimArgsVar   /a:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen,vimFuncVar

  syn match vimBufVar    /b:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimWinVar    /w:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimTabVar    /t:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimVVar      /v:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen

  " global scope syntax {{{2
  " -------------------
  syn match vimGlobalVarNoPrefix /\h[a-zA-Z0-9#_]*/ contained
    \ contains=vimGlobalVar,vimScriptVar,vimBufVar,vimWinVar,vimTabVar,vimVVar
    \ containedin=vimEcho,vimExecute,vimGlobalOperParen

  syn keyword vimFor for skipwhite nextgroup=vimVar,vimGlobalVarNoPrefix
  " NOTE: Add vimGlobalVarNoPrefix
  " NOTE: Need sync to original
  syn keyword vimLet let	unl[et]	skipwhite nextgroup=vimVar,vimGlobalVarNoPrefix,vimFuncVar,vimLetHereDoc
  syn region  vimExecute	oneline excludenl matchgroup=vimCommand start="\<exe\%[cute]\>" skip="\(\\\\\)*\\|" end="$\||\|<[cC][rR]>" contains=vimFuncVar,vimIsCommand,vimOper,vimNotation,vimOperParen,vimString,vimFunc,vimVar,vimGlobalVarNoPrefix
  syn match   vimNotFunc "\<if\>\|\<el\%[seif]\>\|\<return\>\|\<while\>"	skipwhite nextgroup=vimOper,vimOperParen,vimVar,vimGlobalVarNoPrefix,vimFunc,vimNotation
  syn region	vimGlobalOperParen matchgroup=vimParenSep	start="(" end=")" contains=@vimOperGroup
  syn region	vimGlobalOperParen matchgroup=vimSep		start="{" end="}" contains=@vimOperGroup nextgroup=vimVar,vimGlobalVarNoPrefix,vimFuncVar
  syn cluster	vimOperGroup add=vimGlobalOperParen

  if g:vimscript_scope_syntax_assign_operator
    " Enable assignment operator syntax
    " XXX: Affected extraneous syntax
    "      ex) syn match hogeMatch /hoge/ containedin=vimArgsVar
    "                                                 ~~~~~~~~~ affected :(
    syn match	vimAssignOper   /\(+=\?\|-=\?\|\*=\?\|\/=\?\|=\|\.\)\(\s*\h\w*\)\?/	contains=vimVar,vimGlobalVarNoPrefix,vimFunc nextgroup=vimString,vimSpecFile
  endif

  " function(local) scope syntax {{{2
  " ----------------------------
  syn match vimLocalVarNoPrefix  /\h\w*/ contained
    \ contains=vimGlobalVar,vimScriptVar,vimLocalVar,vimArgsVar,vimBufVar,vimWinVar,vimTabVar,vimVVar
    \ containedin=vimFuncEcho,vimFuncExecute,vimFuncOperParen

  " NOTE: Add vimLocalVarNoPrefix
  " NOTE: Need sync to original
  syn keyword vimFuncFor       contained for skipwhite nextgroup=vimVar,vimLocalVarNoPrefix
  syn keyword vimFuncLet       contained let	unl[et]	skipwhite nextgroup=vimVar,vimLocalVarNoPrefix,vimFuncVar,vimLetHereDoc
  syn region  vimFuncEcho      contained oneline excludenl matchgroup=vimCommand start="\<ec\%[ho]\>" skip="\(\\\\\)*\\|" end="$\||" contains=vimFunc,vimFuncVar,vimString,vimVar,vimLocalVarNoPrefix
  syn region  vimFuncExecute   contained oneline excludenl matchgroup=vimCommand start="\<exe\%[cute]\>" skip="\(\\\\\)*\\|" end="$\||\|<[cC][rR]>" contains=vimFuncVar,vimIsCommand,vimOper,vimNotation,vimOperParen,vimString,vimFunc,vimVar,vimLocalVarNoPrefix
  syn match   vimFuncNotFunc   contained "\<if\>\|\<el\%[seif]\>\|\<return\>\|\<while\>"	skipwhite nextgroup=vimOper,vimOperParen,vimVar,vimLocalVarNoPrefix,vimFunc,vimNotation
  syn cluster vimFuncOperGroup           contains=vimEnvvar,vimFunc,vimFuncVar,vimOper,vimFuncOperParen,vimNumber,vimString,vimRegister,vimContinue
  syn region  vimFuncOperParen contained matchgroup=vimParenSep	start="(" end=")" contains=@vimFuncOperGroup
  syn region  vimFuncOperParen contained matchgroup=vimSep		start="{" end="}" contains=@vimFuncOperGroup nextgroup=vimVar,vimLocalVarNoPrefix,vimFuncVar

  syn cluster vimFuncBodyList add=vimFuncFor,vimFuncLet,vimFuncEcho,vimFuncExecute,vimFuncNotFunc,vimFuncOperParen

  " local scope syntax for Vim9script {{{2
  " TODO: Vim9script only
  " ---------------------------------
  syn keyword vimFuncConst     contained const       	skipwhite nextgroup=vimVar,vimLocalVarNoPrefix,vimFuncVar,vimLetHereDoc
  syn cluster vimFuncBodyList add=vimFuncConst

  if g:vimscript_scope_syntax_assign_operator
    " Enable assignment operator syntax
    " XXX: Affected extraneous syntax
    "      ex) syn match hogeMatch /hoge/ containedin=vimArgsVar
    "                                     ~~~~~~~~~~~~~~~~~~~~~ affected :(
    syn match	vimFuncAssignOper  contained /\(\h\w*\s*\)\?\(+=\?\|-=\?\|\*=\?\|\/=\?\|=\|\.\)\(\s*\h\w*\)\?/	contains=vimVar,vimLocalVarNoPrefix,vimFunc nextgroup=vimString,vimSpecFile
    syn cluster vimFuncBodyList add=vimFuncAssignOper
  endif

  " TODO: After fixed bugs, happening in `v8.2.0172` (E492: Not an editor command: --todo)
  "syn match	vimFuncIncrementPostfix contained /\h\w*\s*++/	contains=vimLocalVarNoPrefix
  "syn match	vimFuncDecrementPostfix contained /\h\w*\s*--/	contains=vimLocalVarNoPrefix
  "syn match	vimFuncIncrementPrefix contained /++\s*\h\w*/	contains=vimLocalVarNoPrefix
  "syn match	vimFuncDecrementPrefix contained /--\s*\h\w*/	contains=vimLocalVarNoPrefix
  "syn cluster vimFuncBodyList add=vimFuncIncrementPostfix,vimFuncDecrementPostfix,vimFuncIncrementPrefix,vimFuncDecrementPrefix

  " args scope syntax {{{2
  " -----------------
  syn match vimArgsVarNoPrefix  /\h\w*/ contained
    \ containedin=vimArgsVar

  " NOTE: Need sync to original
  if exists("g:vimsyn_folding") && g:vimsyn_folding =~# 'f'
    syn region vimArgsFuncBody  contained	fold start=")"	matchgroup=vimCommand end="\<\(endf\>\|endfu\%[nction]\>\|enddef\>\)"		contains=@vimFuncBodyList
  else
    syn region vimArgsFuncBody  contained	     start=")"	matchgroup=vimCommand end="\<\(endf\>\|endfu\%[nction]\>\|enddef\>\)"		contains=@vimFuncBodyList
  endif
  syn region vimArgsOperParen contained start="\s*(" end="\ze)" contains=vimArgsVarNoPrefix nextgroup=vimArgsFuncBody
  syn match  vimArgsFunction /\<\(fu\%[nction]\|def\)!\=\s\+\%(<[sS][iI][dD]>\|[sSgGbBwWtTlL]:\)\=\%(\i\|[#.]\|{.\{-1,}}\)*\ze\s*(/ contains=@vimFuncList nextgroup=vimArgsOperParen

  " defined original {{{2
  " ----------------
  syn match vimAutoloadFunc contained "\h[a-zA-Z0-9#_]*\ze\s*("

  " Redefined {{{2
  " ---------
  " NOTE: for priority up
  " NOTE: Need sync to original

  " remove '.'
  " NOTE: for scope syntax of class instance
  " add '#'
  " NOTE: for autoload function syntax for vim plugin
  syn match vimFunc		"\%(\%([sSgGbBwWtTlL]:\|<[sS][iI][dD]>\)\=\%(\w\+\)*\I[a-zA-Z0-9_#]*\)\ze\s*("		contains=vimFuncName,vimUserFunc,vimExecute,vimAutoloadFunc
  " }}}
endfunction
" }}}
call timer_start(0, function('s:lazy'))

if !exists("skip_vim_syntax_inits")
  hi def link vimGlobalVar         vimGlobalVar
  hi def link vimGlobalVarNoPrefix vimGlobalVar
  hi def link vimScriptVar         vimScriptVar
  hi def link vimLocalVar          vimLocalVar
  hi def link vimLocalVarNoPrefix  vimLocalVar
  hi def link vimArgsVar           vimArgsVar
  hi def link vimArgsVarNoPrefix   vimArgsVar

  hi def link vimBufVar            vimBufVar
  hi def link vimWinVar            vimWinVar
  hi def link vimTabVar            vimTabVar
  hi def link vimVVar              vimVVar

  hi def link vimFor               vimCommand
  hi def link vimFuncFor           vimCommand
  hi def link vimFuncLet           vimCommand
  hi def link vimFuncNotFunc       vimCommand
  hi def link vimFuncConst         vimCommand
  hi def link vimAutoloadFunc      Normal
endif
