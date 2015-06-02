function EVENT = H5save(EVENT)
%EVENT = H5save(EVENT, Trilist)
%USAGE: hdf5 support for saving data from TDT Tanks
%IN : EVENT data structure, (see Exinfo3 )
%     Trilist array, first column should contain stimulus onset times
%     In the EVENT structure fields Triallngth and Start should be set.
%
%Chris van der Togt, 30-06-2006
%28-11-2006 : changed to save only snip channels containing values
%11-01-2008 : changed to add comments and edit the blockname
%14-02-2008 : user can add addtional information and save h5 file to other
%directory

%have all data members been set
if( ~isfield(EVENT, 'Triallngth') || ~isfield(EVENT, 'Start'))
    disp('Sorry first set Trial length and trial start')
    return
end

 if isfield(EVENT, 'filename')
     filename = [EVENT.filename '.h5'];
 else
       disp('You must provide : EVENT.filename !!')
    return
 end
%     filename = [EVENT.Mytank '.h5'];
%     EVENT.filename = filename;
% end
% button = questdlg(['Save/Add to ' filename], 'Save file', 'Yes');
% 
% if ~strcmp(button, 'Yes')
%     [pathstr, name] = fileparts(filename); 
%     dname = uigetdir(pathstr);
%     filename = );
%     EVENT.filename = filename;
% end
    
EVNT = hdf5.h5compound;

[~, Ss] = regexp(EVENT.Mytank, '\\', 'match', 'split');
Mytank = Ss{end};
h5str = hdf5.h5string(EVENT.Mytank);
addMember(EVNT, 'Mytank')
setMember(EVNT, 'Mytank', h5str)

Myblock = EVENT.Myblock;
h5str = hdf5.h5string(Myblock); %can be the orignal block name or an edited one
addMember(EVNT, 'Myblock')
setMember(EVNT, 'Myblock', h5str)

% addMember(EVNT, 'Code')
% fullfile(dname, namesetMember(EVNT, 'Code', hdf5.h5string(EVENT.Code));
% addMember(EVNT, 'Comment')
% 
% Str = EVENT.Comment;
% SzStr = size(Str,1);
% if SzStr == 1
%     setMember(EVNT, 'Comment', hdf5.h5string(Str));
% else
%     COMMENT = hdf5.h5compound;
%     Lines = strcat({'line-'},num2str((1:SzStr)','%d'));
%     for i = 1:SzStr
%         addMember(COMMENT, Lines{i})
%         setMember(COMMENT, Lines{i}, hdf5.h5string(Str(i,:) ))
%     end
%     setMember(EVNT, 'Comment', COMMENT);
% end

% str = [{'Change the block name'},...
%        {['Enter a code for this block', 10, 'You can use this to from a database         ']},...
%        {'Add a comment'}];
% def = [{EVENT.Myblock}, {'-'}, {'-'}];   
% answ = inputdlg( str, 'Block description', 1, def);
% 
% if ~isempty(answ)
%     if ~isempty(answ{1})
%         Myblock = answ{1};
%         setMember(EVNT, 'Myblock', hdf5.h5string(Myblock) )
%     end
%     if  ~isempty(answ{2})
%         setMember(EVNT, 'Code', hdf5.h5string(answ{2}));
%     end
%     if  ~isempty(answ{3})
%         setMember(EVNT, 'Comment', hdf5.h5string(answ{3}));
%     end
% end

strm = {};
snip = {};


if isfield(EVENT, 'strms')
    STRMS = hdf5.h5compound;
    strmn = length(EVENT.strms);
    for i = 1:strmn    
        SM = hdf5.h5compound;
        name = EVENT.strms(i).name;
        addMember(SM, 'name')
        setMember(SM, 'name', hdf5.h5string(name))
        addMember(SM, 'size')
        setMember(SM, 'size', EVENT.strms(i).size)
        addMember(SM, 'sampf')
        setMember(SM, 'sampf', EVENT.strms(i).sampf)
        addMember(SM, 'channels')
        setMember(SM, 'channels', EVENT.strms(i).channels)
        addMember(SM, 'bytes')
        setMember(SM, 'bytes', EVENT.strms(i).bytes)
    
        addMember(STRMS, name)
        setMember(STRMS, name, SM)
        strm(i) = {name};
    end
    addMember(EVNT, 'strms')
    setMember(EVNT, 'strms', STRMS)
    
    
end %adding streams

if isfield(EVENT, 'snips')
    SNIPS = hdf5.h5compound;
    snipn = length(EVENT.snips);
    for i = 1:snipn
        SP = hdf5.h5compound;
        name = EVENT.snips(i).name;
        addMember(SP, 'name')
        setMember(SP, 'name', hdf5.h5string(name))
        addMember(SP, 'size')
        setMember(SP, 'size', EVENT.snips(i).size)
        addMember(SP, 'sampf')
        setMember(SP, 'sampf', EVENT.snips(i).sampf)
        addMember(SP, 'bytes')
        setMember(SP, 'bytes', EVENT.snips(i).bytes)
        addMember(SP, 'channels')
        if iscell(EVENT.snips(i).channels)
                %in old EVENT structures this is a cell array of channels
                % h5arr = hdf5.h5array(EVENT.snips.(snip{i}).channels{:});
                snipchan = length(EVENT.snips(i).channels{:});
        else 
            snipchan = EVENT.snips(i).channels;
        end
        setMember(SP, 'channels', snipchan)
        addMember(SP, 'times')
        SPT = hdf5.h5compound;
        for j=1:snipchan
            h5arr = hdf5.h5array(EVENT.snips(i).times{j});
            if ~isempty(h5arr.Data)
                addMember(SPT, num2str(j))
                setMember(SPT, num2str(j), h5arr)
            end
        end
        setMember(SP, 'times', SPT)
        
        addMember(SNIPS, name)
        setMember(SNIPS, name, SP)
        snip(i) = {name};
    end
    addMember(EVNT, 'snips')
    setMember(EVNT, 'snips', SNIPS)   
    
end %add snips

if isfield(EVENT, 'strons')
    STRONS = hdf5.h5compound;
    stron = fieldnames(EVENT.strons);
    for i = 1:length(stron)
        h5arr = hdf5.h5array(EVENT.strons.(stron{i}));
        addMember(STRONS, stron{i})
        setMember(STRONS, stron{i}, h5arr)
    end
    addMember(EVNT, 'strons')
    setMember(EVNT, 'strons', STRONS)
end %add strobe on event info

if isfield(EVENT, 'Trials')
    TRIALS = hdf5.h5compound;
    trilnm = fieldnames(EVENT.Trials);
    Trils = zeros(length(EVENT.Trials.(trilnm{1})), length(trilnm) );
    for i = 1:length(trilnm)
        h5arr = hdf5.h5array(EVENT.Trials.(trilnm{i}));
        addMember(TRIALS, trilnm{i})
        setMember(TRIALS, trilnm{i}, h5arr)
        Trils(:,i) = EVENT.Trials.(trilnm{i});
    end
    addMember(EVNT, 'Trials')
    setMember(EVNT, 'Trials', TRIALS)
end




addMember(EVNT, 'Triallngth')
setMember(EVNT, 'Triallngth', EVENT.Triallngth)
addMember(EVNT, 'Start')
setMember(EVNT, 'Start', EVENT.Start)
if isfield(EVENT, 'CHAN')
    addMember(EVNT, 'CHAN')
    arr = hdf5.h5array(EVENT.CHAN);
    setName(arr, 'Selected channels');
    setMember(EVNT, 'CHAN', arr)
end
    
setName(EVNT, 'EVENT');


dset.Name = 'EVENT';
dset.Location = ['/' Mytank '/' Myblock];
if exist(filename, 'file') == 2
    wmode = 'append';
    S = hdf5info(filename,'ReadAttributes', false);
    Topnm = size(S.GroupHierarchy.Groups,2);
    for i = 1:Topnm
        if strcmp(S.GroupHierarchy.Groups(i).Name, dset.Location)
            button = questdlg( 'This datset already exists. Choosing Overwrite completely deletes the HDF file', ...
                                'Overwrite or Cancel', 'Overwrite','Cancel','Cancel');
            if strcmp(button, 'Overwrite')
                wmode = 'overwrite';
            else
                return
            end
        end
    end
else
    wmode = 'overwrite';
    
end

if strcmp(wmode, 'overwrite')
    DATASET = hdf5.h5compound;
    addMember(DATASET, 'Code')
%    setMember(DATASET, 'Code', hdf5.h5string('-'))
    addMember(DATASET, 'Description')
%    setMember(DATASET, 'Description', hdf5.h5string('-'))
    addMember(DATASET, 'Doc')
    
%     str = [ {['Overwrite or new h5 file.', 10, ...
%               'To retrieve your data in the future you might want to add addtional information', 10, 10, ...
%               'Enter dataset identifier for this tank (a code consisting of letters and numbers.']}, ...
%               {'Enter a path and filename (.doc or .pdf) with detailed information or an excerp from your labbook'},...
%             {['Enter comments here to describe the data;', 10, ... 
%               'Condition set and correspondence with the word value. ']} ];
%   
%     answ = inputdlg( str, 'Dataset description', [1 1 5; 80 80 80]');

    [Cond EVENT] = Hdfsi('Tank', EVENT);

        setMember(DATASET, 'Code', hdf5.h5string(EVENT.Tankcode));
        setMember(DATASET, 'Doc', hdf5.h5string(EVENT.Tankdoc));
        
        Str = EVENT.Tankcomment;
        SzStr = size(Str,1);
        if SzStr == 1
            setMember(DATASET, 'Description', hdf5.h5string(Str));
        else
            DESCR = hdf5.h5compound;
            Lines = strcat({'line-'},num2str((1:SzStr)','%d'));
            for i = 1:SzStr
                   addMember(DESCR, Lines{i})
                   setMember(DESCR, Lines{i}, hdf5.h5string(Str(i,:))) 
            end
            setMember(DATASET, 'Description', DESCR);
        end
    
    set.Name = 'Dataset';
    set.Location = '';
    hdf5write( filename, set, DATASET, 'WriteMode', wmode)
end

disp([10 '*** Saving ' Myblock 10 ' to ' filename 10])

hdf5write( filename, dset, EVNT, 'WriteMode', 'append')
disp('EVENT structure saved to HDF5')
%clear mex; %clears the file handel on the hdf file (bug in Matlab !!!!!!!!)
%retrieve all channels for envelop data
names = [strm snip];
[Selection,ok] = listdlg('ListString', names,...
                         'ListSize', [120 length(names)*15], ...
                         'Name', 'Save');
if(ok == 1)
    
    %only select trials with a proper stim onset
        
        Trials = Trils(~isnan(Trils(:,1)),:);
        TRLS = hdf5.h5array(Trials);
        setName(TRLS, 'Trials')    
        dset.Name = 'Trials';
        hdf5write( filename, dset, TRLS, 'WriteMode', 'append');
    
    
    for i = 1:length(Selection)
        if ismember(names(Selection(i)), strm)
            EVENT.Myevent = names{Selection(i)};
            SIG = Exd4(EVENT, Trials);
            SIGN = hdf5.h5array(SIG);
            setName(SIGN, EVENT.Myevent);
            dset.Name = EVENT.Myevent;
            hdf5write( filename, dset, SIGN, 'WriteMode', 'append');
            disp([ EVENT.Myevent ' saved to HDF5' ])
        
        elseif ismember(names(Selection(i)), snip)
            EVENT.Myevent = names{Selection(i)};
            SNP = Exsnip1(EVENT, Trials);
            % ni = size(SNP,1);
            if ~isempty(SNP)
                Nsnipchan = length(SPT.Membernames);
                for j = 1:Nsnipchan
                    snipchan = str2num(SPT.Membernames{j});

                    TMP = [SNP{snipchan,:}];
                    DATA = [TMP.data];
                    TIME = [TMP.time];

                    Cmpd = hdf5.h5compound;
                    addMember(Cmpd, 'time');
                    setMember(Cmpd, 'time', hdf5.h5array(TIME) );
                    addMember(Cmpd, 'data');
                    setMember(Cmpd, 'data', hdf5.h5array(DATA) );

                    dset.Location = ['/' Mytank '/' EVENT.Myblock '/' EVENT.Myevent ];
                    dset.Name = SPT.Membernames{j};
                    hdf5write( filename, dset, Cmpd, 'WriteMode', 'append')


                end
                disp([ EVENT.Myevent ' saved to HDF5' ])
            end
        end
    end
end
disp('finished saving to HDF5!')
