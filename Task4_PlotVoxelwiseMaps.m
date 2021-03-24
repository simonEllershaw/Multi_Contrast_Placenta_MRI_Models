function Task4_PlotVoxelwiseMaps(healthy, pre_eclampsia)
    
    % process the parameter S0
    S0_h = healthy(1,:,:);
    S0_pe = pre_eclampsia(1,:,:);
    [S0_h_noOutliers, S0_pe_noOutliers, S0_min, S0_max] = processParameters(S0_h, S0_pe);
    
    % process the parameter T2*
    T2_star_h = healthy(2,:,:);
    T2_star_pe = pre_eclampsia(2,:,:);
    [T2_star_h_noOutliers, T2_star_pe_noOutliers, T2_star_min, T2_star_max] = processParameters(T2_star_h, T2_star_pe);
    
    % process the parameter D
    D_h = healthy(3,:,:);
    D_pe = pre_eclampsia(3,:,:);
    [D_h_noOutliers, D_pe_noOutliers, D_min, D_max] = processParameters(D_h, D_pe);

    
    % Plot 
    % figure();
    t = tiledlayout(3,2); % use tiledlayout to make the plots tight and easy to compare
    
    % S0
    plot_results(1, 2, S0_h, S0_pe, S0_h_noOutliers, S0_pe_noOutliers, S0_min, S0_max, "S0");
    
    % T2*
    plot_results(3, 4, T2_star_h, T2_star_pe, T2_star_h_noOutliers, T2_star_pe_noOutliers, T2_star_min, T2_star_max, "T2^*");
    
    % D
    plot_results(5, 6, D_h, D_pe, D_h_noOutliers, D_pe_noOutliers, D_min, D_max, "ADC");
    
    % use tiledlayout to make the plots tight and easy to compare
    t.TileSpacing = 'none';
    t.Padding = 'none';
    
end