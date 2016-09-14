function imgout = ptilt(imgin, channelSwitch)
%PTILT tilt-fit each channel of an image individually
% 
%   PTILT(image) removes tilt from all three channels of the image.
% 
%   PTILT(image, [rDetilt, gDetilt, bDetilt]) tilt-fits the specified
%   channel(s), where each channel switch value is a 1x1 logical.
% 
%   See also PSINE, PSORT, PSMOOTH

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.13  * new program *
$$------------------------------------------------------------------$$
%}

if nargin > 1 && islogical(channelSwitch)
    tilt = struct('r', channelSwitch(1), 'g', channelSwitch(2), 'b', channelSwitch(3));
else
    tilt = struct('r', true, 'g', true, 'b', true);
end

for j = 'rgb'
    if tilt.(j)
        mu = fminsearch(@(x) tiltfit(imgin, x, j), [0, 0, 0]);
        [~, imgout] = tiltfit(imgin, mu, j);
    end
end

imgout = pview(imgout);
end

function [err, tiltfit] = tiltfit(img, coeffs, channel)
% local function which adjusts overall tilt of the pixel values and returns rss "height"
tiltfit = img;
[x, y] = meshgrid(1:img.height, 1:img.width);
z = x .* coeffs(1) + y .* coeffs(2) + coeffs(3);
err = mean(mean((img.(channel) - z).^2));
tiltfit.(channel) = img.(channel)  - z;
end