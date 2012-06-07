let s:galson = {}

let s:seed = 0
function! s:srand(seed)
  let s:seed = a:seed
endfunction

function! s:rand()
  let s:seed = s:seed * 214013 + 2531011
  return (s:seed < 0 ? s:seed - 0x80000000 : s:seed) / 0x10000 % 0x8000
endfunction

function! s:gal(v)
  let r = has_key(s:galson, a:v) ? s:galson[a:v] : [a:v]
  let l = len(r)
  return l ? r[s:rand() % l] : a:v
endfunction

function! s:gal_load()
  if empty(s:galson)
    let s:galson = webapi#json#decode(join(readfile(s:file), "\n"))
  endif
endfunction

let s:file = expand('<sfile>:h').'/gal.json'
function! s:gal_on()
  call s:gal_load()
  call s:srand(localtime())
  augroup Gal
    au!
    autocmd InsertCharPre <buffer> let v:char = s:gal(v:char)
  augroup END
endfunction

function! s:gal_off()
  augroup Gal
    au!
  augroup END
endfunction

function! s:gal_replace() range
  call s:gal_load()
  for n in range(a:firstline, a:lastline)
    call setline(n, join(map(split(getline(n), '\zs'), 's:gal(v:val)'), ''))
  endfor
endfunction

command! -nargs=0 GalOn call s:gal_on()
command! -nargs=0 GalOff call s:gal_off()
command! -nargs=0 -range GalReplace <line1>,<line2>call s:gal_replace()
