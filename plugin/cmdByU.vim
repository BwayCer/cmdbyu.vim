
let g:cmdbyu_getVar_conf = {}
" 對 Vim Script 而言，`~` 必須使用 fnamemodify('~', ':p') 取絕對路徑
let g:cmdbyu_getVar_conf.globalDirectory = fnamemodify('~', ':p')
let g:cmdbyu_getVar_conf.dockerCommand
    \ = 'docker run --rm {volume} local/vimcmdbyu {shCmd}'

command! -nargs=* CmdByURun     :call cmdByU#Run(<f-args>)
command! -nargs=* CmdByUHostRun :call cmdByU#HostRun(<f-args>)

