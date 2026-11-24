#!/usr/bin/env sh

mkdir RDF

T=300

echo ${T}K

for rep in `awk 'BEGIN { for( i=0; i<=9; i++ ) print i }'`; do
    echo $rep
    mkdir RDF/$rep
    mkdir RDF/$rep/${T}K
    cp Serial/$rep/${T}/data.polymer RDF/$rep/${T}K
    cp Serial/Insertion-Output/$rep/polymer.coeff RDF/$rep/${T}K
    cp Serial/Insertion-Output/$rep/groups_index.ndx RDF/$rep/${T}K
done
