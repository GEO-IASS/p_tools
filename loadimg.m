function imgout = loadimg(filename)

if nargin == 0
    filename = uigetfile({'*.png;*.jpg;*.tif'});
end

imgin = im2double(imread(filename));
imgout = struct('r', imgin(:, :, 1), ...
                'b',imgin(:, :, 2), ...
                'g', imgin(:, :, 3));

imgout = pview(imgout);

end