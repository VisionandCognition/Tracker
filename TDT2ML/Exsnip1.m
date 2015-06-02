function CSnip = Exsnip1(EVENT, Trials)
%SIG = Exsnip(EVENT, Trials)
%
%Called by Tdt2ml to retrieve neurophysiological data (only snip data) after
%filtering the trigger array. 
%Returns a cell array :
%       1st dimension channels
%       2nd trials
%       each cell contains a struct array with two fields : 
%       time (double)
%       data (array of data samples (singles) containing the wave form)
%
%usage in batch files:
%define the following variables in EVENT
%Input : EVENT.Triallngth = s; % lenght of trial in seconds
%        EVENT.Start = s;      % start of trial relative to stimulus onset
%        EVENT.type = 'snips';
%        EVENT.Myevent = (string) event;    %snip event 
%
%       Trials : an array processed from the Trials array, which was 
%                returned by Exinf3.m
%
%Added sortcode to final data output
%
%Chris van der Togt, 11/11/2005
%updated 09/04/2013

CSnip = [];
Rt = strmatch(EVENT.Myevent, {EVENT.snips(:).name} );
if isempty(Rt)
    errordlg([EVENT.Myevent ' is not a snip type event'])
    return
end

%check if start and triallength exist
if ~isfield(EVENT, 'Start') || ~isfield(EVENT, 'Triallngth')
    errordlg('No Start or Triallngth defined');
    return
end

F = figure('Visible', 'off');
H = actxcontrol('TTANK.X', [20 20 60 60], F);
H.ConnectServer('local', 'me');

H.OpenTank(EVENT.Mytank, 'R');
H.SelectBlock(EVENT.Myblock);
H.CreateEpocIndexing;

EvCode = EVENT.Myevent; %event code as string
Sampf = EVENT.snips(Rt).sampf; %sample frequency for this event
Evlngth = EVENT.snips(Rt).size;    %number of samples in each event epoch
Evtime = Evlngth/Sampf; %timespan of one event epoch
if iscell(EVENT.snips(Rt).channels)
    ChaNm = length(EVENT.snips(Rt).channels); %channels in block is a cell
else
    ChaNm = EVENT.snips(Rt).channels; 
end

if isfield(EVENT, 'CHAN') && length(EVENT.CHAN) <= ChaNm
    Chans = EVENT.CHAN;  %SELECTED CHANNELS
    if size(Chans,2) == 1
        Chans = Chans';  %should be a row vector
    end
else
    Chans = 1:ChaNm;
end

CSnip = {};
EVNUM = round(ChaNm *(EVENT.Triallngth + 0.5)*Sampf/Evlngth); %more event
%epochs than needed

   for j = 1:size(Trials,1)
          OnsTrl = Trials(j,1) + EVENT.Start;  %time where trial should start relative to stimulus onset
          EndTrl = OnsTrl + EVENT.Triallngth;  %time where trial should end, based on trial lenght
          %select time window starting one event epoch(Evtime) earlier and ending one 
          %event epoch later.
        Recnum = H.ReadEventsV(EVNUM, EvCode, 0, 0, OnsTrl-Evtime, EndTrl+Evtime, 'ALL');
        ChnIdx = H.ParseEvInfoV(0, Recnum, 4);      %channel number corresponding to each epoch
        SortCode = H.ParseEvInfoV(0, Recnum, 5);    %Sort code
        Times = H.ParseEvInfoV(0, Recnum, 6);       %actual time onset of each epoch
        Data = H.ParseEvV(0, Recnum);               %event epoch data  
        %Times = Times - Trials(j,1);
                  
             Nc = 1;
             for i = Chans
                 D2 = Data(:,ChnIdx == i);
                 T2 = Times(ChnIdx == i);
                 Sc = SortCode(ChnIdx == i);
                 
                 CSnip(Nc,j) = { struct('time', num2cell(T2),  'sortcode',  num2cell(Sc) , 'data',  num2cell(D2, 1)) };

                 Nc = Nc + 1;
             end

  end
     
H.CloseTank;
H.ReleaseServer;
close(F)
