%define some variables
maindir = pwd;
func = fullfile(maindir,'data','func.nii');
anat = fullfile(maindir,'data','anat.nii');
phase = fullfile(maindir,'data','phase.nii');
magn = fullfile(maindir,'data','mag.nii');

%make structure with inputs
p.fmriname = func;
p.t1name = anat;
p.TRsec = 2;
p.slice_order = 3;
p.phase = phase;
p.magn = magn;

%run spatial processing with your settings
nii_batch12(p);
