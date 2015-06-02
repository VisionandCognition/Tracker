function SIG = EXdata( EVENT )


Myevent = EVENT.Myevent;
Rt = strmatch(Myevent, {EVENT.strms(:).name} );
 if  isempty(Rt)
    errordlg([Myevent ' is not a stream type event'])
    return
 end

F = figure('Visible', 'off');
H = actxcontrol('TTANK.X', [20 20 60 60], F);
H.ConnectServer('local', 'me');

H.OpenTank(EVENT.Mytank, 'R');
H.SelectBlock(EVENT.Myblock);

EVCODE = int32(H.StringToEvCode(Myevent));
maxevnt = int32(10000);

Recnum = H.ReadEventsV(maxevnt, Myevent, int32(1), 0, 0, 0, 'NEW'); %read in number of events 
EVNUM = Recnum;
while Recnum == maxevnt
    Recnum = H.ReadEventsV(maxevnt, Myevent, int32(1), 0, 0, 0, 'NEW');
    EVNUM = EVNUM + Recnum;
end

SIG = zeros(EVENT.strms(Rt).size, EVNUM, length(EVENT.Chan));
for i = 1:length(EVENT.Chan)
    chan = EVENT.Chan(i);
    Recnum = H.ReadEvents(EVNUM, EVCODE, int32(chan), 0, 0, 0, 0);
    SIG(:,:,i) = H.ParseEvV(0, int32(Recnum)); 
    if i == 1
            Times = H.ParseEvInfoV(0, Recnum, 6); %time onset of each epoch
    end
end

 
H.CloseTank;
H.ReleaseServer;
close(F)

%set(txtObj, 'String', 'Checking data consistency');

sampf = EVENT.strms(Rt).sampf; %sample frequency for this event
Esz = size(SIG,1); %number of samples per epoch
Intvl = Esz/sampf; %time window per epoch = samples per epoch / sample frequency

[Times, Indx] = sort(Times);
Id = find(diff(Indx) ~= 1); %find instances of time disorder  
if ~isempty(Id)
    errordlg(['Timing disorder for ' EVENT.strms(Rt).name ])
    SIG = SIG(:,Indx,:); %each column represents an epoch of samples with a certain onset time
end                      %reorder in accordance with their time stamp
       
SIG = reshape(SIG, size(SIG,1)* size(SIG,2), length(EVENT.Chan));


    %SIG = checseq(SIG, Ind, EVENT, EVENT.CHAN);
    Indx = []; %set this to [] or your computer will stop responding    
    DT = diff(Times);
    Indx = find(DT > (Intvl + 1/sampf)); %find intervals in excess of 1 sample

    if ~isempty(Indx)
        %show where we miss data.
        figure
        plot(Times, 'r.')
        title(EVENT.strms(Rt).name)
        for i = 1:length(Indx)
          Blk = round(DT(Indx(i))*sampf) - Esz; %number of samples to insert minus one interval 
          Blk = zeros(Blk, EVENT.CHAN);   %matrix for all channels

          Smpl = round(Times(Indx(i)).*sampf);
          line([Indx(i) Indx(i)],[0 Times(Indx(i))])


          SIG2 = SIG(1:Smpl + Esz-1, :);
          SIG2 = [SIG2; Blk; SIG(Smpl + Esz:end, :)];
          SIG = SIG2;
        end
    end
