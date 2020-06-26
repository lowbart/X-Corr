%Run this script if you have 'SpikeHistData_all-120-revised' loaded into
%your workspace. It will generate the structure AnimalPerformance, where
%each row is the animal number and the cells in PercentCorrect contain the
%array of average performance over all trials in a session for each animal. 

%Plot individual sessions for a given animal and session using your own
%values of animalnum and sessionnum in the following notation:
%plot(AnimalPerformance(animalnum).PercentCorrect{sessionnum})


AnimalPerformance = struct('Session', [], 'Responses', {}, 'PercentCorrect', {});
animalnum = 0;
sessionnum = 0;
for neuron = 1:540
    if SpikeHistData_animal(neuron) == animalnum && SpikeHistData_session(neuron) == sessionnum
        continue
    end
    if SpikeHistData_animal(neuron) ~= animalnum
        animalnum = SpikeHistData_animal(neuron);
        newanimal = 1;
    else
        newanimal = 0;
    end
    if SpikeHistData_session(neuron) ~= sessionnum
        sessionnum = SpikeHistData_session(neuron);
        if newanimal == 1
            index = 1;
        else
            index = 1+index;
        end
    end
    try
        AnimalPerformance(animalnum).Responses{index} = SpikeHistData_all(neuron).Response;
        AnimalPerformance(animalnum).Session(index) = sessionnum;
    catch
    end
end
for whichanimal = 1:25
    if isempty(AnimalPerformance(whichanimal).Responses)
        continue
    end
    for whichsession = 1:numel(AnimalPerformance(whichanimal).Responses)
        if isempty(AnimalPerformance(whichanimal).Responses{whichsession})
            continue
        else
            pctcorrect = [];
            for num = 1:5
                pctcorrect(num) = sum(AnimalPerformance(whichanimal).Responses{whichsession}(1:num+5))/(num+5);
            end
            for num = 6:numel(AnimalPerformance(whichanimal).Responses{whichsession})-6
                pctcorrect(num) = sum(AnimalPerformance(whichanimal).Responses{whichsession}(num-5:num+5))/11;
            end
            for num = numel(AnimalPerformance(whichanimal).Responses{whichsession})-6:numel(AnimalPerformance(whichanimal).Responses{whichsession})-1
                pctcorrect(num) = sum(AnimalPerformance(whichanimal).Responses{whichsession}(num-5:numel(AnimalPerformance(whichanimal).Responses{whichsession})-1))/(numel(AnimalPerformance(whichanimal).Responses{whichsession})-num+5);
            end
        end
        AnimalPerformance(whichanimal).PercentCorrect{end+1} = pctcorrect;
    end
    if isempty(find(AnimalPerformance(whichanimal).Session == 0, 1))
    else
        blanks = find(AnimalPerformance(whichanimal).Session == 0, 1);
        for cleanzero = numel(blanks):1
            AnimalPerformance(whichanimal).Session(blanks(cleanzero)) = [];
            AnimalPerformance(whichanimal).Responses{blanks(cleanzero)} = [];
            AnimalPerformance(whichanimal).PercentCorrect{blanks(cleanzero)} = [];
        end
    end
end
            