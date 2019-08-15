
let s:_dirvi = fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h')

exec 'source ~/.vimrc'

exec 'source ' . s:_dirvi . '/plugin/cmdByU.vim'
exec 'source ' . s:_dirvi . '/autoload/cmdByU.vim'

