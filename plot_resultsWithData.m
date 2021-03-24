function plot_resultsWithData(h_id, pe_id, h_parameter, pe_parameter, h_noOutliers, pe_noOutliers, parameter_min, parameter_max, parameter_name, V_healthy, V_pre_eclampsia, cmap)
    
    V_healthy_rgb = double2rgb(V_healthy, gray, []);
    V_pre_eclampsia_rgb = double2rgb(V_pre_eclampsia, gray, []);
    
    h = flipud(squeeze(h_parameter)'); % 200*106
    pe = flipud(squeeze(pe_parameter)'); % 200*102
    h_rgb = double2rgb(h, cmap, [parameter_min, parameter_max]); % 200*106*3
    pe_rgb = double2rgb(pe, cmap, [parameter_min, parameter_max]); % 200*102*3
    
    h_combine = zeros(size(h_rgb));
    for x =1:size(h,1)
       for y=1:size(h,2)
          if  h(x,y)==0
             % black area
             h_combine(x,y,:) = V_healthy_rgb(x,y,:);
          else
             h_combine(x,y,:) = h_rgb(x,y,:);
          end
       end
    end
    
    pe_combine = zeros(size(pe_rgb));
    for x =1:size(pe,1)
       for y=1:size(pe,2)
          if  pe(x,y)==0
             % black area
             pe_combine(x,y,:) = V_pre_eclampsia_rgb(x,y,:);
          else
             pe_combine(x,y,:) = pe_rgb(x,y,:);
          end
       end
    end
    
    % clip the images focus on the center
    h_combine_clip = imcrop(h_combine,[0 50 100 110]);
    pe_combine_clip = imcrop(pe_combine,[0 50 100 110]);
    
    % Plot
    %subplot(3,2,h_id);
    nexttile;
    imshow(h_combine_clip)
    title(append(parameter_name," healthy"));
    
    %subplot(3,2,pe_id);
    nexttile;
    imshow(pe_combine_clip)
    title(append(parameter_name," pre-eclampsia"));
    
%     colormap(hot);
%     caxis([parameter_min, parameter_max]);
%     cb = colorbar;
%     cb.Layout.Tile = 'east';
end