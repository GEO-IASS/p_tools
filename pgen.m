function imgout = pgen(audioin, imgW, imgH, startXY)
%PGEN generate image from audio data
% 
%   PGEN(audio) creates a 750-by-750 image with a path iterated from the
%   center in a randomly chosen direction.
% 
%   PGEN(audio, size) creates a square image with the specified side length
%   (in pixel units).
% 
%   PGEN(audio, width, height) creates an image of arbitrary X/Y dimension.
% 
%   PGEN(audio, width, height, [startX, startY]) additionally specifies the
%   starting location of the path.
% 
%   See also PFC, PCREATE, PRAND, LOADAUDIO

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.13  * new program *
$$------------------------------------------------------------------$$
%}

narginchk(1,4)

if nargin < 2
    imgW = 750;
end

if nargin < 3
    imgH = imgW;
end

if nargin < 4
    startXY = fix([imgW/2, imgH/2]);
end

imgout = pcreate(imgW, imgH);
nSlices = length(audioin.right) / audioin.fs * 30;
k = floor(linspace(1, length(audioin.right), nSlices))';
c = 0 .* repmat(k, 1, 3);
c(end, :) = [];

[pthX, pthY] = deal((1:length(c))');
pthX = fix(pthX .* (randn + 1) + startXY(1)+ 50 * sind(pthX));
pthY = fix(pthY .* (randn + 1) + startXY(2)+ randn(size(pthY)));

for j = 1:100
    pthX(pthX > imgW) = 2 * imgW - pthX(pthX > imgW);
    pthY(pthY > imgH) = 2 * imgH - pthY(pthY > imgH);
    pthX(pthX < 1) = 1 - pthX(pthX < 1);
    pthY(pthY < 1) = 1 - pthY(pthY < 1);
end

for j = 1:length(c)
    sig = (audioin.right(k(j):k(j+1)) + audioin.left(k(j):k(j+1))) ./ 2;
    c(j, :) = pfc(fft(sig), max(sig)) + 0.25;
    imgout.r(pthY(j), pthX(j)) = c(j, 1);
    imgout.b(pthY(j), pthX(j)) = c(j, 2);
    imgout.g(pthY(j), pthX(j)) = c(j, 3);
end

imgout = pview(imgout);

end