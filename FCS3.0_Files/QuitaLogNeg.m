function AllData = QuitaLogNeg(AllData,x,y)
for pl = 1:length(AllData)
    for day = 1:length(AllData(pl).PL)
        for well = 1:length(AllData(pl).PL(day).WELL)
            todelete = AllData(pl).PL(day).WELL(well).dat(:,x)<0 | AllData(pl).PL(day).WELL(well).dat(:,y)<0;
            AllData(pl).PL(day).WELL(well).dat(todelete,:)=[];
        end
    end
end
