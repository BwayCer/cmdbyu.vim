
let s:_dirvi = fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h')


echo 'source ~/.vimrc'
source ~/.vimrc

echo 'source ' . s:_dirvi . '/plugin/cmdByU.vim'
exec 'source ' . s:_dirvi . '/plugin/cmdByU.vim'
echo 'source ' . s:_dirvi . '/autoload/cmdByU.vim'
exec 'source ' . s:_dirvi . '/autoload/cmdByU.vim'

echo 'let g:cmdbyu_globalDirectory = ' . s:_dirvi . '/test/exampleDirectory'
let g:cmdbyu_globalDirectory = s:_dirvi . '/test/exampleDirectory'

