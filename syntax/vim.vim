" Vim syntax file
" Language:     Vim 8.0 script
" Maintainer:   wordijp <wordijp@gmail.com>
" URL:          https://github.com/wordijp/vimscript-scope-syntax

" NOTE: Run after original syntax/vim.vim
function! s:lazy(timer)
  syn match vimGlobalVar /g:\h[a-zA-Z0-9#_]*/ containedin=vimVar,vimFBVar,vimOperParen
  syn match vimStaticVar /s:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimLocalVar  /l:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimArgVar    /a:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen,vimFuncVar

  syn match vimBufVar    /b:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimWinVar    /w:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimTabVar    /t:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen
  syn match vimVVar      /v:\h\w*/            containedin=vimVar,vimFBVar,vimOperParen

  " -------------------
  " global scope syntax
  syn match vimGlobalVarNoPrefix /\h\w*/ contained
    \ contains=vimGlobalVar,vimStaticVar,vimLocalVar,vimBufVar,vimWinVar,vimTabVar,vimVVar
    \ containedin=vimEcho,vimExecute

  syn keyword vimFor for skipwhite nextgroup=vimGlobalVarNoPrefix
  " NOTE: Add vimGlobalVarNoPrefix to vimLet
  " NOTE: need sync to original
  syn keyword	vimLet let	unl[et]	skipwhite nextgroup=vimVar,vimGlobalVarNoPrefix,vimFuncVar,vimLetHereDoc

  " ------------------
  " local scope syntax
  syn match vimLocalVarNoPrefix  /\h\w*/ contained
    \ contains=vimGlobalVar,vimStaticVar,vimLocalVar,vimArgVar,vimBufVar,vimWinVar,vimTabVar,vimVVar
    \ containedin=vimFuncEcho,vimFuncExecute

  syn keyword vimFuncFor     contained for skipwhite nextgroup=vimLocalVarNoPrefix
  syn keyword	vimFuncLet     contained let	unl[et]	skipwhite nextgroup=vimLocalVarNoPrefix,vimLetHereDoc
  syn region	vimFuncEcho    contained oneline excludenl matchgroup=vimCommand start="\<ec\%[ho]\>" skip="\(\\\\\)*\\|" end="$\||" contains=vimFunc,vimFuncVar,vimString
  syn region	vimFuncExecute contained oneline excludenl matchgroup=vimCommand start="\<exe\%[cute]\>" skip="\(\\\\\)*\\|" end="$\||\|<[cC][rR]>" contains=vimFuncVar,vimIsCommand,vimOper,vimNotation,vimOperParen,vimString

  syn cluster vimFuncBodyList add=vimFuncFor,vimFuncLet,vimFuncEcho,vimFuncExecute
  
endfunction
call timer_start(0, function('s:lazy'))



if !exists("skip_vim_syntax_inits")
  hi def link vimGlobalVar         vimGlobalVar
  hi def link vimGlobalVarNoPrefix vimGlobalVar
  hi def link vimStaticVar         vimStaticVar
  hi def link vimLocalVar          vimLocalVar
  hi def link vimLocalVarNoPrefix  vimLocalVar
  hi def link vimArgVar            vimArgVar

  hi def link vimBufVar            vimBufVar
  hi def link vimWinVar            vimWinVar
  hi def link vimTabVar            vimTabVar
  hi def link vimVVar              vimVVar
  
  hi def link vimFor               vimCommand
  hi def link vimFuncFor           vimCommand
  hi def link vimFuncLet           vimCommand
endif
