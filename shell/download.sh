#!/bin/bash

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ -z "$1" ]]
then
echo "This script is used to download available FASTA sequence of each genomes specified in ./data/download-list/<sugroup> accession number list"
exit 0
fi

while getopts :i: option;do
	case "${option}"
	in
		i) subgroup=${OPTARG};;
		\?) echo "Invalid option: ${OPTARG}" 1>&2;;
		:) echo "Invalid option: ${OPTARG} requires an argument" 1>&2;;
	esac
done

echo "STARTING DOWNLOADING : ${subgroup}"


declare -a list
cursor=0
while read -r a b; do
	list[$cursor]="${a} ${b}"
	(( cursor += 1 ))
done < "./data/download-list/${subgroup}.tsv"

length=${#list[@]}
echo "${length} FASTA files will be downloaded from ${subgroup} directory"
for (( i=0; i<length; i++ ));
do
	read -r a b <<<"${list[$i]}"
	echo "esearch -db nucleotide -query ${a} | efetch -format fasta > ${b}"
	{
		esearch -db nucleotide -query ${a} | efetch -format fasta > data/genome-fasta/${b}
	} &
	BACK_PID=$!
	wait $BACK_PID
done


