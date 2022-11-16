for i = 1:size(labels)
    figure
    hold on
    plot(emgData(i,:))
    title(labels(i,:))
    xlabel('Datos recolectados 1000Hz')
    ylabel('Amplitud de los datos')
end

