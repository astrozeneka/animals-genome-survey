#!/bin/bash
# This script is used to clean empty files (download error)
# This script should be embedded in a another larger shell script

declare -a file_list
cursor=0
for f in data/genome-fasta/*.fasta; do
	size=$(stat -c %s "${f}")
	echo "File ${size} -> ${f}"
	if [ $size -eq 0 ] ; then
		echo "Empty file"
		rm $f
	fi
done
