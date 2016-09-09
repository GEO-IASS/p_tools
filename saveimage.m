function saveimage(imgin)
filename = uiputfile('*.png');
imwrite(cat(3, imgin.r, imgin.b, imgin.g), filename)
end