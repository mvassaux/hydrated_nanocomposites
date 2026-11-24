#!/usr/bin/env sh

mkdir Modulus

T=300

echo ${T}K

for rep in `awk 'BEGIN { for( i=0; i<=9; i++ ) print i }'`; do
    echo $rep
    mkdir Modulus/${rep}
    mkdir Modulus/${rep}/${T}K

    cp Serial/$rep/${T}/data.polymer Modulus/${rep}/${T}K
    cp Serial/Insertion-Output/$rep/polymer.coeff Modulus/${rep}/${T}K
    cp Serial/Insertion-Output/$rep/groups_index.ndx Modulus/${rep}/${T}K
done
