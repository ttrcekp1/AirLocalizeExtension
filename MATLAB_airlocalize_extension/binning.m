function [bins, bin_counts] = binning(scaled, bin_width) 
    max_scaled = max(scaled(:)); 
    bm = floor(max_scaled/bin_width) * bin_width + bin_width; 
    bins = bin_width/2:bin_width:bm + bin_width/2; 
    [bin_counts, ~] = histcounts(scaled, bins);
end