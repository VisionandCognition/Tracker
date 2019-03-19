function output = LPStat(varargin) 
    global dummyTime
    global dasMode
    
    % default output = 0
    output = 0;
    
    if ~isempty(varargin)
         % return time in ms if input was 0
        if varargin{1} == 0
            output = toc(dummyTime).*1000;
        end
        
        % return fake Hit if input was 1
        if varargin{1} == 1
            switch dasMode
                case 0
                    % in mode 0 we check for entering fixation, so set to 1
                    % straight away
                    output = 1;
                case 1
                    output = 0;
                case 2 
                    output = 0;
                case 3 
                    output = 0;
            end
        end
    end
    
end