let s:save_cpo = &cpo
set cpo&vim

let s:termal_terminals = []

if has('nvim')
  let s:terminal_open_command = 'keepalt terminal'
else
  let s:terminal_open_command = 'keepalt terminal ++curwin'
endif

" {{{ termal#open
function! termal#open() abort
  let winid = win_getid()

  " default: bottom, 12
  let buf_open_cmd = ['botright', 12, 'split']
  let termal_dir = get(g:, 'termal_default_dir')
  if termal_dir == 'bottom'
    let buf_open_cmd[0] = 'botright'
    let buf_open_cmd[2] = 'split'
  elseif termal_dir == 'right'
    let buf_open_cmd[0] = 'botright'
    let buf_open_cmd[2] = 'vsplit'
  elseif termal_dir == 'top'
    let buf_open_cmd[0] = 'topleft'
    let buf_open_cmd[2] = 'split'
  elseif termal_dir == 'left'
    let buf_open_cmd[0] = 'topleft'
    let buf_open_cmd[2] = 'vsplit'
  endif

  let termal_size = get(g:, 'termal_default_size')
  if termal_size =~ '^[1-9]\+\d*$' && termal_size > 3
    let buf_open_cmd[1] = termal_size
  end

  execute join(buf_open_cmd, ' ')
  execute s:terminal_open_command
  stopinsert
  setlocal nonumber norelativenumber
  normal! G
  let bufnr = bufnr()
  let title = bufnr .. '%' .. &shell
  if has('nvim')
    let b:term_title = title
  endif
  call add(s:termal_terminals, {
    \   'job_id': get(b:, 'terminal_job_id'),
    \   'bufnr': bufnr,
    \   'title': title
    \ })
  execute 'autocmd BufDelete <buffer> call s:remove_from_termal_list(' .. bufnr .. ')'
  call win_gotoid(winid)
endfunction
" }}}

" {{{ s:remove_from_termal_list
function! s:remove_from_termal_list(bufnr) abort
for idx in range(len(s:termal_terminals))
  if s:termal_terminals[idx].bufnr == a:bufnr
    unlet s:termal_terminals[idx]
    break
  endif
endfor
endfunction
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
