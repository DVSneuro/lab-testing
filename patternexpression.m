
% load images
V = spm_vol('sub-100206_zstat1.nii');
sub1 = spm_read_vols(V);
V = spm_vol('sub-100307_zstat1.nii');
sub2 = spm_read_vols(V);
V = spm_vol('PNAS_2mm_net0003.nii');
dmn = spm_read_vols(V);
V = spm_vol('mask.nii');
mask = spm_read_vols(V);

data = nan(numel(mask),3); % sub1, sub2, dmn
dims = size(mask);
count = 0;
for x = 1:dims(1)
    for y = 1:dims(2)
        for z = 1:dims(3)
            count = count + 1;
            if mask(x,y,z)
                data(count,1) = sub1(x,y,z);
                data(count,2) = sub2(x,y,z);
                data(count,3) = dmn(x,y,z);
            end
        end
    end
end
x = isnan(data(:,1));
data(x,:) = [];
corr(data)

sub1_result = dot(data(:,1),data(:,3));
sub2_result = dot(data(:,2),data(:,3));

