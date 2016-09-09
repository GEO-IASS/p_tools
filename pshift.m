function imgout = pshift(imgin, rshift, bshift, gshift) %#ok<INUSD>

imgout = imgin;

for j = 'rbg'
    eval(['shift = ', j, 'shift;'])
    shift = fix(shift);
    padx = zeros(size(imgout.k, 1), abs(shift(1)));
    pady = zeros(abs(shift(2)), size(imgout.k, 2));
    if shift(1) > 0
        imgout.(j) = [padx, imgin.(j)(:, 1:end-shift(1))];
    elseif shift(1) < 0
        imgout.(j) = [imgin.(j)(:, abs(shift(1))+1:end), padx];
    end
    if shift(2) > 0
        imgout.(j) = [pady; imgin.(j)(1:end-shift(2), :)];
    elseif shift(2) < 0
        imgout.(j) = [imgin.(j)(abs(shift(2))+1:end, :); pady];
    end
end

imgout = pview(imgout);

end