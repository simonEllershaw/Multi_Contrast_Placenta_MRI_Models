function [h_noOutliers, pe_noOutliers, parameter_min, parameter_max] = processParameters(parameter_h, parameter_pe)
    h_sorted = sort(parameter_h(:));
    pe_sorted = sort(parameter_pe(:));
    % Set upper bound as 10th highest value to handle outliers
    h_noOutliers = h_sorted(1:end-10);
    pe_noOutliers = pe_sorted(1:end-10);
    % use the same color scaling
    parameter_min = min(min(h_noOutliers(h_noOutliers~=0)), min(pe_noOutliers(pe_noOutliers~=0)));
    parameter_max = max(h_noOutliers(end), pe_noOutliers(end));

end