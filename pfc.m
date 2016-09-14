function cout = pfc(fftin, normVal)
%PFC generate a color based on FFT contents and a normalization factor
% 
%   PFC(FFT, NormalizationValue) returns a color (R-G-B triplet) based on
%   the frequency breakdown of FFT, with overall brightness mediated by
%   NormalizationValue.
% 
%   See also PGEN, PRAND, PCREATE

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.11  * new program *
$$------------------------------------------------------------------$$
%}

fftin = fftin ./ normVal;

rFreqs = fftin(1:floor(length(fftin)/3)) ./ 1000;
gFreqs = fftin(ceil(length(fftin)/3):floor(length(fftin)*2/3)) ./ 1000;
bFreqs = fftin(ceil(length(fftin)*2/3):end) ./ 1000;

cout = [abs(sum(real(rFreqs))), abs(sum(real(gFreqs))), abs(sum(real(bFreqs)))];

end