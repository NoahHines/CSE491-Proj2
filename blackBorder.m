function [ orientation_image ] = blackBorder(filename)
%BLACKBORDER Summary of this function goes here
%   Detailed explanation goes here
    orientation_image = imread(filename);

    % Since the blocks are 9x9, we must clear a 4-pixel border for the
    % orientation image.
    InfoImage = imfinfo(filename);
    
    % black out top and bottom
    for i = 1:4
        for j = 1:InfoImage.Width
            orientation_image(i,j) = 0;
        end
    end
    for i = InfoImage.Height-4:InfoImage.Height
        for j = 1:InfoImage.Width
            orientation_image(i,j) = 0;
        end
    end
    
    % black out left and right
    for i = 1:InfoImage.Height
        for j = 1:4
            orientation_image(i,j) = 0;
        end
    end
    for i = 1:InfoImage.Height
        for j = InfoImage.Width-4:InfoImage.Width
            orientation_image(i,j) = 0;
        end
    end

end

