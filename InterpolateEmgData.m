emgDataTransform = zeros(7,2195);
for i = 1:size(emgData,1)
    x = (1:size(emgData(i,:),2));
    v = emgData(i,:);
    xq = (1:2195);
    vq = interpn(x,v,xq);
    emgDataTransform(i,:) = vq;
end
