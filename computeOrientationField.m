% ComputerOrientationField
% by Noah Hines

function[] = computeOrientationField(filename)
    % Uncomment 'close all' to restore all images each run
    % close all;
    
    % Load image
    original_image = double(imread(['images/' filename '.gif']));
    % orientation image is initialized to be the same size as the original
    % image.
    orientation_image = double(blackBorder(['images/' filename '.gif']));
    
    % sobel
    s = fspecial('sobel');
    Gx = conv2(original_image, s); % x component of Sobel gradient
    Gy = conv2(original_image, s'); % y component 
    
    % Uncomment to check that border is okay
    % imshow(orientation_image);
    InfoImage = imfinfo(['images/' filename '.gif']);
    height = InfoImage.Height;
    width = InfoImage.Width;
    
    % x value is the horizontal position of the WxW block
    for x = 1:width-9
        for y = 1:height-9
            numerator=0.0;
            denominator=0.0;
            
            % calculate Sigma(i) Sigma(j) 2 Gx(i,j) Gy(i,j)... numerator
            % calculate Sigma(i) Sigma(j) Gx^2(i,j)-Gy^2(i,j)...
            for i = 1:9
                for j = 1:9
                    numerator = numerator + 2*Gx(y+j-1, x+i-1)*Gy(y+j-1, x+i-1);
                    denominator = denominator + double( Gx(y+j-1, x+i-1)*Gx(y+j-1, x+i-1) ) - double( Gy(y+j-1, x+i-1)*Gy(y+j-1, x+i-1) );
                end
            end
            % The final calculation within each 9x9 block...
            theta = 0.5 * double(atan2(numerator, denominator)) + 3.141592654/2.0;
            orientation_image(y,x) = theta;
        end
    end
    % Special thanks to Dr. Ross for this function
    drawOrientation(original_image, orientation_image, 8);
