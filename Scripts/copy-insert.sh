#!/usr/bin/env sh

mkdir Insertion-Output

for rep in `awk 'BEGIN { for( i=0; i<=9; i++ ) print i }'`; do
    echo $rep
    cp -r Insertion/$rep/Output Insertion-Output/$rep
done
