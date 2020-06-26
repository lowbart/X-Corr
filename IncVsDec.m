%This script sorts the increasers and decreasers from the session data into
%individual animal and session data for further processing


CorrelateNeurons = struct;
EventTimeStamps_fixed_animal = evalin('base', 'EventTimeStamps_fixed_animal');
EventTimeStamps_fixed_session = evalin('base', 'EventTimeStamps_fixed_session');
decreasers_whichneurons = evalin('base', 'decreasers_whichneurons');
increasers_whichneurons = evalin('base', 'increasers_whichneurons');
for animalfill = 1:max(EventTimeStamps_fixed_animal)
    for sessionfill = 1:max(EventTimeStamps_fixed_session)
        CorrelateNeurons(animalfill).animal(sessionfill).session.decreasers = [];
        CorrelateNeurons(animalfill).animal(sessionfill).session.increasers = [];
    end
end

for elemdec = 1:numel(decreasers_whichneurons)
    CorrelateNeurons(EventTimeStamps_fixed_animal(decreasers_whichneurons(elemdec))).animal(EventTimeStamps_fixed_session(decreasers_whichneurons(elemdec))).session.decreasers(end+1) = decreasers_whichneurons(elemdec);
end
for eleminc = 1:numel(increasers_whichneurons)
    CorrelateNeurons(EventTimeStamps_fixed_animal(increasers_whichneurons(eleminc))).animal(EventTimeStamps_fixed_session(increasers_whichneurons(eleminc))).session.increasers(end+1) = increasers_whichneurons(eleminc);
end

