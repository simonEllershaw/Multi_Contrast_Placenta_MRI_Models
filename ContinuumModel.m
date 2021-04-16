classdef ContinuumModel   
    methods(Static)
        
        function F = calc_spectrum(T2_values, D_values, ROI, bvals, TE)
            % Get average signal over all non zero voxels for each scan
            av_ROI = squeeze(sum(ROI,[1,2,3]) ./ sum(ROI~=0,[1,2,3]));
            n_s = length(av_ROI);
            n_t2 = length(T2_values);
            n_d = length(D_values);
            
            % Calculate Kernel
            K = zeros(n_s, n_d*n_t2);
            for s_i=1:n_s
                for t2_i=1:n_t2
                    for d_i=1:n_d
                        K(s_i, (t2_i-1)*n_d+d_i) = exp(-TE(s_i)/T2_values(t2_i))*exp(-bvals(s_i)*D_values(d_i));
                    end
                end
            end
            
            % Solve for F
            F = lsqnonneg(K,av_ROI);
            F = reshape(F, n_t2, n_d);
        end
    end
end

