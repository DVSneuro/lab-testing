#!/bin/sh

S=$1
R=$2
TASK=CardGame

# -- get motion estimates and outlier volumes --
# updated: now using refrms and fdrms because DVARS does not identify the largest motion spikes
MYOUTDIR=${MAINDIR}/${S}/${TASK}
MYINDIR=${MAINDIR}/${S}/${TASK}/run${R}
mcflirt -in ${MYINDIR}/crun${R}.nii -out ${MYINDIR}/crun${R}_mcf -refvol 0 -rmsrel -rmsabs
sh ${SCRIPTDIR}/fsl_motion_outliers_0ref.sh -i ${MYINDIR}/crun${R}.nii -o ${MYOUTDIR}/refrms_spikes_run${R}.txt --nomoco --refrms
sh ${SCRIPTDIR}/fsl_motion_outliers_0ref.sh -i ${MYINDIR}/crun${R}.nii -o ${MYOUTDIR}/fdrms_spikes_run${R}.txt --fdrms
python ${SCRIPTDIR}/combine_spikes2.py ${MYOUTDIR}/fdrms_spikes_run${R}.txt ${MYOUTDIR}/refrms_spikes_run${R}.txt ${MYOUTDIR}/all_spikes_run${R}.txt
rm -rf ${MYINDIR}/crun${R}_mcf.nii.gz
rm -rf ${MYINDIR}/crun${R}_mcf.mat


# -- set output and remove existing --
OUTPUT=${MYOUTDIR}/prestats${R}_0mm_clean
rm -rf ${OUTPUT}.feat


# -- regress out volumes identified as outliers/spikes and all motion --
# Power et al. (2015). Recent progress and outstanding issues in motion correction in resting state fMRI. NeuroImage. http://www.sciencedirect.com/science/article/pii/S1053811914008702
# JISCMail - FSL Archive - dual regression and motion regressors (https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=FSL;459c6c04.1212)
# JISCMail - FSL Archive - Re: fsl_motion_outliers question. (https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=FSL;9f686c8e.1405)
INDATA=${MYOUTDIR}/run${R}/swacrun${R}.nii # data from SPM (has not been temporally filtered!)
if [ ! -e $INDATA ]; then
	echo "missing $INDATA" >> $MAINDIR/__missingfiles.txt
fi
NVOLUMES=`fslnvols ${INDATA}`

CONFOUNDEVSFILE=${MYOUTDIR}/all_confounds_run${R}.txt
mp_diffpow.sh ${MYOUTDIR}/run${R}/rp_crun${R}.txt ${MYOUTDIR}/run${R}/rp_crun${R}_diff.dat
if [ -e ${MYOUTDIR}/all_spikes_run${R}.txt ]; then
	paste -d ' ' ${MYOUTDIR}/run${R}/rp_crun${R}.txt ${MYOUTDIR}/run${R}/rp_crun${R}_diff.dat > ${MYOUTDIR}/run${R}/rp_crun${R}_final.txt
	paste -d ' ' ${MYOUTDIR}/run${R}/rp_crun${R}_final.txt ${MYOUTDIR}/all_spikes_run${R}.txt > ${CONFOUNDEVSFILE}
else
	paste -d ' ' ${MYOUTDIR}/run${R}/rp_crun${R}.txt ${MYOUTDIR}/run${R}/rp_crun${R}_diff.dat > ${CONFOUNDEVSFILE}
fi	

OUTDATA=${MYOUTDIR}/run${R}/swacrun${R}_scrubbed
preMAT=${CONFOUNDEVSFILE}
postMAT=${MYOUTDIR}/run${R}/for_unconfound${R}.mat
cd ${SCRIPTDIR}
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@INDATA@'$INDATA'@g' \
-e 's@UNCONFOUNDFILE@'$preMAT'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
<make_confoundmat.fsf> ${MYOUTDIR}/run${R}/for_unconfound${R}.fsf
feat_model ${MYOUTDIR}/run${R}/for_unconfound${R} ${preMAT}
unconfound ${INDATA} ${OUTDATA} ${postMAT}


