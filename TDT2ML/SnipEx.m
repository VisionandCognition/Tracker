function Dsnp = SnipEx(EVENT)





Dsnp = [];

EvCode = EVENT.Myevent;


F = figure('Visible', 'off');
H = actxcontrol('TTANK.X', [20 20 60 60], F);
H.ConnectServer('local', 'me');

if 0 == H.OpenTank(EVENT.Mytank, 'R')
    errordlg([EVENT.Mytank 'does not exist!!!'])
    H.CloseTank;
    H.ReleaseServer;
    close(F)
    return
end


H.SelectBlock(EVENT.Myblock);
H.CreateEpocIndexing;

Dsnp.Sampf = EVENT.snips.sampf; %sample frequency for this event
Dsnp.Evlngth = EVENT.snips.size; %number of samples in each epoch
ChaNm = EVENT.snips.channels; %channels in block
Chans = 1:ChaNm;

Recnum = H.ReadEventsV(1000*ChaNm, EvCode, 0, 0, 0, 0, 'ALL');


for i = Chans
    Dsnp(i).t = [];
    Dsnp(i).d = [];
end

while Recnum > 0
    ChnIdx = H.ParseEvInfoV(0, Recnum, 4);
    Times = H.ParseEvInfoV(0, Recnum, 6);
    Data = H.ParseEvV(0, Recnum);
    
    for i = Chans
        Ds = Data(:,ChnIdx == i);
        [Ts, Tdx] = sort(Times(ChnIdx == i));
        if any(diff(Tdx)-1)
            Ds = Ds(:,Tdx);
            disp('Warning, order error !!!!!')
        end

        Dsnp(i).t = [Dsnp(i).t Ts];
        Dsnp(i).d = [Dsnp(i).d Ds];

    
    end
    Recnum = H.ReadEventsV(100000, EvCode, 0, 0, 0, 0, 'NEW');
end

H.CloseTank;
H.ReleaseServer;
close(F)