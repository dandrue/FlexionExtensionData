function [marker] = PlotKinematicData(tracks, names)
numMarkers = size(tracks, 2) - 1;
Pointer = 1;
for i = 1:3:numMarkers
    figure
    subplot(3,1,1)
    plot(tracks(:,i))
    title(string(names(Pointer)) + ' X')
    xlabel('Frame')
    ylabel('Values')
    subplot(3,1,2)
    plot(tracks(:,i+1))
    title(string(names(Pointer)) + ' Y')
    xlabel('Frame')
    ylabel('Values')
    subplot(3,1,3)
    plot(tracks(:,i+2))
    title(string(names(Pointer)) + ' Z')
    xlabel('Frame')
    ylabel('Values')
    Pointer = Pointer + 1;
end