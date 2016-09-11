function saveimg(imgin, filename)
%SAVEIMG save images in p_tools format to file
% 
%   SAVEIMG(image) saves the specified image to file, using a UIPUTFILE
%   prompt to determine the filename.
% 
%   SAVEIMG(image, filename) saves the specified image with the specified filename.
% 
%   See also LOADIMG

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.09  * new program *
1.0.1   g.kaplan    2016.09.10  added help, manual filename
$$------------------------------------------------------------------$$
%}

if nargin < 2 || ~ischar(filename)
    [filename, pathname] = uiputfile('*.png');
    cd(pathname)
end

imwrite(cat(3, imgin.r, imgin.b, imgin.g), filename, 'png')

end