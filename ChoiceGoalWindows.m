RecordedTogether = struct;
RecordedTogether.Decreasers = {};
RecordedTogether.Increasers = {};
RecordedTogether.Decreasers.Neuron = [];
RecordedTogether.Increasers.Neuron = [];
RecordedTogether.Increasers.Timestamps = {};
RecordedTogether.Decreasers.Timestamps = {};
HistStep = 10^3;
for subjectnum = 1:25
    for sessionnum = 1:9
        CurrentRecording = CorrelateNeurons(subjectnum).animal(sessionnum).session;
        if isempty(CurrentRecording.decreasers) || isempty(CurrentRecording.increasers)
            continue
         else
            RecordedTogether(end+1).Decreasers.Neuron = [];
            RecordedTogether(end).Increasers.Neuron = [];
            RecordedTogether(end).Decreasers.Timestamps = {};
            RecordedTogether(end).Increasers.Timestamps = {};
            RecordedTogether(end).Decreasers.HistEdges = {};
            RecordedTogether(end).Increasers.HistEdges = {};
            for numdec = 1:numel(CurrentRecording.decreasers)
                recentIndex = 1;
                RecordedTogether(end).Decreasers.Neuron(end+1) = CurrentRecording.decreasers(numdec);
                for stampno = 1:numel(EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).ChoiceGoalTime)
                    if isnan(EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).ChoiceGoalTime(stampno))
                        RecordedTogether(end).Decreasers.Timestamps{numdec}{stampno} = 0;
                        RecordedTogether(end).Decreasers.HistEdges{numdec}{stampno} = 0;
                    else
                        RecordedTogether(end).Decreasers.Timestamps{numdec}{stampno} = [];
                        RecordedTogether(end).Decreasers.HistEdges{numdec}{stampno} = [(EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).ChoiceGoalTime(stampno)-5*10^6):HistStep:EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).ChoiceGoalTime(stampno)+10^7];
                        for timecheck = recentIndex:numel(EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).TimeStampsCell)
                            if EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).TimeStampsCell(timecheck) < EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).ChoiceGoalTime(stampno)-5*10^6
                                continue
                            elseif EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).ChoiceGoalTime(stampno)-5*10^6 <= EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).TimeStampsCell(timecheck)...
                            && EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).ChoiceGoalTime(stampno)+10^7 >= EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).TimeStampsCell(timecheck)
                                RecordedTogether(end).Decreasers.Timestamps{numdec}{stampno}(end+1) = [EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).TimeStampsCell(timecheck)];
                            elseif EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).ChoiceGoalTime(stampno)+10^7 < EventTimeStamps_fixed_all(CurrentRecording.decreasers(numdec)).TimeStampsCell(timecheck)
                                recentIndex = timecheck;
                                break
                            end
                        end
                    end
                end
            end
            for numinc = 1:numel(CurrentRecording.increasers)
                recentIndex = 1;
                RecordedTogether(end).Increasers.Neuron(end+1) = CurrentRecording.increasers(numinc);
                for stampno = 1:numel(EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).ChoiceGoalTime)
                    if isnan(EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).ChoiceGoalTime(stampno))
                        RecordedTogether(end).Increasers.Timestamps{numinc}{stampno} = 0;
                        RecordedTogether(end).Increasers.HistEdges{numinc}{stampno} = 0;
                    else
                        RecordedTogether(end).Increasers.Timestamps{numinc}{stampno} = [];
                        RecordedTogether(end).Increasers.HistEdges{numinc}{stampno} = [(EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).ChoiceGoalTime(stampno)-5*10^6):HistStep:EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).ChoiceGoalTime(stampno)+10^7];
                        for timecheck = recentIndex:numel(EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).TimeStampsCell)
                            if EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).TimeStampsCell(timecheck) < EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).ChoiceGoalTime(stampno)-5*10^6
                                continue
                            elseif EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).ChoiceGoalTime(stampno)-5*10^6 <= EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).TimeStampsCell(timecheck)...
                            && EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).ChoiceGoalTime(stampno)+10^7 >= EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).TimeStampsCell(timecheck)
                                RecordedTogether(end).Increasers.Timestamps{numinc}{stampno}(end+1) = [EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).TimeStampsCell(timecheck)];
                            elseif EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).ChoiceGoalTime(stampno)+10^7 < EventTimeStamps_fixed_all(CurrentRecording.increasers(numinc)).TimeStampsCell(timecheck)
                                recentIndex = timecheck;
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end
RecordedTogether(1) = [];