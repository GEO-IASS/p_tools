function imgout = pview(imgin)

imgout = imgin;

xtrim = repmat(sum(imgin.r + imgin.b + imgin.g, 2), 1, size(imgin.r, 2));
ytrim = repmat(sum(imgin.r + imgin.b + imgin.g, 1), size(imgin.r, 1), 1);

for j = 'rbg'
    imgout.(j)(xtrim == 0 | ytrim == 0) = [];
end

imgout.k = (imgout.r + imgout.b + imgout.g) ./ 3;

for j = 'rbg'
    imgout.(j)= reshape(imgout.(j), size(imgout.k));
end

imshow(cat(3, imgin.r, imgin.b, imgin.g))

end