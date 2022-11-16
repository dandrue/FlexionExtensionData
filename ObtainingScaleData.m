clear
clc
[frequency,D,R,T,labels,links,tracks] = tdfReadData3D ("data.tdf");
[startTime,frequency_e,emgMap,labels_e,emgData] = tdfReadDataEmg ("data.tdf");
labels_plot = [string('SC'), 'AC', 'GH', 'EL', 'EM', 'C7', 'T8', 'AA', 'AI', 'TS']
new_labels = labels_plot'
new_labels = [new_labels(1:5,:); new_labels(8:end,:)]
new_labels = char(new_labels)
new_links = [links(:,1:5),links(:,8:end)];

% rotation;
tracks_rot = tracks;
y_value = max(tracks(:,5));
x_value = 0; %-0.04;
y_value = y_value - 0.04; % - 0.06;
z_value = 0; %-0.02;
translation;
new_tracks = [tracks_mod(:,1:15), tracks_mod(:,22:end)];
size(new_tracks)
CurveDataFitting3d;
toScale = tracksTransform(904:908,:)
% toScale = tracksTransform(904:908,:)

tdfWriteData3D('toScale_1.tdf', frequency, D, R, T, new_labels, new_links, toScale)
tdfWriteData3D('simulation.tdf', frequency, D, R, T, new_labels, new_links, tracksTransform)