function write_output(filename_without_extension, x_data, y_data, z_data, ...
    intensity_data, scaled, molecules_rounded_above_zero)

    output_file_name = strcat(filename_without_extension, "_processed_data.txt");
    
    fileID = fopen(output_file_name, 'w'); 
    fprintf(fileID, 'x\ty\tz\tintensity\tscaled intensity\tnumber of molecules quantified\n'); 
    output_data = [x_data', y_data', z_data', intensity_data', scaled', molecules_rounded_above_zero']; 
    writematrix(output_data, output_file_name, 'Delimiter', 'tab'); 
    
    fprintf('\nProcessed data saved as %s\n', output_file_name); 
    
    fclose(fileID); 
end