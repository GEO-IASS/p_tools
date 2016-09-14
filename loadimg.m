function varargout = loadimg(filename)
%LOADIMG load image from file
% 
%   LOADIMG opens a UIGETFILE box and allows you to select an image to
%   load, then loads the image into a MATLAB structure object for use with
%   p_tools programs.
% 
%   LOADIMG(filename) loads the specified file as a p-strucure.
% 
%   See also SAVEIMG, PCREATE

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.09  * new program *
1.0.1   g.kaplan    2016.09.10  added help
1.0.2   g.kaplan    2016.09.13  added clean escape if user closes window
$$------------------------------------------------------------------$$
%}

if nargin == 0
    [filename, pathname] = uigetfile({'*.png;*.jpg;*.tif'});
    if isempty(filename)
        varargout = {};
        return
    end
    % unfortunately imread does not support full pathnames
    cd(pathname)
end

imgin = im2double(imread(filename));
imgout = struct('r', imgin(:, :, 1), ...
                'b',imgin(:, :, 2), ...
                'g', imgin(:, :, 3));

varargout = {pview(imgout)};

end