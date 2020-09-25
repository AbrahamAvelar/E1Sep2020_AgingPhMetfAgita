%% bajar datos
clear
platos=24;
%close all
%cd 'C:\Users\Abraham\Dropbox\PhD\E1Feb19 Fitness Nando Cit 2do intento'
%directorio='C:\Users\Abraham\Dropbox\PhD\E1Feb19 Fitness Nando Cit 2do intento\E1Feb19_JAARCitometro\PL12';
cd 'D:\Dropbox\Shared_Aging_PhMetfAgita\FCS3.0_Files'
directorio='D:\Dropbox\Shared_Aging_PhMetfAgita\FCS3.0_Files\E1Sep2020_AgingPhMetfAgita\vivas muertas_Metf_003';
PL = LoadCitPlate(directorio, platos);
save ('PL24','PL','-v7.3')
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




%% y PIvsSYBER de un pozo a todos sus tiempos
figure(100)
clf
con=0;
pozos=[11 15 16 20];
platos=[1:10];%1:10;
for w=pozosgit
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
	title(titulo(2))
    if pl==1
        ylabel(strrep(PL(pl).WELL(w).info.filename, '_', '-'))
    else
        xlabel(PL(1).Info.par(x).name)
        ylabel(PL(1).Info.par(y).name)
    end
end
end
%%
samplesize=300;
x=1;y=2;
namex=PL(1).Info.par(x).name;
namey=PL(1).Info.par(y).name;
gatedData=1;
PLn=PL;

%validos = ValidPLs(PLATO,2:end);
%validos = validos(~isnan(validos));
%PLn = reducePlates(PL, validos);

[PLGated GateArray1]= PlateGatingMouse( PLn, wells, samplesize, x, y, namex, namey, 'linear', 'linear', 1, 0, gatedData );
