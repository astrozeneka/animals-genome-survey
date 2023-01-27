#!/bin/bash
declare -a list
cursor=0
while read -r a b; do
	list[$cursor]="${a} ${b}"
	(( cursor += 1 ))
done < download-extract.txt

length=${#list[@]}
for (( i=0; i<length; i++ ));
do
	read -r a b <<<"${list[$i]}"
	echo "esearch -db nucleotide -query ${a} | efetch -format fasta > ${b}"
	{
		esearch -db nucleotide -query ${a} | efetch -format fasta > ${b}
	} &
	BACK_PID=$!
	wait $BACK_PID
done


