if exists('g:vimscript_scope_syntax_loaded')
  finish
endif
let g:vimscript_scope_syntax_loaded = 1

let g:vimscript_scope_syntax_assign_operator = get(g:, 'vimscript_scope_syntax_assign_operator', 1)

" FIXME: typo, deprecated
let g:vimscript_auto_enable = get(g:, 'vimscript_auto_enable', has('gui_running') || (has('termguicolors') && &termguicolors))

let g:vimscript_scope_syntax_auto_enable = get(g:, 'vimscript_scope_syntax_auto_enable', g:vimscript_auto_enable)
if g:vimscript_scope_syntax_auto_enable
  augroup vimscript_auto_enable
    autocmd!
    autocmd BufNewFile,BufReadPost *.vim call vimscript_scope_syntax#hilightLazy()
    autocmd ColorScheme * call vimscript_scope_syntax#hilightLazy()
  augroup END
endif
