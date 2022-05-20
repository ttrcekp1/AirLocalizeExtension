function [concentration_in_molar, volume_L] = ...
    concentration_calc_given_dimensions(total_molecules, voxel_X, voxel_Y, voxel_Zstep, delta_x_voxels, delta_y_voxels, delta_z_voxels)
    
    Xnm = voxel_X * delta_x_voxels;
    Ynm = voxel_Y * delta_y_voxels; 
    Znm = voxel_Zstep * delta_z_voxels; 
    
    volume_nL = Xnm * Ynm * Znm; 
    volume_L = volume_nL/1e27; 
    avogadro_number = 6.022e23; 
    mols = total_molecules/avogadro_number;  
    
    concentration_in_molar = mols/volume_L; 
    
end