let s:_dirvi = fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h')

set nocompatible
set number
source ~/.vimrc


exec 'source ' . s:_dirvi . '/plugin/cmdByU.vim'
exec 'source ' . s:_dirvi . '/autoload/cmdByU.vim'

let g:cmdbyu_globalShFilePath = s:_dirvi . '/test/exampleDirectory/.vimcode/cmdbyu.sh'

