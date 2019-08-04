
let g:cmdbyu_globalShFilePath = '~/.vimcode/cmdbyu.sh'
let g:cmdbyu_dockerCarryOption = '--network host'

command! -nargs=* CmdByURun     :call cmdByU#Run(<f-args>)
command! -nargs=* CmdByUHostRun :call cmdByU#HostRun(<f-args>)

