% Author Simon Ellershaw

classdef NonLinearOptimiser
    properties
        h=optimset('MaxFunEvals',20000,...
         'Algorithm','quasi-newton',...
         'TolX',1e-10,...
         'TolFun',1e-10,...
         'Display', 'off');
    end
    methods
        function [parameter,SSD] = model_to_voxel(obj, model_predict, Avox, bvals, TE, params)
            sumSquaredDif = @(x)sum((Avox - model_predict(x, bvals, TE)).^2);
            [parameter,SSD]=fminunc(sumSquaredDif, params, obj.h);
        end

        function [sorted_SSD, sorted_parameters] = multirun_exploritory(obj, model, voxel, bvals, TE, startx, pertubation_sigmas)
            % Uses large amount of runs. Allows calc of optimum multirun
            % parameters such as numLoops, startx and pertubation_sigmas
            % Setup variables
            num_loops = 100;
            saved_SSD = zeros(num_loops, 1);
            saved_parameters = zeros(num_loops, length(startx));
            
            for loopNum = 1:num_loops
                % Change starting point each loop to find multiple local
                % minima (and hopefully a global one)
                startx_itr = NonLinearOptimiser.pertubate_parameters(startx, pertubation_sigmas);
                [parameters, SSD] = obj.model_to_voxel(@model.predict, voxel, bvals, TE, startx_itr);
                saved_parameters(loopNum, :) = parameters;
                saved_SSD(loopNum) = SSD;       
            end
            % Sort SSD and parameters from best to worst
            [sorted_SSD,sortIdx] = sort(saved_SSD);
            sorted_parameters = saved_parameters(sortIdx, :);
        end


        function [parameter, best_SSD] = multirun_fast(obj, model, voxel, bvals, TE, start_params, num_loops, pertubation_sigmas)
            % Faster version of function above, designed for small numLoops 
            % Only stores best parameters and SSD
            best_SSD = realmax;
            parameter = ones(size(start_params))*realmax;
            for n = 1:num_loops
                % Change starting point each loop to find multiple local
                % minima (and hopefully a global one)
                start_params_itr = NonLinearOptimiser.pertubate_parameters(start_params, pertubation_sigmas);                
                [parameters_search, SSD] = obj.model_to_voxel(@model.predict, voxel, bvals, TE, start_params_itr);
             
                if SSD < best_SSD
                    parameter = model.to_param_space(parameters_search);
                    best_SSD = SSD;
                end
            end
        end

        function [parameter_map, best_SSD_map] = slice_multi_run(obj, model, slice_of_interest, bvals, TE, start_params, num_loops, pertubation_sigmas)
            % Performs fast multi run optimisation for each run in a slice
            % Setup variables
            slice_height = size(slice_of_interest, 1);
            slice_width = size(slice_of_interest, 2);
            parameter_map = zeros(length(start_params), slice_width, slice_height);
            best_SSD_map = ones(slice_width, slice_height, 1) * realmax;
            % Iterate over each pixel
            for row_num = 1:slice_height
                % Print out for sanity as this method can take time
                if mod(row_num, 10) == 0
                    row_num
                end
                for col_num = 1:slice_width
                    Avox = slice_of_interest(row_num, col_num, :);
                    Avox = reshape(Avox, [], 1); % reshape to column vector
                    % Skip all 0 pixels (outside ROI)
                    if(min(Avox) > 0)
                        [parameter_map(:, col_num, row_num), best_SSD_map(col_num, row_num)] = obj.multirun_fast(model, Avox, bvals, TE, start_params, num_loops, pertubation_sigmas);
                    end
                end
            end
            % Threshold for pixels outside of brain region or non
            % convergence
            best_SSD_map(best_SSD_map == realmax) = 0;
        end
    end
    methods(Static)
        function parameters_perturbed = pertubate_parameters(parameters, pertubation_sigmas)
            % Pertuabation by noise ~ maganitude of transformed parameter
            E = normrnd(0, pertubation_sigmas, size(parameters));
            parameters_perturbed = parameters + E;
        end
    end
end
