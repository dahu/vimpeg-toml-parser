function! TOML()
  let obj = {}
  func obj.decode(str) dict
    return tomlp#parse(a:str)
  endfunc
  return obj
endfunc
