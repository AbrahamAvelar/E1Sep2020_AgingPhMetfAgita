function PlotAltGatedScatter(AllDataNoLog, platos, pls, ws, x, y, samplesize)

for plato=platos
    figure(1000+platos)
    clf
    con=0;
	for w = ws
        for pl=pls
            con=con+1;
            subplot(length(ws),length(pls),con)
            
            datos=[(AllDataNoLog(plato).PL(pl).WELL(w).dat(:,x)),(AllDataNoLog(plato).PL(pl).WELL(w).dat(:,y))]; %To avoid conflicts due to negative or infinite values ...
            datos(datos<=0) = .1;  % And to have propper coloring in the dscatter
            datos=log10(datos);
            hold on
            usaeste=min(size(datos,1), samplesize);
            dscatter(datos(1:usaeste,1),datos(1:usaeste,2))
            
            if mod(w,10)
                columna=mod(w,10);
            else
                columna=10;
            end
            
            plot( AllDataNoLog(plato).GateArrays(columna).vivas(:,1),  AllDataNoLog(plato).GateArrays(columna).vivas(:,2), 'r-', 'linewidth', 1)
            plot( AllDataNoLog(plato).GateArrays(columna).muertas(:,1),  AllDataNoLog(plato).GateArrays(columna).muertas(:,2), 'r-', 'linewidth', 1)
            
            plot( AllDataNoLog(plato).GateArrays(columna).vivas2(:,1),  AllDataNoLog(plato).GateArrays(columna).vivas2(:,2), 'g-', 'linewidth', 1)
            plot( AllDataNoLog(plato).GateArrays(columna).muertas2(:,1),  AllDataNoLog(plato).GateArrays(columna).muertas2(:,2), 'g-', 'linewidth', 1)
            
            
            if mod(con, length(pls) ) == 1
                temp=strsplit(AllDataNoLog(plato).PL(pl).WELL(w).info.filename, '_');
                ylabel(temp(3));
            else
                ylabel(AllDataNoLog(plato).PL(1).Info.par(y).name);
                xlabel(AllDataNoLog(plato).PL(1).Info.par(x).name);
            end
            %temp=strsplit(AllDataNoLog(plato).PL(pl).Info.PlateName,'_');
            %title(temp(2))
            if con<=length(pls)
                title(strrep(AllDataNoLog(plato).PL(pl).Info.PlateName,'_','-') )
            end
            
            xlim([.1,6])
            ylim([.11,6])
        end
    end
end
