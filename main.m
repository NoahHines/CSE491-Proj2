% CSE491 Biometrics
% Project 2
% by Noah Hines
% Fall Semester 2016

% Part 1
for loop = 1:9
    computeOrientationField(['user00' int2str(loop) '_1']);
end
computeOrientationField('user010_1');

%Part 2
tolerance = 11.0;
files = {'user001_1.minpoints', 'user001_2.minpoints', 'user002_1.minpoints', 'user002_2.minpoints', 'user003_1.minpoints', 'user003_2.minpoints', 'user004_1.minpoints', 'user004_2.minpoints', 'user005_1.minpoints', 'user005_2.minpoints'};
combinations = zeros(length(files),length(files));
% run all possible pairings of minutiae files without repeats such as
% (1_1,1_2) and then (1_2,1_1).
for i=1:length(files)
    for j=1:length(files)
        if (i~=j && combinations(i,j)~= 1 && combinations(j,i)~= 1)
            disp(runRansac(['minutiae/' files{i}], ['minutiae/' files{j}], tolerance));
            combinations(i,j)=1;
        end
    end
end

% Part 3
generateRidgePattern([0 45 90 135]);
