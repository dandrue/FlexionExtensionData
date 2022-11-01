function [lpfilt, hpfilt]= ExampleEMG_Filter(raw,samplefreq,CO_hp,CO_lp)
% Filters raw EMG by highpass filtering, rectifying and lowpass
% filtering as proposed by:

%Staudenmann, D., Potvin, J.R., Kingma, I., Stegeman, D.F., van Dieen,
%J.H., 2007. Effects of EMG processing on biomechanical models of muscle
%joint systems: Sensitivity of trunk muscle moments, spinal forces, and
%stability. Journal of Biomechanics 40 (4), 900-909.


if nargin <3
    % Default cut-off frequencies
    CO_hp = 350; % Cut-off frequency of highpass-filter in Hz
    CO_lp = 2; % Cut-off frequency of lowpass-filter in Hz
end

% Design 1st-order highpass filter and filter 'raw'
[B1,A1] = butter(1,CO_hp/(0.5*samplefreq),'high');
hpfilt = filtfilt(B1,A1,raw);

% Rectify high-pass filtered signal
rect = abs(hpfilt);

% Design 1st order low-pass filter and filter the rectified signal
[B2,A2] = butter(1,CO_lp/(0.5*samplefreq),'low');
lpfilt = filtfilt(B2,A2,rect);

