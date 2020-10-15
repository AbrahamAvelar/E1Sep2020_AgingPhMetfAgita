%% bajar datos
clear
platos=14;
%close all
%cd 'C:\Users\Abraham\Dropbox\PhD\E1Feb19 Fitness Nando Cit 2do intento'
%directorio='C:\Users\Abraham\Dropbox\PhD\E1Feb19 Fitness Nando Cit 2do intento\E1Feb19_JAARCitometro\PL12';
cd 'D:\Dropbox\Shared_Aging_PhMetfAgita\FCS3.0_Files'
directorio='D:\Dropbox\Shared_Aging_PhMetfAgita\FCS3.0_Files\E1Sep2020_AgingPhMetfAgita\vivas muertas_Metf_003';
PL = LoadCitPlate(directorio, platos);
save ('PL14','PL','-v7.3')
%%
%Qué pasó con el PL24 en los 2 primeros platos tienen la misma fecha el que
%dice volteado va el día 10, no el 8
%% Ver histogramas de pi y de SYBR
%close all
y=3; %SYBR Green
x=4; %PI
namex=PL(1).Info.par(x).name;
namey=PL(1).Info.par(y).name;
platosausar=[2 5 10];
for pl = platosausar
    con=0;
    figure(pl)
    clf
    for  w=sort([5:20:60 6:20:60])
        con=con+1;
        subplot(3,2,con)
        
        %plot(log10(PL(pl).WELL(w).dat(1:1000,x)),log10(PL(pl).WELL(w).dat(1:1000,y)),'o','MarkerSize',.8)
        
        hold on
        datos=[(PL(pl).WELL(w).dat(:,x)), (PL(pl).WELL(w).dat(:,y))];
        datos(datos<0)=0.001;
        datos=log10(datos);
        datos(isinf(datos))=0.001;
        %[log10(PL(pl).WELL(w).dat(:,x)), log10(PL(pl).WELL(w).dat(:,y))];
        %scatter(datos)
        [n,c]=hist3(datos, [15 35]);
        %contour(c{2},c{1},n)
        [n c] = hist(datos(:,1),75);
        HistLine(c,n,'g')
        [n c] = hist(datos(:,2),75);
        HistLine(c,n,'r')
        
        
        %xlim([1 5.6])
        %ylim([1 5.6])
        titulo=strsplit(PL(pl).WELL(w).info.filename, '_');
        ylabel(strcat('well-',num2str(w), '-', titulo(3)) )
    end
end

%% ver SYBR vs PI scatter 
%close all
platosausar=[2 5 9 10];
for pl = platosausar
    con=0;
    figure(pl)
    clf
    for  w=sort([5:10:40 6:10:40])
        con=con+1;
        subplot(4,2,con)
        
        %plot(log10(PL(pl).WELL(w).dat(1:1000,x)),log10(PL(pl).WELL(w).dat(1:1000,y)),'o','MarkerSize',.8)
        
        hold on
        datos=[(PL(pl).WELL(w).dat(:,x)), (PL(pl).WELL(w).dat(:,y))];
        datos(datos<0)=0.001;
        datos=log10(datos);
        datos(isinf(datos))=0.001;
        %[log10(PL(pl).WELL(w).dat(:,x)), log10(PL(pl).WELL(w).dat(:,y))];
        %scatter(datos)
        %[n,c]=hist3(datos, [15 35]);
        %contour(c{2},c{1},n)
        dscatter(datos(:,1),datos(:,2))
        xlim([2 5.6])
        ylim([1.52 5.6])
        titulo=strsplit(PL(pl).WELL(w).info.filename, '_');
        ylabel(strcat('well-',num2str(w), '-', titulo(3)) )
        if con<12
            set(gca,'xtick',[])
        end
    end
end

%% y PIvsSYBER de n pozos a m tiempos con el color en la densidad 
%close all
%load PL24
y=3; %SYBR Green
x=4; %PI
buffer = { 'pH6','pH5','pH4','pH3','pH0'};
for fila = 1:6
figure(100+fila);
clf
con=0;
%pozos=6+(10*(fila-1)):6+(10*(fila-1))+4%Para 2da concentración de metf
pozos=1+(10*(fila-1)):1+(10*(fila-1))+4
platos=1:length(PL);%[1:10];%1:10;
  for w=pozos
     for pl=platos
        con=con+1;
        subplot(length(pozos),length(platos),con)
        datos=[PL(pl).WELL(w).dat(:,x),(PL(pl).WELL(w).dat(:,y))];
        datos(datos<=0) = .1;
        datos=log10(datos);
        muestra=min(2000, size(datos,1));
        dscatter(datos(1:muestra,1),datos(1:muestra,2))
        %plot((PL(pl).WELL(w).dat(1:1000,x)),(PL(pl).WELL(w).dat(1:1000,y)), 'o','MarkerSize',0.5 )
        %set(gca,'yscale','log', 'xscale','log')
        xlim([1 5.5])
        ylim([1 5.5])
        titulo=strsplit(PL(pl).Info.PlateName, '_');%strsplit(strrep(PL(pl).Info.PlateName,'_');%strrep(strrep(PL(pl).Info.PlateName, '_', '-');
        %title(titulo(2))
        text(1.5, 1.5, strcat('n=', num2str(size(datos,1))))
        if pl==1
            etiq=strsplit(PL(pl).WELL(w).info.filename, '_');
            ylabel( strcat (etiq(3), '-',buffer(floor((con/10)+1 ))) );
        else
            xlabel(PL(1).Info.par(x).name)
            ylabel(PL(1).Info.par(y).name)
        end
        if con <= length(platos)
                title(strrep(PL(pl).Info.PlateName, '_','-'))
        end
  end
  end
  savefig(strrep(cell2mat(strcat('Figuras/',titulo(1),'-Pozos', num2str(pozos) )),'  ','-'))
end
%% Consolidar datos en AllData
con=0;
for plato={'PL11','PL14','PL21','PL24'}
	load((cell2mat(plato)))
    con=con+1;
    AllData(con).PL=PL;
end
save ('AllData','AllData','-v7.3')

%% Quitar valores negativos en x & y
y=3; %SYBR Green
x=4; %PI
AllDataNoLog = QuitaLogNeg(AllData, x, y);
save ('AllDataNoLog','AllDataNoLog','-v7.3')


%%  Hacer Gates para todas las réplicas
y=3; %SYBR Green
x=4; %PI
namex=AllDataNoLog(1).PL(1).Info.par(x).name;
namey=AllDataNoLog(1).PL(1).Info.par(y).name;

for plato=1:4
    for columna=10%3:10
        wells=columna:10:60;
        samplesize = 400;
        [AllDataNoLog(plato).GateArrays(columna).vivas, AllDataNoLog(plato).GateArrays(columna).muertas] = TwoGatesSubset(AllDataNoLog(plato).PL, wells, samplesize, x, y, namex, namey);
    end
end


%% Calcular los porcentajes con los gates de la sección pasada
y=3; %SYBR Green
x=4; %PI
namex=AllDataNoLog(1).PL(1).Info.par(x).name;
namey=AllDataNoLog(1).PL(1).Info.par(y).name;
clear AllData
for plato=1:4
    for w=1:63
    for pl=1:length(AllDataNoLog(plato).PL)
        if mod(w,10)
            columna=mod(w,10);
        else
            columna=10;
        end
        
        [GatedDataV, GatedIndexesV] = ApplyGate(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat), AllDataNoLog(plato).GateArrays(columna).vivas, x, y);
        [GatedDataM, GatedIndexesM] = ApplyGate(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat), AllDataNoLog(plato).GateArrays(columna).muertas, x, y);
        
        V=length(GatedIndexesV);
        M=length(GatedIndexesM);
        AllData(plato).pctV(pl,w) = V/(V+M);
        AllData(plato).pctM(pl,w) = M/(V+M);
        
        AllData(plato).pctVtot(pl, w) = V/size(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat),1);
        AllData(plato).pctMtot(pl, w) = M/size(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat),1);
    end
    end
end
GatedPctgs = AllData
save GatedPctgs GatedPctgs

%% ver las 63 curvas de muerte por plato
%load GatedPctgs
for plato = 1:4
    figure(plato)
    clf
    for w=1:63
        figure(plato)
        subplot(7, 10, w)
        plot(GatedPctgs(plato).pctV([1:3 5:end],w), 'c');
        hold on
        plot(GatedPctgs(plato).pctVtot([1:3 5:end],w), 'm');
    end
end


%% Curvas de muerte de todas las réplicas
for plato = 1%:4
    figure(plato)
    clf
    for w=1:10
        figure(plato)
        subplot(1, 10, w)
        hold on
        h(1,:)=plot(GatedPctgs(1).pctV([1:3 5:end],w:10:60),'b');
        h(2,:)=plot(GatedPctgs(2).pctV([1:3 5:end],w:10:60),'c');
        h(3,:)=plot(GatedPctgs(3).pctV([1:3 5:end],w:10:60),'r');
        h(4,:)=plot(GatedPctgs(4).pctV([1:3 5:end],w:10:60),'m');
    end
end
legend(h(:,1),'PL11','PL14','PL21','PL24')
%% sacar los vectores de tiempo
for plate = 1:4
    for pl = 1: length(AllDataNoLog(plate).PL)
        temp=strsplit(AllDataNoLog(plate).PL(pl).Info.PlateName,'_');
        GatedPctgs(plate).t(pl) = datenum(cell2mat(temp(2)), 'YYYYMMDD');
    end
    GatedPctgs(plate).t=GatedPctgs(plate).t- GatedPctgs(plate).t(1);
end

% FALTA ARREGLAR EL PL24 VOLTEADO QUE ADEMÁS TIENE MAL LA FECHA
%% Curvas de muerte de todas mean y std
mapaCol=[ 0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.7940, 0.1250; 0.5940, 0.1840, 0.5560 ];
clear h
figure(6)
clf
buffer = { 'pH6','pH5','pH4','pH3','pH0'};
diasbuenos=[1 2 3 5 7 8 10];
for plato = [1 3]
    for w=1:5 
        subplot(2,5,w)
        hold on
        % h = ShadeDist(x, y, C, alfa, SEM, shadeSEM, soloplot)
        h(plato) = ShadeDist(GatedPctgs(plato).t(diasbuenos), 100*GatedPctgs(plato).pctV(diasbuenos,w:10:60)', mapaCol(plato,:), .25, 4, 2, 0  );
        h(plato+1) = ShadeDist(GatedPctgs(plato).t(diasbuenos), 100*GatedPctgs(plato).pctV(diasbuenos,w+5:10:60)', mapaCol(plato+1,:), .25,4, 2, 0  );
        ylim([-1 105])
        xlim([0 16])
        title(strcat(buffer(w),'-Agitado'))

    end
end
legend(h,'PL11-0Metf','PL11-3Metf','PL21-40Metf','PL21-100Metf', 'location', 'best')
ylabel('% vivas')
xlabel('Días')
clear h

diasbuenos=[1 2 3 5 7 8];
for plato = [2 4]
    for w=1:5 
        subplot(2,5,w+5)
        hold on
        % h = ShadeDist(x, y, C, alfa, SEM, shadeSEM, soloplot)
        h(plato-1) = ShadeDist(GatedPctgs(plato).t([diasbuenos 10:end]), 100*GatedPctgs(plato).pctV([diasbuenos 10:end],w:10:60)', mapaCol(plato-1,:), .25, 4, 2, 0  );
        h(plato) = ShadeDist(GatedPctgs(plato).t([diasbuenos 10:end]), 100*GatedPctgs(plato).pctV([diasbuenos 10:end],w+5:10:60)', mapaCol(plato,:), .25, 4, 2, 0  );
        ylim([-1 105])
        xlim([0 21])
        title(strcat(buffer(w),'-SinAgitar'))
    end
end
legend(h,'PL14-0Metf','PL14-3Metf','PL24-40Metf','PL24-100Metf', 'location', 'best')
ylabel('% vivas')
xlabel('Días')
%% Figura con los gates de todos los pozos
figure(3)
clf
con=0;
for plato=3%1:4
    figure(plato)
    clf
    con=0;
for columna=4%:10
    for w=columna:10:60
    for pl=1:length( AllDataNoLog(plato).PL )
        con=con+1;
        subplot(6,11,con)
        [GatedDataV, GatedIndexesV] = ApplyGate(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat), AllDataNoLog(plato).GateArrays(columna).vivas, x, y);
        [GatedDataM, GatedIndexesM] = ApplyGate(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat), AllDataNoLog(plato).GateArrays(columna).muertas, x, y);
        
        datos=[(AllDataNoLog(plato).PL(pl).WELL(w).dat(:,x)),(AllDataNoLog(plato).PL(pl).WELL(w).dat(:,y))]; %To avoid conflicts due to negative or infinite values ...
        datos(datos<=0) = .1;  % And to have propper coloring in the dscatter
        datos=log10(datos);
        hold on
        dscatter(datos(:,1),datos(:,2))
        
         plot( AllDataNoLog(plato).GateArrays(columna).vivas(:,1),  AllDataNoLog(plato).GateArrays(columna).vivas(:,2), 'r-', 'linewidth', 1)
         plot( AllDataNoLog(plato).GateArrays(columna).muertas(:,1),  AllDataNoLog(plato).GateArrays(columna).muertas(:,2), 'r-', 'linewidth', 1)
        
        V=length(GatedIndexesV);
        M=length(GatedIndexesM);
        pctV = V/(V+M);
        pctM = M/(V+M);
        xlim([-1 6])
        ylim([-1 6])
        text(.1,-.5, strcat('V=',num2str(V), '-', num2str(floor(pctV*1000)/10)))
        text(.1,0.5, strcat('M=',num2str(M), '-', num2str(floor(pctM*1000)/10)))
        if pl==1
            etiq=strsplit(AllDataNoLog(plato).PL(pl).WELL(w).info.filename, '_');
            ylabel(etiq(3))
            %ylabel( strcat (etiq(3), '-',buffer(floor((con/10)+1 ))) );
        else
            xlabel(AllDataNoLog(plato).PL(1).Info.par(x).name)
            ylabel(AllDataNoLog(plato).PL(1).Info.par(y).name)
        end
        if con <= length( AllDataNoLog(plato).PL )
                title(strrep(AllDataNoLog(plato).PL(pl).Info.PlateName, '_','-'))
        end
    end
    end
end
%savefig(strcat('plato','','') )
end

%% Figura con gates de los pozos deseados

platos=4;
pls = [1 5 8 11];
ws  = [16:20];
samplesize=3000;
PlotGatedScatter(AllDataNoLog, platos, pls, ws, x, y, samplesize);

%% segundo gate ver las mediciones 1 y 2 junto al pool para hacerlos mejor
y=3; %SYBR Green
x=4; %PI
namex=AllDataNoLog(1).PL(1).Info.par(x).name;
namey=AllDataNoLog(1).PL(1).Info.par(y).name;

for plato=3
    for columna=9%3:10
        wells=columna:10:60;
        samplesize = 800;
        [AllDataNoLog(plato).GateArrays(columna).vivas2, AllDataNoLog(plato).GateArrays(columna).muertas2] = TwoGatesSubsetStartEnd(AllDataNoLog(plato).PL, wells, samplesize, x, y, namex, namey);
    end
end
%
platos=plato;
pls = [1 3 7 10];
ws  = [columna:10:60];
samplesize=3000;
PlotAltGatedScatter(AllDataNoLog, platos, pls, ws, x, y, samplesize);

%%  Calcular los porcentajes con los gates de la sección pasada
y=3; %SYBR Green
x=4; %PI
namex=AllDataNoLog(1).PL(1).Info.par(x).name;
namey=AllDataNoLog(1).PL(1).Info.par(y).name;
clear AllData
for plato=1:4
    for w=1:63
    for pl=1:length(AllDataNoLog(plato).PL)
        if mod(w,10)
            columna=mod(w,10);
        else
            columna=10;
        end
        
        [GatedDataV, GatedIndexesV] = ApplyGate(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat), AllDataNoLog(plato).GateArrays(columna).vivas2, x, y);
        [GatedDataM, GatedIndexesM] = ApplyGate(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat), AllDataNoLog(plato).GateArrays(columna).muertas2, x, y);
        
        V=length(GatedIndexesV);
        M=length(GatedIndexesM);
        AllData(plato).pctV2(pl,w) = V/(V+M);
        AllData(plato).pctM2(pl,w) = M/(V+M);
        
        AllData(plato).pctVtot2(pl, w) = V/size(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat),1);
        AllData(plato).pctMtot2(pl, w) = M/size(log10(AllDataNoLog(plato).PL(pl).WELL(w).dat),1);
    end
    end
end
GatedPctgs2 = AllData
% save GatedPctgs GatedPctgs

%% Curvas de muerte de todas mean y std
mapaCol=[ 0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.7940, 0.1250; 0.5940, 0.1840, 0.5560 ];
clear h
figure(5)
clf
buffer = { 'pH6','pH5','pH4','pH3','pH0'};

for plato = [1 3]
    for w=1:5 
        subplot(2,5,w)
        hold on
        % h = ShadeDist(x, y, C, alfa, SEM, shadeSEM, soloplot)
        h(plato) = ShadeDist(GatedPctgs(plato).t([1:3 5:end]), 100*GatedPctgs2(plato).pctV2([1:3 5:end],w:10:60)', mapaCol(plato,:), .25, 4, 2, 0  );
        h(plato+1) = ShadeDist(GatedPctgs(plato).t([1:3 5:end]), 100*GatedPctgs2(plato).pctV2([1:3 5:end],w+5:10:60)', mapaCol(plato+1,:), .25,4, 2, 0  );
        ylim([-1 105])
        xlim([0 16])
        title(strcat(buffer(w),'-Agitado'))

    end
end
legend(h,'PL11-0Metf','PL11-3Metf','PL21-40Metf','PL21-100Metf')
ylabel('% vivas')
xlabel('Días')
clear h

for plato = [2 4]
    for w=1:5 
        subplot(2,5,w+5)
        hold on
        % h = ShadeDist(x, y, C, alfa, SEM, shadeSEM, soloplot)
        h(plato-1) = ShadeDist(GatedPctgs(plato).t([1:3 5:end]), 100*GatedPctgs2(plato).pctV2([1:3 5:end],w:10:60)', mapaCol(plato-1,:), .25, 4, 2, 0  );
        h(plato) = ShadeDist(GatedPctgs(plato).t([1:3 5:end]), 100*GatedPctgs2(plato).pctV2([1:3 5:end],w+5:10:60)', mapaCol(plato,:), .25, 4, 2, 0  );
        ylim([-1 105])
        xlim([0 21])
        title(strcat(buffer(w),'-SinAgitar'))
    end
end
legend(h,'PL14-0Metf','PL14-3Metf','PL24-40Metf','PL24-100Metf')
ylabel('% vivas')
xlabel('Días')

%% Figura con gates de los pozos deseados

platos=1;
pls = [1 2 3 7 8 9 10 11];
ws  = [6:10:30];
samplesize=3000;
PlotAltGatedScatter(AllDataNoLog, platos, pls, ws, x, y, samplesize);





