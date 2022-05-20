function [scaled, x_data, y_data, integrated_intensity, scaling_factor_used, ...
    delta_x_pixels, delta_y_pixels] = loc_file_reader2D(loc_filename, scaling_factor_method, scaling_factor) 
    
    data = readmatrix(loc_filename, 'FileType', 'text'); % ignores column titles in .loc4 file 
    
    x_data = data(:, 1); 
    y_data = data(:, 2);
    integrated_intensity = data(:, 3); 
    scaling_factor_used = 0; 
    
    if scaling_factor_method == "default"
        highest = max(integrated_intensity(:)); 
        div = floor(log10(highest)) - 3; % this corresponds to reducing order of magnitude by 3
        div = 10^div; 
        if (highest/div < 250)
            div = div/10; 
        end
        scaling_factor_used = div; 
        fprintf("\nUsing a script-generated scaling factor of %0.3f for the data.\n\n", scaling_factor_used) 
    elseif scaling_factor_method == "manual"
        scaling_factor_used = double(scaling_factor); 
        fprintf("\nUsing a user-generated scaling factor of %0.3f for the data.\n\n", scaling_factor_used) 
    end
    
    scaled = arrayfun(@(inten) inten/scaling_factor_used, integrated_intensity); 
    
    min_x = min(x_data(:)); 
    max_x = max(x_data(:)); 
    delta_x_pixels = max_x - min_x;
    
    min_y = min(y_data(:)); 
    max_y = max(y_data(:)); 
    delta_y_pixels = max_y - min_y;
        
    % save('loc_file_params.mat', 'scaled', 'x_data', 'y_data', 'integrated_intensity', 'scaling_factor_used', 'delta_x_pixels', 'delta_y_pixels'); 
end