% 
disp('Part 1');

% for loop = 1:9
%     computeOrientationField(['user00' int2str(loop) '_1']);
% end
% computeOrientationField('user010_1');

disp('Part 2');
tolerance = 11.0;

combinations = zeros(10,10);
for i=1:5
    for j=1:5
        if ((combinations(i,j)~=1)&&(combinations(j,i)~=1))
            if (i~=j)
                disp(runRansac(['minutiae/user00' num2str(i) '_1.minpoints'], ['minutiae/user00' num2str(j) '_1.minpoints'], tolerance));
                disp(runRansac(['minutiae/user00' num2str(i) '_2.minpoints'], ['minutiae/user00' num2str(j) '_2.minpoints'], tolerance));
            end
            disp(runRansac(['minutiae/user00' num2str(i) '_1.minpoints'], ['minutiae/user00' num2str(j) '_2.minpoints'], tolerance));
            combinations(i,j) = 1;
        end
    end
end

% disp('Part 3');

% generateRidgePattern([0 45 90 135]);
