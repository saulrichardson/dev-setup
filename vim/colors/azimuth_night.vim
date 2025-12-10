" Azimuth Night Color Scheme
if version < 700
  finish
endif

set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = 'azimuth_night'

" Palette
let s:bg       = '#2a1a2e'
let s:fg       = '#f2e9e1'
let s:comment  = '#ffb7c5'
let s:purple   = '#c381c3'
let s:cyan     = '#66d9ef'
let s:magenta  = '#ff66cc'
let s:orange   = '#ff9f43'
let s:green    = '#8bfd4b'
let s:grey     = '#888888'

function! s:hi(group, fg, bg, attr) abort
  let l:cmd = 'hi ' . a:group
  if !empty(a:fg)
    let l:cmd .= ' guifg=' . a:fg
  endif
  if !empty(a:bg)
    let l:cmd .= ' guibg=' . a:bg
  endif
  if !empty(a:attr)
    let l:cmd .= ' gui=' . a:attr
  endif
  execute l:cmd
endfunction

" Core UI
call s:hi('Normal',       s:fg,   s:bg,   '')
call s:hi('CursorLine',   '',     '#3e2143', '')
call s:hi('LineNr',       s:grey, s:bg,   '')
call s:hi('CursorLineNr', s:green,s:bg,   'bold')

" Syntax
call s:hi('Comment',      s:comment,'','italic')
call s:hi('Constant',     s:purple,'','')
call s:hi('Identifier',   s:cyan,'','')
call s:hi('Statement',    s:magenta,'','')
call s:hi('PreProc',      s:orange,'','')
call s:hi('Type',         s:green,'','')
call s:hi('Special',      s:orange,'','')
call s:hi('Underlined',   s:cyan,'','underline')
call s:hi('Ignore',       s:grey,'','')
call s:hi('Error',        '#ff5555','', 'bold')
call s:hi('Todo',         '#50fa7b','', 'bold')

" Modes
call s:hi('Visual',       '', '#5b3e6f','')

" Statusline & UI bits
call s:hi('StatusLine',   s:fg, '#222133','')
call s:hi('StatusLineNC', s:grey, '#1c1522','')
call s:hi('Pmenu',        s:fg, '#3e2143','')
call s:hi('PmenuSel',     s:fg, '#5b3e6f','')
call s:hi('VertSplit',    '#3e2143', s:bg, '')
call s:hi('Directory',    s:cyan, '', '')
call s:hi('Search',       s:bg, '#ff9f43', '')
call s:hi('IncSearch',    s:bg, '#ff66cc', '')
call s:hi('MatchParen',   s:bg, '#ff9f43', 'bold')
