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
% imshow(flipud(squeeze(V_healthy(:,:,10,100))), []);
% title("healthy control");
% figure(2);
% imshow(flipud(squeeze(V_pre_eclampsia(:,:,8,100))), []);
% title("pre-eclampsia");
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
% figure(1);
% imshow(flipud(squeeze(M_healthy_placenta(:,:,10))), []);
% title("healthy placenta mask");
% figure(2);
% imshow(flipud(squeeze(M_healthy_placenta_uterine_wall(:,:,10))), []); % larger
% title("healthy placenta and uterine wall mask");
% figure(3);
% imshow(flipud(squeeze(M_pre_eclampsia_placenta(:,:,10))), []);
% title("pre-eclampsia placenta");
% figure(4);
% imshow(flipud(squeeze(M_pre_eclampsia_placenta_uterine_wall(:,:,10))), []);
% title("pre-eclampsia placenta and uterine wall mask");

%% Load and plot the MRI acquisition parameters
fileName_grad_echo = "data/grad_echo.txt";
grad_echo = importdata(fileName_grad_echo); 
% size: 330 * 5 [bvecs_x, bvecs_y, bvecs_z, b-values, echo-times]
% there are 330 rows in the gradient table
% it is equal to the fourth dimension of the loaded MRI volumes

%unique_b_values_number = numel(unique(grad_echo(:,4)));
%unique_echo_times_number = numel(unique(grad_echo(:,5)));

% 2D scatter plot 
% (echo times on the x-axis, b-values on y-axis)
%x = grad_echo(:,5);
%y = grad_echo(:,4);
%scatter(x,y);
%xlabel("echo times");
%ylabel("b-values");
%%

format shortG;
TE_vec = grad_echo(:,5);
q_hat = grad_echo(:,1:3);
bvals = grad_echo(:,4);

Avox = squeeze(V_healthy(100,50,7,:));

h = optimset('MaxFunEvals', 2000,...
    'Algorithm', 'quasi-newton',...
    'TolX', 1e-10,...
    'TolFun', 1e-10);

% order - S0, T2_star, D , f, D_p 4
startx = [10 6 5 5 4];
[parameter_hat,RESNORM,EXITFLAG,OUTPUT]=fminunc('IVIM',startx,h,Avox,bvals,TE_vec);


S0_map = zeros(size( V_healthy_original(:,:,7) ));
T2_map = zeros(size( V_healthy_original(:,:,7) ));
D_map = zeros(size( V_healthy_original(:,:,7) ));
f_map = zeros(size( V_healthy_original(:,:,7) ));
D_p_map = zeros(size( V_healthy_original(:,:,7) ));

S0_map_PE = zeros(size( V_healthy_original(:,:,7) ));
T2_map_PE = zeros(size( V_healthy_original(:,:,7) ));
D_map_PE = zeros(size( V_healthy_original(:,:,7) ));
f_map_PE = zeros(size( V_healthy_original(:,:,7) ));
D_p_map_PE = zeros(size( V_healthy_original(:,:,7) ));






k = 0;
for i = 1:200
    for j = 1:106
        if M_healthy_placenta_uterine_wall(i,j,7) == 1
            Avox = squeeze(V_healthy(i,j,7,:));
            [parameter_hat,RESNORM,EXITFLAG,OUTPUT]=fminunc('IVIM',startx,h,Avox,bvals,TE_vec);
            S0 = parameter_hat(1)^2;
            T2_star = 1/(1+parameter_hat(2)^2);
            D = 1/(1+parameter_hat(3)^2);
            f = 1/(1+parameter_hat(4)^2);
            D_p = D + 0.15/(1+parameter_hat(5)^2);
            S0_map(i,j) = S0;
            T2_map(i,j) = T2_star;
            D_map(i,j) = D;
            f_map(i,j) = f;
            D_p_map(i,j) = D_p;
            RESNORMS_map(i,j) = RESNORM;
%             k = k + 1;
%             if k == 50
%                 disp('Done j');
%                 break
%             end
        end
        
    end
%     if k == 50
%         disp('Done i');
%         break
%     end
end


%these are for the healthy maps!
%figure, imagesc(flipud(S0_map), [0 1600])
%figure, imagesc(flipud(D_map), [0 0.006])
%figure, imagesc(flipud(D_p_map), [0 1])
%figure, imagesc(flipud(f_map))
%figure, imagesc(flipud(T2_map))

figure, imagesc(flipud(squeeze(S0_map)), [0 2000]); 
title('Healthy S0 map');
axis image; caxis([0 2000]); 
colormap hot; 
colorbar;

figure, imagesc(flipud(squeeze(D_map)), [0 0.007]); 
title('Healthy D map');
axis image; caxis([0 0.007]); 
colormap hot; 
colorbar;

figure, imagesc(flipud(squeeze(D_p_map)), [0 0.2]); 
title('Healthy D_p map');
axis image; caxis([0 0.2]); 
colormap hot; 
colorbar;

figure, imagesc(flipud(squeeze(f_map)), [0 1]); 
title('Healthy f map');
axis image; caxis([0 1]); 
colormap hot; 
colorbar;

figure, imagesc(flipud(squeeze(T2_map)), [0 0.08]);
title('Healthy T2* map');
axis image; caxis([0 0.08]); 
colormap hot; 
colorbar;



Avox = squeeze(V_pre_eclampsia(100,50,7,:));

k = 0;
for i = 1:200
    for j = 1:102
        if M_pre_eclampsia_placenta_uterine_wall(i,j,7) == 1
            Avox = squeeze(V_pre_eclampsia(i,j,7,:));
            [parameter_hat,RESNORM,EXITFLAG,OUTPUT]=fminunc('IVIM',startx,h,Avox,bvals,TE_vec);
            S0 = parameter_hat(1)^2;
            T2_star = 1/(1+parameter_hat(2)^2);
            D = 1/(1+parameter_hat(3)^2);
            f = 1/(1+parameter_hat(4)^2);
            D_p = D + 0.15/(1+parameter_hat(5)^2);
            S0_map_PE(i,j) = S0;
            T2_map_PE(i,j) = T2_star;
            D_map_PE(i,j) = D;
            f_map_PE(i,j) = f;
            D_p_map_PE(i,j) = D_p;
            RESNORMS_map(i,j) = RESNORM;
%             k = k + 1;
%             if k == 50
%                 disp('Done j');
%                 break
%             end
        end
        
    end
%     if k == 50
%         disp('Done i');
%         break
%     end
end

%these are for the pre-eclampsia maps!
%figure, imagesc(flipud(S0_map), [0 1600])
%figure, imagesc(flipud(D_map), [0 0.006])
%figure, imagesc(flipud(D_p_map), [0 1])
%figure, imagesc(flipud(f_map))
%figure, imagesc(flipud(T2_map))


figure, imagesc(flipud(squeeze(S0_map_PE)), [0 2000]); 
title('Pre-Eclampsia S0 map');
axis image; caxis([0 2000]); 
colormap hot; 
colorbar;

figure, imagesc(flipud(squeeze(D_map_PE)), [0 0.007]); 
title('Pre-Eclampsia D map');
axis image; caxis([0 0.007]); 
colormap hot; 
colorbar;

figure, imagesc(flipud(squeeze(D_p_map_PE)), [0 0.2]); 
title('Pre-Eclampsia D_p map');
axis image; caxis([0 0.2]); 
colormap hot; 
colorbar;

figure, imagesc(flipud(squeeze(f_map_PE)), [0 1]); 
title('Pre-Eclampsia f map');
axis image; caxis([0 1]); 
colormap hot; 
colorbar;

figure, imagesc(flipud(squeeze(T2_map_PE)), [0 0.08]);
title('Pre-Eclampsia T2* map');
axis image; caxis([0 0.08]); 
colormap hot; 
colorbar;