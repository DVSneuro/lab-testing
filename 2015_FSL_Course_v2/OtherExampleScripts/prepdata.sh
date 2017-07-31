# !/bin/bash

SUBJ=$1

BASEDIR=/mnt/delgadolab/disk02/labdata02/HighResReward
INPUTBASE=${BASEDIR}/MRI/DelgadoLab_HiRes-${SUBJ}
OUTPUT=${BASEDIR}/NIFTI/${SUBJ}
mkdir -p $OUTPUT

./dcm2niix -o ${OUTPUT} -f anat -z y ${INPUTBASE}/*/t1_mpr_ns_sag_p2_iso_12Channel_2
./dcm2niix -o ${OUTPUT} -f mag_image -z y ${INPUTBASE}/*/gre_field_mapping_3
./dcm2niix -o ${OUTPUT} -f phase_image -z y ${INPUTBASE}/*/gre_field_mapping_4

for r in 1 2 3 4; do
	let NUM=$r+6
	./dcm2niix -o ${OUTPUT} -f CardTask_run${r} -z y ${INPUTBASE}/*/HighRes_ep2d_bold_12ChannelCoil_${NUM}
done

