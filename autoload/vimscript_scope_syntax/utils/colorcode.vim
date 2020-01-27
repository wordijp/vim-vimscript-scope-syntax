let s:ColorCode = {}

function! vimscript_scope_syntax#utils#colorcode#new(color_code) abort
  let l:inst = deepcopy(s:ColorCode)
  
  let l:inst.r = str2nr(a:color_code[1:2], 16)
  let l:inst.g = str2nr(a:color_code[3:4], 16)
  let l:inst.b = str2nr(a:color_code[5:6], 16)

  return l:inst
endfunction

function! s:ColorCode.clone()
  return deepcopy(self)
endfunction

function! s:ColorCode.add(v, ...)
  let l:vr = a:v
  let l:vg = get(a:, 1, a:v)
  let l:vb = get(a:, 2, a:v)
  let self.r = s:clamp(self.r + l:vr, 0, 255)
  let self.g = s:clamp(self.g + l:vg, 0, 255)
  let self.b = s:clamp(self.b + l:vb, 0, 255)

  return self
endfunction

function! s:ColorCode.mul(s, ...)
  let l:sr = a:s
  let l:sg = get(a:, 1, a:s)
  let l:sb = get(a:, 2, a:s)
  let self.r = s:clamp(float2nr(self.r * l:sr), 0, 255)
  let self.g = s:clamp(float2nr(self.g * l:sg), 0, 255)
  let self.b = s:clamp(float2nr(self.b * l:sb), 0, 255)
  
  return self
endfunction

function! s:ColorCode.str()
  return printf('#%02x%02x%02x', self.r, self.g, self.b)
endfunction

" ---

function! s:clamp(value, min, max)
  if a:value < a:min | return a:min | endif
  if a:value > a:max | return a:max | endif
  return a:value
endfunction
