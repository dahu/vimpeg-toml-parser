call vimtest#StartTap()
call vimtap#Plan(7) " <== XXX  Keep plan number updated.  XXX

function! OK(test)
  call vimtap#Ok(a:test, string(a:test), string(a:test))
endfunction

"comments
call OK(TOML().decode("# comment") == {})
call OK(TOML().decode("# comment\nname = \"value\"") == {'name': 'value'})

" embedded newline in key_value
call OK(TOML().decode("name = #special\n  \"value\"") == {'name': 'value'})

" primitives
call OK(TOML().decode("float = 0.001") == {'float': 0.001})
call OK(TOML().decode("datetime = 1977-07-08T19:23:00Z") == {'datetime': ['1977-07-08','19:23:00']})

call OK(TOML().decode("bool = true") == {'bool': 'true'})
call OK(TOML().decode("bool = false") == {'bool': 'false'})
call OK(TOML().decode("age = 100") == {'age': 100})
call OK(TOML().decode("name = \"bob\"") == {'name': 'bob'})

" tables
call OK(TOML().decode("[name]") == {'name': {}})
call OK(TOML().decode("[foo.bar]") == {'foo': {'bar': {}}})
call OK(TOML().decode("[one.two.three]") == {'one': {'two': {'three': {}}}})

call OK(TOML().decode('name = "bob"') == {'name': 'bob'})
call OK(TOML().decode("[person] \n name = \"bob\"") == {'person': {'name': 'bob'}})
call OK(TOML().decode("[person.bob] \n age = 20") == {'person': {'bob': {'age': 20}}})
call OK(TOML().decode("[person.bob.details] \n wage = 2000") == {'person': {'bob': {'details': {'wage': 2000}}}})

" arrays
call OK(TOML().decode("ports = [ 8001, 8002 , 8003 ]") == {'ports': [8001, 8002, 8003]})
call OK(TOML().decode("ports = [ 8001\n,\n 8002\n , 8003\n ]") == {'ports': [8001, 8002, 8003]})
call OK(TOML().decode("ports = [\n 8001\n,\n 8002\n , \n 8003\n\n ]") == {'ports': [8001, 8002, 8003]})
call OK(TOML().decode("ports = [\n8001,\n8002,\n8003\n  ]\n") == {'ports': [8001, 8002, 8003]})

call vimtest#Quit()
