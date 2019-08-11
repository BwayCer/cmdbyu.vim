#!/bin/bash
# 查找 .vimcode 的目錄


shFilePathPart="$1"
fileAbsPath="$2"


tmpDir=$fileAbsPath;
while [ -n "y" ]; do
    tmpMarkPath="$tmpDir/$shFilePathPart"
    tmpNextDir=`dirname "$tmpDir"`;
    if [ -f "$tmpMarkPath" ]; then
        echo -n "$tmpDir";
        exit
    elif [ "$tmpNextDir" == "/home" ] || [ "$tmpNextDir" == "/" ]; then
        exit 1
    fi;
    tmpDir=$tmpNextDir;
done

