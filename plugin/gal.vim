let s:galson = {}

let s:seed = 0
function! s:srand(seed)
  let s:seed = a:seed
endfunction

function! s:rand()
  let s:seed = s:seed * 214013 + 2531011
  return (s:seed < 0 ? s:seed - 0x80000000 : s:seed) / 0x10000 % 0x8000
endfunction

function! s:gal()
  let r = has_key(s:galson, v:char) ? s:galson[v:char] : [v:char]
  let l = len(r)
  return l ? r[s:rand() % l] : v:char
endfunction

let s:file = expand('<sfile>:h').'/gal.json'
function! s:gal_on()
  let s:galson = webapi#json#decode(join(readfile(s:file), "\n"))
  call s:srand(localtime())
  augroup Gal
    au!
    autocmd InsertCharPre <buffer> let v:char = s:gal()
  augroup END
endfunction

function! s:gal_off()
  call s:srand(localtime())
  augroup Gal
    au!
  augroup END
endfunction

command! -nargs=0 GalOn call s:gal_on()
command! -nargs=0 GalOff call s:gal_off()
