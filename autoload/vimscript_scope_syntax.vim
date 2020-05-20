function! vimscript_scope_syntax#hilightLazy() abort
  if &ft !~ 'vim' | return | endif

  " NOTE: not call it, keep ctermfg etc. added by user
  " TODO: Find existing colors similar to generated colors for ctermfg.
  "call s:clear()
  call timer_start(0, function('s:hilight'))
endfunction

" ---

function! s:hilight(_)
  let l:color_code = s:getIdentifierColorCodeFG()
  let l:fg_code = vimscript_scope_syntax#utils#colorcode#new(l:color_code)
  exe 'hi vimGlobalVar guifg='.l:fg_code.clone().mul(0.7).add(0, 0, 40).mul(0.8, 0.8, 0.9).str()
  exe 'hi vimScriptVar guifg='.l:fg_code.clone().mul(0.7).add(0, 40, 0).mul(0.8, 0.9, 0.8).str()
  exe 'hi vimLocalVar  guifg='.l:fg_code.clone().mul(0.6).add(80, 20, 0).mul(1.6, 0.7, 0.5).str()
  exe 'hi vimArgsVar   guifg='.l:fg_code.clone().mul(0.6).add(80, 0, 40).mul(1.6, 0.55, 0.97).str()
  
  let l:color_code = s:getNormalColorCodeBG()
  let l:bg_color_code = vimscript_scope_syntax#utils#colorcode#new(l:color_code).add(20).str()
  let l:fg_color_code = l:fg_code.mul(0.65).str()
  exe 'hi vimBufVar guifg='.l:fg_color_code.' guibg='.l:bg_color_code
  exe 'hi vimWinVar guifg='.l:fg_color_code.' guibg='.l:bg_color_code
  exe 'hi vimTabVar guifg='.l:fg_color_code.' guibg='.l:bg_color_code
  exe 'hi vimVVar   guifg='.l:fg_color_code.' guibg='.l:bg_color_code
endfunction

"function! s:clear()
"  exe 'hi clear vimGlobalVar'
"  exe 'hi clear vimScriptVar'
"  exe 'hi clear vimLocalVar'
"  exe 'hi clear vimArgsVar'

"  exe 'hi clear vimBufVar'
"  exe 'hi clear vimWinVar'
"  exe 'hi clear vimTabVar'
"  exe 'hi clear vimVVar'
"endfunction

function! s:getIdentifierColorCodeFG()
  let l:fg = synIDattr(synIDtrans(hlID('Identifier')), 'fg#')
  if l:fg !~ '#' | return '#000000' | endif
  return l:fg
endfunction

function! s:getNormalColorCodeBG()
  let l:bg = synIDattr(synIDtrans(hlID('Normal')), 'bg#')
  if l:bg !~ '#' | return '#ffffff' | endif
  return l:bg
endfunction
