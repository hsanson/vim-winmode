"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin that add new winmode to vim for easier window navigation and
" manipulation.
"

if exists("g:loaded_win_mode_plugin")
  finish
endif

let g:loaded_win_mode_plugin=1

let g:win_mode_default = get(g:, 'win_mode_default', 'focus')

command! WinModeStart call winmode#start(g:win_mode_default)
command! WinModeFocusStart call winmode#start("focus")
command! WinModeResizeStart call winmode#start("resize")
command! WinModeSwapStart call winmode#start("swap")
command! WinModeMoveStart call winmode#start("move")

noremap <unique> <Plug>WinModeStart :call winmode#start(g:win_mode_default)<CR>
noremap <unique> <Plug>WinModeFocusStart :call winmode#start("focus")<CR>
noremap <unique> <Plug>WinModeResizeStart :call winmode#start("resize")<CR>
noremap <unique> <Plug>WinModeSwapStart :call winmode#start("swap")<CR>
noremap <unique> <Plug>WinModeMoveStart :call winmode#start("move")<CR>
