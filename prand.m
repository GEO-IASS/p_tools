function imgout = prand(imgin, varargin)
%PRAND generate noise in an image, with blocks of arbitrary size
% 
%   PRAND(image) fills each pixel in image with random red, blue and green values.
% 
%   PRAND( ... , 'Size', nBlocks) fills the image with a randomly-colored
%   gradient, with nBlocks color points in both the x and y directions.
% 
%   PRAND( ... , 'Size', [xBlocks yBlocks]) fills the image with a
%   randomly-colored gradient, with predictable divisions in the x and y
%   directions.
% 
%   PRAND( ... 'Color', [upperLimit lowerLimit]) sets high and low limits
%   for each randomly-generated channel value.

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.10  * new program *
$$------------------------------------------------------------------$$
%}

%% inputs
narginchk(1,5)

imgout = pview(imgin);

boxes = [imgout.width, imgout.height];
clim = [0, 1];

if nargin > 1
    for j = 1:length(varargin)
        if ischar(varargin{j}) && length(varargin) > j
            switch varargin{j}
                case {'Size', 'size', 's'}
                    if isnumeric(varargin{j+1})
                        switch length(varargin{j+1})
                            case 1
                                boxes = [varargin{j+1}, varargin{j+1}];
                            case 2
                                boxes = varargin{j+1};
                            otherwise
                                error('Unsupported block dimension.')
                        end
                    end
                case {'Color', 'color', 'c'}
                    if isnumeric(varargin{j+1})
                        if length(varargin{j+1}) == 2
                            clim = varargin{j+1};
                        else
                            error('Unsupported number of color parameters.')
                        end
                    end
                otherwise
                    error('Unsupported input parameter.')
            end
        end
    end
end

if sum(boxes) < 4
    boxes = [2, 2];
end

%% let the randomness commence
rmat = rand(boxes(1), boxes(2)) .* (max(clim) - min(clim)) + min(clim);
bmat = rand(boxes(1), boxes(2)) .* (max(clim) - min(clim)) + min(clim);
gmat = rand(boxes(1), boxes(2)) .* (max(clim) - min(clim)) + min(clim);

[bxx, bxy] = meshgrid(linspace(0, boxes(2), boxes(2)), linspace(0, boxes(1), boxes(1)));

bxx = bxx ./ boxes(2) .* imgout.height;
bxy = bxy ./ boxes(1) .* imgout.width;

[ixx, ixy] = meshgrid(1:imgout.height, 1:imgout.width);

RSI = scatteredInterpolant(bxx(:), bxy(:), rmat(:));
BSI = scatteredInterpolant(bxx(:), bxy(:), bmat(:));
GSI = scatteredInterpolant(bxx(:), bxy(:), gmat(:));

imgout.r = RSI(ixx, ixy);
imgout.b = BSI(ixx, ixy);
imgout.g = GSI(ixx, ixy);

%% show off that pretty picture
imgout = pview(imgout);

end