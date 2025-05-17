rm -f E2.txt
rm -f R1.txt

sdhdf_identify -src S37 uwl*.Tav.hdf > S37.txt
#sdhdf_identify -src R1 uwl*.Tav.hdf > R1.txt

mkdir -p S37_data

foreach file (`cat S37.txt | grep -v -e "ERROR" -e "ATTEMPTING"`)
 \cp $file S37_data
end 

#foreach file (`cat R1.txt | grep -v -e "ERROR" -e "autoFlag" -e  "flagged"`)
 #\cp $file S37_data
#end

\cp S37.txt S37_data
#\cp R1.txt S37_data
\cp time.py S37_data

cd S37_data
rm -f time_data.txt
sdhdf_extractBand -zoom 1664 1668 -zoom 3335 3336 -zoom 3348 3350 -zoom 1420 1421 -e extract uwl*.Tav.hdf
sdhdf_statistics uwl*.Tav.extract.hdf > time_data.txt
rm -f Matched_pair_1.txt
rm -f join*.lsr.hdf
python time.py
mkdir -p S37_files
set totalLineNumber = `wc -l Matched_pair_1.txt | awk '{print $1}'`

foreach lineNumber (`seq 1 $totalLineNumber`)
  set onFile = `head -$lineNumber Matched_pair_1.txt | tail -1 | awk '{print $1}'`
  \cp $onFile S37_files
  #set offFile = `head -$lineNumber Matched_pair_1.txt | tail -1 | awk '{print $2}'`




#echo $lineNumber "on = $onFile" "off = $offFile"
  #sdhdf_onoff -subtract -on $onFile -off $offFile -o join_${lineNumber}.hdf
end
cd S37_files
rm -f uwl*.lsr.hdf
sdhdf_modify -lsr_regrid -e lsr uwl*.Tav.hdf

#sdhdf_extractBand -zoom 1665 1666 -e extract uwl_*.Tav.lsr.hdf
#mkdir deletedFiles
#sdhdf_plotMultiSpec -query queryCheck_1665_1666.txt uwl_*.extract.hdf
#mv `awk '{if ($2=="n") {print $1}}' queryCheck_1665_1666.txt` deletedFiles
#sdhdf_join -o S37($iter).hdf  uwl_*.extract.hdf
#sdhdf_modify -Tav -e Tav S37_{$iter}.hdf


sdhdf_join -o joint.hdf uwl*.Tav.lsr.hdf

sdhdf_modify -Tav -e Tav joint.hdf

sdhdf_modify -fav 4 -e fav joint.Tav.hdf

sdhdf_modify -mult2pol 1 0.0000037 0.0000045 -mult2pol 2 0.0000032 0.0000041 -mult2pol 4 0.00000230 0.00000240 -mult2pol 3 0.00000354 0.00000372 -e mult joint.Tav.fav.hdf
rm -f S37.dat
sdhdf_quickdump joint.Tav.fav.mult.hdf > S37.dat


#!/bin/bash

# Define the range of iterations
#for iter in {0..7}; do
    # Extract band
    #sdhdf_extractBand -zoom fmin fmax -e extract uwl_*.Tav.lsr.hdf

    # Create directory for deleted files
    #mkdir -p deletedFiles_${iter}

    # Plot multi-spec
    #sdhdf_plotMultiSpec -query queryCheck_${iter}.txt uwl_*.extract.hdf

    # Move files based on query
    #mv $(awk '{if ($2=="n") {print $1}}' queryCheck_${iter}.txt) deletedFiles_${iter}

    # Join files
    #sdhdf_join -o S37_${iter}.hdf uwl_*.extract.hdf

    # Modify files
    #sdhdf_modify -Tav -e Tav S37_${iter}.hdf

    # Additional commands (if required)
    #sdhdf_modify -mult2pol 1 0.0000037 0.0000045 -mult2pol 2 0.0000032 0.0000041 -mult2pol 4 0.00000354 0.00000372 -mult2pol 3 0.00000354 0.00000372 -e mult S37_${iter}.Tav.hdf
   
#done

#!/bin/tcsh

#set iterations = ( 1419 1421 1611 1613 1665 1666 1667 1668 1719 1721 3262 3264 3335 3336 3348 3350 )
#set scale = ( 0.0000037 0.0000045 0.0000032 0.0000041 0.0000032 0.0000041 0.0000032 0.0000041 0.0000032 0.0000041 0.00000354 0.0000037 0.00000354 0.0000037 0.00000354 0.00000372 )

# Loop through the iterations array
#@ i = 1
#while ( $i <= $#iterations )
   
    #set fmin = $iterations[$i]
    #@ next = $i + 1
    #set fmax = $iterations[$next]
    #set S37 = $scale[$i]
    #set S2 = $scale[$next]
    # Extract band
    #sdhdf_extractBand -zoom $fmin $fmax -e extract uwl_*.Tav.lsr.hdf

    # Create directory for deleted files
    #mkdir -p deletedFiles_${i}

    rm -f quer*.txt

    # Plot multi-spec
    #sdhdf_plotMultiSpec -query queryCheck_${fmin}_${fmax}.txt uwl_*.extract.hdf

    # Move files based on query
    #mv `awk '{if ($2=="n") {print $1}}' queryCheck_${fmin}_${fmax}.txt` deletedFiles_${i}

    # Join files
    #sdhdf_join -o S37_${fmin}_${fmax}.hdf uwl_*.extract.hdf

    # Modify files
    #sdhdf_modify -Tav -e Tav S37_${fmin}_${fmax}.hdf

    # Additional commands
    #sdhdf_modify -mult2pol 0 $S37 $S2 -e mult S37_${fmin}_${fmax}.Tav.hdf

    #rm -f S37_${fmin}_${fmax}.dat
    #sdhdf_quickdump S37_${fmin}_${fmax}.Tav.mult.hdf > S37_${fmin}_${fmax}.dat

    #@ i += 2  # Increment i by 2 to move to the next pair
#end




