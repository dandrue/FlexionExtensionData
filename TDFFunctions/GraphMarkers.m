count = 1;
labels1 = [1,4,5,6,7,9,10,13,12,11];
for j = 1:size(labels,1)
    figure
    hold on
    
    for i = 1:3
        plot(tracks(:,count))
        count = count + 1;
    end
    title(strcat('Marcador->',int2str(labels1(j))))
    xlabel('Número de tomas')
    ylabel('Valor de la muestra')
    legend('X','Y', 'Z')
end