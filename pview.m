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
1.0.2   g.kaplan    2016.09.11  removed trim due to all-black image complications
1.0.3   g.kaplan    2016.09.17  fixed image channel order
$$------------------------------------------------------------------$$
%}

imgout = imgin;

imgout.k = (imgout.r + imgout.b + imgout.g) ./ 3;

for j = 'rbg'
    imgout.(j)= reshape(imgout.(j), size(imgout.k));
end

[imgout.width, imgout.height] = size(imgout.k);

imshow(cat(3, imgin.r, imgin.g, imgin.b))

if nargout == 0
    varargout = {};
else
    varargout = {imgout};
end

end