
rm -f S7.txt
sdhdf_identify -src S7 uwl*_2.Tav.hdf > S7.txt
rm -f R1.txt
sdhdf_identify -src R1 uwl*_2.Tav.hdf >	R1.txt

mkdir -p S7_method1
cd S7_method1
rm -f uwl*.hdf
cd ..
foreach file (`cat S7.txt | grep -v "ERROR"`)
 \cp $file S7_method1
end

foreach file (`cat R1.txt | grep -v "ERROR"`)
 \cp $file S7_method1
end

cd S7_method1
rm -f uwl*_4.Tav.hdf
rm -f uwl*_4.Tav.lsr.hdf
sdhdf_modify -lsr_regrid -e lsr uwl*.hdf

rm -f S7.txt
rm -f R1.txt
sdhdf_identify -src S7 uwl*_2.Tav.lsr.hdf > S7.txt
sdhdf_identify -src R1 uwl*_2.Tav.lsr.hdf > R1.txt

set totalLineNumber1 = `wc -l S7.txt | awk '{print $1}'`
set totalLineNumber2 = `wc -l R1.txt | awk '{print $1}'`
if ($totalLineNumber2 < 12) then
    set lineNumberToRepeat = 5
    set fileToRepeat = `head -$lineNumberToRepeat R1.txt | tail -1 | awk '{print $1}'`
    rm -f R1_temp.txt
    head -n 5 R1.txt > R1_temp.txt
    echo $fileToRepeat >> R1_temp.txt
    tail -n +6 R1.txt >> R1_temp.txt

    # Replace the original R1.txt with the modified list
    \mv R1_temp.txt R1.txt
    @ totalLineNumber2++
endif
foreach lineNumber (`seq 1 $totalLineNumber1`)
  set onFile = `head -$lineNumber S7.txt | tail -1 | awk '{print $1}'`
  set offFile = `head -$lineNumber R1.txt | tail -1 | awk '{print $1}'`
  echo $lineNumber "on = $onFile" "off = $offFile"
  sdhdf_onoff -sclA 35 -sclB 36 -on $onFile -off $offFile -o joinOHS7_${lineNumber}.hdf
end

sdhdf_join -o jointmet1.hdf joinOH*.hdf

sdhdf_modify -Tav -e Tav jointmet1.hdf
sdhdf_modify -fav 2 -e fav jointmet1.Tav.hdf

rm -f S7met1.dat
sdhdf_quickdump jointmet1.Tav.fav.hdf > S7met1.dat