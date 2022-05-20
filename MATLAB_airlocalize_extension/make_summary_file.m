function make_summary_file(filename_without_extension, num_spots, ...
    total_molecules, volume, concentration, scaling_factor_used)

    summary_filename = strcat(filename_without_extension, '_summary_file.txt'); 
    fileID = fopen(summary_filename, 'w'); 
    fprintf(fileID, strcat('# Spots Detected', '\t', '# Molecules Quantified', ...
        '\t', 'Image volume', '\t', 'Concentration', '\t', 'Scaling factor', '\n')); 
    fprintf(fileID, strcat(num2str(num_spots), '\t', num2str(total_molecules), '\t', ...
        num2str(volume), '\t', num2str(concentration), '\t', num2str(scaling_factor_used))); 
    
    fclose(fileID); 
end