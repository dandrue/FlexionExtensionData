function [maxSignal] = PlotFilteredEMG(EMG_filtered, EMG_Names)

totalMuscles = size(EMG_Names, 1);
maxSignal = zeros(size(EMG_Names));
figure
for i = 1:totalMuscles
    subplot(4,4,i)
    plot(EMG_filtered(:,i))
    title('EMG ' + string(EMG_Names(i)))
    xlabel('Frames')
    ylabel('Values mV')
    maxSignal(i) = max(EMG_filtered(:,i));
end
% To close the all the figures type "close all" 
