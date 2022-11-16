tracks_mod = tracks;
for i=1:3:30
    tracks_mod(:,i) = tracks_rot(:,i)-x_value;
end
for i=2:3:30
    tracks_mod(:,i) = tracks_rot(:,i)-y_value;
end
for i=3:3:30
    tracks_mod(:,i) = tracks_rot(:,i)-z_value;
end