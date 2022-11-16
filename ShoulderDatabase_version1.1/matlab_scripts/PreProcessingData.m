
ArraySize = size(Landmarks);
NumMarkers = ArraySize(2);
TotalRuns = ArraySize(3);

Tracks = zeros(TotalRuns, NumMarkers);
Pointer_1 = 1;
Pointer_2 = 3;
for i = 1:NumMarkers
    Tracks(:,Pointer_1:Pointer_2) = squeeze(Landmarks(:,i,:))';
    Pointer_1 = Pointer_1 + 3;
    Pointer_2 = Pointer_2 + 3;
end

Labels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27'];