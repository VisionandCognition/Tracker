function varargout = dbBrowser(varargin)
% DBBROWSER MATLAB code for dbBrowser.fig
%      DBBROWSER, by itself, creates a new DBBROWSER or raises the existing
%      singleton*.
%
%      H = DBBROWSER returns the handle to a new DBBROWSER or the handle to
%      the existing singleton*.
%
%      DBBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DBBROWSER.M with the given input arguments.
%
%      DBBROWSER('Property','Value',...) creates a new DBBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dbBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dbBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dbBrowser

% Last Modified by GUIDE v2.5 04-Aug-2017 09:45:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dbBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @dbBrowser_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before dbBrowser is made visible.
function dbBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dbBrowser (see VARARGIN)

% Choose default command line output for dbBrowser
handles.output = hObject;

javaaddpath([gitpath '\java\ttv.jar'])

DB = DbMVPparms;
handles.DB = DB;

set(handles.lb_colums, 'String', DB.Fields(1:end-3)) %not Datafile, Stimulus, URL

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dbBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dbBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function lb_colums_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_colums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pb_Done.
function pb_Done_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    h = handles;
    
    selection = get(h.lb_colums, 'Value');
    colnames = get(h.lb_colums, 'String');
    
if ~isempty(selection)
    fields = [ colnames(selection); 'Datafile'; 'Idx'];
    records = mysqlselect(handles.DB, fields);
     
    Idx = length(fields);
    for i = 1:size(records,1) %add record idx to identify return string, because Datafile is not unique
        records{i, Idx-1} = [records{i, Idx} '_' records{i, Idx-1}];
    end
 %   Sz = size(records,2);
    blocks = filepathfromtree(records(:,1:end-1)); %last column = Idx
    
    if ~isempty(blocks)        
        strwhere = 'Idx in (';  %Index is a unique identifier
        for i = 1:blocks.length()-1
            rcnm = sscanf(char(blocks(i)), '%d', 1); %identify record and get Datetime
            strwhere = [strwhere '"' num2str(rcnm) '",'];
        end
        rcnm = sscanf(char(blocks(blocks.length())), '%d', 1);
        strwhere = [strwhere '"' num2str(rcnm)  '")'];
        
        fields = handles.DB.Fields;
        records = mysqlselect(handles.DB, fields, strwhere);
        
        
        %t = uitable(f,'Data',records,...
        %    'ColumnName',fields, 'ColumnWidth', {'auto','auto','auto','auto','auto','auto','auto','auto','auto', 400});
        handles.uitable_rec.Data = records;
        handles.uitable_rec.ColumnName = fields;
        fldnm = length(fields);
        ColumnWidth = cell(1,fldnm);
        ColumnWidth(1:fldnm-1) = {'auto'};
        ColumnWidth(fldnm) = {500};
        %handles.uitable_rec.ColumnWidth = {'auto','auto','auto','auto','auto','auto','auto','auto','auto', 400};
        handles.uitable_rec.ColumnWidth = ColumnWidth;
       % handles.uitable_rec.ColumnEditable = logical([zeros(1,fldnm-1) 1]);
       % handles.uitable_rec.Position(3) = handles.uitable_rec.Extent(3);
        %handles.uitable_rec.Position(4) = handles.uitable_rec.Extent(4); 
        
       % handles.selection = selection;  
        handles.fields = fields;
        handles.records = records;
        handles.blocks = blocks;
        guidata(hObject, handles); 
    end
end

% function strOut = mycat( str1, str2)
%     strOut = [str1 ' : ' str2];

% % --- Executes on button press in pb_Import.
% function pb_Import_Callback(hObject, eventdata, handles)
% % hObject    handle to pb_Import (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global Par
%     h = handles;
% 
%     selection = get(h.lb_SelBlocks, 'Value');
%     colnames = get(h.lb_SelBlocks, 'String');
%     
%     if ~isempty(selection)
%         Datetime = colnames(selection,:);
%         rec = mysqlselect({'Pathraw', 'Filename'}, ['Datetime="' Datetime '"']);
% 
%         dbpath = [Par.PathDest  block ];
%         blckpath = [dbpath '\*.tif'];
%         filenms = dir(blckpath);
%         
%         if ~isempty(filenms)
%             blckpath = [dbpath '\' filenms(1).name];
%             
%             MIJ.start
%           %   MIJ.run('Bio-Formats', ['open=' blckpath ' autoscale color_mode=Default split_channels view=Hyperstack stack_order=XYCZT use_virtual_stack'] );
%             MIJ.run('Image Sequence...', ['open=' blckpath ' sort use']);
%         end
%         
%         btn = questdlg('Retrieve log file in addition?', 'Imagedb','yes', 'no', 'no');
%         if strcmp(btn,'yes') 
%             fnm = uigetfile([dbpath '\log.mat']);
%             if ~isempty(fnm)
%                 load([dbpath '\' fnm] );
%                 stim = log.stim;
%                 frames = log.frames;
%                 assignin('base', 'stim', stim)
%                 assignin('base', 'frames', frames)
%             end
%         end
%         
%     end

% 
% % --------------------------------------------------------------------
% function DisplayComment_Callback(hObject, eventdata, handles)
% % hObject    handle to DisplayComment (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
%         %get comment string associated with this block
%  h = handles;
%  selected = get(h.lb_SelBlocks, 'Value');
%  block = h.blocks(selected);
% 
%  if selected > 0
%    %  colnum = size(h.records,2);  
%    %  Ary = strfind(h.records(:,colnum-1), block);
%    %  Idx = find(not(cellfun('isempty', Ary)));    
%   %   if Idx > 0
%         Imagedb(0, char(block)) 
%    %  end
%  end
        


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitable_rec.
function uitable_rec_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_rec (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
    
    row = eventdata.Indices(1);
    column = eventdata.Indices(2);
    
    fieldname = handles.fields{column};
    recrdId = char(handles.blocks(row));
    
    mysqlupdate(fieldname, eventdata.EditData, recrdId);


% --- Executes when selected cell(s) is changed in uitable_rec.
function uitable_rec_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_rec (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
   
if ~isempty(eventdata.Indices)
    row = eventdata.Indices(1);
    column = eventdata.Indices(2);
    
    fields = handles.fields;
    
    fieldId = fields{column};
    fldurl = strcmp(fields, 'URL');
    
    
    switch fieldId
        case 'URL'
            strfile = handles.records(row, column);
            strfile = strrep(strfile{1}, '/volume1', '//mvpnin');
            md  =[];
            if exist(strfile, 'file')
                md = loadjson(strfile);
            end
            mfile = [strfile(1:end-13) '.mat'];
            if exist(mfile, 'file')
                inf = load(mfile);
                md.info = inf.info;
            end

           if ~isempty(md)
                assignin('base', 'metadata', md)
                openvar metadata
           else
                errordlg([filenmjs ' :  does not exist!!!'])
            end
            
       case 'Datafile'
            cf = handles.records(row, fldurl);
            strfile =  cf{1};
            strfile = strrep(strfile, '/volume1', '//mvpnin');
            sbxfile = strfile(1:end-13);
            if  exist([sbxfile '.mat'], 'file')
                Showsbx(sbxfile)
            end
    end
end



% --------------------------------------------------------------------
function import_Callback(hObject, eventdata, handles)
% hObject    handle to import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %global Par
    
    fields = handles.fields;
    records = handles.records;
    pidx  = strcmp(fields, 'Pathraw');
    fidx = strcmp(fields, 'Filename');
    Cmidx = strcmp(fields, 'Comments');
    Sidx = strcmp(fields, 'Stimulus');
    
    Datasrc = cell(size(records,1), 3); %record source
    recinf = []; %record id
    
    hwb = waitbar(0);
    for i = 1:size(records,1)        
        Datasrc{i,1} = [records{i,pidx} '\' records{i,fidx}];
        Datasrc{i,2} = records{i,Sidx};
        Datasrc{i,3} = records{i,Cmidx};
        
        filenm = [Datasrc{i,1} '.rcrd'];
        filenmjs = [Datasrc{i,1} '.json'];

        if exist(filenmjs, 'file')
            parms = loadjson(filenmjs);

            fldnm = fieldnames(parms);
            for j = 1:length(fldnm)
                recinf{i}.(fldnm{j}) = parms.(fldnm{j}); %copy info
            end
   
        elseif exist(filenm, 'file')
            parms = load(filenm, '-mat');
            fldnm = fieldnames(parms);
            for j = 1:length(fldnm)
                recinf{i}.(fldnm{j}) = parms.(fldnm{j}); %copy info
            end
                     
        else
            disp([filenmjs ' : Does not exist!!']);
            recinf{i} = [];
        end
        waitbar(i/size(records,1) , hwb);
    end
    close(hwb);
    
    Tbl.recinf = recinf;
    Tbl.Datasrc = Datasrc;   
    assignin('base', 'Tbl', Tbl)
    disp('Data imported!!!')
    
        


% --- Executes on selection change in lb_colums.
function lb_colums_Callback(hObject, eventdata, handles)
% hObject    handle to lb_colums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_colums contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_colums
