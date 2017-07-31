**the goal of this tutorial is to have you walk through all the analysis steps following your dcm2nii conversion**


1) spatial preprocessing with SPM. open up nii_batch12.m and run_nii_batch12.m to check your settings against the scanner_protocol.pdf

2) motion scrubbing with FSL. after you run spatial preprocessing, you can filter out motion parameters and spikes. have a look at scrub_motion.sh to do this. read every line of code and look at the file(s) it calls (e.g., make_confoundmat.fsf). think about how and why everything is connected.

3) clicking: temporal filtering, bet, smoothing, and stats with FSL. open the FEAT GUI and get ready to click. after you've "scrubbed" your data, you still need to do temporal filtering, smoothing, and BET, so be sure to turn those on in your Pre-Stats tab when you set up your analysis (of course, everything else in Pre-stats should be off since you've done it already). make your model using the four EV files in the folder "ev_files", turn off registration, hit "go". (could also save a template fsf file at this stage, but your analysis will create this automatically (design.fsf).

4) scripting: temporal filtering, bet, smoothing, and stats with FSL. open the design.fsf that you created in #3 and identify the paths/lines that would change between runs/subjects. replace these with placeholders (OUTPUT, DATA, A1_FILE, A2_FILE, B1_FILE, B2_FILE, NVOLUMES). this is where find and replace comes in. open up the L1_FSLstats.sh and check your paths and variables. remember the sed statement is only doing "find and replace", so check this against what you wrote in your template (also check the name of your template (e.g., did you save it as L1_template.fsf? if not, change that line). once you've verified that everything is correct, run the script by typing "bash L1_FSLstats.sh" into the terminal. obviously, you can add inputs to this script and make it fit your needs.

