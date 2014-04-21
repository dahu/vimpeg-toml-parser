function! TOML()
  let obj = {}
  func obj.decode(str) dict
    return tomlp#parse(a:str)
  endfunc
  func obj.debug(str) dict
    " tomlp != toml
    return toml#parse(a:str)
  endfunc
  return obj
endfunc
