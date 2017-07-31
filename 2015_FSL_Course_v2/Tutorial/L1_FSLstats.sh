#!/bin/sh

# example L1 stats script / example finish preprocessing
# David V. Smith (smith@psychology.rutgers.edu)


#where art thou files?
maindir=`pwd`
datadir=${maindir}/data
evdir=${maindir}/ev_files
A1_FILE=${evdir}/condA1.txt
A2_FILE=${evdir}/condA2.txt
B1_FILE=${evdir}/condB1.txt
B2_FILE=${evdir}/condB2.txt

DATA=${datadir}/swaufunc_scrubbed
NVOLUMES=`fslnvols ${DATA}`
OUTPUT=${maindir}/stats_scripted


#find and replace
TEMPLATE=${maindir}/L1_template.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@A1_FILE@'$A1_FILE'@g' \
-e 's@A2_FILE@'$A2_FILE'@g' \
-e 's@B1_FILE@'$B1_FILE'@g' \
-e 's@B2_FILE@'$B2_FILE'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
<$TEMPLATE> ${maindir}/L1_stats.fsf


#run analysis: this will finish preprocessing (SUSAN smoothing, BET, high-pass filtering)
feat ${maindir}/L1_stats.fsf


#delete junk
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
#rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz #need this file for later. it is fully preprocessed and happy happy. :-)

