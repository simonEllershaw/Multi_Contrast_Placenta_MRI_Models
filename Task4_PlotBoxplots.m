function Task4_PlotBoxplots(healthy, pre_eclampsia, healthy_uterine_wall, pre_eclampsia_uterine_wall)
    % process the parameter S0
    S0_h = healthy(1,:,:);
    S0_pe = pre_eclampsia(1,:,:);
    S0_huw = healthy_uterine_wall(1,:,:);
    S0_peuw = pre_eclampsia_uterine_wall(1,:,:);
    % Set upper bound as 10th highest value to handle outliers
    [S0_h_noOutliers, S0_pe_noOutliers, ~, ~] = processParameters(S0_h, S0_pe);
    [S0_huw_noOutliers, S0_peuw_noOutliers, ~, ~] = processParameters(S0_huw, S0_peuw);
    
    % process the parameter T2*
    T2_star_h = healthy(2,:,:);
    T2_star_pe = pre_eclampsia(2,:,:);
    T2_star_huw = healthy_uterine_wall(2,:,:);
    T2_star_peuw = pre_eclampsia_uterine_wall(2,:,:);
    % Set upper bound as 10th highest value to handle outliers
    [T2_star_h_noOutliers, T2_star_pe_noOutliers, ~, ~] = processParameters(T2_star_h, T2_star_pe);
    [T2_star_huw_noOutliers, T2_star_peuw_noOutliers, ~, ~] = processParameters(T2_star_huw, T2_star_peuw);
    
    % process the parameter D
    D_h = healthy(3,:,:);
    D_pe = pre_eclampsia(3,:,:);
    D_huw = healthy_uterine_wall(3,:,:);
    D_peuw = pre_eclampsia_uterine_wall(3,:,:);
    % Set upper bound as 10th highest value to handle outliers
    [D_h_noOutliers, D_pe_noOutliers, ~, ~] = processParameters(D_h, D_pe);
    [D_huw_noOutliers, D_peuw_noOutliers, ~, ~] = processParameters(D_huw, D_peuw);

    
    figure();
    subplot(3,1,1);
    % since healthy control and pre-eclampsia data have different sizes
    x = [S0_h_noOutliers(S0_h_noOutliers~=0); S0_pe_noOutliers(S0_pe_noOutliers~=0); S0_huw_noOutliers(S0_huw_noOutliers~=0); S0_peuw_noOutliers(S0_peuw_noOutliers~=0)];
    s_label1 = repmat({'S0 Control'},length(S0_h_noOutliers(S0_h_noOutliers~=0)),1);
    s_label2 = repmat({'S0 PE'},length(S0_pe_noOutliers(S0_pe_noOutliers~=0)),1);
    s_label3 = repmat({'S0 Control(uterine wall)'},length(S0_huw_noOutliers(S0_huw_noOutliers~=0)),1);
    s_label4 = repmat({'S0 PE(uterine wall)'},length(S0_peuw_noOutliers(S0_peuw_noOutliers~=0)),1);
    s_labels = [s_label1; s_label2; s_label3; s_label4];
    boxplot(x,s_labels);
    title('S0')
    xlabel('Parameter S0');
    ylabel('Values');
    
    subplot(3,1,2);
    % since healthy control and pre-eclampsia data have different sizes
    x2 = [T2_star_h_noOutliers(T2_star_h_noOutliers~=0); T2_star_pe_noOutliers(T2_star_pe_noOutliers~=0); T2_star_huw_noOutliers(T2_star_huw_noOutliers~=0); T2_star_peuw_noOutliers(T2_star_peuw_noOutliers~=0)];
    t_label1 = repmat({'T2* Control'},length(T2_star_h_noOutliers(T2_star_h_noOutliers~=0)),1);
    t_label2 = repmat({'T2* PE'},length(T2_star_pe_noOutliers(T2_star_pe_noOutliers~=0)),1);
    t_label3 = repmat({'T2* Control(uterine wall)'},length(T2_star_huw_noOutliers(T2_star_huw_noOutliers~=0)),1);
    t_label4 = repmat({'T2* PE(uterine wall)'},length(T2_star_peuw_noOutliers(T2_star_peuw_noOutliers~=0)),1);
    t_labels = [t_label1; t_label2; t_label3; t_label4];
    boxplot(x2,t_labels);
    title('T2^*')
    xlabel('Parameter T2^*');
    ylabel('Values (s)');
    
    subplot(3,1,3);
    % since healthy control and pre-eclampsia data have different sizes
    D_h_noOutliers = rmoutliers(D_h(D_h~=0),"quartiles");
    D_pe_noOutliers = rmoutliers(D_pe(D_pe~=0),"quartiles");
    D_huw_noOutliers = rmoutliers(D_huw(D_huw~=0),"quartiles");
    D_peuw_noOutliers = rmoutliers(D_peuw(D_peuw~=0),"quartiles");
    
    x3 = [D_h_noOutliers(D_h_noOutliers~=0); D_pe_noOutliers(D_pe_noOutliers~=0); D_huw_noOutliers(D_huw_noOutliers~=0); D_peuw_noOutliers(D_peuw_noOutliers~=0)];
    d_label1 = repmat({'ADC Control'},length(D_h_noOutliers(D_h_noOutliers~=0)),1);
    d_label2 = repmat({'ADC PE'},length(D_pe_noOutliers(D_pe_noOutliers~=0)),1);
    d_label3 = repmat({'ADC Control(uterine wall)'},length(D_huw_noOutliers(D_huw_noOutliers~=0)),1);
    d_label4 = repmat({'ADC PE(uterine wall)'},length(D_peuw_noOutliers(D_peuw_noOutliers~=0)),1);
    d_labels = [d_label1; d_label2; d_label3; d_label4];
    boxplot(x3,d_labels);
    title('ADC')
    xlabel('Parameter ADC');
    ylabel('Values (10^-^3 mm^2s^-^1)');
    
end