scriptencoding utf-8

" Position of cursor relative to screen cell
function! coc#cursor#screen_pos() abort
  let nr = winnr()
  let [row, col] = win_screenpos(nr)
  return [row + winline() - 2, col + wincol() - 2]
endfunction

function! coc#cursor#move_by_col(delta)
  let pos = getcurpos()
  call cursor(pos[1], pos[2] + a:delta)
endfunction

" Get cursor position.
function! coc#cursor#position()
  let line = getline('.')
  return [line('.') - 1, coc#string#character_index(line, col('.') - 1)]
endfunction

" Move cursor to position.
function! coc#cursor#move_to(line, character) abort
  let content = getline(a:line + 1)
  call cursor(a:line + 1, coc#string#byte_index(content, a:character) + 1)
endfunction

" Character offset of current cursor, vim provide bytes offset only.
function! coc#cursor#char_offset() abort
  let offset = 0
  let lnum = line('.')
  for i in range(1, lnum)
    if i == lnum
      let offset += strchars(strpart(getline('.'), 0, col('.')-1))
    else
      let offset += strchars(getline(i)) + 1
    endif
  endfor
  return offset
endfunction

" Returns latest selection range
function! coc#cursor#get_selection(char) abort
  let m = a:char ? 'char' : visualmode()
  if empty(m)
    return v:null
  endif
  let [_, sl, sc, soff] = getpos(m ==# 'char' ? "'[" : "'<")
  let [_, el, ec, eoff] = getpos(m ==# 'char' ? "']" : "'>")
  let start_idx = coc#string#character_index(getline(sl), sc - 1)
  if m ==# 'V'
    return [sl - 1, start_idx, el, 0]
  endif
  let line = getline(el)
  let end_idx = coc#string#character_index(line, ec - 1)
  if m !=# 'char'
    if &selection ==# 'exclusive' && !(sl == el && start_idx == end_idx)
      let end_idx = end_idx - 1
    endif
    let end_idx = end_idx == coc#string#character_length(line) ? end_idx : end_idx + 1
  endif
  return [sl - 1, start_idx, el - 1, end_idx]
endfunction
