function imgout = pshift(imgin, rshift, bshift, gshift) %#ok<INUSD>
%PSHIFT shift red, blue, and green channels in x and y directions
% 
%   PSHIFT(image, [rX, rY], [bX, bY], [gX, gY]) shifts the red channel in
%   image by rX pixels in the x direction (right is +x) and by rY pixels in
%   the y direction (down is +y), and similarly with the blue and green
%   channels. Empty values are padded with zeroes.
% 
%   See also PSORT, PINVERT, PRAND, PROT, PVIEW

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.09  * new program *
1.0.1   g.kaplan    2016.09.10  added help
$$------------------------------------------------------------------$$
%}

narginchk(4,4)

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