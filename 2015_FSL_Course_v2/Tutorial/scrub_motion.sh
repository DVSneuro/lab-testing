#!/bin/sh

# example "scrubbing" via regression script
# David V. Smith (smith@psychology.rutgers.edu)

maindir=`pwd`
datadir=${maindir}/data

# -- get motion estimates and outlier volumes --
mcflirt -in ${datadir}/func.nii -out ${datadir}/func_mcf -refvol 0 -rmsrel -rmsabs
sh ${maindir}/fsl_motion_outliers_0ref.sh -i ${datadir}/func.nii -o ${datadir}/refrms_spikes_func.txt --nomoco --refrms
sh ${maindir}/fsl_motion_outliers_0ref.sh -i ${datadir}/func.nii -o ${datadir}/fdrms_spikes_func.txt --fdrms
python ${maindir}/combine_spikes2.py ${datadir}/fdrms_spikes_func.txt ${datadir}/refrms_spikes_func.txt ${datadir}/all_spikes_func.txt
rm -rf ${datadir}/func_mcf.nii.gz
rm -rf ${datadir}/func_mcf.mat


# -- regress out volumes identified as outliers/spikes and all motion --
# Power et al. (2015). Recent progress and outstanding issues in motion correction in resting state fMRI. NeuroImage. http://www.sciencedirect.com/science/article/pii/S1053811914008702
# JISCMail - FSL Archive - dual regression and motion regressors (https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=FSL;459c6c04.1212)
# JISCMail - FSL Archive - Re: fsl_motion_outliers question. (https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=FSL;9f686c8e.1405)
INDATA=${datadir}/swaufunc.nii # data from SPM (has not been temporally filtered!)
NVOLUMES=`fslnvols ${INDATA}`

CONFOUNDEVSFILE=${datadir}/all_confounds_func.txt
mp_diffpow.sh ${datadir}/rp_func.txt ${datadir}/rp_func_diff.dat
if [ -e ${datadir}/all_spikes_func.txt ]; then
	paste -d ' ' ${datadir}/rp_func.txt ${datadir}/rp_func_diff.dat > ${datadir}/rp_func_final.txt
	paste -d ' ' ${datadir}/rp_func_final.txt ${datadir}/all_spikes_func.txt > ${CONFOUNDEVSFILE}
else
	paste -d ' ' ${datadir}/rp_func.txt ${datadir}/rp_func_diff.dat > ${CONFOUNDEVSFILE}
fi	

outdata=${datadir}/swaufunc_scrubbed
preMAT=${CONFOUNDEVSFILE}
postMAT=${datadir}/for_unconfound.mat
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@INDATA@'$INDATA'@g' \
-e 's@UNCONFOUNDFILE@'$preMAT'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
<make_confoundmat.fsf> ${datadir}/for_unconfound.fsf
feat_model ${datadir}/for_unconfound ${preMAT}
unconfound ${INDATA} ${outdata} ${postMAT}


