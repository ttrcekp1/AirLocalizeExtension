function [concentration_in_molar, volume_L] = ...
    concentration_calc_given_volume(total_molecules, volume, volume_dimension)

    volume_L = volume * volume_dimension; 
    avogadro_number = 6.022e23; 
    mols = total_molecules/avogadro_number;  
    concentration_in_molar = mols/volume_L;
    
end