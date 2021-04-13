% Load the MRI volumes
% author: Yu (Simon Ellershaw removed plotting bits)

% File Name
fileName_healthy = "Data/pip0101_20_20_1401_T2MEdiff_abs.alle.nii";
fileName_pre_eclampsia = "Data/pip0120_20_20_2501_T2MEdiff_abs.alle.nii";
fileName_healthy_placenta_mask = "Data/pip0101_placenta_mask.nii.gz";
fileName_healthy_placenta_uterine_wall_mask = "Data/pip0101_placenta_and_uterine_wall_mask.nii.gz";
fileName_pre_eclampsia_placenta_mask = "Data/pip0120_placenta_mask.nii.gz";
fileName_pre_eclampsia_placenta_uterine_wall_mask = "Data/pip0120_placenta_and_uterine_wall_mask.nii.gz";
fileName_grad_echo = "Data/grad_echo.txt";

% Load MRI volumes
V_healthy_original = niftiread(fileName_healthy); 
V_pre_eclampsia_original = niftiread(fileName_pre_eclampsia); 
% Convert to double-precision arrays
V_healthy = double(V_healthy_original);   % size: 200, 106, 30, 330
V_pre_eclampsia = double(V_pre_eclampsia_original);  % size: 200, 102, 20, 330

% Load masks with and without uterine wall
M_healthy_placenta = double(niftiread(fileName_healthy_placenta_mask));
M_healthy_placenta_uterine_wall = double(niftiread(fileName_healthy_placenta_uterine_wall_mask));
M_pre_eclampsia_placenta = double(niftiread(fileName_pre_eclampsia_placenta_mask));
M_pre_eclampsia_placenta_uterine_wall = double(niftiread(fileName_pre_eclampsia_placenta_uterine_wall_mask));

% Load MRI acquisition parameters
grad_echo = importdata(fileName_grad_echo); 
bvals = grad_echo(:, 4);
TE = grad_echo(:, 5);

% Calc regions of interest (ROI)
% Must be a better way to do this...
num_scans = length(grad_echo);
ROI_healthy_placenta_uterine_wall = zeros(size(V_healthy_original));
ROI_pre_eclampsia_placenta_uterine_wall = zeros(size(V_pre_eclampsia));
for i = 1:num_scans
    ROI_healthy_placenta_uterine_wall(:,:,:,i) = V_healthy_original(:,:,:,i).*M_healthy_placenta_uterine_wall;
    ROI_pre_eclampsia_placenta_uterine_wall(:,:,:,i) = V_pre_eclampsia(:,:,:,i).*M_pre_eclampsia_placenta_uterine_wall;
end



