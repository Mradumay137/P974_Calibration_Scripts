rm -f S10.txt
sdhdf_identify -src S10 uwl*_4.Tav.hdf > S10.txt
mkdir -p S10_method3CH

foreach file (`cat S10.txt | grep -v "ERROR"`)
 \cp $file S10_method3CH
end
cd S10_method3CH
rm -f uwl*.lsr.hdf
sdhdf_modify -lsr_regrid -e lsr uwl*.hdf

sdhdf_join -o jointmet3.hdf uwl*.lsr.hdf

sdhdf_modify -Tav -e Tav jointmet3.hdf

sdhdf_calibrate -fluxcal uwl_210911_142647.anitaLines.fluxcal -e calibrateS jointmet3.Tav.hdf
sdhdf_modify -fav 2 -e fav jointmet3.Tav.calibrateS.hdf
rm -f S10met3CH.dat
sdhdf_quickdump jointmet3.Tav.calibrateS.fav.hdf > S10met3CH.dat