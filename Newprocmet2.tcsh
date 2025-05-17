rm -f S6.txt
sdhdf_identify -src S6 uwl*_2.Tav.hdf > S6.txt
rm -f R1.txt
sdhdf_identify -src R1 uwl*_2.Tav.hdf > R1.txt

mkdir -p S6_method2
cd S6_method2
rm -f uwl*.hdf
cd ..
foreach file (`cat S6.txt | grep -v "ERROR"`)
 \cp $file S6_method2
end

foreach file (`cat R1.txt | grep -v "ERROR"`)
 \cp $file S6_method2
end

cd S6_method2
rm -f uwl*.lsr.hdf
sdhdf_modify -lsr_regrid -e lsr uwl*.hdf

rm -f S6.txt
rm -f R1.txt
sdhdf_identify -src S6 uwl*_2.Tav.lsr.hdf > S6.txt
sdhdf_identify -src R1 uwl*_2.Tav.lsr.hdf > R1.txt




set totalLineNumber1 = `wc -l S6.txt | awk '{print $1}'`
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
  set onFile = `head -$lineNumber S6.txt | tail -1 | awk '{print $1}'`
  set offFile = `head -$lineNumber R1.txt | tail -1 | awk '{print $1}'`
  echo $lineNumber "on = $onFile" "off = $offFile"
  sdhdf_onoff -subtract  -on $onFile -off $offFile -o joinOHS6_${lineNumber}.hdf
end
sdhdf_join -o jointmet1.hdf joinOH*.hdf

sdhdf_modify -Tav -e Tav jointmet1.hdf
sdhdf_modify -fav 2 -e fav jointmet1.Tav.hdf

sdhdf_calibrate -fluxcal uwl_210911_142647.anitaLines.fluxcal -e calibrateS jointmet1.Tav.fav.hdf

rm -f S6met2.dat
sdhdf_quickdump jointmet1.Tav.fav.calibrateS.hdf > S6met2.dat