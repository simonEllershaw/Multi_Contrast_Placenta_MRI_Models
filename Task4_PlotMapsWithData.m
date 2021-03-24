function Task4_PlotMapsWithData(healthy, pre_eclampsia, healthy_uterine_wall, pre_eclampsia_uterine_wall, V_healthy, V_pre_eclampsia)
    
    % process the parameter S0
    S0_h = healthy(1,:,:);
    S0_pe = pre_eclampsia(1,:,:);
    [S0_h_noOutliers, S0_pe_noOutliers, S0_min, S0_max] = processParameters(S0_h, S0_pe);
    S0_huw = healthy_uterine_wall(1,:,:);
    S0_peuw = pre_eclampsia_uterine_wall(1,:,:);
    [S0_huw_noOutliers, S0_peuw_noOutliers, S0_uw_min, S0_uw_max] = processParameters(S0_huw, S0_peuw);
    
    % process the parameter T2*
    T2_star_h = healthy(2,:,:);
    T2_star_pe = pre_eclampsia(2,:,:);
    [T2_star_h_noOutliers, T2_star_pe_noOutliers, T2_star_min, T2_star_max] = processParameters(T2_star_h, T2_star_pe);
    T2_star_huw = healthy_uterine_wall(2,:,:);
    T2_star_peuw = pre_eclampsia_uterine_wall(2,:,:);
    [T2_star_huw_noOutliers, T2_star_peuw_noOutliers, T2_star_uw_min, T2_star_uw_max] = processParameters(T2_star_huw, T2_star_peuw);
    
    
    % process the parameter D
    D_h = healthy(3,:,:);
    D_pe = pre_eclampsia(3,:,:);
    [D_h_noOutliers, D_pe_noOutliers, D_min, D_max] = processParameters(D_h, D_pe);
    D_huw = healthy_uterine_wall(3,:,:);
    D_peuw = pre_eclampsia_uterine_wall(3,:,:);
    [D_huw_noOutliers, D_peuw_noOutliers, D_uw_min, D_uw_max] = processParameters(D_huw, D_peuw);

    % slice 7, b=0, lowest TE: 78
    V_healthy_original = flipud(squeeze(V_healthy(:,:,7,1)));  % 200*106
    V_pre_eclampsia_original = flipud(squeeze(V_pre_eclampsia(:,:,7,1)));   % 200*102
    
    % Plot 
    % figure();
    t = tiledlayout(3,4); % use tiledlayout to make the plots tight and easy to compare
    
    % S0
    plot_resultsWithData(1, 2, S0_h, S0_pe, S0_h_noOutliers, S0_pe_noOutliers, S0_min, S0_max, "S0", V_healthy_original, V_pre_eclampsia_original, hot);
    plot_resultsWithData(1, 2, S0_huw, S0_peuw, S0_huw_noOutliers, S0_peuw_noOutliers, S0_uw_min, S0_uw_max, "S0", V_healthy_original, V_pre_eclampsia_original, hot);
    
    % T2*
    plot_resultsWithData(3, 4, T2_star_h, T2_star_pe, T2_star_h_noOutliers, T2_star_pe_noOutliers, T2_star_min, T2_star_max, "T2^*", V_healthy_original, V_pre_eclampsia_original, hot);
    plot_resultsWithData(3, 4, T2_star_huw, T2_star_peuw, T2_star_huw_noOutliers, T2_star_peuw_noOutliers, T2_star_uw_min, T2_star_uw_max, "T2^*", V_healthy_original, V_pre_eclampsia_original, hot);
    
    % D
    plot_resultsWithData(5, 6, D_h, D_pe, D_h_noOutliers, D_pe_noOutliers, D_min, D_max, "ADC", V_healthy_original, V_pre_eclampsia_original, hot);
    plot_resultsWithData(5, 6, D_huw, D_peuw, D_huw_noOutliers, D_peuw_noOutliers, D_uw_min, D_uw_max, "ADC", V_healthy_original, V_pre_eclampsia_original, hot);
    
    % use tiledlayout to make the plots tight and easy to compare
    t.TileSpacing = 'none';
    t.Padding = 'none';
    
end