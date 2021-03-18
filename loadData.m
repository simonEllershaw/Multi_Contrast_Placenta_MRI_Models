% Load the MRI volumes
% author: Yu (Simon Ellershaw removed plotting bits)

% Load MRI volumes
fileName_healthy = "data/pip0101_20_20_1401_T2MEdiff_abs.alle.nii";
fileName_pre_eclampsia = "data/pip0120_20_20_2501_T2MEdiff_abs.alle.nii";

V_healthy_original = niftiread(fileName_healthy); 
V_pre_eclampsia_original = niftiread(fileName_pre_eclampsia); 
% they are single-precision so far, convert them to double-precision arrays
V_healthy = double(V_healthy_original);   % size: 200, 106, 30, 330
V_pre_eclampsia = double(V_pre_eclampsia_original);  % size: 200, 102, 20, 330

fileName_healthy_placenta_mask = "data/pip0101_placenta_mask.nii.gz";
fileName_healthy_placenta_uterine_wall_mask = "data/pip0101_placenta_and_uterine_wall_mask.nii.gz";
fileName_pre_eclampsia_placenta_mask = "data/pip0120_placenta_mask.nii.gz";
fileName_pre_eclampsia_placenta_uterine_wall_mask = "data/pip0120_placenta_and_uterine_wall_mask.nii.gz";

M_healthy_placenta = double(niftiread(fileName_healthy_placenta_mask));
M_healthy_placenta_uterine_wall = double(niftiread(fileName_healthy_placenta_uterine_wall_mask));
M_pre_eclampsia_placenta = double(niftiread(fileName_pre_eclampsia_placenta_mask));
M_pre_eclampsia_placenta_uterine_wall = double(niftiread(fileName_pre_eclampsia_placenta_uterine_wall_mask));

Load and plot the MRI acquisition parameters
fileName_grad_echo = "data/grad_echo.txt";
grad_echo = importdata(fileName_grad_echo); 



