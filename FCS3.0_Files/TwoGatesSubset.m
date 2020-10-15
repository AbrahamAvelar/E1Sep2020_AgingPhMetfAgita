function [GateArrayV, GateArrayM]=TwoGatesSubset(PL, wells, samplesize, x, y, namex, namey)

figure()
datoswell=[];

for i=1:length(PL)
    for w=wells
        num=floor(rand(samplesize,1).*length(PL((i)).WELL(w).dat));
        num(num<1 | num>size(PL((i)).WELL(w).dat,1))=[];
        datoswell=[datoswell; PL((i)).WELL(w).dat(num,:)];  
    end
end
title( strcat(PL(1).Info.PlateName,  num2str(wells)) )
[~, ~, GateArrayV] = GatingMouseDscatter(datoswell, x, y, namex, namey);
[~, ~, GateArrayM] = GatingMouseDscatter(datoswell, x, y, namex, namey);
end
