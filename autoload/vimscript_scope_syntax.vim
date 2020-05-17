let s:highlight_names = {'vimGlobalVar':1, 'vimScriptVar':1, 'vimLocalVar':1, 'vimArgsVar':1, 'vimBufVar':1, 'vimWinVar':1, 'vimTabVar':1, 'vimVVar':1}
let s:highlight_dynamic_names = {}
for s:k in keys(s:highlight_names)
  let s:highlight_dynamic_names[s:k.'Dyn'] = 1
endfor

" ---

function! vimscript_scope_syntax#hilightLazy() abort
  if &ft !~ 'vim' | return | endif

  " NOTE: not call it, keep ctermfg etc. added by user
  " TODO: Find existing colors similar to generated colors for ctermfg.
  "call s:clear()
  call timer_start(0, function('s:hilight'))
endfunction

let s:dynamic_timer_id = 0
function! vimscript_scope_syntax#dynamic_redrawLazy() abort
  if g:vimscript_scope_syntax_dynamic_cursor_enable == 0 | return | endif
  if &ft !~ 'vim' | return | endif

  if s:dynamic_timer_id != 0
    call timer_stop(s:dynamic_timer_id)
    let s:dynamic_timer_id = 0
  end

  let s:dynamic_timer_id = timer_start(g:vimscript_scope_syntax_dynamic_cursor_interval, function('s:dynamic_redraw'))
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

  " dynamic definition/references highlight
  let l:bg_code = vimscript_scope_syntax#utils#colorcode#new(l:bg_color_code).add(60, 30, 30)

  let l:warm_hi_dyn_opts = {}
  for [l:k, l:v] in items(l:warm_hi_opts)
    let l:v['guifg'] = l:v['guifg'].add(60, 30, 30)
    let l:v['guibg'] = l:bg_code.clone()
    let l:warm_hi_dyn_opts[l:k.'Dyn'] = l:v
  endfor
  call s:exe_highlight(l:warm_hi_dyn_opts)

  let l:cold_hi_dyn_opts = {}
  for [l:k, l:v] in items(l:cold_hi_opts)
    let l:v['guifg'] = l:v['guifg'].add(30, 30, 60)
    let l:v['guibg'] = l:v['guibg'].add(30, 30, 60)
    let l:cold_hi_dyn_opts[l:k.'Dyn'] = l:v
  endfor
  call s:exe_highlight(l:cold_hi_dyn_opts)
endfunction

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

" ---

function! s:dynamic_redraw(_)
  let s:dynamic_timer_id = 0
  if !vimscript_scope_syntax#lsp#vim_lsp#check_enabled() | return | endif

  " clear old matches
  for l:x in getmatches()
    if has_key(s:highlight_dynamic_names, l:x['group'])
      call matchdelete(l:x['id'])
    endif
  endfor
  let s:match_ids = []

  let l:cursor_id = synID(line('.'), col('.'), 1)
  if l:cursor_id == 0 | return | endif

  let l:cursor_hiname = synIDattr(synIDtrans(l:cursor_id), "name")
  if has_key(s:highlight_names, l:cursor_hiname)
    call vimscript_scope_syntax#lsp#vim_lsp#request_match(function('s:on_match', [l:cursor_hiname]))
  endif
endfunction

function! s:on_match(hiname, data) abort
  let l:req_uri = a:data['request']['params']['textDocument']['uri']

  for l:x in a:data['response']['result']
    if l:x['uri'] != l:req_uri
      continue
    endif

    let l:line = l:x['range']['start']['line'] + 1
    let l:num = l:x['range']['start']['character'] + 1
    let l:size = l:x['range']['end']['character'] - l:x['range']['start']['character']
    call matchaddpos(a:hiname.'Dyn', [[l:line, l:num, l:size]], 0)
  endfor
endfunction
