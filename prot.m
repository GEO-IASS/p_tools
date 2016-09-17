function imgout = prot(imgin, rotval)
%PROT rotate image
% 
%   Angles that are not multiples of 90 not recommended; uses IMROTATE from
%   the image processing toolbox and can create really large arrays. Use at
%   your own RAM.
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
1.0.2   g.kaplan    2016.09.16  added fast & free method for multiples of 90
$$------------------------------------------------------------------$$
%}

imgout = imgin;

if rotval < 0
    rotval = rotval + 360;
end

if mod(rotval, 90) == 0
    for h = 1:rotval/90
        for j = 'rgb'
            imgout.(j) = fliplr(imgout.(j)');
        end
    end
else
    imtemp = imrotate(cat(3, imgin.r, imgin.b, imgin.g), rotval);

    imgout.r = imtemp(:, :, 1);
    imgout.b = imtemp(:, :, 2);
    imgout.g = imtemp(:, :, 3);
end

imgout = pview(imgout);

end