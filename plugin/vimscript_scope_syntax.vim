if exists('g:vimscript_scope_syntax_loaded')
  finish
endif
let g:vimscript_scope_syntax_loaded = 1

let g:vimscript_auto_enable = get(g:, 'vimscript_auto_enable', 1)
if g:vimscript_auto_enable
  augroup vimscript_auto_enable
    autocmd!
    autocmd BufNewFile,BufReadPost *.vim call vimscript_scope_syntax#hilightLazy()
    autocmd ColorScheme * call vimscript_scope_syntax#hilightLazy()
  augroup END
endif
