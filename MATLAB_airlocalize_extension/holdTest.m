loc_filename = '/Users/lakshaysood/Desktop/JHU/Trcek_Lab/AIRLOCALIZE/examples/3DsmFISH_humCells_spots.loc4'; 
scaling_factor_method = "default"; 
scaling_factor = 150; 

[scaled, x_data, y_data, z_data, integrated_intensity, scaling_factor_used, ...
    delta_x_pixels, delta_y_pixels, delta_z_pixels] = loc_file_reader3D(loc_filename, scaling_factor_method, scaling_factor);

[bins, binCounts] = binning(scaled, 200); 

twoDGaussian = @ (x, A1, mu1, sigma1, A2, mu2, sigma2) A1 * exp(-((x - mu1)/(2 * sigma1)).^2) + A2 * exp(-((x - mu2)/(2 * sigma2)).^2); 

twoDGaussianFit = feval(twoDGaussian, 1:0.1:max(bins(:)), 70, 700, 600, 20, 1900, 200); 


f = figure(); 
ax = gca;
histogram(ax, 'BinEdges', bins, 'BinCounts', binCounts) 

hold(ax, 'on') 
x = 1:0.1:max(bins); 
plot(x, twoDGaussianFit) 
hold off 