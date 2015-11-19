% RunRansac!
% Sorry in advance for all of the file reading overhead. I was having a
% hard time with matlab and file reading.

function[output] = runRansac(filepath1, filepath2, tolerance)
    
    fid1 = fopen(filepath1,'rt');
    fid2 = fopen(filepath2,'rt');

    % Get numer of minutae
    numMinutiae1 = 0;
    while true
      thisline = fgetl(fid1);
      if ~ischar(thisline); break; end  %end of file
      numMinutiae1 = numMinutiae1+1;
    end
    fclose(fid1);
    numMinutiae2 = 0;
    while true
      thisline = fgetl(fid2);
      if ~ischar(thisline); break; end  %end of file
      numMinutiae2 = numMinutiae2+1;
    end
    fclose(fid2);

    % Initialize matrices for x,y,theta values for both minutiae sets
    Px = zeros(1,numMinutiae1);
    Py = zeros(1,numMinutiae1);
    Pt = zeros(1, numMinutiae1);
    Qx = zeros(1,numMinutiae2);
    Qy = zeros(1,numMinutiae2);
    Qt = zeros(1, numMinutiae2);

    % Fill x,y,theta matrices with data from minutiae sets
    fid1 = fopen(filepath1,'rt');
    for i=1:numMinutiae1
        thisline = fgetl(fid1);
        % Check whether the string in thisline is a "word", and store it if it is.
        values=strsplit(thisline,'	');
        Px(i)=str2double(values(1));
        Py(i)=str2double(values(2));
        Pt(i)=str2double(values(3));
    end
    fclose(fid1);
    fid2 = fopen(filepath2,'rt');
    for i=1:numMinutiae2
        thisline = fgetl(fid2);
        % Check whether the string in thisline is a "word", and store it if it is.
        values=strsplit(thisline,'	');
        Qx(i)=str2double(values(1));
        Qy(i)=str2double(values(2));
        Qt(i)=str2double(values(3));
    end
    fclose(fid2);
        
    x3=Px;
    y3=Py;
    
    nMax = 0;
    finalDeltaX=0;
    finalDeltaY=0;
    finalDeltaTheta=0;
    
    for i=1:numMinutiae1
        for j=1:numMinutiae2
            % 1
            deltaX = Qx(j) - Px(i);
            deltaY = Qy(j) - Py(i);
            deltaTheta = (Qt(j) - Pt(i))*3.141592654/180;
            
            % apply deltaX, deltaY, and deltaTheta to all points in 1
            % The new 1, P', is...
            %2
            for k=1:numMinutiae1
                x3(k) = ( (Px(k)-Px(i))* cos(deltaTheta) + ( (Py(k)-Py(i))*sin(deltaTheta)) + Px(i) + deltaX);
                y3(k) = (-(Px(k)-Px(i))*sin(deltaTheta) + ( (Py(k)-Py(i))*cos(deltaTheta)) + Py(i) + deltaY);
            end


            % 3
            
            % Calculate distance
            for k =  1:numMinutiae1
                for l = 1:numMinutiae2
                    dist(k,l) = sqrt( (x3(k)-Qx(l))^2 + (y3(k)-Qy(l))^2 );
                end
            end
            corrPoints = 0;
            [mini ind] = min(dist(:));
            while (mini <= tolerance)
                k = mod(ind-1, numMinutiae1)+1;
                l = ceil(ind/numMinutiae1);
                corrPoints = corrPoints + 1;
                dist(k,:)=10000;
                dist(:,l)=10000;
                [mini ind] = min(dist(:));
            end
            % Choose max number of corresponding points for reporting
            if (corrPoints > nMax)
                nMax = corrPoints;
                finalDeltaX = deltaX;
                finalDeltaY = deltaY;
                finalDeltaTheta = deltaTheta;
            end
        end
    end

    matchScore = (nMax*nMax)/(numMinutiae1*numMinutiae2);
    
    output = ([filepath1 ' ' filepath2 ' ' num2str(finalDeltaX) ' ' num2str(finalDeltaY) ' ' num2str(finalDeltaTheta) ' ' num2str(nMax) ' Match Score: ' num2str(matchScore)]);
    
    % disp(['Match Score: ' num2str(matchScore)]);

end
