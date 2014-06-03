function! tomlp#parse(str)
  let s:obj = {}
  let s:current = s:obj
  call toml#parse(a:str)
  return deepcopy(s:obj)
endfunction

function! tomlp#key_table(expr)
  echom 'key_table: ' . string(a:expr ) . ', obj=' . string(s:obj)
  let s:current = s:obj
  for group in a:expr[2]
      echom 'que'
    " need to know if s:current is a hash or list
    if ! has_key(s:current, group)
      echom 'xxx'
      let s:current[group] = []
    else
      echom 'wtf>!'
    endif
    let x = s:current
    unlet s:current
    let s:current = x[group]
  endfor
  return a:expr[2]
endfunction

function! tomlp#key_group(expr)
  let s:current = s:obj
  for group in a:expr[1]
    if ! has_key(s:current, group)
      let s:current[group] = {}
    endif
    let s:current = s:current[group]
  endfor
  return a:expr[1]
endfunction

function! tomlp#key_name(expr)
  let keys = extend([a:expr[0]], map(a:expr[1], 'v:val[1]'))
  return keys
endfunction

function! tomlp#key_value(expr)
  if type(s:current) == type({})
    call extend(s:current, {a:expr[0] : a:expr[4]})
  elseif type(s:current) == type([])
    call extend(s:current, [{a:expr[0] : a:expr[4]}])
    let x = s:current
    unlet s:current
    let s:current = x[-1]
  else
    echo "key_value: unexpected type(s:current) => " . type(s:current)
  endif
  echom string(s:current)
  return {a:expr[0] : a:expr[4]}
endfunction

function! tomlp#float(expr)
  return str2float(a:expr)
endfunction

function! tomlp#datetime(expr)
  return [a:expr[0], a:expr[2]]
endfunction

function! tomlp#integer(expr)
  return str2nr(a:expr)
endfunction

function! tomlp#string(expr)
  return a:expr[1:-2]
endfunction

function! tomlp#array(expr)
  return extend([a:expr[3]], map(a:expr[4], 'v:val[-1]'))
endfunction

function! tomlp#comment(expr)
  return []
endfunction
