function[] = computeOrientationField(filename)
    close all;
    % Load image
    original_image = double(imread(['images/' filename '.gif']));
    % orientation image is initialized to be the same size as the original
    % image.
    orientation_image = double(blackBorder(['images/' filename '.gif']));
    
    % sobel
    s = [1 2 1; 0 0 0; -1 -2 -1];
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
            
            % calculate Sigma(i) Sigma(j) 2 Gx(i,j) Gy(i,j)... numerator
            % calculate Sigma(i) Sigma(j) Gx^2(i,j)-Gy^2(i,j)...
            % denominator
            GxSum = 0;
            GySum = 0;
            for i = 1:9
                for j = 1:9
                    GxSum = GxSum + Gx(y+j, x+i);
                    GySum = GySum + Gy(y+j, x+i);
                end
            end
            
            % The final calculation within each 9x9 block...
            theta = 0.5 * atan(double((2*GxSum*GySum))/double((GxSum*GxSum - GySum*GySum)));
            orientation_image(y,x) = theta;
            
        end
    end
    
    figure;
    imshow(orientation_image);
    
    size(orientation_image)
    size(original_image)
       
    drawOrientation(original_image, orientation_image, 9);
    
    
    

