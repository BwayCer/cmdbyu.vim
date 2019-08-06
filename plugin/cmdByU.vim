

let g:cmdbyu_getVar_conf = {}
let g:cmdbyu_getVar_conf.globalShFilePath = '~/.vimcode/cmdbyu.sh'
let g:cmdbyu_getVar_conf.dockerCarryOption = '--network host'

command! -nargs=* CmdByURun     :call cmdByU#Run(<f-args>)
command! -nargs=* CmdByUHostRun :call cmdByU#HostRun(<f-args>)

