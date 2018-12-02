function! amake#hello_world() abort
  echo "Hello World"
endfunction

function! amake#run() abort
  let runner = amake#runner#new(&filetype)
  let result = amake#runner#run(runner, expand('%:p'))
  let bufname = printf('amake://%s', join(result.args, ' '))
  call amake#buffer#new(bufname, result.output)
endfunction
