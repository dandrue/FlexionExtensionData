%% Importing the kinematic data and the raw EMG data
% Custom File to load and Visualize the experimental data
clear;clc

subject = 1; % Number of the subject
taskname = 'ABDSLOW1'; % Name of the task

% Load the kinematic data
Filename = ['S' int2str(subject) '_' taskname];
KinFileName = ['../Kinematics/RoM/' Filename '.mat'];
load(['../Kinematics/RoM/' Filename '.mat']);

% Load the EMG data
load(['../EMG/RoM/' Filename '_emg.mat']);

%% Synchronise EMG and kinematics data 

sync = EMG_raw(:,17); % The synchronisation signal is the 17th channel

% The sync signal switches from 256 to 257 when the Optotrak was
% switched on and back to 256 when it was switched off. 
selection = find(sync == 257);
% The first value in 'selection' is the sample number that corresponds to
% the first Optotrak frame. The values with a value other than 257 can be
% removed.

EMG_new = EMG_raw(selection,1:14);

%% Data preprocessing
% Decompressing the kinematic data and filtering the raw EMG data
PreProcessingData;

Tracks = horzcat(Tracks(:,1:42), Tracks(:,49:54));
Landmarks_Names = horzcat(Landmarks_Names(:,1:14), Landmarks_Names(:,17:18));
EMG_filtered = ExampleEMG_Filter(EMG_new, samplefreq);

clear Pointer_1 Pointer_2 i 


%% Data visualization
PlotFilteredEMG(EMG_new, EMG_Names);
PlotFilteredEMG(EMG_filtered, EMG_Names);
PlotHumAngles(SegmRot, SegmRot_Names);
PlotKinematicData(Tracks, Landmarks_Names);