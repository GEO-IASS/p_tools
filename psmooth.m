function imgout = psmooth(imgin, nPix)
%PSMOOTH convolution filtering using a 2-D gaussian filter
% 
%   PSMOOTH(image, nPixels) filters the provided image with a 2-D gaussian
%   filter, where nPixels is the standard deviation of the gaussian.
% 
%   See also PSHIFT, PSINE, PTILT, PSORT, PINVERT, PSUM

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.13  * new program *
1.0.1   g.kaplan    2016.09.17  switched to 'same' mode in conv2
$$------------------------------------------------------------------$$
%}

imgout = pview(imgin);

[radX, radY] = meshgrid(-nPix:nPix);

filt = exp((radX.^2 - radY.^2)/(2*nPix^2));

filt = filt ./ max(filt(:));

for j = 'rgb'
    imgout.(j) = conv2(imgin.(j), filt, 'same');
end

imax = max([max(max(imgout.r)), max(max(imgout.b)), max(max(imgout.g))]);

for j = 'rgb'
    imgout.(j) = imgout.(j) ./ imax;
end

imgout = pview(imgout);

end