for cellnum = 1:540
    neuronfiringhistogram{cellnum,1} = ...
        SpikeHistData_all(cellnum).('ChoiceGoalTime')(find(cell2mat(SpikeHistData_all(cellnum).TrialType) == 'N' ...
        & (SpikeHistData_all(cellnum).Response == 1)),551:700);
        neuronfiringhistogram{cellnum,2} = ...
        SpikeHistData_all(cellnum).('ChoiceGoalTime')(find(cell2mat(SpikeHistData_all(cellnum).TrialType) == 'N' ...
        & (SpikeHistData_all(cellnum).Response == 0)),551:700);
    
        neuronfiringhistogram{cellnum,3} = ...
        SpikeHistData_all(cellnum).('ChoiceGoalTime')(find(cell2mat(SpikeHistData_all(cellnum).TrialType) == 'C' ...
        & (SpikeHistData_all(cellnum).Response == 1)),551:700);
        neuronfiringhistogram{cellnum,4} = ...
        SpikeHistData_all(cellnum).('ChoiceGoalTime')(find(cell2mat(SpikeHistData_all(cellnum).TrialType) == 'C' ...
        & (SpikeHistData_all(cellnum).Response == 0)),551:700);
    
            neuronfiringhistogram{cellnum,5} = ...
        SpikeHistData_all(cellnum).('ChoiceGoalTime')(find(cell2mat(SpikeHistData_all(cellnum).TrialType) == 'N'),551:700);
        neuronfiringhistogram{cellnum,6} = ...
        SpikeHistData_all(cellnum).('ChoiceGoalTime')(find(cell2mat(SpikeHistData_all(cellnum).TrialType) == 'C'),551:700);
end

for cellnum = 1:540
    try
    neuronfiringrate(cellnum,1) = nansum(nanmean(neuronfiringhistogram{cellnum,1}(:,51:110),1))/6;%correct OFF trials
        neuronfiringrate(cellnum,2) = nansum(nanmean(neuronfiringhistogram{cellnum,2}(:,51:110),1))/6;%incorrect OFF trials
            neuronfiringrate(cellnum,3) = nansum(nanmean(neuronfiringhistogram{cellnum,3}(:,51:110),1))/6;%correct CHOICE ON trials
        neuronfiringrate(cellnum,4) = nansum(nanmean(neuronfiringhistogram{cellnum,4}(:,51:110),1))/6;%incorrect CHOICE ON trials
        for i = 1:1000
            bootstrappedFRs1_and_2(cellnum,i) = nansum(nanmean(neuronfiringhistogram{cellnum,5}(randsample(size(neuronfiringhistogram{cellnum,5},1),round(size(neuronfiringhistogram{cellnum,1}(:,51:110),1)...
                + size(neuronfiringhistogram{cellnum,2}(:,51:110),1))/2),51:110)))/6;
            bootstrappedFRs3_and_4(cellnum,i) = nansum(nanmean(neuronfiringhistogram{cellnum,6}(randsample(size(neuronfiringhistogram{cellnum,6},1),round(size(neuronfiringhistogram{cellnum,3}(:,51:110),1)...
                + size(neuronfiringhistogram{cellnum,4}(:,51:110),1))/2),51:110)))/6;
        end
    catch
    end
end

        bootstrappedFRs1_and_2 = sort(bootstrappedFRs1_and_2,2);
        bootstrappedFRs3_and_4 = sort(bootstrappedFRs3_and_4,2);
        

for cellnum = 1:540
    if neuronfiringrate(cellnum,1)/neuronfiringrate(cellnum,2) >= 1.2
    increasers(cellnum) = 1;
    decreasers(cellnum) = 0;
    elseif neuronfiringrate(cellnum,1)/neuronfiringrate(cellnum,2) <= 0.8
        decreasers(cellnum) = 1;
        increasers(cellnum) = 0;
    else
    end
end
  
increasers_whichneurons = find(increasers == 1);
percent_increasers = length(increasers_whichneurons)/540*100;

decreasers_whichneurons = find(decreasers == 1);
percent_decreasers = length(decreasers_whichneurons)/540*100;

for cellnum = increasers_whichneurons
    temp1_2(cellnum,:) = abs(bootstrappedFRs1_and_2(cellnum,:) - neuronfiringrate(cellnum,1));
    temp = temp1_2(cellnum,:);
    if (sum(find(temp == min(temp1_2(cellnum,:)))>900) | sum(find(temp == min(temp1_2))<100)) >=1 
    else
        increasers(cellnum) = 2;
    end
end

for cellnum = decreasers_whichneurons
    temp1_2(cellnum,:) = abs(bootstrappedFRs1_and_2(cellnum,:) - neuronfiringrate(cellnum,1));
    temp = temp1_2(cellnum,:);
    if (sum(find(temp == min(temp1_2(cellnum,:)))>900) | sum(find(temp == min(temp1_2))<100)) >=1 
    else
        decreasers(cellnum) = 2;
    end
end

increasers_whichneurons_stringent = find(increasers == 1);
percent_increasers_stringent = length(increasers_whichneurons_stringent)/540*100;

decreasers_whichneurons_stringent = find(decreasers == 1);
percent_decreasers_stringent = length(decreasers_whichneurons_stringent)/540*100;

for trialtype = 1:4
    increasercellcount = 1;
    for cellnum = increasers_whichneurons
        increaser_histograms{increasercellcount,trialtype} =         cell2mat(neuronfiringhistogram(cellnum,trialtype));
        mean_increaser_histograms{increasercellcount,trialtype} = nanmean(cell2mat(neuronfiringhistogram(cellnum,trialtype)));
        increasercellcount = increasercellcount + 1;
    end
end

for trialtype = 1:4
    decreasercellcount = 1;
    for cellnum = decreasers_whichneurons
        decreaser_histograms{decreasercellcount,trialtype} =         cell2mat(neuronfiringhistogram(cellnum,trialtype));
        mean_decreaser_histograms{decreasercellcount,trialtype} = nanmean(cell2mat(neuronfiringhistogram(cellnum,trialtype)));
        decreasercellcount = decreasercellcount + 1;
    end
end

for trialtype = 1:4
        for cellnum = 1:increasercellcount - 1
    increaser_histograms_bytrialtype{trialtype}(cellnum,:) =  nanmean(increaser_histograms{cellnum,trialtype},1)/0.1;
        end
end

for trialtype = 1:4
        for cellnum = 1:decreasercellcount - 1
    decreaser_histograms_bytrialtype{trialtype}(cellnum,:) =  nanmean(decreaser_histograms{cellnum,trialtype},1)/0.1;
        end
end

figure;
plot(smooth(nanmean(increaser_histograms_bytrialtype{1})))
hold on; plot(smooth(nanmean(increaser_histograms_bytrialtype{2})))
title('Increasers, OFF trials')
figure;
plot(smooth(nanmean(increaser_histograms_bytrialtype{3})))
hold on; plot(smooth(nanmean(increaser_histograms_bytrialtype{4})))
title('Increasers, CHOICE ON trials')
figure;
plot(smooth(nanmean(decreaser_histograms_bytrialtype{1})))
hold on; plot(smooth(nanmean(decreaser_histograms_bytrialtype{2})))
title('Decreasers, OFF trials')
figure;
plot(smooth(nanmean(decreaser_histograms_bytrialtype{3})))
hold on; plot(smooth(nanmean(decreaser_histograms_bytrialtype{4'})))
title('Decreasers, CHOICE ON trials')
