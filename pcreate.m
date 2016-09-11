function imgout = pcreate(varargin)
%PCREATE make a blank image structure
% 
%   PCREATE(imageSize) returns a square image with width and height
%   dictated by imageSize and all pixels equal to zero.
% 
%   PCREATE(imageWidth, imageHeight) returns a blank image with the
%   specified width and height.
% 
%   PCREATE(image) returns an image with the same dimensions as image.
% 
%   PCREATE( ... , fillValue) returns an image with the
%   specified width, height, and fill color. If fillValue is a 3-element
%   vector, it will be allocated [RED BLUE GREEN].
% 
%   See also PSHIFT, PSORT, PINVERT, PRAND, PVIEW

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.10  * new program *
$$------------------------------------------------------------------$$
%}

%% input checking and parsing
narginchk(1,3)

[numParameterCount, structIn, imgw, imgh, fillnum] = deal(0);

for j = 1:length(varargin)
    switch class(varargin{j})
        case 'struct'
            [imgh, imgw] = size(varargin{j}.r);
            structIn = 1;
        case 'double'
            switch numParameterCount
                case 0
                    if structIn
                        fillnum = colorParse(varargin{j});
                    else
                        imgw = varargin{j};
                    end
                case 1
                    imgh = varargin{j};
                otherwise
                    fillnum = colorParse(varargin{j});
            end
            numParameterCount = numParameterCount + 1;
    end
end

if imgh == 0
    imgh = imgw;
end

if fillnum == 0
    fillnum = [0, 0, 0];
end

%% make new image
imgout = struct;
imgout.r = ones(imgh, imgw) .* fillnum(1);
imgout.b = ones(imgh, imgw) .* fillnum(2);
imgout.g = ones(imgh, imgw) .* fillnum(3);

imgout = pview(imgout);
end

function cout = colorParse(cin)
% local function which handles fill color inputs
switch length(cin)
    case 1
        cout = [cin, cin, cin];
    case 3
        cout = cin;
    otherwise
        error('Invalid color argument.')
end
end