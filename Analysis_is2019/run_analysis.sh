#!/bin/bash -e

for type in txt  txt.char.tok  txt.D0.tok  txt.D3.tok  txt.lemma; do

bash report_sentence.sh $type > FULL_report_$type.Done  & 

done 