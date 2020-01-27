" Vim syntax file
" Language:     Vim 8.0 script
" Maintainer:   wordijp <wordijp@gmail.com>
" URL:          https://github.com/wordijp/vimscript-scope-syntax

syn match synVimGlobalVar /g:\h[a-zA-Z0-9#_]*/ containedin=vimVar,vimFBVar,vimFuncVar,vimOperParen
syn match synVimStaticVar /s:\h\w*/            containedin=vimVar,vimFBVar,vimFuncVar,vimOperParen
syn match synVimLocalVar  /l:\h\w*/            containedin=vimVar,vimFBVar,vimFuncVar,vimOperParen
syn match synVimArgVar    /a:\h\w*/            containedin=vimVar,vimFBVar,vimFuncVar,vimOperParen

syn match synVimBufVar    /b:\h\w*/            containedin=vimVar,vimFBVar,vimFuncVar,vimOperParen
syn match synVimWinVar    /w:\h\w*/            containedin=vimVar,vimFBVar,vimFuncVar,vimOperParen
syn match synVimTabVar    /t:\h\w*/            containedin=vimVar,vimFBVar,vimFuncVar,vimOperParen
syn match synVimVVar      /v:\h\w*/            containedin=vimVar,vimFBVar,vimFuncVar,vimOperParen

if !exists("skip_vim_syntax_inits")
  hi def link synVimGlobalVar vimGlobalVar
  hi def link synVimStaticVar vimStaticVar
  hi def link synVimLocalVar  vimLocalVar
  hi def link synVimArgVar    vimArgVar

  hi def link synVimBufVar    vimBufVar
  hi def link synVimWinVar    vimWinVar
  hi def link synVimTabVar    vimTabVar
  hi def link synVimVVar      vimVVar
endif
