function! vimscript_scope_syntax#hilightLazy() abort
  if &ft !~ 'vim' | return | endif

  " NOTE: not call it, keep ctermfg etc. added by user
  " TODO: Find existing colors similar to generated colors for ctermfg.
  "call s:clear()
  call timer_start(0, function('s:hilight'))
endfunction

" ---

function! s:hilight(timer)
  let l:color_code = s:getIdentifierColorCode()
  let l:fg_code = vimscript_scope_syntax#utils#colorcode#new(l:color_code)
  exe 'hi vimGlobalVar guifg='.l:fg_code.clone().mul(0.7).add(0, 0, 40).mul(0.8, 0.8, 0.9).str()
  exe 'hi vimStaticVar guifg='.l:fg_code.clone().mul(0.7).add(0, 40, 0).mul(0.8, 0.9, 0.8).str()
  exe 'hi vimLocalVar  guifg='.l:fg_code.clone().mul(0.6).add(80, 20, 0).mul(1.6, 0.7, 0.5).str()
  exe 'hi vimArgVar    guifg='.l:fg_code.clone().mul(0.6).add(80, 0, 40).mul(1.6, 0.55, 0.97).str()
  
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
"  exe 'hi clear vimStaticVar'
"  exe 'hi clear vimLocalVar'
"  exe 'hi clear vimArgVar'

"  exe 'hi clear vimBufVar'
"  exe 'hi clear vimWinVar'
"  exe 'hi clear vimTabVar'
"  exe 'hi clear vimVVar'
"endfunction

function! s:getIdentifierColorCode()
  let l:fg = synIDattr(s:getIdentifierID(), 'fg#')
  if l:fg !~ '#' | return '#000000' | endif
  return l:fg
endfunction

function! s:getNormalColorCodeBG()
  let l:bg = synIDattr(s:getNormalID(), 'bg#')
  if l:bg !~ '#' | return '#ffffff' | endif
  return l:bg
endfunction

function! s:getIdentifierID()
  return s:searchSynID('Identifier')
endfunction

function! s:getNormalID()
  return s:searchSynID('Normal')
endfunction

function! s:searchSynID(name)
  for l:id in range(1, 1000)
    let l:name = synIDattr(l:id, 'name')
    if l:name =~ a:name
      return l:id
    endif
  endfor
  
  throw 'not found ID'
endfunction
