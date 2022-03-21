function refreshtracker( varargin)
%refreshtracker( varargin)
%clears the tracker screen and displays all control windows
%varargin: 1 to update values, enter nothing to refresh the screen

persistent HArray
global Par

if nargin > 0 && varargin{1} == 1
    cla
    WIN = Par.WIN;
    nmW = size(WIN,2);
    HArray = zeros(nmW+3,1);
    zoom = Par.ZOOM;
    xlim([-Par.HW /zoom Par.HW /zoom]);
    ylim([ -Par.HH /zoom  Par.HH /zoom]);
    
    fix.x = cos((1:61)/30*pi);
    fix.y = sin((1:61)/30*pi);  
    
    if Par.Bsqr
        dot.x = [-1 1 1 -1 -1];
        dot.y = [-1 -1 1 1 -1];
    else
         dot.x = cos((1:61)/30*pi);
         dot.y = sin((1:61)/30*pi);   
    end

        
    HArray(1) = line('XData', [-Par.HW Par.HW Par.HW -Par.HW -Par.HW], ...
               'YData', [-Par.HH -Par.HH Par.HH Par.HH -Par.HH]);
     
    HArray(2) = line('XData', WIN(1,1), 'YData', WIN(2,1));
    set(HArray(2), 'Marker', 'o', 'MarkerSize', 5*zoom, 'MarkerFaceColor', 'r')
    for i = 1:nmW
        if (WIN(5,i) == 0) %fix window   
            HArray(4+i) = line('XData', (fix.x*WIN(3,i)*0.5+WIN(1,i)),...           
                               'YData', (fix.y*WIN(4,i)*0.5+WIN(2,i)));
            HArray(3) = line('XData', (fix.x*WIN(3,i)*0.5*sqrt(0.5)+WIN(1,i)),...
                               'YData', (fix.y*WIN(4,i)*0.5*sqrt(0.5)+WIN(2,i)));
            set(HArray(3), 'Color', [0.7 0.7 0.7])
        elseif(WIN(5,i) == 2) %2 == correct target window            %                     width        cx                            height       cy
            HArray(4) = line('XData', (dot.x*WIN(3,i)*0.5+WIN(1,i)), 'YData', (dot.y*WIN(4,i)*0.5+WIN(2,i)));
            set(HArray(4), 'Color', 'm')
        else
            HArray(4+i) = line('XData', (dot.x*WIN(3,i)*0.5+WIN(1,i)), 'YData', (dot.y*WIN(4,i)*0.5+WIN(2,i)));
        end
    end
    
elseif varargin{1} == 2
    set(HArray(4), 'Color', 'g') 
    
elseif varargin{1} == 3
    set(HArray(2), 'MarkerFaceColor', 'g')
else   
    if ~isempty(HArray)
       cla( HArray )
    end
end