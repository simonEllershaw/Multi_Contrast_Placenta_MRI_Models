classdef Plotter
    methods(Static)
        function visualise_param_maps(param_maps, V_h_slice, V_pe_slice, param_labels, map_labels, param_units)
            % Extract size of map and setup plot
            num_maps = size(param_maps, 1);
            num_params = size(param_maps, 2);
            tiledlayout(num_params,num_maps);
            
            % Convert 2D slices into grayscale RGB array
            V_h_slice_rgb = double2rgb(flipud(V_h_slice), gray, []);
            % Zero pad so h and pe slices are the same size
            V_pe_slice_rgb = zeros(size(V_h_slice_rgb));
            V_pe_slice_rgb(1:size(V_pe_slice,1), 1:size(V_pe_slice,2), :) = double2rgb(flipud(V_pe_slice), gray, []);
            
            for param_num=1:num_params
                % Use same thresholding for plots of same parameter
                [param_min, param_max] = Plotter.thresholdParameters(param_maps(:,param_num,:,:));
                for map_num=1:num_maps
                    % Alternate which slice is the background
                    if mod(map_num,2)==1
                        slice_rgb = V_h_slice_rgb;
                    else
                        slice_rgb = V_pe_slice_rgb;
                    end
                    % Plot combined rgb map
                    map_combine = Plotter.calc_combined_map(flipud(squeeze(param_maps(map_num,param_num,:,:))'), slice_rgb, param_min, param_max);
                    nexttile;
                    imshow(map_combine)
                    if map_num == num_maps
                        colormap(hot);
                        caxis([param_min, param_max]);
                        cb = colorbar;
                        cb.Label.String = param_units(param_num);
                    end
                    if param_num == 1
                        title(map_labels(map_num));
                    end
                    if map_num == 1
                        ylabel(param_labels(param_num), 'Rotation',0);
                    end
                end
            end          
        end
        
        function map_combine = calc_combined_map(param_map, V_slice_rgb, param_min, param_max)
            % Parameter map to RGB array, using same scale for all maps
            % of same parameter
            map_combine = double2rgb(param_map, hot, [param_min, param_max]);
            for x =1:size(map_combine,1)
               for y=1:size(map_combine,2)
                  % If outside ROI use MRI scan as background 
                  if param_map(x,y) == 0
                     map_combine(x,y,:) = V_slice_rgb(x,y,:);
                  end
               end
            end
            % Crop to ROI
            map_combine = imcrop(map_combine,[0 50 100 110]);
        end
        
        function [param_min, param_max] = thresholdParameters(param_map)
            param_map_sorted = sort(param_map(:));
            % Set upper bound as nth highest value to handle outliers
            param_map_no_outliers = param_map_sorted(1:end-50);
            param_min = min(param_map_no_outliers(param_map_no_outliers~=0));
            param_max = param_map_no_outliers(end);
        end
        
        function box_plot_param_maps(param_maps, param_labels, map_labels, param_units)
            num_maps = size(param_maps, 1);
            num_params = size(param_maps, 2);
                        
            for param_num=1:num_params
                x = [];
                label = [];
                for map_num=1:num_maps
                    map = param_maps(map_num, param_num,:,:);
                    x = [x; map(map~=0)];
                    label = [label; repmat({map_labels(map_num)},length(map(map~=0)),1)];
                end
                % Use same thresholding for plots of same parameter
                subplot(num_params,1,param_num);
                boxplot(x,label);
                title(param_labels(param_num))
                ylabel('Values (' + param_units(param_num) + ')'); 
            end    
        end
    end
end

