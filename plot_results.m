function plot_results(h_id, pe_id, h_parameter, pe_parameter, h_noOutliers, pe_noOutliers, parameter_min, parameter_max, parameter_name)
    %subplot(3,2,h_id);
    nexttile;
    imagesc(flipud(squeeze(h_parameter)'), [0 h_noOutliers(end)]);
    axis image;
    caxis([parameter_min parameter_max]);
    colormap hot;
    colorbar;
    title(append(parameter_name," healthy"));
    
    %subplot(3,2,pe_id);
    nexttile;
    imagesc(flipud(squeeze(pe_parameter)'), [0 pe_noOutliers(end)]);
    axis image;
    caxis([parameter_min parameter_max]);
    colormap hot;
    colorbar;
    title(append(parameter_name," pre-eclampsia"));
end
