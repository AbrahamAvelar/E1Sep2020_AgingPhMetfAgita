save DataPH ExppHAgitacionMetforminaS1
%% Load xlsx

[Num Txt Raw] = xlsread("Exp pH_Agitacion_Metformina.xlsx", "pHTabular");
Nombres=strcat("Metf",num2str(Num(:,2)),"Buf",num2str(Num(:,3)),"Agit",num2str(Num(:,8)) );
%% Plot pH vs Tiempo
horas=Num(1,4:7);

SB_Metf = Num(:,2)==100; %SeleccionadorBooleano
SB_Buffer = Num(:,3)==0;

plot(horas, Num(SB_Metf&SB_Buffer,4:7), '.-')
ylim([2.5 6.5])
%% Diferentes pH en la misma metformina
figure(3);clf
mapacolores=jet(5);
contador=0;
for metforminas = [0, 3, 40, 100]
    contador=contador+1;
    subplot(2,4,contador)
    SB_Metf = Num(:,2)==metforminas; %SeleccionadorBooleano
    %SB_Buffer = Num(:,3)==0;
    SB_Agit = Num(:,8)==1;

    seleccionadas=SB_Metf&SB_Agit;%&SB_Buffer;
    plot(horas, Num(seleccionadas,4:7), 'o-')
    ylim([2.5 6.5])
    grid on
    title( strcat("Metformina=", num2str(metforminas),"mM" ))
    if contador==4
        legend(Nombres(seleccionadas), "location", "best")
    end
    subplot(2,4,contador+4)
    seleccionadas2=SB_Metf&not(SB_Agit);%&SB_Buffer;
    plot(horas, Num(seleccionadas2,4:7), 'o-')
    ylim([2.5 6.5])
    grid on
    if contador==4
        legend(Nombres(seleccionadas2), "location", "best")
    end
end
%% Diferentes metforminas en el mismo pH
contador=0;
figure(4); clf

for pHs = [0, 3.6, 4.3, 5.5, 6 ]
    contador=contador+1;
    subplot(2,5,contador)
    %SB_Metf = Num(:,2)==metforminas; %SeleccionadorBooleano
    SB_Buffer = Num(:,3)==pHs;
    SB_Agit = Num(:,8)==1;

    seleccionadas=SB_Buffer&SB_Agit;%;
    plot(horas, Num(seleccionadas,4:7)', 'o-')
    ylim([2.5 6.5])
    grid on
    title( strcat("Buffer=", num2str(pHs) ))
    legend(Nombres(seleccionadas), "location", "best")
    
    
    
	subplot(2,5,contador+5)
    seleccionadas=SB_Buffer&not(SB_Agit);%;
    plot(horas, Num(seleccionadas,4:7)', 'o-')
    ylim([2.5 6.5])
    grid on
    title( strcat("Buffer=", num2str(pHs) ))
    legend(Nombres(seleccionadas), "location", "best")
    
    ylabel('pH')
    xlabel('Horas post inoculación')
    
end

subplot(2,5,1)
ylabel("pH")
%% 
save 20200911_GraficasPHvsTiempo