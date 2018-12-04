let s:Promise = vital#amake#import('Async.Promise')

function! amake#hello_world() abort
  echo "Hello World"commit
endfunction

function! amake#fizzbuzz() abort
  for i in range(1, 100)
    call s:judge_fizzbuzz(i)
  endfor
endfunction

function! amake#async_fizzbuzz() abort
  let promises = []
  for i in range(1, 100)
    let p = s:Promise.new({resolve -> resolve(s:judge_fizzbuzz(i))})
    call add(promises, p)
  endfor
  call s:Promise.all(promises)
        \.then({-> execute('echom "All promises were successfuly done"', '')})
        \.catch({err -> execute('echom "Failed: " . err', '')})
endfunction

function! s:judge_fizzbuzz(i) abort
    if a:i % 15 == 0
      echo "FizzBuzz"
    elseif a:i % 3 == 0
      echo "Fizz"
    elseif a:i % 5 == 0
      echo "Buzz"
    else
      echo a:i
    endif
endfunction

function! amake#eslint()
  let result = split(system('yarn eslint ' . bufname("")), '\n')
  echo result
  let error_list = []
  for r in result
    echo matchlist(r, '\v(\d+):(\d+)', 1)
  endfor
  echo error_list
  if empty(error_list)
    call clearmatches()
    echo "No error"
    return
  endif
  call matchaddpos("Error", [str2nr(error_list[1])])
endfunction

autocmd! BufWritePost *.js :call amake#eslint()

function! amake#run(opener) abort
  let runner = amake#runner#new(&filetype)
  let result = amake#runner#run(runner, expand('%:p'))
  let bufname = printf('amake://%s', join(result.args, ' '))
  let options = {
        \ 'opener': empty(a:opener) ? 'new' : a:opener,
        \}
  let Open = { c -> amake#buffer#new(bufname, c, options) }
  call result
        \.then({ v -> Open(v.stdout) })
        \.catch({ v -> Open(v.stdout + [''] + v.strerr) })
endfunction
