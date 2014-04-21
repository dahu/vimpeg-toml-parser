let &rtp = expand('<sfile>:p:h:h') . ',' . &rtp . ',' . expand('<sfile>:p:h:h') . '/after'

runtime autoload/vimpeg.vim
runtime plugin/toml.vim

function! OK(test)
  call vimtap#Ok(a:test, string(a:test), string(a:test))
endfunction
