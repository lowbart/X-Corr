for paired = 1:30
    for decintrial = 1:numel(CenteredRT(paired).CorrelateDecRef)
        

        lagplot = [CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg10 CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg9 CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg8...
            CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg7 CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg6 CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg5...
            CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg4 CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg3 CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg2...
            CenteredRT(paired).CorrelateDecRef(decintrial).Lags.neg1 CenteredRT(paired).CorrelateDecRef(decintrial).Lags.zero CenteredRT(paired).CorrelateDecRef(decintrial).Lags.one...
            CenteredRT(paired).CorrelateDecRef(decintrial).Lags.two CenteredRT(paired).CorrelateDecRef(decintrial).Lags.three CenteredRT(paired).CorrelateDecRef(decintrial).Lags.four...
            CenteredRT(paired).CorrelateDecRef(decintrial).Lags.five CenteredRT(paired).CorrelateDecRef(decintrial).Lags.six CenteredRT(paired).CorrelateDecRef(decintrial).Lags.seven...
            CenteredRT(paired).CorrelateDecRef(decintrial).Lags.eight CenteredRT(paired).CorrelateDecRef(decintrial).Lags.nine CenteredRT(paired).CorrelateDecRef(decintrial).Lags.ten];
        multlagplot = [CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg10 CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg9 CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg8...
            CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg7 CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg6 CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg5...
            CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg4 CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg3 CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg2...
            CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.neg1 CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.zero CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.one...
            CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.two CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.three CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.four...
            CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.five CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.six CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.seven...
            CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.eight CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.nine CenteredRT(paired).CorrelateDecRef(decintrial).MultLags.ten];
        combined = lagplot + multlagplot;
        bar(combined, 'green')
        title([paired decintrial])
        pause
        bar(lagplot, 'blue')
        pause
        hold on
        bar(multlagplot, 'red')
        pause
        bar(lagplot, 'blue')
        pause
        x = input('See 1 second corr?', 's');
        clf
        if x == 'y'
            decstamps = EventTimeStamps_fixed_all(CenteredRT(paired).CorrelateDecRef(decintrial).Pairs(1)).TimeStampsCell;
            dechist = histogram(decstamps);
            dechist.NumBins = floor((decstamps(end)-decstamps(1))/10^3);
            numBins = dechist.NumBins;
            dechistval = dechist.Values;
            incstamps = EventTimeStamps_fixed_all(CenteredRT(paired).CorrelateDecRef(decintrial).Pairs(2)).TimeStampsCell;
            incsize = floor((incstamps(end)-incstamps(1))/10^3);
            discrep = numBins - incsize;
            inchist = histogram(incstamps);
            inchist.NumBins = incsize;
            inchistval = inchist.Values;
            if discrep > 0
                dechistval = dechistval(1:end-discrep);
            elseif discrep < 0
                inchistval = inchistval(1:end+discrep);
            end
            plot(xcorr(dechistval, inchistval, 1000))
            pause
            plot(xcorr(dechistval, dechistval, 1000))
            
            
       
            pause
        end
        x = input('See full corr?', 's');
        if x == 'y'
            decstamps = EventTimeStamps_fixed_all(CenteredRT(paired).CorrelateDecRef(decintrial).Pairs(1)).TimeStampsCell;
            dechist = histogram(decstamps);
            dechist.NumBins = floor((decstamps(end)-decstamps(1))/10^3);
            numBins = dechist.NumBins;
            dechistval = dechist.Values;
            incstamps = EventTimeStamps_fixed_all(CenteredRT(paired).CorrelateDecRef(decintrial).Pairs(2)).TimeStampsCell;
            incsize = floor((incstamps(end)-incstamps(1))/10^3);
            discrep = numBins - incsize;
            inchist = histogram(incstamps);
            inchist.NumBins = incsize;
            inchistval = inchist.Values;
            if discrep > 0
                dechistval = dechistval(1:end-discrep);
            elseif discrep < 0
                inchistval = inchistval(1:end+discrep);
            end
        plot(xcorr(dechistval, inchistval))
        pause
        
        
        
        plot(xcorr(dechistval, dechistval))
        pause
        end
    end
end


