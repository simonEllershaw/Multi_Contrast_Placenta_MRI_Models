%% Load the MRI volumes
% author: Yu 
% Load MRI vloumes
fileName_healthy = "data/pip0101_20_20_1401_T2MEdiff_abs.alle.nii";
fileName_pre_eclampsia = "data/pip0120_20_20_2501_T2MEdiff_abs.alle.nii";

V_healthy_original = niftiread(fileName_healthy); 
V_pre_eclampsia_original = niftiread(fileName_pre_eclampsia); 
% they are single-precision so far, convert them to double-precision arrays
V_healthy = double(V_healthy_original);   % size: 200, 106, 30, 330
V_pre_eclampsia = double(V_pre_eclampsia_original);  % size: 200, 102, 20, 330
% [width, length, slice, echotime]?

%% Plot some image slices in the first, second and third spatial dimensions
% figure(1);
% imshow(flipud(squeeze(V_healthy(90,:,:,100))'), []);
% figure(2);
% imshow(flipud(squeeze(V_pre_eclampsia(90,:,:,100))'), []);
% 
% figure(3);
% imshow(flipud(squeeze(V_healthy(:,50,:,100))'), []);
% figure(4);
% imshow(flipud(squeeze(V_pre_eclampsia(:,50,:,100))'), []);

figure(1);
imshow(flipud(squeeze(V_healthy(:,:,10,100))), []);
title("healthy control");
figure(2);
imshow(flipud(squeeze(V_pre_eclampsia(:,:,8,100))), []);
title("pre-eclampsia");
%% Load masks
fileName_healthy_placenta_mask = "data/pip0101_placenta_mask.nii";
fileName_healthy_placenta_uterine_wall_mask = "data/pip0101_placenta_and_uterine_wall_mask.nii";
fileName_pre_eclampsia_placenta_mask = "data/pip0120_placenta_mask.nii";
fileName_pre_eclampsia_placenta_uterine_wall_mask = "data/pip0120_placenta_and_uterine_wall_mask.nii";

M_healthy_placenta = niftiread(fileName_healthy_placenta_mask);
M_healthy_placenta_uterine_wall = niftiread(fileName_healthy_placenta_uterine_wall_mask);
M_pre_eclampsia_placenta = niftiread(fileName_pre_eclampsia_placenta_mask);
M_pre_eclampsia_placenta_uterine_wall = niftiread(fileName_pre_eclampsia_placenta_uterine_wall_mask);

%% Plot some representative image slices of the placenta and uterine wall masks
figure(1);
imshow(flipud(squeeze(M_healthy_placenta(:,:,10))), []);
title("healthy placenta mask");
figure(2);
imshow(flipud(squeeze(M_healthy_placenta_uterine_wall(:,:,10))), []); % larger
title("healthy placenta and uterine wall mask");
figure(3);
imshow(flipud(squeeze(M_pre_eclampsia_placenta(:,:,10))), []);
title("pre-eclampsia placenta");
figure(4);
imshow(flipud(squeeze(M_pre_eclampsia_placenta_uterine_wall(:,:,10))), []);
title("pre-eclampsia placenta and uterine wall mask");

%% Load and plot the MRI acquisition parameters
fileName_grad_echo = "data/grad_echo.txt";
grad_echo = importdata(fileName_grad_echo); 
% size: 330 * 5 [bvecs_x, bvecs_y, bvecs_z, b-values, echo-times]
% there are 330 rows in the gradient table
% it is equal to the fourth dimension of the loaded MRI volumes

unique_b_values_number = numel(unique(grad_echo(:,4)));
unique_echo_times_number = numel(unique(grad_echo(:,5)));

% 2D scatter plot 
% (echo times on the x-axis, b-values on y-axis)
x = grad_echo(:,5);
y = grad_echo(:,4);
scatter(x,y);
xlabel("echo times");
ylabel("b-values");
