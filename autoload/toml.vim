" Parser compiled on Mon 21 Apr 2014 06:55:03 AM CST,
" with VimPEG v0.2 and VimPEG Compiler v0.1
" from "toml.vimpeg"
" with the following grammar:

" ; TOML
" ; Barry Arthur, 2014 04 19
" 
" .skip_white   = false
" .namespace    = 'tomlp'
" .parser_name  = 'toml'
" .root_element = 'tomldoc'
" 
" tomldoc    ::= (as ( key_group | key_value ))+
" key_group  ::= '[' key_name ']'                                 -> #key_group
" key_name   ::= identifier ( '\.' identifier )*                    -> #key_name
" identifier ::= '\$\?[a-zA-Z][a-zA-Z0-9_]*\%(?\|!\|#\)\?'
" key_value  ::= identifier s '=' as value                 -> #key_value
" value      ::= primitive | array
" primitive  ::= float | datetime | boolean | integer | string
" float      ::= '\%(+\|-\)\?[0-9]\+\.[0-9]\+'                      -> #float
" datetime   ::= date 'T' time 'Z'                                  -> #datetime
" date       ::= '[0-9]\{4}-[0-9]\{2}-[0-9]\{2}'
" time       ::= '[0-9]\{2}:[0-9]\{2}:[0-9]\{2}'
" boolean    ::= 'true\|false'
" integer    ::= '\%(+\|-\)\?[0-9]\+'                               -> #integer
" string     ::= '"\%(\\.\|[^\\"]\)\{-}"'                           -> #string
" array      ::= as '[' as value ( as ',' as value )* as ','? as ']' as -> #array
" as         ::= s '#.\{-}\n'? '\_s*'                             -> #comment
" s          ::= '\s*'

let s:p = vimpeg#parser({'root_element': 'tomldoc', 'skip_white': 0, 'parser_name': 'toml', 'namespace': 'tomlp'})
call s:p.many(s:p.and(['as', s:p.or(['key_group', 'key_value'])]),
      \{'id': 'tomldoc'})
call s:p.and([s:p.e('['), 'key_name', s:p.e(']')],
      \{'id': 'key_group', 'on_match': 'tomlp#key_group'})
call s:p.and(['identifier', s:p.maybe_many(s:p.and([s:p.e('\.'), 'identifier']))],
      \{'id': 'key_name', 'on_match': 'tomlp#key_name'})
call s:p.e('\$\?[a-zA-Z][a-zA-Z0-9_]*\%(?\|!\|#\)\?',
      \{'id': 'identifier'})
call s:p.and(['identifier', 's', s:p.e('='), 'as', 'value'],
      \{'id': 'key_value', 'on_match': 'tomlp#key_value'})
call s:p.or(['primitive', 'array'],
      \{'id': 'value'})
call s:p.or(['float', 'datetime', 'boolean', 'integer', 'string'],
      \{'id': 'primitive'})
call s:p.e('\%(+\|-\)\?[0-9]\+\.[0-9]\+',
      \{'id': 'float', 'on_match': 'tomlp#float'})
call s:p.and(['date', s:p.e('T'), 'time', s:p.e('Z')],
      \{'id': 'datetime', 'on_match': 'tomlp#datetime'})
call s:p.e('[0-9]\{4}-[0-9]\{2}-[0-9]\{2}',
      \{'id': 'date'})
call s:p.e('[0-9]\{2}:[0-9]\{2}:[0-9]\{2}',
      \{'id': 'time'})
call s:p.e('true\|false',
      \{'id': 'boolean'})
call s:p.e('\%(+\|-\)\?[0-9]\+',
      \{'id': 'integer', 'on_match': 'tomlp#integer'})
call s:p.e('"\%(\\.\|[^\\"]\)\{-}"',
      \{'id': 'string', 'on_match': 'tomlp#string'})
call s:p.and(['as', s:p.e('['), 'as', 'value', s:p.maybe_many(s:p.and(['as', s:p.e(','), 'as', 'value'])), 'as', s:p.maybe_one(s:p.e(',')), 'as', s:p.e(']'), 'as'],
      \{'id': 'array', 'on_match': 'tomlp#array'})
call s:p.and(['s', s:p.maybe_one(s:p.e('#.\{-}\n')), s:p.e('\_s*')],
      \{'id': 'as', 'on_match': 'tomlp#comment'})
call s:p.e('\s*',
      \{'id': 's'})

let g:toml = s:p.GetSym('tomldoc')
function! toml#parse(in)
  return g:toml.match(a:in)
endfunction
function! toml#parser()
  return deepcopy(g:toml)
endfunction
