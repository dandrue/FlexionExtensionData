for i=3:3:30
    tracks_rot(:,i) = tracks(:,i-2);
end
for i=2:3:30
    tracks_rot(:,i) = tracks(:,i);
end
for i=1:3:30
    tracks_rot(:,i) = -tracks(:,i+2);
end