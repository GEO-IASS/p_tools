function imgout = psort(imgin)
%PSORT funky pixel-sorting algorithm with arbitrary angle and path waviness
% 
%   PSORT(image) initiates a series of user prompts to sort specified
%   regions of pixels in an image. The user is given as many chances to
%   sort with different parameters as desired.
% 
%   See also PSHIFT, PINVERT, PRAND, PCREATE, PVIEW

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.09  * new program *
1.0.1   g.kaplan    2016.09.10  added help, upper and lower thresholds instead of dark/light modes
1.0.2   g.kaplan    2016.09.10  added wavelength parameter for extra sweg
$$------------------------------------------------------------------$$
%}

% show the original image
imgout = pview(imgin);

% allow user to try/retry as many times as it takes to get a cool result
sort = true;
while sort
    % some fun sorting parameters i discovered while trying and filing to make the core functionality work
    sortOptions = listdlg('PromptString', 'Options', 'ListString', {'Normal sort', 'Broken sort', 'Backward sort'}, 'InitialValue', 1);
    % important info comes in here
    params = inputdlg({'Upper threshold [0, 1]', 'Lower threshold [0, 1]', 'Sort direction (deg)', 'Waviness parameter [0, inf]', 'Wavelength (>0, px)'}, '', 1, {'1', '0', '0', '0', '360'});
    
    if isempty(params)
        % end the program if the user hits cancel
        return
    else
        % parse out inputs
        thresholdU = str2double(params{1});
        thresholdL = str2double(params{2});
        sortDir = str2double(params{3});
        sortWave = str2double(params{4});
        sortLambda = str2double(params{5});
        if thresholdU > 1 || thresholdL < 0
            % keep the idiots out - pixel values are between 0 and 1
            return
        else
            if thresholdU < thresholdL
                tmp = thresholdU;
                thresholdU = thresholdL;
                thresholdL = tmp;
            end
            % check out the local function below to see the nuts and bolts of it
            imgout = pixelsort(imgin, thresholdU, thresholdL, sortOptions, sortDir, sortWave, sortLambda);
        end
    end
    % mercifully allow the user to try again
    cont = questdlg('Would you like to sort differently?', '', 'No', 'Yes', 'No');
    if strcmp(cont, 'No')
        sort = false;
    end
end

end

function imgout = pixelsort(imgin, thresholdU, thresholdL, sortOptions, sortDir, sortWave, sortLambda)

imgout = imgin;

% allocate brightness map as a logical
kmap = false(size(imgin.k));

% "TRUE" pixels will get picked up and sorted.
kmap(imgin.k >= thresholdL & imgin.k <= thresholdU) = true;

% convert from degrees into useful units of slope
sortSlope = -tand(sortDir);

% stop the stupidity before it happens
if sortLambda == 0
    sortLambda = 360;
end

%% build the path - split into two options because that's what google told me to do
if abs(sortDir) < 45 || abs(sortDir - 180) < 45
    X = repmat((1:size(kmap, 2))', 4*size(kmap, 1)+1, 1);
    Y0 = sort(repmat((-size(kmap, 1):3*size(kmap, 1))', size(kmap, 2), 1));
    Y = fix(sortSlope .* X + sortWave .* sind(X .* 360 ./ sortLambda) + Y0);
    xc = [X, Y];
    condition = xc(:, 2) > size(kmap, 1) | xc(:, 2) < 1;
    xc(condition, :) = [];
else
    Y = sort(repmat((1:size(kmap, 1))', 4*size(kmap, 2)+1, 1));
    X0 = sort(repmat((-size(kmap, 2):3*size(kmap, 2))', size(kmap, 1), 1));
    X = fix(sortSlope .* Y + sortWave .* sind(Y .* 360 ./ sortLambda) + X0);
    xc = [X, Y];
    condition = xc(:, 1) > size(kmap, 2) | xc(:, 2) < 1;
    xc(condition, :) = [];
end

%% iterate through the path
i = 1;
pix = [];

wt = waitbar(0, 'Finding and sorting pixel values');

for j = 1:size(xc, 1)
    wt = waitbar(j/size(xc, 1), wt);
    if kmap(xc(j,2), xc(j,1)) && xc(j,2) ~= 1 && xc(j,2) ~= size(kmap, 1) && xc(j,1) ~= 1 && xc(j,1) ~= size(kmap, 2)
        % record all consecutive sort-able pixels that are not on the edges of the image
        pix(i, :) = [imgin.r(xc(j,2), xc(j,1)), imgin.b(xc(j,2), xc(j,1)), imgin.g(xc(j,2), xc(j,1))];
        i = i+1;
    else
        if ~isempty(pix)
            % the moment of truth: sorting the pixels
            if isempty(find(sortOptions==3, 1))
                pix = sort(pix, 1);
            else
                pix = sort(pix, 1, 'descend');
            end
            % iterate back with the sorted data - this is the slow part
            for l = 1:size(pix, 1)
                imgout.r(xc(j-l,2), xc(j-l,1)) = pix(l, 1);
                imgout.b(xc(j-l,2), xc(j-l,1)) = pix(l, 2);
                imgout.g(xc(j-l,2), xc(j-l,1)) = pix(l, 3);
            end
            i = 1;
            % broken sort is cool and all, but this step is critical for good-looking sorts
            if isempty(find(sortOptions==2, 1))
                pix = [];
            end
        end
    end
end

close(wt)

% show off the pretty picture
imgout = pview(imgout);

end