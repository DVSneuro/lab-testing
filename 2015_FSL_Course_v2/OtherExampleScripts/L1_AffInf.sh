#!/bin/sh

# this is was inputs to shell script look like
SUBJ=$1
RUN=$2

CBTYPE=a
MAINDIR=/wormhole/david/AvI_FB_01


EVFILES=${MAINDIR}/FSL/EV_files_m02/${SUBJ}
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

CONSTANT=${EVFILES}/${CBTYPE}_r${RUN}_feedback_constant.txt
LINEAR=${EVFILES}/${CBTYPE}_r${RUN}_feedback_linear.txt
LAPSE_FILE=${EVFILES}/${CBTYPE}_r${RUN}_lapse.txt
if [ -e ${LAPSE_FILE} ]; then
	LAPSE_SHAPE=3
else
	LAPSE_SHAPE=10
fi

MAINOUTPUT=${MAINDIR}/FSL/${SUBJ}
mkdir -p ${MAINOUTPUT}
OUTPUT=${MAINOUTPUT}/L1_run${RUN}
DATA=${MAINOUTPUT}/run${RUN}.feat/filtered_func_data
MOTION=${MAINOUTPUT}/run${RUN}.feat/confoundevs.txt
OUTLIERVOLS=${MAINOUTPUT}/run${RUN}.feat/outlier_vols.txt
CONFOUNDEVSFILE=${MAINOUTPUT}/run${RUN}.feat/confound_mat.txt
if [ -e $OUTLIERVOLS ]; then
	paste -d '\0' ${OUTLIERVOLS} ${MOTION} > ${CONFOUNDEVSFILE}
else
	CONFOUNDEVSFILE=${MOTION}
fi

TEMPLATE=${MAINDIR}/FSL/templates/L1_parametric_new.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@D1_FILE@'$D1_FILE'@g' \
-e 's@D2_FILE@'$D2_FILE'@g' \
-e 's@D1_SHAPE@'$D1_SHAPE'@g' \
-e 's@D2_SHAPE@'$D2_SHAPE'@g' \
-e 's@LAPSE_FILE@'$LAPSE_FILE'@g' \
-e 's@LAPSE_SHAPE@'$LAPSE_SHAPE'@g' \
-e 's@CONSTANT@'$CONSTANT'@g' \
-e 's@LINEAR@'$LINEAR'@g' \
<$TEMPLATE> ${MAINOUTPUT}/L1_FEAT_0${RUN}.fsf

feat ${MAINOUTPUT}/L1_FEAT_0${RUN}.fsf
rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
cp -r ${MAINOUTPUT}/run${RUN}.feat/reg ${OUTPUT}.feat/.
