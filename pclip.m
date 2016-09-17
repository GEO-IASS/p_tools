function imgout = pclip(imgin, scaleVal, scaleCenter, brightMatch)
%PCLIP clip image at bottom and top for distortion fun
% 
%   PCLIP(image) clips any values greater than 1 or less than 0 in image.
% 
%   PCLIP(image, scaleVal) scales the image by the specified factor away
%   from its mean brightness value, then clips it.
% 
%   PCLIP(image, scaleVal, scaleCenter) scales the image away from the
%   specified value. Entering an empty matrix here resumes the default behavior.
% 
%   PCLIP(image, scaleVal, scaleCenter, true) enables brightness matching -
%   the average brightness of the output image will be equal to that of the
%   input image. This is off by default.
% 
%   See also PRAND

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.17  * new program *
$$------------------------------------------------------------------$$
%}

[imgin, imgout] = deal(pview(imgin));

if nargin < 4
    brightMatch = false;
end

if nargin < 3
    scaleCenter = mean(mean(imgin.k));
end

if nargin == 1
    scaleVal = 1;
end

for j = 'rgb'
    imgout.(j) = (imgin.(j) - scaleCenter) .* scaleVal + scaleCenter;
end

imgout = pview(imgout);

for j = 'rgb'
    imgout.(j)(imgout.k >= 1) = 1 - rand(size(imgout.(j)(imgout.k >= 1))) .* 0.5;
    imgout.(j)(imgout.k < 0) = rand(size(imgout.(j)(imgout.k < 0))) .* 0.25;
end

imgout = pview(imgout);

if brightMatch
    for j = 'rgb'
        imgout.(j) = imgout.(j) - mean(mean(imgout.k)) + mean(mean(imgin.k));
    end
end

imgout = pview(imgout);

end