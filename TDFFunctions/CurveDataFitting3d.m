tracksTransform = zeros(size(new_tracks,1),size(new_tracks,2));
x = 1:size(new_tracks(:,1),1);
for i = 1:size(new_tracks,2)
    [results, coef] = FitCustom(x, new_tracks(:,i));
    y = feval(results, x);
    tracksTransform(:,i) = y;
end