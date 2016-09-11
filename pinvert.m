function imgout = pinvert(imgin, colorSwitch)
%PINVERT invert colors in an image
% 
%   PINVERT(image) inverts all three channels in the image.
% 
%   PINVERT(image, [invR invB invG]) inverts the specified channels, where
%   each inversion parameter is a logical TRUE or FALSE.
% 
%   See also PSHIFT, PSORT, PRAND, PCREATE, PVIEW

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.09  * new program *
1.0.1   g.kaplan    2016.09.10  added help, color switching
$$------------------------------------------------------------------$$
%}

%% inputs and default
narginchk(1,2)

[invR, invB, invG] = deal(true);

if nargin == 2 && islogical(colorSwitch) && length(colorSwitch) == 3
    invR = colorSwitch(1);
    invB = colorSwitch(2);
    invG = colorSwitch(3);
end

%% do the inversion
if invR
    imgin.r = 1 - imgin.r;
end

if invB
    imgin.b = 1 - imgin.b;
end

if invG
    imgin.g = 1 - imgin.g;
end

%% output
imgout = pview(imgin);

end