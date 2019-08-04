
let g:cmdbyu_dockerCarryOption = '--network host'

command! -nargs=1 CmdByURun :call cmdByU#Run(<f-args>)

