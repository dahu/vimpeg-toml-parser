call vimtest#StartTap()
call vimtap#Plan(1) " <== XXX  Keep plan number updated.  XXX

source easy_example.viml
let easy_example_toml = join(readfile('easy_example.toml'), "\n")
let easy_decoded = TOML().decode(easy_example_toml)
echom string(sort(items(easy_example_viml)))
echom string(sort(items(easy_decoded)))
call OK(easy_decoded == easy_example_viml)

call vimtest#Quit()
