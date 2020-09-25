%% Leer los datos
directorio='D:\Dropbox\Shared_Aging_PhMetfAgita\GrowthKin\RawData/';
BgDataAll = ReadTecanFiles(directorio, 0, 0);
save RawData
%% Plot Od vs tiempo 

for pl = 1:4
    subplot(2,2,pl)
    plot(24*(BgDataAll(pl).t-BgDataAll(pl).t(1)), BgDataAll(pl).OD,'o-') %*24 para que sea en horas
    xlabel('t, horas')
    ylabel('OD_6_0_0')
end

%% GENERAR EL Diccionario "Medios" con las posiciones en el plato
[NUM TXT RAW]=xlsread('PosicionesPlato.xlsx');
for i=1:length(TXT)
    Medios(NUM(i,1)).(cell2mat((TXT(i)))) = NUM(i, 2:length(find(~isnan(NUM(i, 1:end)))));
end

%% Diferentes metforminas en el mismo pH
campos=fieldnames(Medios);
titulos={'Buffer=0', 'Buffer=3.6', 'Buffer=4.3', 'Buffer=5.5', 'Buffer=6'};
for pl=[3]
clear h
contador=0;
figure(pl); clf
mapaCol=hsv(4);
mapaCol=[ 0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250; 0.4940, 0.1840, 0.5560 ];
for pHs = {'control', 'ph3', 'ph4', 'ph5', 'ph6'}
     contador=contador+1;
%     subplot(2,5,contador)
    
    %SB_Metf = Num(:,2)==metforminas; %SeleccionadorBooleano
    equis=regexpi(campos(),pHs);
    SB_Buffer = find(~cellfun(@isempty,equis));
    %SB_Agit = Num(:,8)==1;
    con=0;
    for sel = SB_Buffer'
        con=con+1;
        subplot(2,5,contador)
        hold on
        wells = Medios.(str2mat( campos(sel) ));
        x = 24*(BgDataAll(pl).t-BgDataAll(pl).t(1));
        y = BgDataAll(pl).OD(:, wells)-BgDataAll(pl).OD(1, wells);
        %plot( x,y,'o-','color', mapaCol(con,:) )
        h(con)=ShadeDist(x,y',mapaCol(con,:), .5, 4, 1, 0);
        title( titulos(contador) );
        ylim([-.04 .76])

        subplot(2,5,5+contador)
        hold on
        wells = Medios.(str2mat( campos(sel) ));
        x = 24*(BgDataAll(pl+1).t-BgDataAll(pl+1).t(1));
        y = BgDataAll(pl+1).OD(:, wells)-BgDataAll(pl+1).OD(1, wells);
        %plot( x,y,'o-','color', mapaCol(con,:) )
        h(con)=ShadeDist(x,y',mapaCol(con,:), .5, 4, 1, 0);
        ylim([-.04 .76])
    end
end
legend(h,strrep(campos(SB_Buffer'),'ph6_',''), "location", "best", "linewidth", 0.1)

subplot(2,5,1)
ylabel("OD_6_0_0-AGITADO-")
xlabel("t, horas")
subplot(2,5,6)
ylabel("OD_6_0_0 -SIN AGITAR-")
xlabel("t, horas")
end % platos 3 y 4

for pl=[1]
clear h
contador=0;
figure(pl); clf
mapaCol=hsv(4);
mapaCol=[ 0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250; 0.4940, 0.1840, 0.5560 ];
for pHs = {'control', 'ph3', 'ph4', 'ph5', 'ph6'}
     contador=contador+1;
%     subplot(2,5,contador)
    
    %SB_Metf = Num(:,2)==metforminas; %SeleccionadorBooleano
    equis=regexpi(campos(),pHs);
    SB_Buffer = find(~cellfun(@isempty,equis));
    %SB_Agit = Num(:,8)==1;
    con=0;
    for sel = SB_Buffer'
        con=con+1;
        subplot(2,5,5+contador)
        hold on
        wells = Medios.(str2mat( campos(sel) ));
        x = 24*(BgDataAll(pl).t-BgDataAll(pl).t(1));
        y = BgDataAll(pl).OD(:, wells)-BgDataAll(pl).OD(1, wells);
        %plot( x,y,'o-','color', mapaCol(con,:) )
        h(con)=ShadeDist(x,y',mapaCol(con,:), .5, 4, 1, 0);
        ylim([0 .96])

        subplot(2,5,contador)
        hold on
        wells = Medios.(str2mat( campos(sel) ));
        x = 24*(BgDataAll(pl+1).t-BgDataAll(pl+1).t(1));
        y = BgDataAll(pl+1).OD(:, wells)-BgDataAll(pl+1).OD(1, wells);
        %plot( x,y,'o-','color', mapaCol(con,:) )
        h(con)=ShadeDist(x,y',mapaCol(con,:), .5, 4, 1, 0);
        ylim([0 .96])
        title( titulos(contador) );
    end
end
legend(h,strrep(campos(SB_Buffer'),'ph6_',''), "location", "best", "linewidth", 0.1)

subplot(2,5,1)
ylabel("OD_6_0_0-AGITADO-")
xlabel("t, horas")
subplot(2,5,6)
ylabel("OD_6_0_0 -SIN AGITAR-")
xlabel("t, horas")
end % platos 1 y 2

%% Graficar tasas de crecimiento DeltaOD/DeltaT, solo platos 2 3 y 4

clear maxGR
for pl=1:4 % Esta figura no tiene sentido para el pl 1 ver curvas de crecimiento
    for well=1:96
        x = 24*(BgDataAll(pl).t-BgDataAll(pl).t(1));
        y = BgDataAll(pl).OD(2:end, well)-BgDataAll(pl).OD(1, well);
        maxGR(pl,well) = mean(maxk(diff(y(:,1)')./diff(x(2:end)), 4));
    end
end

for pl=[2,3,4] % Esta figura no tiene sentido para el pl 1
contador=0;
figure(pl); clf
clear h
mapaCol=hsv(4);
mapaCol=[ 0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250; 0.4940, 0.1840, 0.5560 ];
for pHs = {'control', 'ph3', 'ph4', 'ph5', 'ph6'}
     contador=contador+1;
%     subplot(2,5,contador)
    
    %SB_Metf = Num(:,2)==metforminas; %SeleccionadorBooleano
    equis=regexpi(campos(),pHs);
    SB_Buffer = find(~cellfun(@isempty,equis));
    %SB_Agit = Num(:,8)==1;
    con=0;    
	subplot(1,5,contador)
	hold on
    for sel = SB_Buffer'
        con=con+1;
        wells = Medios.(str2mat( campos(sel) ));
        h(contador)=JitterPlot(con, maxGR(pl,wells), .5, 'o', mapaCol(con,:), 5, 1);
    end
    title(titulos(contador))
    %legend(h,strrep(campos(SB_Buffer'),'ph6_',''), "location", "best", "linewidth", 0.1)
    if pl<3
        ylim([0 .04])
    else
        ylim([0.05 .15])
    end
    set(gca,'xtick', 1:4,'xticklabels',strrep(campos(SB_Buffer'),strcat(pHs,"_"),''))
end

subplot(1,5,1)
if pl == 2 || pl == 3
    ylabel("GrowthRate-OD/t -AGITADO-")
else
	ylabel("GrowthRate-OD/t -SIN AGITAR-")
end

end 

%%
save 20200914_GR