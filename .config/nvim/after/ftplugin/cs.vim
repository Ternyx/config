" %VS120COMNTOOLS% => C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\
" $COMSPEC /k $VS120COMNTOOLS."vsvars32.bat"

" Note: this file runs _before_ vim-csharp\compiler\msbuild.vim

setlocal tabstop=4 shiftwidth=4 copyindent commentstring=//\ %s

func! s:setup()
  let msbuild_ps1 = expand('<sfile>:p:h', 1).'\msbuild.ps1'
  let root = projectionist#path()
  let sln = glob(root.'/*.sln', 1)
  if strlen(sln) > 0
    let g:net_build_file = '\ /verbosity:detailed\ ' . sln 
    " exe 'CompilerSet makeprg=powershell\ -c\ '.fnameescape(msbuild_ps1).'\ -dir\ '.escape(fnameescape(root), '\').'\ {$*}'
  endif
endf

augroup ftplugin_cs
  au!
  autocmd User ProjectionistActivate call s:setup()
augroup END



if !exists("g:OmniSharp_loaded")
  " mod  T:System.IO.Path |w3m -T text/html
  " mod  T:System.IO.Path/|w3m -T text/html
  " mod  N:System.IO      |w3m -T text/html
  " mod 'M:System.Collections.ArrayList.ToArray(System.Type)'|w3m -T text/html
  if executable('mod')
    nnoremap <buffer> K :Websearch c# <C-R><C-W><CR>
  endif
else " TODO: gD OmniSharpFindType
  setlocal omnifunc=OmniSharp#Complete

  nnoremap <buffer> gd    :<c-u>OmniSharpGotoDefinition<cr>
  nnoremap <buffer> gr    :<c-u>OmniSharpFindUsages<cr>
  nnoremap <buffer> gI    :<c-u>OmniSharpFindImplementations<cr>
  nnoremap <buffer> crr   :<c-u>OmniSharpRename<cr>
  nnoremap <buffer> cpA   :<c-u>OmniSharpAddToProject<cr>
  nnoremap <buffer> cpR   :<c-u>OmniSharpReloadSolution<cr>
  nnoremap <buffer> K     :<c-u>OmniSharpDocumentation<cr>
  nnoremap <buffer> gk    :<c-u>OmniSharpTypeLookup<cr>
  nnoremap <buffer> <m-o> :<c-u>OmniSharpFindMembers<cr>
  nnoremap <buffer> <bs>  :<c-u>OmniSharpFixIssue<cr>
  nnoremap <buffer> !m    :<c-u>OmniSharpBuildAsync<cr>
  nnoremap <buffer> !e    :<c-u>OmniSharpFindSyntaxErrors<cr>

  command! -buffer Format OmniSharpCodeFormat

  augroup ftplugin_cs_omnisharp
    au!
    autocmd CursorHold <buffer> call OmniSharp#TypeLookupWithoutDocumentation()
  augroup END
endif

