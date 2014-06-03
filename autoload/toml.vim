" Parser compiled on Fri 02 May 2014 08:14:53 PM CST,
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
" tomldoc    ::= skip* ((key_table | key_group | key_value) skip+)+ skip* eof
" key_table  ::= '[' '[' key_name ']' ']'                                -> #key_table
" key_group  ::= '[' key_name ']'                                        -> #key_group
" key_name   ::= identifier ( '\.' identifier )*                         -> #key_name
" identifier ::= '\$\?[a-zA-Z]\w*\%(?\|!\|#\)\?'
" key_value  ::= identifier s '=' s value                                -> #key_value
" value      ::= primitive | array
" primitive  ::= float | datetime | boolean | integer | string
" float      ::= '\%(+\|-\)\?[0-9]\+\.[0-9]\+'                           -> #float
" datetime   ::= date 'T' time 'Z'                                       -> #datetime
" date       ::= '[0-9]\{4}-[0-9]\{2}-[0-9]\{2}'
" time       ::= '[0-9]\{2}:[0-9]\{2}:[0-9]\{2}'
" boolean    ::= 'true\|false'
" integer    ::= '\%(+\|-\)\?[0-9]\+'                                    -> #integer
" string     ::= '"\%(\\.\|[^\\"]\)\{-}"'                                -> #string
" array      ::= skip* '[' skip* value (skip* ',' skip* value)* skip* ','? skip* ']' -> #array
" skip       ::= ('\_s' | c)
" c          ::= '#.\{-}\n'                                              -> #comment
" s          ::= '\s*'
" eof        ::= !'.'
" 
" ;as         ::= '\s*\%(\_s*#.\{-}\n\)*\_s*'                            -> #comment
" ;; as         ::= (n+ '#' (!'\n' '.')*)* n*                            -> #comment
" ;; n          ::= '\_s'
" ;; eof        ::= !'.'

let s:p = vimpeg#parser({'root_element': 'tomldoc', 'skip_white': 0, 'parser_name': 'toml', 'namespace': 'tomlp'})
call s:p.and([s:p.maybe_many('skip'), s:p.many(s:p.and([s:p.or(['key_table', 'key_group', 'key_value']), s:p.many('skip')])), s:p.maybe_many('skip'), 'eof'],
      \{'id': 'tomldoc'})
call s:p.and([s:p.e('['), s:p.e('['), 'key_name', s:p.e(']'), s:p.e(']')],
      \{'id': 'key_table', 'on_match': 'tomlp#key_table'})
call s:p.and([s:p.e('['), 'key_name', s:p.e(']')],
      \{'id': 'key_group', 'on_match': 'tomlp#key_group'})
call s:p.and(['identifier', s:p.maybe_many(s:p.and([s:p.e('\.'), 'identifier']))],
      \{'id': 'key_name', 'on_match': 'tomlp#key_name'})
call s:p.e('\$\?[a-zA-Z]\w*\%(?\|!\|#\)\?',
      \{'id': 'identifier'})
call s:p.and(['identifier', 's', s:p.e('='), 's', 'value'],
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
call s:p.and([s:p.maybe_many('skip'), s:p.e('['), s:p.maybe_many('skip'), 'value', s:p.maybe_many(s:p.and([s:p.maybe_many('skip'), s:p.e(','), s:p.maybe_many('skip'), 'value'])), s:p.maybe_many('skip'), s:p.maybe_one(s:p.e(',')), s:p.maybe_many('skip'), s:p.e(']')],
      \{'id': 'array', 'on_match': 'tomlp#array'})
call s:p.or([s:p.e('\_s'), 'c'],
      \{'id': 'skip'})
call s:p.e('#.\{-}\n',
      \{'id': 'c', 'on_match': 'tomlp#comment'})
call s:p.e('\s*',
      \{'id': 's'})
call s:p.not_has(s:p.e('.'),
      \{'id': 'eof'})

let g:toml = s:p.GetSym('tomldoc')
function! toml#parse(in)
  return g:toml.match(a:in)
endfunction
function! toml#parser()
  return deepcopy(g:toml)
endfunction
