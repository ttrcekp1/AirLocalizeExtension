function [molecules_rounded_above_zero, num_spots, total_molecules] = ...
    spot_quantification(x0, scaled)

    fprintf("\nUsing x0 = %f to quantify the molecules in the detected spots...\n", x0) 
    
    molecules = arrayfun(@(x) x/x0, scaled); 
    molecules_rounded = round(molecules); 
    total_molecules = sum(molecules_rounded(:)); 
    fprintf("\nNumber of molecules quantified: %d\n", total_molecules)
    above_zero_index_vector = molecules_rounded > 0; 
    molecules_rounded_above_zero = molecules_rounded(above_zero_index_vector);
    
    num_spots = length(molecules_rounded_above_zero(:)); 
    
end

        