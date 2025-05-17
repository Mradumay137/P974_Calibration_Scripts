rm -f S10OH.txt
rm -f S10CH.txt
rm -f S10H1.txt

rm -f R1.txt

sdhdf_identify -src S10 uwl*_2.Tav.hdf > S10OH.txt
sdhdf_identify -src S10 uwl*_4.Tav.hdf > S10CH.txt
sdhdf_identify -src S10 uwl*_1.Tav.hdf > S10H1.txt

mkdir -p S10_data

foreach file (`cat S10OH.txt | grep -v "ERROR"`)
 \cp $file S10_data
end

foreach file (`cat S10CH.txt | grep -v "ERROR"`)
 \cp $file S10_data
end

foreach file (`cat S10H1.txt | grep -v "ERROR"`)
 \cp $file S10_data
end

#foreach file (`cat R1.txt | grep -v "ERROR"`)
 #\cp $file S10_data
#end

\cp S10OH.txt S10_data
\cp S10CH.txt S10_data
\cp S10H1.txt S10_data
#\cp R1.txt S10_data
\cp time.py S10_data
cd S10_data
rm -f time_data_OH.txt
rm -f time_data_CH.txt
rm -f time_data_H1.txt
sdhdf_extractBand -zoom 1414 1418 -e extract uwl*_1.Tav.hdf
sdhdf_extractBand -zoom 1664 1668 -e extract uwl*_2.Tav.hdf
sdhdf_extractBand -zoom 3333 3337 -e extract uwl*_4.Tav.hdf
sdhdf_statistics uwl*_2.Tav.extract.hdf > time_data_OH.txt
sdhdf_statistics uwl*_4.Tav.extract.hdf > time_data_CH.txt
sdhdf_statistics uwl*_1.Tav.extract.hdf > time_data_H1.txt
#\cp time_data_OH.txt S10_data
#\cp time_data_CH.txt S10_data
#\cp time_data_H1.txt S10_data

rm -f time_data.txt
rm -f Matched_pair_OH.txt
rm -f Matched_pair_CH.txt
rm -f Matched_pair_H1.txt
rm -f join*.lsr.hdf
python time.py

set totalLineNumber1 = `wc -l Matched_pair_OH.txt | awk '{print $1}'`
set totalLineNumber2 = `wc -l Matched_pair_CH.txt | awk '{print $1}'`
set totalLineNumber3 = `wc -l Matched_pair_H1.txt | awk '{print $1}'`

mkdir -p S10_files
foreach lineNumber (`seq 1 $totalLineNumber1`)
  set onFile = `head -$lineNumber Matched_pair_OH.txt | tail -1 | awk '{print $1}'`
  echo $onFile
  \cp $onFile S10_files
 #set offFile = `head -$lineNumber1 Matched_pair_OH.txt | tail -1 | awk '{print $2}'`
 #echo $lineNumber1 "on = $onFile" "off = $offFile"
 #sdhdf_onoff -subtract -on $onFile -off $offFile -o joinOH_${lineNumber1}.hdf
end

foreach lineNumber (`seq 1 $totalLineNumber2`)
  set onFile = `head -$lineNumber Matched_pair_CH.txt | tail -1 | awk '{print $1}'`
  \cp $onFile S10_files
  #set offFile = `head -$lineNumber Matched_pair_CH.txt | tail -1 | awk '{print $2}'`
  #echo $lineNumber "on = $onFile" "off = $offFile"
  #sdhdf_onoff -subtract -on $onFile -off $offFile -o joinCH_${lineNumber}.hdf
end

foreach lineNumber (`seq 1 $totalLineNumber3`)

  set onFile = `head -$lineNumber Matched_pair_H1.txt | tail -1 | awk '{print $1}'`
  \cp $onFile S10_files
  #set offFile = `head -$lineNumber Matched_pair_H1.txt | tail -1 | awk '{print $2}'`
  #echo $lineNumber "on = $onFile" "off = $offFile"
  #sdhdf_onoff -subtract -on $onFile -off $offFile -o joinH1_${lineNumber}.hdf
end

rm -f joinOH_11.hdf
rm -f joinOH_12.hdf
rm -f joinOH_11.lsr.hdf
rm -f joinOH_12.lsr.hdf
cd S10_files


sdhdf_modify -lsr_regrid -e lsr uwl*_2.Tav.hdf 
sdhdf_modify -lsr_regrid -e lsr uwl*_4.Tav.hdf
sdhdf_modify -lsr_regrid -e lsr uwl*_1.Tav.hdf
sdhdf_join -o jointOH.hdf uwl*_2.Tav.lsr.hdf

sdhdf_join -o jointCH.hdf uwl*_4.Tav.lsr.hdf

sdhdf_join -o jointH1.hdf uwl*_1.Tav.lsr.hdf


sdhdf_modify -Tav -e Tav jointH1.hdf

sdhdf_modify -Tav -e Tav jointOH.hdf

sdhdf_modify -Tav -e Tav jointCH.hdf

sdhdf_modify -mult2pol 0 0.024 0.031 -e mult jointH1.Tav.hdf

sdhdf_modify -mult2pol 0 0.024 0.031 -e mult jointOH.Tav.hdf

sdhdf_modify -mult2pol 0 0.0024 0.0031 -e mult jointCH.Tav.hdf

sdhdf_modify -fav 2 -e fav  jointH1.Tav.mult.hdf

sdhdf_modify -fav 2 -e fav  jointOH.Tav.mult.hdf

sdhdf_modify -fav 2 -e fav  jointCH.Tav.mult.hdf

rm -f S10H1.dat
rm -f S10OH.dat
rm -f S10CH.dat

sdhdf_quickdump jointH1.Tav.mult.fav.hdf > S10H1.dat

sdhdf_quickdump jointOH.Tav.mult.fav.hdf > S10OH.dat

sdhdf_quickdump jointCH.Tav.mult.fav.hdf > S10CH.dat

