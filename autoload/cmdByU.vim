
" 以反斜線編碼文字中的引號
" GitHub BwayCer/bway.vim/autoload/bway/utils.vim
function! s:safeQuote(path)
    return substitute(a:path, '"', '\\\"', 'g')
endfunction

" 取得設定變數值
" GitHub BwayCer/bway.vim/autoload/bway/utils.vim
function! s:getVar(name)
    let l:result = get(g:, 'cmdbyu_' . a:name)
    if !empty(l:result) " or l:result != '0'
        return l:result
    endif
    return get(g:cmdbyu_getVar_conf, a:name, 0)
endfunction


" cmdByU.vim 的執行文件路徑
let s:shFilePathPart = '.vimcode/cmdbyu.sh'
" 容器名稱
let s:containerName = 'local/vimcmdbyu:latest'


" 查找擁有執行文件的目錄
function! s:findMainDirectory(fileAbsolutePath)
    let l:cmdTxt = 'tmpDir=`realpath "' . s:safeQuote(a:fileAbsolutePath) . '"`;'
        \ . ' while [ -n "y" ]; do'
        \ .   ' tmpConfigDefaultPath="$tmpDir/' . s:shFilePathPart . '";'
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

" 檢查執行文件是否存在，若存在則返回目錄路徑
function! s:checkMainDirectory(fileAbsolutePath)
    let l:mainDirectory = s:findMainDirectory(a:fileAbsolutePath)
    if l:mainDirectory == ''
        throw '找不到擁有 "' . s:shFilePathPart . '" 的目錄'
    endif
    return l:mainDirectory
endfunction

" 檢查容器是否存在
function! s:checkContainer()
    let l:cmdTxt = ''
        \ . ' if ! type docker &> /dev/null ; then'
        \ .   ' echo -n "找不到 \`docker\` 命令";'
        \ .   ' exit 1;'
        \ . ' fi;'
        \ . ' tmpImgName="' . s:containerName . '";'
        \ . ' tmp=`docker images --format "{{.ID}}" --filter reference="$tmpImgName"`;'
        \ . ' if [ -z "$tmp" ]; then'
        \ .   ' echo -n "找不到 \"$tmpImgName\" 的 docker 容器";'
        \ .   ' exit 1;'
        \ . ' fi'
    let l:rtnMsg = system(l:cmdTxt)
    if v:shell_error
        throw l:rtnMsg
    endif
endfunction

" 取得運行命令程式碼
" @param {Number} ynUseDocker - 0 or 1。
function! s:getRunCmdTxt(ynUseDocker, shFile, method, fileAbsolutePath, fileExt, mainDirectory)
    let l:safeMainDirectory = s:safeQuote(a:mainDirectory)

    let l:cmdTxt = 'sh "' . s:safeQuote(a:shFile) . '"'
        \ . ' "' . s:safeQuote(a:method) . '"'
        \ . ' "' . s:safeQuote(a:fileAbsolutePath) . '"'
        \ . ' ".' . s:safeQuote(a:fileExt) . '"'
        \ . ' "' . l:safeMainDirectory . '"'
        \ . ' "' . (a:ynUseDocker ? 'inDocker' : 'unDocker') . '"'

    if a:ynUseDocker
        let l:execDocker = 'docker run --rm'
            \ . ' --volume "' . l:safeMainDirectory . ':' . l:safeMainDirectory . '"'
            \ . ' ' . s:getVar('dockerCarryOption')
            \ . ' ' . s:containerName
        let l:cmdTxt = l:execDocker . ' ' . l:cmdTxt
    endif

    return l:cmdTxt
endfunction


" 將標準輸出覆寫到文件上
function! cmdByU#Overwrite(cmdTxt)
    let &formatprg = a:cmdTxt
    normal! ggVGgq
endfunction

" 將標準輸出顯示於 quickfix-window 窗格
function! cmdByU#ShowMsg(cmdTxt)
    let &makeprg = a:cmdTxt
    make
    copen
    if line('$') == 1 && getline(1) == ''
        cclose
    else
        " 單引號無效果
        exec "normal! \<CR>"
    endif
endfunction


" 執行命令
" machine != docker 都視為以容器執行
function! s:run(method, fileAbsolutePath, fileExt, machine, assignShFile)
    let l:mainDirectory = s:checkMainDirectory(a:fileAbsolutePath)
    let l:ynUseDocker = !(a:machine != 'docker')
    if a:assignShFile == ''
        let l:shFile = l:mainDirectory . '/' . s:shFilePathPart
    else
        if a:assignShFile == 'global'
            let l:shFile = s:getVar('globalShFilePath')
        else
            let l:shFile = a:assignShFile
        endif
        if findfile(a:assignShFile) == ''
            throw '找不到 "' . l:shFile . '" 的 cmdByU.vim 執行文件。'
        endif
    endif

    let l:cmdTxt = s:getRunCmdTxt(l:ynUseDocker, l:shFile,
        \ a:method, a:fileAbsolutePath, a:fileExt, l:mainDirectory)

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

" 容器執行命令
function! cmdByU#Run(method, ...)
    let l:assignShFile = get(a:, 1, '')
    call s:checkContainer()
    call s:run(a:method, expand('%:p'), expand('%:e'), 'docker', l:assignShFile)
endfunction

" 主機執行命令
function! cmdByU#HostRun(method, ...)
    let l:assignShFile = get(a:, 1, '')
    call s:run(a:method, expand('%:p'), expand('%:e'), 'host', l:assignShFile)
endfunction

