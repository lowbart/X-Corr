CenteredRT = RecordedTogether; 

%for paired = 1:size(CenteredRT, 2)
%histograms in 10 ms bins - to change adjust the step value in ChoiceGoalWindows to 10^5 (for
%100 ms)
avgOffset = 0;
numelements = 0;
%stepval says the window around each event to xcorr. 10 is for 20 ms bins, 100
%is for 200 100 us bins, etc
stepval = 10;

%% Main Loop
%paired loops through every session with neuron pairs together (same
%animal, same session)
%for paired = 1   
for paired = 1:size(CenteredRT, 2)
    %DecRef and IncRef are categories for correlated pairs, using
    %Decreasers or Increasers as reference, respectively.
    CenteredRT(paired).CorrelateDecRef = struct('Pairs', [], 'AvgOffset', [], 'AllAvg', [], 'AllOffset', [], 'SEM',...
        [], 'AvgSEM', [], 'SampleSize', [], 'X_Corrs', [], 'Timestamps', [], 'Mult', {}, 'AllFR', []);
    CenteredRT(paired).CorrelateIncRef = struct('Pairs', [], 'AvgOffset', [], 'AllAvg', [], 'AllOffset', [], 'SEM',...
        [], 'AvgSEM', [], 'SampleSize', [], 'X_Corrs', [], 'Timestamps', [], 'Mult', {}, 'AllFR',[]);
    disp(paired)
    comparisons = numel(CenteredRT(paired).Decreasers.Timestamps)*numel(CenteredRT(paired).Increasers.Timestamps)
    for decintrial = 1:numel(CenteredRT(paired).Decreasers.Timestamps)
        for incintrial = 1:numel(CenteredRT(paired).Increasers.Timestamps)
            %Every 20 ms correlation's offset for an entire neuron
            %comparison, sorted by reward number in rows.
            trialOffset = {};
            %Timestamps of events in the 15 second windows.
            timestampsDecRef = {};
            %Offset for a given correlation when there were more than one
            %of either inc or dec in a 20 ms window.
            trialOffsetMult = {};
            %See above but for increasers as reference.
            trialOffset_increasers = {};
            timestampsIncRef = {};
            trialOffset_increasersMult = {};
            %Correlation values
            corrs_decref = {};
            corrs_incref = {};
            allFR_dec = [];
            allFR_inc = [];
            if incintrial == 1
                CenteredRT(paired).Decreasers.InstFR{1, decintrial} = cell(1, numel(CenteredRT(paired).Decreasers.Timestamps{1, decintrial}));
            end
            if decintrial == 1
                CenteredRT(paired).Increasers.InstFR{1, incintrial} = cell(1, numel(CenteredRT(paired).Increasers.Timestamps{1, incintrial}));
            end
            instFR_dec = zeros(numel(CenteredRT(paired).Decreasers.Timestamps{1, decintrial}), 15000);
            instFR_inc = zeros(numel(CenteredRT(paired).Increasers.Timestamps{1, incintrial}), 15000);
            for rewardno = 1:numel(CenteredRT(paired).Increasers.Timestamps{1, incintrial})
                if CenteredRT(paired).Increasers.HistEdges{1,incintrial}{1,rewardno} == 0
                    instFR_dec(rewardno, :) = NaN;
                    instFR_inc(rewardno, :) = NaN;
                    continue
                else
                    a = histogram(CenteredRT(paired).Increasers.Timestamps{1,incintrial}{1,rewardno}, CenteredRT(paired).Increasers.HistEdges{1,1}{1,rewardno}, 'FaceColor', 'red', 'EdgeColor', 'red');
                    incval = a.Values;
                    incbins = a.BinEdges;
                    b = histogram(CenteredRT(paired).Decreasers.Timestamps{1,decintrial}{1,rewardno}, CenteredRT(paired).Decreasers.HistEdges{1,1}{1,rewardno}, 'FaceColor', 'blue', 'EdgeColor', 'blue');   
                    decval = b.Values;
                    decbins = b.BinEdges;
                    clf
                    incevents = find(incval);
                    decevents = find(decval);
                    if incintrial == 1
                        lastref = 1;
                        for whichdecevent = 1:numel(decevents)
                            instFR_dec(rewardno, lastref:decevents(whichdecevent)) = 1/(decevents(whichdecevent)-lastref+1)*10^3;
                            allFR_dec(rewardno, whichdecevent) = 1/(decevents(whichdecevent)-lastref)*10^3;
                            lastref = decevents(whichdecevent)+1;
                        end
                        try
                            instFR_dec(rewardno, lastref:15000) = 1/(15000-lastref)*10^3;
                        catch
                        end
                        
                            
                    end
                    if decintrial == 1
                        lastref = 1;
                        for whichincevent = 1:numel(incevents)
                            instFR_inc(rewardno, lastref:incevents(whichincevent)) = 1/(incevents(whichincevent)-lastref+1)*10^3;
                            allFR_inc(rewardno, whichincevent) = 1/(incevents(whichincevent)-lastref)*10^3;
                            lastref = incevents(whichincevent)+1;
                        end
                        try
                            instFR_inc(rewardno, lastref:15000) = 1/(15000-lastref)*10^3;
                        catch
                        end
                        
                    end
                    for compareinc = 1:numel(incevents)
                        try
                            hist_inc = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0];
                            hist_dec = decval((incevents(compareinc)-stepval):(incevents(compareinc)+stepval));
                            mycorr = xcorr(hist_inc, hist_dec, 'normalized');
                            timestampsIncRef{rewardno, compareinc} = CenteredRT(paired).Increasers.Timestamps{1, incintrial}{1, rewardno}(compareinc);
                            if isnan(max(mycorr))
                                corrs_incref{rewardno, compareinc} = NaN;
                                trialOffset_increasers{rewardno, compareinc} = NaN;
                                trialOffset_increasersMult{rewardno, compareinc} = NaN;
                                continue
                            elseif numel(find(mycorr == max(mycorr))) == 1
                                trialOffset_increasers{rewardno, compareinc} = find(mycorr == max(mycorr));
                                trialOffset_increasersMult{rewardno, compareinc} = 0;
                                corrs_incref{rewardno, compareinc} = max(mycorr);
                            else
                                trialOffset_increasers{rewardno, compareinc} = 0;
                                trialOffset_increasersMult{rewardno, compareinc} = find(mycorr == max(mycorr));
                                corrs_incref{rewardno, compareinc} = max(mycorr);
                            end
                        catch
                            if incevents(compareinc) < 21
                                hist_inc = incval(1:(incevents(compareinc)+stepval));
                                hist_dec = decval(1:(incevents(compareinc)+stepval));
                                mycorr = xcorr(hist_inc, hist_dec, 'normalized'); 
                                timestampsIncRef{rewardno, compareinc} = CenteredRT(paired).Increasers.Timestamps{1, incintrial}{1, rewardno}(compareinc);
                                if isnan(max(mycorr))
                                    corrs_incref{rewardno, compareinc} = NaN;
                                    trialOffset_increasers{rewardno, compareinc} = NaN;
                                    trialOffset_increasersMult{rewardno, compareinc} = NaN;
                                    continue
                                elseif numel(find(mycorr == max(mycorr))) == 1
                                    trialOffset_increasers{rewardno, compareinc} = find(mycorr == max(mycorr));
                                    trialOffset_increasersMult{rewardno, compareinc} = 0;
                                    corrs_incref{rewardno, compareinc} = max(mycorr);
                                else
                                    trialOffset_increasers{rewardno, compareinc} = 0;
                                    trialOffset_increasersMult{rewardno, compareinc} = find(mycorr == max(mycorr));
                                    corrs_incref{rewardno, compareinc} = max(mycorr);
                                    
                                end
                            elseif incevents(compareinc) >14980
                                hist_inc = incval((incevents(compareinc)-stepval):end);
                                hist_dec = decval((incevents(compareinc)-stepval):end);
                                mycorr = xcorr(hist_inc, hist_dec, 'normalized');
                                timestampsIncRef{rewardno, compareinc} = CenteredRT(paired).Increasers.Timestamps{1, incintrial}{1, rewardno}(compareinc);
                                if isnan(max(mycorr))
                                    corrs_incref{rewardno, compareinc} = NaN;
                                    trialOffset_increasers{rewardno, compareinc} = NaN;
                                    trialOffset_increasersMult{rewardno, compareinc} = NaN;
                                    continue
                                elseif numel(find(mycorr == max(mycorr))) == 1
                                    trialOffset_increasers{rewardno, compareinc} = find(mycorr == max(mycorr));
                                    trialOffset_increasersMult{rewardno, compareinc} = 0;
                                    corrs_incref{rewardno, compareinc} = max(mycorr);
                                else
                                    trialOffset_increasers{rewardno, compareinc} = 0;
                                    trialOffset_increasersMult{rewardno, compareinc} = find(mycorr == max(mycorr));
                                    corrs_incref{rewardno, compareinc} = max(mycorr);
                                end
                            end
                        end
                    end
                    
                    for comparedec = 1:numel(decevents)
                        try
                            hist_dec = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0];;
                            hist_inc = incval((decevents(comparedec)-stepval):(decevents(comparedec)+stepval));
                            mycorr = xcorr(hist_dec, hist_inc, 'normalized');
                            timestampsDecRef{rewardno, comparedec} = CenteredRT(paired).Decreasers.Timestamps{1, decintrial}{1, rewardno}(comparedec);
                            if isnan(max(mycorr))
                                corrs_decref{rewardno, comparedec} = NaN;
                                trialOffset{rewardno, comparedec} = NaN;
                                trialOffsetMult{rewardno, comparedec} = NaN;
                                continue
                            elseif numel(find(mycorr == max(mycorr))) == 1
                                trialOffset{rewardno, comparedec} = find(mycorr == max(mycorr));
                                trialOffsetMult{rewardno, comparedec} = 0;
                                corrs_decref{rewardno, comparedec} = max(mycorr);
                            else
                                trialOffset{rewardno, comparedec} = 0;
                                trialOffsetMult{rewardno, comparedec} = find(mycorr == max(mycorr));
                                corrs_decref{rewardno, comparedec} = max(mycorr);
                            end
                        catch
                            if decevents(comparedec) < 21
                                hist_dec = decval(1:(decevents(comparedec)+stepval));
                                hist_inc = incval(1:(decevents(comparedec)+stepval));
                                mycorr = xcorr(hist_dec, hist_inc, 'normalized');
                                timestampsDecRef{rewardno, comparedec} = CenteredRT(paired).Decreasers.Timestamps{1, decintrial}{1, rewardno}(comparedec);
                                if isnan(max(mycorr))
                                    corrs_decref{rewardno, comparedec} = NaN;
                                    trialOffset{rewardno, comparedec} = NaN;
                                    trialOffsetMult{rewardno, comparedec} = NaN;
                                    continue
                                elseif numel(find(mycorr == max(mycorr))) == 1
                                    trialOffset{rewardno, comparedec} = find(mycorr == max(mycorr));
                                    trialOffsetMult{rewardno, comparedec} = 0;
                                    corrs_decref{rewardno, comparedec} = max(mycorr);
                                else
                                    trialOffset{rewardno, comparedec} = 0;
                                    trialOffsetMult{rewardno, comparedec} = find(mycorr == max(mycorr));
                                    corrs_decref{rewardno, comparedec} = max(mycorr);
                                end
                            elseif decevents(comparedec) > 14980
                                hist_dec = decval((decevents(comparedec)-stepval):end);
                                hist_inc = incval((decevents(comparedec)-stepval):end);
                                mycorr = xcorr(hist_dec, hist_inc, 'normalized');
                                timestampsDecRef{rewardno, comparedec} = CenteredRT(paired).Decreasers.Timestamps{1, decintrial}{1, rewardno}(comparedec);
                                if isnan(max(mycorr))
                                    corrs_decref{rewardno, comparedec} = NaN;
                                    trialOffset{rewardno, comparedec} = NaN;
                                    trialOffsetMult{rewardno, comparedec} = NaN;
                                    continue
                                elseif numel(find(mycorr == max(mycorr))) == 1
                                    trialOffset{rewardno, comparedec} = find(mycorr == max(mycorr));
                                    trialOffsetMult{rewardno, comparedec} = 0;
                                    corrs_decref{rewardno, comparedec} = max(mycorr);
                                else
                                    trialOffset{rewardno, comparedec} = 0;
                                    trialOffsetMult{rewardno, comparedec} = find(mycorr == max(mycorr));
                                    corrs_decref{rewardno, comparedec} = max(mycorr);
                                end
                            end
                        end
                    end
                end
            end
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).Pairs = [CenteredRT(paired).Decreasers.Neuron(decintrial), CenteredRT(paired).Increasers.Neuron(incintrial)];
            for padrow = 1:size(trialOffset, 1)
                for padcol = 1:size(trialOffset, 2)
                    if isempty(trialOffset{padrow, padcol})
                        trialOffset{padrow, padcol} = 0;
                    end
                end
            end
            decaverages = cell2mat(trialOffset);
            decavgreal = [];
            decsem = [];
            numxcorr_dec = [];
            for rewardnum = 1:size(decaverages, 1)
                zerofind = numel(nonzeros(decaverages(rewardnum, :)));
                decavgreal(end+1) = nanmean(nonzeros(decaverages(rewardnum, :)));
                if zerofind == 0
                    decsem(end+1) = NaN;
                else
                    decsem(end+1) = nanstd(nonzeros(decaverages(rewardnum, :)))/sqrt(zerofind);
                end
                numxcorr_dec(end+1) = (zerofind);
            end
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).AvgOffset = nanmean(decavgreal);
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).AllAvg = decavgreal;
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).AllOffset = decaverages;
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).SEM = decsem;
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).AvgSEM = nanmean(decsem);
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).SampleSize = numxcorr_dec;
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).X_Corrs = corrs_decref;
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).Timestamps = timestampsDecRef;
            CenteredRT(paired).CorrelateDecRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).Mult = trialOffsetMult;
            if incintrial == 1
                CenteredRT(paired).Decreasers.InstFR{decintrial} = instFR_dec;
                CenteredRT(paired).Decreasers.AllFR{decintrial} = allFR_dec;
            end
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).Pairs = [CenteredRT(paired).Increasers.Neuron(incintrial), CenteredRT(paired).Decreasers.Neuron(decintrial)];
            for padrow = 1:size(trialOffset_increasers, 1)
                for padcol = 1:size(trialOffset_increasers, 2)
                    if isempty(trialOffset_increasers{padrow, padcol})
                        trialOffset_increasers{padrow, padcol} = 0;
                    end
                end
            end
            incaverages = cell2mat(trialOffset_increasers);
            incavgreal = [];
            incsem = [];
            numxcorr_inc = [];
            for rewardnum = 1:size(incaverages, 1)
                zerofind = numel(nonzeros(incaverages(rewardnum, :)));
                incavgreal(end+1) = nanmean(nonzeros(incaverages(rewardnum, :)));
                if zerofind == 0
                    incsem(end+1) = NaN;
                else
                    incsem(end+1) = nanstd(nonzeros(incaverages(rewardnum, :)))/sqrt(zerofind);
                end
                numxcorr_inc(end+1) = (zerofind);
            end
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).AvgOffset = nanmean(incavgreal);
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).AllAvg = incavgreal;
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).AllOffset = incaverages;
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).SEM = incsem;
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).AvgSEM = nanmean(incsem);
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).SampleSize = numxcorr_inc;
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).X_Corrs = corrs_incref;
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).Timestamps = timestampsIncRef;
            CenteredRT(paired).CorrelateIncRef(decintrial+(incintrial-1)*numel(CenteredRT(paired).Decreasers.Timestamps)).Mult = trialOffset_increasersMult;
            if decintrial == 1
                CenteredRT(paired).Increasers.InstFR{incintrial} = instFR_inc;
                CenteredRT(paired).Increasers.AllFR{incintrial} = allFR_inc;
            end
        end
    end
end
