function imgout = psum(imgin1, imgin2, addMode, opacity)
%PSUM add images using various transfer modes
% 
%   PSUM(image1, image2) averages the two images and returns the result.
% 
%   PSUM(image1, image2, addMode) applies the specified transfer mode to
%   the images being summed. Currently supported modes are:
% 
%       - Add
%       - Subtract
%       - Multiply
%       - Divide
%       - ColorBurn
%       - LinearBurn
%       - Screen
%       - ColorDodge
%       - LighterColor
%       - DarkerColor
% 
%   PSUM(image1, image2, addMode, opacity) allows you to set the opacity of
%   image2. Use values between 0 and 1 for normal-looking results, but who
%   am I to judge.
% 
%   See also PSHIFT, PSORT, PRAND, PINVERT, PROT, PVIEW

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.10  * new program *
1.0.1   g.kaplan    2016.09.11  fixed narginchk, added lighter/darker color modes
$$------------------------------------------------------------------$$
%}

%% inputs
narginchk(2,4)

if nargin == 2
    addMode = 'Add';
end

if nargin == 4 && isnumeric(opacity)
    for j = 'rbg'
        imgin2.(j) = imgin2.(j) .* opacity;
    end
end

imgout = imgin1;

%% add 'em up
switch addMode
    case 'Add'
        for j = 'rbg'
            imgout.(j) = (imgin1.(j) + imgin2.(j)) ./ 2;
        end
    case 'Subtract'
        for j = 'rbg'
            imgout.(j) = imgin1.(j) - imgin2.(j);
        end
    case 'Multiply'
        for j = 'rbg'
            imgout.(j) = imgin1.(j) .* imgin2.(j);
        end
    case 'Divide'
        for j = 'rbg'
            imgout.(j) = imgin1.(j) ./ imgin2.(j);
        end
    case 'ColorBurn'
        for j = 'rbg'
            imgout.(j) = 1 - (1 - imgin1.(j)) .* imgin2.(j);
        end
    case 'LinearBurn'
        for j = 'rbg'
            imgout.(j) = imgin1.(j) + imgin2.(j) - 1;
        end
    case 'Screen'
        for j = 'rbg'
            imgout.(j) = 1 - (1 - imgin2.(j)) .* (1 - imgin1.(j));
        end
    case 'ColorDodge'
        for j = 'rbg'
            imgout.(j) = imgin1.(j) ./ (1 - imgin2.(j));
        end
    case 'LighterColor'
        for j = 'rbg'
            temp.(j) = cat(3, imgin1.(j), imgin2.(j));
            imgout.(j) = max(temp.(j), [], 3);
        end
    case 'DarkerColor'
        for j = 'rbg'
            temp.(j) = cat(3, imgin1.(j), imgin2.(j));
            imgout.(j) = min(temp.(j), [], 3);
        end
    otherwise
        error('Unsupported transfer mode.')
end

%% show it off
imgout = pview(imgout);

end