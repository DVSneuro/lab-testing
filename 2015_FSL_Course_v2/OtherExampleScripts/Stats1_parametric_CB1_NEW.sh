#!/bin/sh

SUBJ=$1
RUN=$2
SMOOTHING=$3

#if [ $SUBJ -eq 203 -o $SUBJ -eq 205 -o $SUBJ -eq 207 ]; then
#cbtype = 2, then I, A, I, A
if [ $RUN -eq 1 -o $RUN -eq 3 ]; then
	CBTYPE=a
else
	CBTYPE=i
fi

MAINDIR=/mnt/delgadolab/disk02/labdata02/HighResReward
EVFILES=${MAINDIR}/Behavior/EV_files_m12/${SUBJ}
D1_FILE=${EVFILES}/${CBTYPE}_r${RUN}_d1_choice.txt
if [ -e ${D1_FILE} ]; then
	D1_SHAPE=3
else
	D1_SHAPE=10
fi
D2_FILE=${EVFILES}/${CBTYPE}_r${RUN}_d2_choice.txt
if [ -e ${D2_FILE} ]; then
	D2_SHAPE=3
else
	D2_SHAPE=10
fi
D3_FILE=${EVFILES}/${CBTYPE}_r${RUN}_d3_choice.txt
if [ -e ${D3_FILE} ]; then
	D3_SHAPE=3
else
	D3_SHAPE=10
fi
CONSTANT=${EVFILES}/${CBTYPE}_r${RUN}_feedback_constant.txt
LINEAR=${EVFILES}/${CBTYPE}_r${RUN}_feedback_linear.txt
LAPSE_FILE=${EVFILES}/${CBTYPE}_r${RUN}_lapse_d.txt
if [ -e ${LAPSE_FILE} ]; then
	LAPSE_SHAPE=3
else
	LAPSE_SHAPE=10
fi
MAINOUTPUT=${MAINDIR}/FSL/${SUBJ}
mkdir -p ${MAINOUTPUT}
OUTPUT=${MAINOUTPUT}/Stats1_run${RUN}_${SMOOTHING}
#rm -rf ${OUTPUT}.feat
DATA=${MAINDIR}/NIFTI/${SUBJ}/CardTask_run${RUN}_${SMOOTHING}mm/swacCardTask_run${RUN}_scrubbed
NVOLUMES=`fslnvols ${DATA}`

TEMPLATE=${MAINDIR}/FSL/templates/Stats1_Parametric_1stlev_SPM_NEW.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@D1_FILE@'$D1_FILE'@g' \
-e 's@D2_FILE@'$D2_FILE'@g' \
-e 's@D3_FILE@'$D3_FILE'@g' \
-e 's@D1_SHAPE@'$D1_SHAPE'@g' \
-e 's@D2_SHAPE@'$D2_SHAPE'@g' \
-e 's@D3_SHAPE@'$D3_SHAPE'@g' \
-e 's@LAPSE_FILE@'$LAPSE_FILE'@g' \
-e 's@LAPSE_SHAPE@'$LAPSE_SHAPE'@g' \
-e 's@CONSTANT@'$CONSTANT'@g' \
-e 's@LINEAR@'$LINEAR'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
<$TEMPLATE> ${MAINOUTPUT}/SPM_Stats1_FEAT_0${RUN}_NEW.fsf

feat ${MAINOUTPUT}/SPM_Stats1_FEAT_0${RUN}_NEW.fsf
rm -rf ${OUTPUT}.feat/filtered_func_.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
#cp -r ${MAINOUTPUT}/run${RUN}_NL_1mm_CardTask_wB0.feat/reg ${OUTPUT}.feat/.
