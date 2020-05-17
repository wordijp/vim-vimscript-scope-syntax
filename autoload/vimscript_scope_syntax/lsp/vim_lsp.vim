function! vimscript_scope_syntax#lsp#vim_lsp#check_enabled() abort
  return exists('*lsp#send_request')
    && exists('*lsp#get_whitelisted_servers')
    && exists('*lsp#get_text_document_identifier')
    && exists('*lsp#get_position')
    && execute(':LspStatus') =~ 'running'
endfunction

function! vimscript_scope_syntax#lsp#vim_lsp#request_match(callback) abort
  call s:lsp_definition(a:callback)
  call s:lsp_references(a:callback)
endfunction

" see) https://github.com/prabirshrestha/vim-lsp

function! s:lsp_definition(callback) abort
  call s:list_location('definition', a:callback)
endfunction
function! s:lsp_references(callback) abort
  let l:request_params = { 'context': { 'includeDeclaration': v:false } }
  call s:list_location('references', a:callback, l:request_params)
endfunction
  
function! s:list_location(method, callback, ...) abort
    " typeDefinition => type definition
    let l:operation = substitute(a:method, '\u', ' \l\0', 'g')

    let l:capabilities_func = printf('lsp#capabilities#has_%s_provider(v:val)', substitute(l:operation, ' ', '_', 'g'))
    let l:servers = filter(lsp#get_whitelisted_servers(), l:capabilities_func)

    if len(l:servers) == 0
        return
    endif

    let l:params = {
        \   'textDocument': lsp#get_text_document_identifier(),
        \   'position': lsp#get_position(),
        \ }
    if a:0
        call extend(l:params, a:1)
    endif

    for l:server in l:servers
        call lsp#send_request(l:server, {
            \ 'method': 'textDocument/' . a:method,
            \ 'params': l:params,
            \ 'on_notification': a:callback,
            \ })
    endfor
endfunction
