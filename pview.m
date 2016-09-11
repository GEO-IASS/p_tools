function varargout = pview(imgin)
%PVIEW view image in p_tools format
% 
%   PVIEW(image) displays the specified image in the current figure.
% 
%   See also PCREATE, LOADIMG

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.09  * new program *
1.0.1   g.kaplan    2016.09.10  added help, output muting, width and height fields
$$------------------------------------------------------------------$$
%}

imgout = imgin;

xtrim = repmat(sum(imgin.r + imgin.b + imgin.g, 2), 1, size(imgin.r, 2));
ytrim = repmat(sum(imgin.r + imgin.b + imgin.g, 1), size(imgin.r, 1), 1);

for j = 'rbg'
    imgout.(j)(xtrim == 0 | ytrim == 0) = [];
end

imgout.k = (imgout.r + imgout.b + imgout.g) ./ 3;

for j = 'rbg'
    imgout.(j)= reshape(imgout.(j), size(imgout.k));
end

[imgout.width, imgout.height] = size(imgout.k);

imshow(cat(3, imgin.r, imgin.b, imgin.g))

if nargout == 0
    varargout = {};
else
    varargout = {imgout};
end

end