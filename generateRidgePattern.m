% GenerateRidgePattern!


function[] = generateRidgePattern(theta)
    close all;
    % w(x,y) = A cos[ 2pi f(x cos theta + y sin theta) ]

    % w(x,y) = 128 * cos[ 2pi 0.1*(x cos theta + y sin theta) ]
    for i=1:length(theta)
        theta(i)
        t = theta(i)*3.141592654/180;
        for x=1:300
            for y=1:300
                image(x,y) =  128 * cos( 2*pi*0.1*(x*cos(t) + y*sin(t)) );
            end
        end
        imwrite(image,['output/ridgePatterns/ridgepattern-' num2str(theta(i)) '.jpg']);
        
        %fft
        fftImg = fft2(image);
        fftImg = fftshift(log(abs(fftImg) + 1));
        
        % imwrite does not seem to work with normalized images!?
        % imwrite(fftImg,['output/ridgePatterns/fftridgepattern-' num2str(theta(i)) '.png'],'bitdepth',16);
        % instead I will manually use imshow and save.
        % imshow(fftImg, []); %Uncomment for manual image saving
    end
end
