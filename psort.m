function imgout = psort(imgin, thresholds, sortOptions, sortDir, sortWave, sortLambda)
%PSORT funky pixel-sorting algorithm with arbitrary angle and path waviness
% 
%   PSORT(image) initiates a series of user prompts to sort specified
%   regions of pixels in an image. The user is given as many chances to
%   sort with different parameters as desired.
% 
%   PSORT(image, 'random') applies a random set of parameters to the sort
%   and shows you the result.
% 
%   PSORT(image, thresh_low) performs a horizontal sort with no waviness,
%   acting only on pixels with a higher value than thresh_low.
% 
%   PSORT(image, [thresh_low, thresh_high]) performs a straight, horizontal
%   sort using only pixels between the two specified brightness values.
% 
%   PSORT(image, [thresh_low, thresh_high], sortOptions) allows the user to
%   pick from several different sorting "modes" built into the program. The
%   syntax for sortOptions is as follows: a vector containing the code
%   values for each option the user wants to select. 1 or empty for normal
%   sorting, 2 for "broken" sorting, which prevents the pixel cache from
%   being cleared, 3 for "backward" sorting, which changes the direction in
%   which a given set of pixels are sorted, 4 for "messy" sorting, which
%   allows sort lines to cross the edges of the image, 5 for "dual band"
%   sorting, where pixels outside the range of specified threshold values
%   are sorted, as opposed to those inside the range.
% 
%   PSORT(image, [thresh_low, thresh_high], sortOptions, sortDir) allows
%   the user to specify a sorting angle (in degrees from the x axis).
% 
%   PSORT(image, [thresh_low, thresh_high], sortOptions, sortDir, sortWave)
%   adds a sine wave term into the sort path calculation, with amplitude
%   equal to sortWave (in pixels).
% 
%   PSORT(image, [thresh_low, thresh_high], sortOptions, sortDir, sortWave, sortLambda)
%   modifies the wavelength of the sine oscillation. Default is 360.
% 
%   See also PSHIFT, PINVERT, PRAND, PCREATE, PVIEW

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.09  * new program *
1.0.1   g.kaplan    2016.09.10  added help, upper and lower thresholds instead of dark/light modes
1.0.2   g.kaplan    2016.09.10  added wavelength parameter for extra sweg
1.0.3   g.kaplan    2016.09.13  actually made the high-angle sort work
1.0.4   g.kaplan    2016.09.16  high angles, for real...also messy sorting
1.0.5   g.kaplan    2016.09.17  added ability to pass arguments if you know what you want, hide rotated view for high angle sorting, dual band sort
$$------------------------------------------------------------------$$
%}

%%

switch nargin
    case 1
        % allow user to try/retry as many times as it takes to get a cool result
        sort = true;
        while sort
            % show the original image
            imgout = pview(imgin);
            % some fun sorting parameters i discovered while trying and filing to make the core functionality work
            sortOptions = listdlg('PromptString', 'Options', 'ListString', {'Normal sort', 'Broken sort', 'Backward sort', 'Messy sort', 'Dual band sort'}, 'InitialValue', 1);
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
    case 2
        if ischar(thresholds)
            thrs1 = 0.5 * rand;
            thrs2 = 0.5 * rand + 0.25;
            imgout = pixelsort(imgin, thrs1+thrs2, thrs1, [1, 4], rand*180, randi(40), randi(400)+100);
        elseif isnumeric(thresholds) && length(thresholds) == 2
            imgout = pixelsort(imgin, max(thresholds), min(thresholds), 1, 0, 0, 360);
        end
    case 3
        imgout = pixelsort(imgin, max(thresholds), min(thresholds), sortOptions, 0, 0, 360);
    case 4
        imgout = pixelsort(imgin, max(thresholds), min(thresholds), sortOptions, sortDir, 0, 360);
    case 5
        imgout = pixelsort(imgin, max(thresholds), min(thresholds), sortOptions, sortDir, sortWave, 360);
    case 6
        imgout = pixelsort(imgin, max(thresholds), min(thresholds), sortOptions, sortDir, sortWave, sortLambda);
    otherwise
        narginchk(1,6)
end

end

function imgout = pixelsort(imgin, thresholdU, thresholdL, sortOptions, sortDir, sortWave, sortLambda)

sortDir = mod(sortDir, 180);

if abs(sortDir) > 45 && abs(180 - sortDir) > 45
    fig1 = figure('Visible', 'off');
    [imgin, imgout] = deal(prot(imgin, 90));
    close(fig1)
    sortDir = sortDir - 90;
    rot = true;
else
    imgout = imgin;
    rot = false;
end

if thresholdL == thresholdU
    thresholdU = 1;
end

% allocate brightness map as a logical
kmap = false(size(imgin.k));

% "TRUE" pixels will get picked up and sorted.
if isempty(find(sortOptions==5, 1))
    kmap(imgin.k >= thresholdL & imgin.k <= thresholdU) = true;
else
    kmap(imgin.k <= thresholdL | imgin.k >= thresholdU) = true;
end

% messy sort happens here
if isempty(find(sortOptions==4, 1))
    [kmap(1, :), kmap(:, 1), kmap(end, :), kmap(:, end)] = deal(false);
else
    kmap(imgin.k >= 0.99 | imgin.k <= 0.01) = false;
end

% convert from degrees into useful units of slope
sortSlope = -tand(sortDir);

% stop the stupidity before it happens
if sortLambda == 0
    sortLambda = 360;
end

%% build the path
X = repmat((1:size(kmap, 2))', 4*size(kmap, 1)+1, 1);
Y0 = sort(repmat((-size(kmap, 1):3*size(kmap, 1))', size(kmap, 2), 1));
Y = fix(sortSlope .* X + sortWave .* sind(X .* 360 ./ sortLambda) + Y0);
xc = [X, Y];

condition = xc(:, 1) > size(kmap, 2) | xc(:, 1) < 1 | xc(:, 2) > size(kmap, 1) | xc(:, 2) < 1;
xc(condition, :) = [];

%% iterate through the path
i = 1;
pix = [];

wt = waitbar(0, 'Finding and sorting pixel values');

for j = 1:size(xc, 1)
    wt = waitbar(j/size(xc, 1), wt);
    if kmap(xc(j,2), xc(j,1))
        % record all consecutive sort-able pixels that are not on the edges of the image
        pix(i, :) = [imgin.r(xc(j,2), xc(j,1)), imgin.b(xc(j,2), xc(j,1)), imgin.g(xc(j,2), xc(j,1))]; %#ok<AGROW>
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
if rot
    imgout = prot(imgout, -90);
else
    imgout = pview(imgout);
end

end