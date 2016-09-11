function imgout = prot(imgin, rotval)
%PROT rotate image
% 
%   Not recommended; uses IMROTATE from the image processing toolbox and
%   can create really large arrays. Use at your own RAM.
% 
%   PROT(image, rotationAngle) rotates the input image counterclockwise,
%   where rotationAngle is in degrees.
% 
%   See also PSORT, PINVERT, PSHIFT, PCREATE, PVIEW

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.09  * new program *
1.0.1   g.kaplan    2016.09.10  added help
$$------------------------------------------------------------------$$
%}

imgout = imgin;

imtemp = imrotate(cat(3, imgin.r, imgin.b, imgin.g), rotval);

imgout.r = imtemp(:, :, 1);
imgout.b = imtemp(:, :, 2);
imgout.g = imtemp(:, :, 3);

imgout = pview(imgout);

end