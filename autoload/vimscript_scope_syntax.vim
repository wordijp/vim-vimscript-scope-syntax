function! vimscript_scope_syntax#hilightLazy() abort
  if &ft !~ 'vim' | return | endif

  " NOTE: not call it, keep ctermfg etc. added by user
  " TODO: Find existing colors similar to generated colors for ctermfg.
  "call s:clear()
  call timer_start(0, function('s:hilight'))
endfunction

" ---

function! s:hilight(_)
  " scope highlight
  let l:fg_color_code = s:getIdentifierColorCodeFG()
  let l:fg_code = vimscript_scope_syntax#utils#colorcode#new(l:fg_color_code)
  let l:warm_hi_opts = {
    \ 'vimGlobalVar': {
    \   'guifg': l:fg_code.clone().mul(0.7).add(0, 0, 40).mul(0.8, 0.8, 0.9),
    \ },
    \ 'vimScriptVar': {
    \   'guifg': l:fg_code.clone().mul(0.7).add(0, 40, 0).mul(0.8, 0.9, 0.8),
    \ },
    \ 'vimLocalVar': {
    \   'guifg': l:fg_code.clone().mul(0.6).add(80, 20, 0).mul(1.6, 0.7, 0.5),
    \ },
    \ 'vimArgsVar': {
    \   'guifg': l:fg_code.clone().mul(0.6).add(80, 0, 40).mul(1.6, 0.55, 0.97),
    \ },
    \ }
  call s:exe_highlight(l:warm_hi_opts)
  
  let l:bg_color_code = s:getNormalColorCodeBG()
  let l:bg_code = vimscript_scope_syntax#utils#colorcode#new(l:bg_color_code).add(20)
  let l:fg_code = l:fg_code.mul(0.65)
  let l:cold_hi_opts = {
    \ 'vimBufVar': {
    \   'guifg': l:fg_code.clone(),
    \   'guibg': l:bg_code.clone()
    \ },
    \ 'vimWinVar': {
    \   'guifg': l:fg_code.clone(),
    \   'guibg': l:bg_code.clone()
    \ },
    \ 'vimTabVar': {
    \   'guifg': l:fg_code.clone(),
    \   'guibg': l:bg_code.clone()
    \ },
    \ 'vimVVar': {
    \   'guifg': l:fg_code.clone(),
    \   'guibg': l:bg_code.clone()
    \ },
    \ }
  call s:exe_highlight(l:cold_hi_opts)
  
function! s:exe_highlight(opts)
  for [l:k, l:v] in items(a:opts)
    let l:s = 'hi '.l:k
    if has_key(l:v, 'guifg')
      let l:s = l:s.' guifg='.l:v['guifg'].str()
    endif
    if has_key(l:v, 'guibg')
      let l:s = l:s.' guibg='.l:v['guibg'].str()
    endif
    exe l:s
  endfor
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
