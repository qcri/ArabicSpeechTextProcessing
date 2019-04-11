#!/bin/bash -e

# Copyright (C) 2018, Qatar Computing Research Institute, HBKU (author: Ahmed Ali)

# This script shows the usage for the WER,  multi reference WER and AV-WER processing text with different Tokenization 
# we focus here on txt txt.char.tok tx-D0.tok txt.lemma

# Results are based on sample from the MGB3 test data

if [[ $# -ne 1 ]]; then
  echo "ERROR report_sentence.sh $type"
  echo "e.g report_sentence.sh txt"
  exit 1
fi

type=$1

for i in {1..1000}; do 
	machine=$(echo -e 'sentence \t')
	wers=$(echo -e 'sentence \t')


	ls Machine | while read system; do
		
		machine=$(echo -e $machine ${system} '\t' ${system} '\t' ${system} '\t' ${system} '\t' ${system} '\t')
		echo $machine >> machine$type.$$
		#echo -e ${type}'-avwer\t'${type}'-mrwer\t'${type}'-weralaa\t'${type}'-werali\t'${type}'-weromar'
		
		wers=$(echo -e $wers ${type}'-avwer\t'${type}'-mrwer\t'${type}'-weralaa\t'${type}'-werali\t'${type}'-weromar')
		echo $wers >> wers$type.$$
			
		head -n $i Human/Alaa/$type | tail -1  > Human/Alaa/$type.$i
		head -n $i Human/Ali/$type  | tail -1 > Human/Ali/$type.$i
		head -n $i Human/Omar/$type | tail -1 > Human/Omar/$type.$i 
		head -n $i Machine/$system/$type | tail -1 > Machine/$system/$type.$i
		cat Machine/$system/$type.$i | cut -d ' ' -f1 > sentenceid$type.$$
		python mrwer.py Human/Alaa/$type.$i Human/Ali/$type.$i Human/Omar/$type.$i Machine/$system/$type.$i &> tmp$type.$$
		#rm Human/Alaa/$type.$i Human/Ali/$type.$i Human/Omar/$type.$i Machine/$system/$type.$i
		weralaa=$(grep -m1 "Overall WER:" tmp$type.$$ | awk '{print $2}' | cut -d ':' -f2)
		werali=$(grep -m2 "Overall WER:" tmp$type.$$ | tail -1 |  awk '{print $2}' | cut -d ':' -f2)
		weromar=$(grep -m3 "Overall WER:" tmp$type.$$ | tail -1  | awk '{print $2}' | cut -d ':' -f2)
		mrwer=$(grep MR-WER tmp$type.$$ | awk '{print $2}' | cut -d ':' -f2)
		avwer=$(grep AV-WER tmp$type.$$ | awk '{print $2}' | cut -d ':' -f2)
		#echo -e $avwer '\t' $mrwer  '\t' $weralaa '\t' $werali '\t' $weromar
		
		numbers=$(echo -e $numbers $avwer '\t' $mrwer  '\t' $weralaa '\t' $werali '\t' $weromar)
		echo $numbers >> numbers$type.$$
		rm tmp$type.$$ */*/$type.$i
		
	done

	if (( $i == 1 )); then 
		tail -1 machine$type.$$
		tail -1 wers$type.$$
	fi
	sentenceid=$(cat sentenceid$type.$$)
	tail -1 numbers$type.$$ | sed "s:^:$sentenceid\t:"

rm machine$type.$$ wers$type.$$ numbers$type.$$ sentenceid$type.$$

done 


exit 0

