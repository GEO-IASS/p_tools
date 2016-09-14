function varargout = loadaudio(filename)
%LOADAUDIO load wav file into MATLAB structure
% 
%   LOADAUDIO opens a UIGETFILE window and returns the audio file selected
%   by the user in a formatted structure array.
% 
%   LOADAUDIO(filename) loads the specified audio file.
% 
%   See also LOADIMG, SAVEIMG, PGEN, PFC

%{
$$------------------------------------------------------------------$$
                           VERSION HISTORY
1.0.0   g.kaplan    2016.09.13  * new program *
$$------------------------------------------------------------------$$
%}

if nargin == 0
    [fn, pn] = uigetfile('*.wav');
    if isempty(fn)
        varargout = {};
        return
    end
    filename = fullfile(pn, fn);
end

[aud, Fs] = audioread(filename);

varargout = {struct('right', aud(:, 1), 'left', aud(:, 2), 'fs', Fs)};
end