# Intro

Vim plugin that adds a new windows modes that allow for easier navigation and
manipulation of vim windows.

 1. Focus Mode: Allows easy switching of windows focus using movement keys (hjkl).
 2. Move Mode:  Allows easily move the current focused window using movement keys (hjkl).
 3. Resize Mode: Allows easily resize the current focused window using movement keys (hjkl).
 4. Swap Mode: Allows moving the current buffer between windows using movement keys (hjkl).

# Installation

Use Vundle or Pathogen to install the plugin:

```
Bundle 'hsanson/vim-winmode'
```

# Usage

Create mappings to resize windows in your vimrc like:

```
nmap <leader>w <Plug>WinModeStart
```

or call the defined commands directly:

```
:WinModeStart
```

