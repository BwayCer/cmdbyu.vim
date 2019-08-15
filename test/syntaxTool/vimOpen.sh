#!/bin/bash

useTool="$1"

__filename=`realpath "$0"`
_dirsh=`dirname "$__filename"`

toolPath="$_dirsh/$useTool"
toolShPath="$toolPath/tool.sh"

if [ ! -f "$toolShPath" ]; then
    echo "找不到 \"$toolShPath\" 執行文件。"
    exit 1
fi

echo "$useTool" > "$_dirsh/.vimcode/useTool.cmdbyu.tmp"
vim -u "$_dirsh/.vimrc" "$toolPath"/code*

