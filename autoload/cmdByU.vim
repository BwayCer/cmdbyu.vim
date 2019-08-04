
" 以反斜線編碼文字中的引號
" GitHub BwayCer/bway.vim/autoload/bway/utils.vim
function! s:safeQuote(path)
    return substitute(a:path, '"', '\\\"', 'g')
endfunction


" 執行文件路徑
let s:shFilePath = '.vimcode/cmdbyu.sh'

" 查找擁有執行文件的目錄
function! s:findMainDirectory(fileAbsolutePath)
    let l:cmdTxt = 'tmpDir=`realpath "' . s:safeQuote(a:fileAbsolutePath) . '"`;'
        \ . ' while [ -n "y" ]; do'
        \ .   ' tmpConfigDefaultPath="$tmpDir/' . s:shFilePath . '";'
        \ .   ' tmpNextDir=`dirname "$tmpDir"`;'
        \ .   ' if [ -f "$tmpConfigDefaultPath" ]; then'
        \ .     ' echo -n "$tmpDir";'
        \ .     ' break;'
        \ .   ' elif [ "$tmpNextDir" == "/home" ] || [ "$tmpNextDir" == "/" ]; then'
        \ .     ' break;'
        \ .   ' fi;'
        \ .   ' tmpDir=$tmpNextDir;'
        \ . ' done'
    return system(l:cmdTxt)
endfunction

" 取得運行命令程式碼
" @param {Number} isUseDocker - 0 or 1。
function! s:getRunCmdTxt(mainDirectory, fileAbsolutePath, fileExt, method, isUseDocker)
    let l:safeMainDirectory = s:safeQuote(a:mainDirectory)
    return 'sh "' . l:safeMainDirectory . '/' . s:shFilePath . '"'
        \ . ' "' . s:safeQuote(a:method) . '"'
        \ . ' "' . s:safeQuote(a:fileAbsolutePath) . '"'
        \ . ' ".' . s:safeQuote(a:fileExt) . '"'
        \ . ' "' . l:safeMainDirectory . '"'
        \ . ' "' . (a:isUseDocker == 1? 'inDocker' : 'unDocker') . '"'
endfunction


" 將標準輸出覆寫到文件上
function! cmdByU#Overwrite(cmdTxt)
    let &formatprg = a:cmdTxt
    normal! ggVGgq
endfunction

" 將標準輸出寫到 quickfix-window 窗格
function! cmdByU#ShowMsg(cmdTxt)
    let &makeprg = a:cmdTxt
    make
    copen
endfunction


" 執行命令
function! cmdByU#Run(method)
    let l:fileAbsolutePath = expand('%:p')
    let l:mainDirectory = s:findMainDirectory(l:fileAbsolutePath)

    if l:mainDirectory == ''
        throw '找不到擁有 .vimcode/cmdByU.sh 的目錄'
    endif

    let l:cmdTxt = s:getRunCmdTxt(l:mainDirectory, l:fileAbsolutePath,
        \ expand('%:e'), a:method, 0)
    if a:method =~# '^format\([A-Z].*\)\?$'
        " 執行格式化命令
        call cmdByU#Overwrite(l:cmdTxt)
    elseif a:method =~# '^syntax\([A-Z].*\)\?$'
        " 執行檢查語法命令
        call cmdByU#ShowMsg(l:cmdTxt)
    else
        exec '!' . l:cmdTxt
    endif
endfunction

" TODO run with docker

