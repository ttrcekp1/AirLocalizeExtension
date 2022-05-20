function decision_tree(loc_filename, filename_without_extension, ...
    scaling_factor_method, scaling_factor, find_x0_method, user_x0, ~)

    fprintf("\nScaling factor method is: %s\n", scaling_factor_method)
    bin_width = 150; % temporary setting; user will be able to reset bin width if unsatisfactory later 
    x0_confirmed = false; 
    histo_confirmed = false; 
    x0_peak_chosen = false; 
    scaling_confirmed = false; 
    
    fprintf("\nfind_x0_method is: %s\n", find_x0_method)
    
    if strcmpi(find_x0_method, 'manual')
		x0_confirmed = true; 
		scaling_confirmed = true; 
		histo_confirmed = true; 
		x0_peak_chosen = true; 
		chosen_x0_value = user_x0; 
		print('x0 value of:', chosen_x0_value, 'was user-supplied. Skipping histogram generation...')
    end
    
    while ~x0_confirmed 
        while ~histo_confirmed % only accessible if find_x0_method is not manual 
            [scaled, x_data, y_data, z_data, intensity_data, scaling_factor_used, delta_x_voxels, ...
            delta_y_voxels, delta_z_voxels] = ...
            loc_file_reader3D(loc_filename, scaling_factor_method, scaling_factor);  % moved here to regenerate histogram with new inputs
        
            [bins, bin_counts] = binning(scaled, bin_width); 
            
            max_count = max(bin_counts); 
            
            bins_truncated = [0, bins(bin_counts >= 0.15 * max_count)]; % added 0 because you need 1 more bin edge to enclose all bin_counts data
            bin_counts_truncated = bin_counts(bin_counts >= 0.15 * max_count); 
            
            histogram('BinEdges', bins_truncated, 'BinCounts', bin_counts_truncated) 
            
            data_rescale_input = input("Should the data be re-scaled? y or n, ", 's'); 
            
            if strcmpi(data_rescale_input, 'n')
                scaling_confirmed = true; 
                rescale_data = false; 
                
            elseif strcmpi(data_rescale_input, 'y')
                user_scaling_factor_confirmed = false; 
              
                while ~user_scaling_factor_confirmed
                    fprintf("\nThe data was scaled with a scaling factor of %0.3f\n", scaling_factor_used)
                    user_scaling_factor = double(input("What new scaling factor should be used? Enter a number: ")); 
                    fprintf("\nNew scaling factor is: %0.3f\n", user_scaling_factor) 
                    scaling_factor_confirmation_input = input("Is the desired scaling factor correct? (type y or n) ", 's'); 
                    if strcmpi(scaling_factor_confirmation_input, 'y')
                        user_scaling_factor_confirmed = true; 
                        scaling_factor = user_scaling_factor; 
                        scaling_factor_method = 'manual'; 
                        rescale_data = true; 
                        close; 
                    end
                end 
                
                if user_scaling_factor_confirmed 
                    continue; 
                end
            else
                disp("Input not recognized")
            end
            
            if ~rescale_data
                histo_rebin_input = input("Should the histogram be rebinned? (type y or n) ", 's'); 
                if histo_rebin_input == 'n'
					histo_confirmed = true; 
					break
                    
                elseif strcmpi(histo_rebin_input, 'y')
					user_bin_width_confirmed = false; 
                    
					while ~user_bin_width_confirmed
						fprintf('Bin width used for binning the data was %f (arbitrary units)\n', bin_width)
						user_bin_width = input("What new bin width should be used? (enter a number) "); 
						fprintf('\nNew bin width entered is: %f\n', user_bin_width)
						bin_width_confirmation_input = input("Is the desired bin width correct? (type y or n) ", 's'); 
						if bin_width_confirmation_input == 'y'
							user_bin_width_confirmed = true; 
							bin_width = user_bin_width; 
							histo_confirmed = true; 
                        end
                    end
                end
            end    
        end    

        [x0_values, x0_locs] = findpeaks(bin_counts_truncated); 
        num_peaks = length(x0_values); 
        
        initial_x0_value = 0; 
        if ~isempty(x0_values) 
            initial_x0_value = x0_values(1);
        else 
            disp("No local maxima found in histogram")
        end
     
        chosen_x0_value = 0; 

        if num_peaks > 1
            fprintf("Number of peaks detected: %d\n", num_peaks)
            for i = 1:num_peaks
                fprintf("Peak %d value: %0.3f at %0.3f - %0.3f\n", i, x0_values(i), bins_truncated(x0_locs(i)), bins_truncated(x0_locs(i) + 1))
            end
            fprintf("First peak with value of: %0.3f at %0.3f - %0.3f selected as potential x0\n", initial_x0_value, bins_truncated(x0_locs(1)), bins_truncated(x0_locs(1) + 1))
        else
            initial_x0_value = x0_values; 
            fprintf("x0 detected at %0.3f with value: %0.3f\n", x0_locs(1), initial_x0_value)  
        end

        x0_satisfaction = false; 
        while ~x0_satisfaction 
            x0_satisfactory_usr_input = input("Are you satisfied with the x0? (type y or n) ", 's'); 
            if ~(strcmpi(x0_satisfactory_usr_input, 'y') | strcmpi(x0_satisfactory_usr_input, 'n'))
                disp('Input was not y or n')
                continue
            elseif strcmpi(x0_satisfactory_usr_input, 'y')
                chosen_x0_value = initial_x0_value; 
                x0_confirmed = true; 
                x0_satisfaction = true; 
            else 
                if num_peaks > 1
                    x0_choice_loop = true; 
                    while x0_choice_loop
                        rechoose_x0_choice = input("Do you want to choose a different x0? (type y or n) ", 's'); 
                        if ~(strcmpi(rechoose_x0_choice, 'y') | strcmpi(rechoose_x0_choice, 'n'))
                            disp('Input was not y or n') 
                            continue
                        elseif strcmpi(rechoose_x0_choice, 'y')
                            disp("Peaks found are: ") 
                            for i = 1:length(x0_values) 
                                fprintf("%d: %f at %f\n", i, x0_values(i), x0_locs(i))
                            end
              
                            chosen_x0_index = input("Which peak do you want to choose as x0? (Enter the peak number, i.e. 1, 2, 3,...")
                            if ~isnumeric(chosen_x0_index)
                                disp("Input not recognized. Enter a number")
                                continue
                            else
                                x0_satisfaction = true; 
                                x0_confirmed = true; 
                                chosen_x0_value = x0_values(chosen_x0_index); 
                                fprintf("The value of x0 you chose is: %f\n", chosen_x0_value)
                                x0_choice_loop = false; 
                            end
                        elseif strcmpi(rechoose_x0_choice, 'n')
                            histo_question_loop = true; 
                            while histo_question_loop 
                                histo_confirm_input = input("Should the histogram be re-binned? (type y or n) ", 's'); 
                                if ~(strcmpi(histo_confirm_input, 'y') | strcmpi(histo_confirm_input, 'n'))
                                    disp("Input not recognized. Type y or n")
                                    continue
                                elseif strcmpi(histo_confirm_input, 'y')
                                    user_bin_width_confirmed = false; 
                                    while ~user_bin_width_confirmed
                                        fprintf("Bin width used for binning the dataset was: %d (arbitrary units)\n", bin_width)
                                        user_bin_width = input("What new bin width should be used? Enter a number: ")
                                        fprintf("New bin width is %f", user_bin_width)
                                        bin_width_confirmation_input = input("Is the desired bin width correct? (type y or n) ", 's')
                                        if ~(strcmpi(bin_width_confirmation_input, 'y') | strcmpi(bin_width_confirmation_input, 'n'))
                                            disp("Input not recognized. Type y or n")
                                            continue
                                        elseif strcmpi(histo_confirm_input, 'y')
                                            user_bin_width_confirmed = true; 
                                            bin_width = user_bin_width; 
                                            histo_confirmed = false; 
                                            histo_question_loop = false; 
                                            continue
                                        end
                                    end
                                elseif strcmpi(histo_confirm_input, 'n')
                                    histo_question_loop = false; 
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    if strcmpi(find_x0_method, 'default')
        close
    end
    
    [molecules_rounded_above_zero, num_spots, total_molecules] = spot_quantification(chosen_x0_value, scaled); 
    
    dimensions_confirmed = false; 
    while ~dimensions_confirmed
        voxel_X = input("Enter the voxel length without dimensions: ");
        voxel_Y = input("Enter the voxel width without dimensions: ");
        voxel_Z = input("Enter the voxel height without dimensions: ");
        fprintf("\nThe dimensions you entered are: \nLength: %d nm\nWidth: %d nm\nHeight: %d nm\n", voxel_X, voxel_Y, voxel_Z)
        dimensions_confirm_input = input("Are those dimensions correct? (type y or n) ", 's'); 
        if strcmpi(dimensions_confirm_input, 'y')
            dimensions_confirmed = true; 
        end
    end    
    
    [concentration_in_molar, volume_L] = concentration_calc(total_molecules, voxel_X, voxel_Y, voxel_Z, delta_x_voxels, delta_y_voxels, delta_z_voxels); 
    
    write_output(filename_without_extension, x_data, y_data, z_data, intensity_data, scaled, molecules_rounded_above_zero)

	make_summary_file(filename_without_extension, num_spots, total_molecules, volume_L, concentration_in_molar, scaling_factor_used)
    
end