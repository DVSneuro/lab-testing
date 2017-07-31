#!/bin/sh

SUBJ=$1
RUN=$2

#where art thou files?
MAINDIR=/mnt/delgadolab/disk02/labdata02/HighResReward
EVFILES=${MAINDIR}/Behavior/EV_files_CardTask/${SUBJ}
GAIN=${EVFILES}/run${RUN}/gain.txt
LOSS=${EVFILES}/run${RUN}/loss.txt
NEUTRAL=${EVFILES}/run${RUN}/neutral.txt
RESPONSE=${EVFILES}/run${RUN}/response.txt

MAINOUTPUT=${MAINDIR}/FSL/${SUBJ}
mkdir -p ${MAINOUTPUT}
OUTPUT=${MAINOUTPUT}/CardTask${RUN}
DATA=${MAINDIR}/NIFTI/${SUBJ}/CardTask_run${RUN}/swacCardTask_run${RUN}_scrubbed
NVOLUMES=`fslnvols ${DATA}`

#find and replace
TEMPLATE=${MAINDIR}/FSL/templates/L1_CardTask_template.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@GAIN@'$GAIN'@g' \
-e 's@LOSS@'$LOSS'@g' \
-e 's@NEUTRAL@'$NEUTRAL'@g' \
-e 's@RESPONSE@'$RESPONSE'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
<$TEMPLATE> ${MAINOUTPUT}/L1_CardTask_template${RUN}.fsf

#run analysis
feat ${MAINOUTPUT}/L1_CardTask_template${RUN}.fsf

#delete junk
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
