function! winmode#start(mode)

  let win_mode = a:mode

  while 1

    echo s:keysMsg(win_mode)

    let c = getchar()

    if c == 115  "s
      let win_mode = "swap"
    elseif c == 119  "w
      let win_mode = "move"
    elseif c == 114  "r
      let win_mode = "resize"
    elseif c == 102  "f
      let win_mode = "focus"
    elseif c == 113 || c == 27  "q || Esc
      break
    else
      if win_mode == "focus"
        call s:focusKeys(c)
      elseif win_mode == "swap"
        call s:swapKeys(c)
      elseif win_mode == "resize"
        call s:resizeKeys(c)
      elseif win_mode == "move"
        call s:moveKeys(c)
      endif
    endif

    redraw

  endwhile

  redraw
  echo ""
endfunction

function! s:step()
  return get(g:, 'win_mode_resize_step', '5')
endfunction

function! s:verticalStep()
  return get(g:, 'win_mode_vertical_resize_step', s:step())
endfunction

function! s:horizontalStep()
  return get(g:, 'win_mode_horizontal_resize_step', s:step())
endfunction

function! s:hasBottomNeighbor()
  let oldwn = winnr()
  silent! exe "normal! \<c-w>j"
  let newwn = winnr()
  silent! exe oldwn.'wincmd w'
  return oldwn != newwn
endfunction

function! s:hasTopNeighbor()
  let oldwn = winnr()
  silent! exe "normal! \<c-w>k"
  let newwn = winnr()
  silent! exe oldwn.'wincmd w'
  return oldwn != newwn
endfunction

function! s:hasLeftNeighbor()
  let oldwn = winnr()
  silent! exe "normal! \<c-w>h"
  let newwn = winnr()
  silent! exe oldwn.'wincmd w'
  return oldwn != newwn
endfunction

function! s:hasRigthNeighbor()
  let oldwn = winnr()
  silent! exe "normal! \<c-w>l"
  let newwn = winnr()
  silent! exe oldwn.'wincmd w'
  return oldwn != newwn
endfunction

function! s:resizeUp()
  if s:hasBottomNeighbor()
    silent! exe s:resizeCommand(s:verticalStep(), '-')
  else
    silent! exe s:resizeCommand(s:verticalStep(), '+')
  endif
endfunction

function! s:resizeDown()
  if s:hasBottomNeighbor()
    silent! exe s:resizeCommand(s:verticalStep(), '+')
  else
    if s:hasTopNeighbor()
      silent! exe s:resizeCommand(s:verticalStep(), '-')
    endif
  endif
endfunction

function! s:resizeRight()
  if s:hasLeftNeighbor()
    if s:hasRigthNeighbor()
      silent! exe s:resizeCommand(s:horizontalStep(), '>')
    else
      silent! exe s:resizeCommand(s:horizontalStep(), '<')
    endif
  else
    silent! exe s:resizeCommand(s:horizontalStep(), '>')
  endif
endfunction

function! s:resizeLeft()
  if s:hasLeftNeighbor()
    if s:hasRigthNeighbor()
      silent! exe s:resizeCommand(s:horizontalStep(), '<')
    else
      silent! exe s:resizeCommand(s:horizontalStep(), '>')
    endif
  else
    silent! exe s:resizeCommand(s:horizontalStep(), '<')
  endif
endfunction

fun! s:resizeCommand(step, dir)
  return "normal! \<c-w>" . a:step . a:dir
endfun

" Swap buffer in current window to the direct window. The direct argument can
" be one of h, j, k, l
fun! s:swapTo(direct)
  let from = winnr()
  exe "wincmd " . a:direct
  let to = winnr()
  exe from . "wincmd w"

  if to != from
    call s:swapWindow(to)
  endif

endfun

fun! s:swapWindow(to)
  let curNum = winnr()
  let curBuf = bufnr( "%" )
  exe a:to . "wincmd w"
  let toBuf  = bufnr( "%" )
  exe 'hide buf' curBuf
  exe curNum . "wincmd w"
  exe 'hide buf' toBuf
  exe a:to ."wincmd w"
endfun


function! s:keysMsg(mode)
  return s:commonMsg(a:mode) . s:modeMsg(a:mode)
endfunction

function! s:commonMsg(mode)
  return '[win ' . a:mode . ' mode]'
endfunction

function! s:modeMsg(mode)
  if a:mode == 'focus'
    return s:focusMsg()
  elseif a:mode == 'swap'
    return s:swapMsg()
  elseif a:mode == 'move'
    return s:moveMsg()
  elseif a:mode == 'resize'
    return s:resizeMsg()
  endif
endfunction

function! s:focusMsg()
  return '(s:swap,w:move,r:resize,c:split,v:vsplit,x:close,q:quit)'
endfunction

function! s:moveMsg()
  return '(s:swap,f:focus,r:resize,c:split,v:vsplit,x:close,q:quit)'
endfunction

function! s:resizeMsg()
  return '(s:swap,f:focus,w:move,=:equal,q:quit)'
endfunction

function! s:swapMsg()
  return '(f:focus,w:move,r:resize,q:quit)'
endfunction

function! s:focusKeys(key)
  let c = a:key
  if c == 104      "h
    exe "normal! \<c-w>h"
  elseif c == 106  "j
    exe "normal! \<c-w>j"
  elseif c == 107  "k
    exe "normal! \<c-w>k"
  elseif c == 108  "l
    exe "normal! \<c-w>l"
  elseif c == 120  "x
    exe ":close"
  elseif c == 118  "v
    exe ":vsplit"
  elseif c == 99   "c
    exe ":split"
  endif
endfunction

function! s:swapKeys(key)
  let c = a:key
  if c == 104    "C-h
    exe ":call s:swapTo('h')"
  elseif c == 106   "C-j
    exe ":call s:swapTo('j')"
  elseif c == 107   "C-k
    exe ":call s:swapTo('k')"
  elseif c == 108   "C-l
    exe ":call s:swapTo('l')"
  endif
endfunction

function! s:resizeKeys(key)
  let c = a:key
  if c == 104
    exe ":call s:resizeLeft()"
  elseif c == 106
    exe ":call s:resizeDown()"
  elseif c == 107
    exe ":call s:resizeUp()"
  elseif c == 108
    exe ":call s:resizeRight()"
  elseif c == 61   "=
    exe "normal! \<c-w>="
  endif
endfunction

function! s:moveKeys(key)
  let c = a:key
  let oldeoa = &equalalways
  set noequalalways
  if c == 104      "h
    exe "normal! \<c-w>H"
  elseif c == 106  "j
    exe "normal! \<c-w>J"
  elseif c == 107  "k
    exe "normal! \<c-w>K"
  elseif c == 108  "l
    exe "normal! \<c-w>L"
  elseif c == 120  "x
    exe ":close"
  elseif c == 118  "v
    exe ":vsplit"
  elseif c == 99   "c
    exe ":split"
  endif
  let &equalalways = oldeoa
endfunction


