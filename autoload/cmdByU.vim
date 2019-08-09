
" 取得設定變數值
function! s:getVar(name)
    return canUtils#GetVar('cmdbyu', a:name)
endfunction

let s:_dirvi = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let s:findVimCodeDirFilePath = s:_dirvi . '/lib/findVimCodeDirectory.sh'

" cmdByU.vim 的執行文件路徑
let s:shFilePathPart = '.vimcode/cmdbyu.sh'
let s:shFileParentPathPart = fnamemodify(s:shFilePathPart, ':h')


" 檢查執行文件是否存在，若存在則返回專案目錄路徑
" @throws '找不到擁有 s:shFilePathPart 的目錄
function! s:checkProjectDirectory(fileAbsolutePath)
    let l:projectDir = canUtils#Sh('sh', s:findVimCodeDirFilePath,
        \ s:shFilePathPart, a:fileAbsolutePath)
    if v:shell_error != 0
        throw '找不到擁有 "' . s:shFilePathPart . '" 的目錄'
    endif
    return l:projectDir
endfunction

" 檢查使用的執行文件並返回執行文件目錄路徑
function! s:checkShFileDirectory(projectDir, assignShFileDirArgu)
    if a:assignShFileDirArgu == ''
        let l:shFileDir = a:projectDir
    elseif a:assignShFileDirArgu == 'global'
        let l:shFileDir = s:getVar('globalDirectory')
    else
        let l:shFileDir = a:assignShFileDirArgu
    endif

    let l:shFile = l:shFileDir . '/' . s:shFilePathPart
    if empty(findfile(l:shFile))
        throw '找不到 "' . l:shFile . '" 執行文件。'
    endif
    return l:shFileDir
endfunction

" docker 命令替換
function s:replaceDockerCmd(shFileDir, projectDir, shCmd)
    let l:volumeProjectTxt =   '--volume "' . a:projectDir   . ':' . a:projectDir . '"'
    if a:shFileDir == a:projectDir
        let volumeTxt = l:volumeProjectTxt
    else
        let l:shFileParentDir = a:shFileDir . '/' . s:shFileParentPathPart
        let l:volumeShFileTxt
            \ = '--volume "' . l:shFileParentDir . ':' . l:shFileParentDir . '"'
        if len(split(a:shFileDir, '/*')) >= len(split(a:projectDir, '/*'))
            " 路徑層數較少或重要目錄者擺後面
            let volumeTxt = l:volumeShFileTxt . ' ' . l:volumeProjectTxt
        else
            let volumeTxt = l:volumeProjectTxt . ' ' . l:volumeShFileTxt
        endif
    endif

    let l:cmdTxt = s:getVar('dockerCommand')
    let l:cmdTxt = substitute(l:cmdTxt, '{volume}', l:volumeTxt, 'g')
    let l:cmdTxt = substitute(l:cmdTxt, '{shCmd}', a:shCmd, 'g')
    return l:cmdTxt
endfunction

" 取得運行命令程式碼
function! s:getRunCmdTxt(machine, method, fileAbsolutePath, fileExt, projectDir, shFileDir)
    let l:ynUseDocker = !(a:machine != 'docker')
    let l:shFile = a:shFileDir . '/' . s:shFilePathPart

    let l:cmdTxt = canUtils#GetCmdTxt('sh', l:shFile,
        \ a:method, a:fileAbsolutePath, (empty(a:fileExt) ? '' : '.' . a:fileExt),
        \ a:projectDir, (l:ynUseDocker ? 'inDocker' : 'unDocker'))

    if l:ynUseDocker
        let l:cmdTxt = s:replaceDockerCmd(a:shFileDir, a:projectDir, l:cmdTxt)
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
function! s:run(fileAbsolutePath, fileExt, machine, method, assignShFileDirArgu)
    let l:projectDir = s:checkProjectDirectory(a:fileAbsolutePath)
    let l:shFileDir = s:checkShFileDirectory(l:projectDir, a:assignShFileDirArgu)
    let l:cmdTxt = s:getRunCmdTxt(
        \ a:machine, a:method, a:fileAbsolutePath, a:fileExt,
        \ l:projectDir, l:shFileDir)

    " 執行命令的訊息
    echom l:cmdTxt
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
    let l:assignShFileDir = get(a:, 1, '')
    call s:run(expand('%:p'), expand('%:e'), 'docker', a:method, l:assignShFileDir)
endfunction

" 主機執行命令
function! cmdByU#HostRun(method, ...)
    let l:assignShFileDir = get(a:, 1, '')
    call s:run(expand('%:p'), expand('%:e'), 'host', a:method, l:assignShFileDir)
endfunction

