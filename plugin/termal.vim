if exists('g:loaded_termal')
  finish
endif
let g:loaded_termal = 1

let s:save_cpo = &cpo
set cpo&vim

command! TermalOpen call termal#open()

let &cpo = s:save_cpo
unlet s:save_cpo
