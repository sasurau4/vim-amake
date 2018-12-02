let s:Buffer = vital#amake#import('Vim.Buffer')

function! amake#buffer#new(bufname, content, opener) abort
  call s:Buffer.open(a:bufname, {
        \ 'opener': a:opener
        \})
  setlocal modifiable
  silent %delete _
  call setline(1, a:content)
  setlocal nomodified nomodifiable
  setlocal buftype=nofile bufhidden=wipe
endfunction
