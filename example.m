% This is an example file on how to load in kinematic and EMG data.
clear;clc

subject = 1; % Number of the subject
taskname = 'ABDFAST1'; % Name of the task

% Load the kinematic data
Filename = ['S' int2str(subject) '_' taskname];
KinFileName = ['../Kinematics/RoM/' Filename '.mat'];
kinematics = load(['../Kinematics/RoM/' Filename '.mat']);

% Load the EMG data
EMG = load(['../EMG/RoM/' Filename '_emg.mat']);

%% Use the data viewer to inspect the the kinematics data.
% Some tips:
% -  Use the scroll bar or play-button to browse through the data.
% -  In the top right dropdown-menu you can select what angles to plot.
% -  By clicking the 'Show Landmark Labels' button the names and locations 
%    of the landmarks will be plotted for the current position.
% -  By clicking the 'Plot direction vector' button the coordinate systems
%    will be plotted for the current position.
DataViewer(KinFileName) 

%% Synchronise EMG and kinematics data 

sync = EMG.EMG_raw(:,17); % The synchronisation signal is the 17th channel

% The sync signal switches from 256 to 257 when the Optotrak was
% switched on and back to 256 when it was switched off. 
selection = find(sync == 257);
% The first value in 'selection' is the sample number that corresponds to
% the first Optotrak frame. The values with a value other than 257 can be
% removed.

EMG_new = EMG.EMG_raw(selection,1:14); % Select only channels 1-14 (15-16 were unused)

% Apply the example filter to the EMG data. This filter is based on
% Staudenmann et al. (2007)

[EMG.LowPass_Filt, EMG.HighPass_Filt] =...
    ExampleEMG_Filter(EMG_new,EMG.samplefreq,350,2);

% Plot both the kinematics and the EMG data. In this example, humeral
% elevation and middle deltoid EMG are plotted in the time domain.

% Create time-vectors for kinematic and EMG data. The sample frequency for
% the Optotrak was always 100Hz.
f_optotrak = 100;
t_kin = (0:1:size(kinematics.SegmRot,1)-1) / f_optotrak;
t_EMG = (0:1:size(EMG.LowPass_Filt,1)-1) / EMG.samplefreq;

figure('Name','Example of how to combine kinematics and EMG data')
subplot(2,1,1)
plot(t_kin,kinematics.SegmRot(:,12),'LineWidth',2,'Color','g')
xlabel('Time (sec)')
ylabel('Angle (degr)')
legend(kinematics.SegmRot_Names{12})
title('Humeral elevation')

subplot(2,1,2);hold on
handle_hp = plot(t_EMG,EMG.HighPass_Filt(:,5));
handle_lp = plot(t_EMG,EMG.LowPass_Filt(:,5),'LineWidth',2,'Color','r');
legend([handle_hp handle_lp],{'High-pass filtered','High-pass+rectified+low-pass filtered'})
title(['EMG signal for ' EMG.EMG_Names{5}])
xlabel('Time (sec)')
ylabel('Amplitude')




