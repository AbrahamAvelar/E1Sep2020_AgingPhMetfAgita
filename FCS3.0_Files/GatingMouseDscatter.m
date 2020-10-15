function [NewData, GatingIndex, GateArray] = GatingMouseDscatter(Data, x, y, namex, namey, xscale, yscale, ver, GateArray)
% Te deja hacer un gate con el mouse y te regresa los indices, el gate que hiciste y los
% datos que quedaron dentro del gate 
% Data es la matriz de NxM con N eventos y M parametros medidos
% x y - son las dos columnas en las que estan los parametros de los que
% quieres hacer el gate
% x/yname y x/yscale son para que aparezcan en el plot
% GateArray-por si ya hay otro gate dibujado que quieras aplicar a estos datos
% ver-si quieres ver cómo quedó el gate en tus datos sin que avance el for
error(nargchk(0,10,nargin))

%clf

datos=[(Data(:,x)), (Data(:,y))]; %To avoid conflicts due to negative or infinite values ...
datos(datos<=0) = .1;  % And to have propper coloring in the dscatter
datos=log10(datos);
muestra=min(2000, size(datos,1));
hold on
dscatter(datos(:,1),datos(:,2))



%hold on
%set(gca, 'yscale',yscale,'xscale',xscale)
xlabel(namex)
ylabel(namey)

    if nargin < 9
        %from BW del SpringerLab
        ginputArray = ginput();
        GateArray = [ginputArray; ginputArray(1,:)];
    end
    if nargin<8
        ver=0;
    end
    %GI = find(inpolygon(datos(1:muestra,1),datos(1:muestra,2), GateArray(:,1), GateArray(:,2)));
    GI = find(inpolygon(log10(Data(:,x)),log10(Data(:,y)), GateArray(:,1), GateArray(:,2)));

%plot((datos(:,1)), (datos(:,2)),'or','MarkerSize',1 )
%plot((datos(GI,1)), (datos(GI,2)),'og','MarkerSize',1 )

plot(log10(Data(:,x)), log10(Data(:,y)),'oc','MarkerSize',2 )
plot(log10(Data(GI,x)), log10(Data(GI,y)),'og','MarkerSize',2 )
plot(GateArray(:,1), GateArray(:,2), 'r-', 'linewidth', 2)

NewData=Data(GI,:);
GatingIndex=GI;
if ver
	pause
end
end