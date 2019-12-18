#!/bin/bash
dotnet /gitversion/GitVersion.dll $WORKING_DIR /l buildserver /output json /nofetch /diag
dotnet /gitversion/GitVersion.dll $WORKING_DIR /l buildserver /output json /nofetch /showvariable semVer > version.txt

version=`cat version.txt`

git tag > tags.txt
cat tags.txt
export c=`grep -c "$version" tags.txt`
if [ "$c" = "" ]; then
	echo "Cannot get versions from git"
	exit 1
fi
echo $c
if [ "$c" -gt "0" ]; then
	echo "$version already exists, we try to bump the patch"
	ma=$(echo $version | cut -f1 -d".")
	mi=$(echo $version | cut -f2 -d".")
	mp=$(echo $version | cut -f3 -d".")
	mp=$((mp + 1))
	version=$ma"."$mi"."$mp
	echo $version > version.txt
else
	echo $c
fi

echo "New version is $version"

git tag "v$version"
