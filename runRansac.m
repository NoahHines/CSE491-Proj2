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
    x1 = zeros(1,numMinutiae1);
    y1 = zeros(1,numMinutiae1);
    theta1 = zeros(1, numMinutiae1);
    x2 = zeros(1,numMinutiae2);
    y2 = zeros(1,numMinutiae2);
    theta2 = zeros(1, numMinutiae2);

    % Fill x,y,theta matrices with data from minutiae sets
    fid1 = fopen(filepath1,'rt');
    for i=1:numMinutiae1
        thisline = fgetl(fid1);
        %now check whether the string in thisline is a "word", and store it if it is.
        values=strsplit(thisline,'	');
        x1(i)=str2double(values(1));
        y1(i)=str2double(values(2));
        theta1(i)=str2double(values(3));
    end
    fclose(fid1);
    fid2 = fopen(filepath2,'rt');
    for i=1:numMinutiae2
        thisline = fgetl(fid2);
        %now check whether the string in thisline is a "word", and store it if it is.
        values=strsplit(thisline,'	');
        x2(i)=str2double(values(1));
        y2(i)=str2double(values(2));
        theta2(i)=str2double(values(3));
    end
    fclose(fid2);
        
    nMax = 0;
    x3=x1;
    y3=y1;
    
    finalDeltaX=0;
    finalDeltaY=0;
    finalDeltaTheta=0;
    
    for i=1:numMinutiae1
        for j=1:numMinutiae2
            % 1
            deltaX = x2(j) - x1(i);
            deltaY = y2(j) - y1(i);
            deltaTheta = wrapToPi(theta2(j) - theta1(i));
            
            % apply deltaX, deltaY, and deltaTheta to all points in 1
            % The new 1, P', is...
            %2
            for k=1:numMinutiae1
                x3(k) = ( (x1(k)-x1(i)) * cos(deltaTheta) + ( y1(k)-y1(i) ) * sin(deltaTheta) + x1(i) + deltaX);
                y3(k) = ( -(x1(k)-x1(i)) * sin(deltaTheta) + ( y1(k)-y1(i) ) * cos(deltaTheta) + y1(i) + deltaY);
            end
            
            % 3
            corrPoints = 0;
            for k=1:numMinutiae1
               if (abs(x1(k) - x3(k)) <= tolerance)
                   if (abs(y1(k) - y3(k)) <= tolerance)
                       % disp(['y1(k): ' num2str(y1(k)) ', y3(k): ' num2str(y3(k))]);
                       corrPoints = corrPoints + 1;
                   end
               end
            end
            if (corrPoints > nMax)
                finalDeltaX=deltaX;
                finalDeltaY=deltaY;
                finalDeltaTheta=deltaTheta;
                nMax = corrPoints;
            end
        end
    end

    matchScore = (nMax*nMax)/(numMinutiae1*numMinutiae2);
    
    output = ([filepath1 ' ' filepath2 ' ' num2str(finalDeltaX) ' ' num2str(finalDeltaY) ' ' num2str(finalDeltaTheta) ' ' num2str(nMax)]);
    
    % disp(['Match Score: ' num2str(matchScore)]);

end
    
    
    
    