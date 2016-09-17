function imgout = pswap(imgin, channelSpec)
%PSWAP swap channels in an image
% 
%   PSWAP(image, 'fw') moves the image's red channel to its green channel,
%   its green channel to its blue channel, and its blue back to its red.
%   This is the default behavior when no direction is specified.
% 
%   PSWAP(image, 'bw') moves the image's red channel to its blue channel,
%   its blue to its green, and its green to its red.
% 
%   PSWAP(image, 'rg') swaps the red and green channels in image.
% 
%   PSWAP(image, 'rb') swaps the red and blue channels in image.
% 
%   PSWAP(image, 'gb') swaps the green and blue channels in image.
% 
%   See also PINVERT

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.17  * new program *
$$------------------------------------------------------------------$$
%}

imgout = imgin;

if nargin == 1
    channelSpec = 'fw';
end

switch channelSpec
    case {'fw', true}
        imgout.r = imgin.b;
        imgout.g = imgin.r;
        imgout.b = imgin.g;
    case {'bw', false}
        imgout.r = imgin.g;
        imgout.g = imgin.b;
        imgout.b = imgin.r;
    case {'rg', 'gr'}
        imgout.r = imgin.g;
        imgout.g = imgin.r;
    case {'rb', 'br'}
        imgout.r = imgin.b;
        imgout.b = imgin.r;
    case {'gb', 'bg'}
        imgout.g = imgin.b;
        imgout.b = imgin.g;
end

imgout = pview(imgout);

end