for num = 1:30
    disp(num)
    for decintrial = 1:numel(CenteredRT(num).CorrelateDecRef)
        lags = struct('neg10', 0, 'neg9', 0, 'neg8', 0, 'neg7', 0, 'neg6', 0, 'neg5', 0, 'neg4', 0, 'neg3', 0, 'neg2', 0, 'neg1', 0, 'zero', 0, 'one', 0, 'two', 0, 'three', 0, 'four', 0, 'five', 0, 'six', 0, 'seven', 0, 'eight', 0, 'nine', 0, 'ten', 0, 'NC', 0);
        multlags = struct('neg10', 0, 'neg9', 0, 'neg8', 0, 'neg7', 0, 'neg6', 0, 'neg5', 0, 'neg4', 0, 'neg3', 0, 'neg2', 0, 'neg1', 0, 'zero', 0, 'one', 0, 'two', 0, 'three', 0, 'four', 0, 'five', 0, 'six', 0, 'seven', 0, 'eight', 0, 'nine', 0, 'ten', 0, 'NC', 0);
        for row = 1:size(CenteredRT(num).CorrelateDecRef(decintrial).AllOffset, 1)
            for col = 1:size(CenteredRT(num).CorrelateDecRef(decintrial).AllOffset, 2)
                if CenteredRT(num).CorrelateDecRef(decintrial).AllOffset(row, col) == 0
                    break
                elseif isnan(CenteredRT(num).CorrelateDecRef(decintrial).AllOffset(row, col))
                    lags.NC = lags.NC + 1;
                end
                switch CenteredRT(num).CorrelateDecRef(decintrial).AllOffset(row, col)
                    case 11
                        lags.neg10 = lags.neg10 + 1;
                    case 12
                        lags.neg9 = lags.neg9 + 1;
                    case 13
                        lags.neg8 = lags.neg8 + 1;
                    case 14
                        lags.neg7 = lags.neg7 + 1;
                    case 15
                        lags.neg6 = lags.neg6 + 1;
                    case 16
                        lags.neg5 = lags.neg5 + 1;
                    case 17
                        lags.neg4 = lags.neg4 + 1;
                    case 18
                        lags.neg3 = lags.neg3 + 1;
                    case 19
                        lags.neg2 = lags.neg2 + 1;
                    case 20
                        lags.neg1 = lags.neg1 + 1;
                    case 21
                        lags.zero = lags.zero+ 1;
                    case 22
                        lags.one = lags.one + 1;
                    case 23
                        lags.two = lags.two + 1;
                    case 24
                        lags.three = lags.three + 1;
                    case 25
                        lags.four = lags.four + 1;
                    case 26
                        lags.five = lags.five + 1;
                    case 27
                        lags.six = lags.six + 1;
                    case 28
                        lags.seven = lags.seven + 1;
                    case 29
                        lags.eight = lags.eight + 1;
                    case 30
                        lags.nine = lags.nine + 1;
                    case 31
                        lags.ten = lags.ten + 1;
                end
            end
        end
        for row = 1:size(CenteredRT(num).CorrelateDecRef(decintrial).Mult, 1)
            for col = 1:size(CenteredRT(num).CorrelateDecRef(decintrial).Mult, 2)
                if isempty(CenteredRT(num).CorrelateDecRef(decintrial).Mult{row, col})
                    break
                elseif isnan(CenteredRT(num).CorrelateDecRef(decintrial).Mult{row, col})
                    multlags.NC = multlags.NC + 1;
                end
                for laggin = 1:numel(CenteredRT(num).CorrelateDecRef(decintrial).Mult{row, col})
                    
                switch CenteredRT(num).CorrelateDecRef(decintrial).Mult{row, col}(laggin)
                    case 11
                        multlags.neg10 = multlags.neg10 + 1;
                    case 12
                        multlags.neg9 = multlags.neg9 + 1;
                    case 13
                        multlags.neg8 = multlags.neg8 + 1;
                    case 14
                        multlags.neg7 = multlags.neg7 + 1;
                    case 15
                        multlags.neg6 = multlags.neg6 + 1;
                    case 16
                        multlags.neg5 = multlags.neg5 + 1;
                    case 17
                        multlags.neg4 = multlags.neg4 + 1;
                    case 18
                        multlags.neg3 = multlags.neg3 + 1;
                    case 19
                        multlags.neg2 = multlags.neg2 + 1;
                    case 20
                        multlags.neg1 = multlags.neg1 + 1;
                    case 21
                        multlags.zero = multlags.zero+ 1;
                    case 22
                        multlags.one = multlags.one + 1;
                    case 23
                        multlags.two = multlags.two + 1;
                    case 24
                        multlags.three = multlags.three + 1;
                    case 25
                        multlags.four = multlags.four + 1;
                    case 26
                        multlags.five = multlags.five + 1;
                    case 27
                        multlags.six = multlags.six + 1;
                    case 28
                        multlags.seven = multlags.seven + 1;
                    case 29
                        multlags.eight = multlags.eight + 1;
                    case 30
                        multlags.nine = multlags.nine + 1;
                    case 31
                        multlags.ten = multlags.ten + 1;
                end
                end
            end
        end
        CenteredRT(num).CorrelateDecRef(decintrial).Lags = lags;
        CenteredRT(num).CorrelateDecRef(decintrial).MultLags = multlags; 
    end
    for incintrial = 1:numel(CenteredRT(num).CorrelateIncRef)
        lags = struct('neg10', 0, 'neg9', 0, 'neg8', 0, 'neg7', 0, 'neg6', 0, 'neg5', 0, 'neg4', 0, 'neg3', 0, 'neg2', 0, 'neg1', 0, 'zero', 0, 'one', 0, 'two', 0, 'three', 0, 'four', 0, 'five', 0, 'six', 0, 'seven', 0, 'eight', 0, 'nine', 0, 'ten', 0, 'NC', 0);
        multlags = struct('neg10', 0, 'neg9', 0, 'neg8', 0, 'neg7', 0, 'neg6', 0, 'neg5', 0, 'neg4', 0, 'neg3', 0, 'neg2', 0, 'neg1', 0, 'zero', 0, 'one', 0, 'two', 0, 'three', 0, 'four', 0, 'five', 0, 'six', 0, 'seven', 0, 'eight', 0, 'nine', 0, 'ten', 0, 'NC', 0);
        for row = 1:size(CenteredRT(num).CorrelateIncRef(incintrial).AllOffset, 1)
            for col = 1:size(CenteredRT(num).CorrelateIncRef(incintrial).AllOffset, 2)
                if CenteredRT(num).CorrelateIncRef(incintrial).AllOffset(row, col) == 0
                    break
                elseif isnan(CenteredRT(num).CorrelateIncRef(incintrial).AllOffset(row, col))
                    lags.NC = lags.NC + 1;
                end
                switch CenteredRT(num).CorrelateIncRef(incintrial).AllOffset(row, col)
                    case 11
                        lags.neg10 = lags.neg10 + 1;
                    case 12
                        lags.neg9 = lags.neg9 + 1;
                    case 13
                        lags.neg8 = lags.neg8 + 1;
                    case 14
                        lags.neg7 = lags.neg7 + 1;
                    case 15
                        lags.neg6 = lags.neg6 + 1;
                    case 16
                        lags.neg5 = lags.neg5 + 1;
                    case 17
                        lags.neg4 = lags.neg4 + 1;
                    case 18
                        lags.neg3 = lags.neg3 + 1;
                    case 19
                        lags.neg2 = lags.neg2 + 1;
                    case 20
                        lags.neg1 = lags.neg1 + 1;
                    case 21
                        lags.zero = lags.zero+ 1;
                    case 22
                        lags.one = lags.one + 1;
                    case 23
                        lags.two = lags.two + 1;
                    case 24
                        lags.three = lags.three + 1;
                    case 25
                        lags.four = lags.four + 1;
                    case 26
                        lags.five = lags.five + 1;
                    case 27
                        lags.six = lags.six + 1;
                    case 28
                        lags.seven = lags.seven + 1;
                    case 29
                        lags.eight = lags.eight + 1;
                    case 30
                        lags.nine = lags.nine + 1;
                    case 31
                        lags.ten = lags.ten + 1;
                end
            end
        end
        for row = 1:size(CenteredRT(num).CorrelateIncRef(incintrial).Mult, 1)
            for col = 1:size(CenteredRT(num).CorrelateIncRef(incintrial).Mult, 2)
                if isempty(CenteredRT(num).CorrelateIncRef(incintrial).Mult{row, col})
                    break
                elseif isnan(CenteredRT(num).CorrelateIncRef(incintrial).Mult{row, col})
                    multlags.NC = multlags.NC + 1;
                end
                for laggin = 1:numel(CenteredRT(num).CorrelateIncRef(incintrial).Mult{row, col})
                switch CenteredRT(num).CorrelateIncRef(incintrial).Mult{row, col}(laggin)
                    case 11
                        multlags.neg10 = multlags.neg10 + 1;
                    case 12
                        multlags.neg9 = multlags.neg9 + 1;
                    case 13
                        multlags.neg8 = multlags.neg8 + 1;
                    case 14
                        multlags.neg7 = multlags.neg7 + 1;
                    case 15
                        multlags.neg6 = multlags.neg6 + 1;
                    case 16
                        multlags.neg5 = multlags.neg5 + 1;
                    case 17
                        multlags.neg4 = multlags.neg4 + 1;
                    case 18
                        multlags.neg3 = multlags.neg3 + 1;
                    case 19
                        multlags.neg2 = multlags.neg2 + 1;
                    case 20
                        multlags.neg1 = multlags.neg1 + 1;
                    case 21
                        multlags.zero = multlags.zero+ 1;
                    case 22
                        multlags.one = multlags.one + 1;
                    case 23
                        multlags.two = multlags.two + 1;
                    case 24
                        multlags.three = multlags.three + 1;
                    case 25
                        multlags.four = multlags.four + 1;
                    case 26
                        multlags.five = multlags.five + 1;
                    case 27
                        multlags.six = multlags.six + 1;
                    case 28
                        multlags.seven = multlags.seven + 1;
                    case 29
                        multlags.eight = multlags.eight + 1;
                    case 30
                        multlags.nine = multlags.nine + 1;
                    case 31
                        multlags.ten = multlags.ten + 1;
                    end
                end
            end
        end
        CenteredRT(num).CorrelateIncRef(incintrial).Lags = lags; 
        CenteredRT(num).CorrelateIncRef(incintrial).MultLags = multlags;
    end
end