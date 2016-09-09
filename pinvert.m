function imgout = pinvert(imgin)
imgin.r = 1 - imgin.r;
imgin.b = 1 - imgin.b;
imgin.g = 1 - imgin.g;
imgout = pview(imgin);
end