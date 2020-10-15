function [PLGatedVivas, GateArray]=GateSubset(PL, wells, samplesize, x, y, namex, namey, xscale, yscale)

figure()
datoswell=[];

for i=1:length(PL)
    for w=wells
        num=floor(rand(samplesize,1).*length(PL((i)).WELL(w).dat));
        num(num<1 | num>size(PL((i)).WELL(w).dat,1))=[];
        datoswell=[datoswell; PL((i)).WELL(w).dat(num,:)];  
    end
end

[~, ~, GateArray] = GatingMouseDscatter(datoswell, x, y, namex, namey);



PLGatedVivas=1;

end
