% Steps: 

% 1. loc_file_reader
    % - Put data from .loc file into a matrix 
    % - Determine the smallest possible volume in pixels of a box that
    % encloses all data points
% 2. binning
    % - 
    
    

loc_filename = '/Users/lakshaysood/Desktop/JHU/Trcek_Lab/AIRLOCALIZE/examples/3DsmFISH_humCells_lakshay.loc4'; 
loc_filename = split(loc_filename, '/')
loc_filename = loc_filename{end}
filename_without_extension = split(loc_filename, '.');
filename_without_extension = filename_without_extension{1}

decision_tree(loc_filename, filename_without_extension, 'default', 10, 'default', 10)
