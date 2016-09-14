function imgout = psine(imgin, channelSwitch)
%PSINE fit each channel of an image to a sin(xy) surface individually
% 
%   PSINE(image) fits all three channels of the image to their own sine functions.
% 
%   PSINE(image, [rSine, gSine, bSine]) sine-fits the specified
%   channel(s), where each channel switch value is a 1x1 logical.
% 
%   See also PTILT, PSORT, PSMOOTH

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.13  * new program *
$$------------------------------------------------------------------$$
%}

if nargin > 1 && islogical(channelSwitch)
    sineFit = struct('r', channelSwitch(1), 'g', channelSwitch(2), 'b', channelSwitch(3));
else
    sineFit = struct('r', true, 'g', true, 'b', true);
end

for j = 'rgb'
    if sineFit.(j)
        mu = fminsearch(@(x) sinfit(imgin, x, j), [100, 0, 100, 0]);
        [~, imgout] = sinfit(imgin, mu, j);
    end
end

imgout = pview(imgout);
end

function [err, sinefit] = sinfit(img, coeffs, channel)
% local function which subtracts nominal sine surface from image channel and returns rms error
sinefit = img;
[x, y] = meshgrid(1:img.height, 1:img.width);
x = x .* coeffs(1) + coeffs(2);
y = y .* coeffs(3) + coeffs(4);
z = 0.5 .* sin(x .* y) + 0.5;
err = mean(mean((img.(channel) - z).^2));
sinefit.(channel) = img.(channel)  - z;
end