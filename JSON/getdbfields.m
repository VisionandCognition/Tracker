function varargout = getdbfields(varargin)
% GETDBFIELDS MATLAB code for getdbfields.fig
%      GETDBFIELDS, by itself, creates a new GETDBFIELDS or raises the existing
%      singleton*.
%
%      H = GETDBFIELDS returns the handle to a new GETDBFIELDS or the handle to
%      the existing singleton*.
%
%      GETDBFIELDS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GETDBFIELDS.M with the given input arguments.
%
%      GETDBFIELDS('Property','Value',...) creates a new GETDBFIELDS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before getdbfields_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to getdbfields_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help getdbfields

% Last Modified by GUIDE v2.5 26-Feb-2018 13:27:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @getdbfields_OpeningFcn, ...
                   'gui_OutputFcn',  @getdbfields_OutputFcn, ...
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


% --- Executes just before getdbfields is made visible.
function getdbfields_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to getdbfields (see VARARGIN)

    %parameters for the vision and cognition database
    if strcmp(varargin{1}, 'VC')
        dbpar = DbVCparms();
    elseif strcmp(varargin{1}, 'MVP')
        dbpar = DbMVPparms();
    end
    handles.dbpar = dbpar;

    dgc = mysql('open', dbpar.Server, dbpar.User, dbpar.Passw);
    dbdb = mysql('use', dbpar.Database);
    
    
     
    VC.projects = mysql('SELECT strname FROM Projects');
    VC.datasets = mysql('SELECT strname FROM Datasets');
    VC.protocols = mysql('SELECT strname FROM Protocols');
    VC.subjects = mysql('SELECT strname FROM Subjects');
    VC.groups = mysql('SELECT strname FROM Groups');
    VC.researchers = mysql('SELECT strname FROM Researcher');
    VC.setups = mysql('SELECT strname FROM Setups');
    VC.stims = mysql('SELECT strname FROM Stimulus');
    
    
    mysql('close')
    
    set(handles.figure1, 'Name', dbpar.Database)
    set(handles.e_project, 'String', VC.projects);
    set(handles.e_protocol, 'String', VC.protocols);
    set(handles.e_dataset, 'String', VC.datasets);
    set(handles.e_subject, 'String', VC.subjects );
    set(handles.e_group, 'String', VC.groups );
    set(handles.e_researcher, 'String', VC.researchers); 
    set(handles.e_date, 'String', datestr(now, 'yyyymmdd'));
    set(handles.e_setup, 'String', VC.setups); 
    set(handles.e_stim, 'String', VC.stims);
       
    handles.record.Project = VC.projects{1,1};
    handles.record.Protocol = VC.protocols{1,1};
    handles.record.Dataset = VC.datasets{1,1};
    handles.record.Subject = VC.subjects{1,1};
    handles.record.Group = VC.groups{1,1};
    handles.record.Researcher = VC.researchers{1,1};
    handles.record.Date = datestr(now, 'yyyymmdd');
    handles.record.Setup = VC.setups{1,1};
    handles.record.Stimulus = VC.stims{1,1};
    
    if length(varargin)> 1 %setting to previous values if they exist
       entries = varargin{2};
       if isfield(entries, 'Project') && ~isempty(find(strcmp(VC.projects, entries.Project),1))
           indx = find(strcmp(VC.projects, entries.Project),1);
           handles.record.Project = VC.projects{indx,1};
           set(handles.e_project,'Value', indx);
       end
       if isfield(entries, 'Protocol') && ~isempty(find(strcmp(VC.protocols, entries.Protocol),1))
           indx = find(strcmp(VC.protocols, entries.Protocol),1);
           handles.record.Protocol = VC.protocols{indx,1};
           set(handles.e_protocol,'Value', indx);
       end
       if isfield(entries, 'Dataset') && ~isempty(find(strcmp(VC.datasets, entries.Dataset),1))
           indx = find(strcmp(VC.datasets, entries.Dataset),1);
           handles.record.Dataset = VC.datasets{indx,1};
           set(handles.e_dataset,'Value', indx);
       end
       if isfield(entries, 'Subject') && ~isempty(find(strcmp(VC.subjects, entries.Subject),1))
           indx = find(strcmp(VC.subjects, entries.Subject),1);
           handles.record.Subject = VC.subjects{indx,1};
           set(handles.e_subject,'Value', indx);
       end
       if isfield(entries, 'Group') && ~isempty(find(strcmp(VC.groups, entries.Group),1))
           indx = find(strcmp(VC.groups, entries.Group),1);
           handles.record.Group = VC.groups{indx,1};
           set(handles.e_group,'Value', indx);
       end
       if isfield(entries, 'Researcher') && ~isempty(find(strcmp(VC.researchers, entries.Researcher),1))
           indx = find(strcmp(VC.researchers, entries.Researcher),1);
           handles.record.Researcher = VC.researchers{indx,1};
           set(handles.e_researcher,'Value', indx);
       end
       if isfield(entries, 'Setup') && ~isempty(find(strcmp(VC.setups, entries.Setup),1))
           indx = find(strcmp(VC.setups, entries.Setup),1);
           handles.record.Setup = VC.setups{indx,1};
           set(handles.e_setup,'Value', indx);
       end
       if isfield(entries, 'Stimulus') && ~isempty(find(strcmp(VC.stims, entries.Stimulus),1))
           indx = find(strcmp(VC.stims, entries.Stimulus),1);
           handles.record.Stimulus = VC.stims{indx,1};
           set(handles.e_stim,'Value', indx);
       end
    end
    

    
    
    
handles.VC = VC;    
% Choose default command line output for getdbfields
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes getdbfields wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = getdbfields_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.record;

delete(hObject)

% --- Executes on selection change in e_project.
function e_project_Callback(hObject, eventdata, handles)
% hObject    handle to e_project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns e_project contents as cell array
%        contents{get(hObject,'Value')} returns selected item from e_project
 projects = get(hObject,'String');
 sel = get(hObject,'Value');
 handles.record.Project =  projects{sel};
 guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function e_project_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in e_protocol.
function e_protocol_Callback(hObject, eventdata, handles)
% hObject    handle to e_protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns e_protocol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from e_protocol
protocols = get(hObject,'String');
sel = get(hObject,'Value');
handles.record.Protocol = protocols{sel};
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function e_protocol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in e_subject.
function e_subject_Callback(hObject, eventdata, handles)
% hObject    handle to e_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns e_subject contents as cell array
%        contents{get(hObject,'Value')} returns selected item from e_subject
    subjects = get(hObject,'String');
    sel = get(hObject,'Value');
    handles.record.Subject = subjects{sel};
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function e_subject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Proj_pb.
function Proj_pb_Callback(hObject, eventdata, handles)
% hObject    handle to Proj_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = inputdlg('New project title', '');
if ~isempty(answer)
    handles.VC.projects =  [ handles.VC.projects;  answer ];
    set(handles.e_project, 'string', handles.VC.projects );
    handles.record.Project = answer{1};
    set(handles.e_project, 'Value',  length(handles.VC.projects))
    
    guidata(hObject, handles);
    
    dgc = mysql('open', handles.dbpar.Server, handles.dbpar.User, handles.dbpar.Passw);
    dgc = mysql('use', handles.dbpar.Database);
    QUERY = ['INSERT INTO Projects '  ...
        '(strname) ' ...
        'VALUES( "' handles.record.Project '" ) ' ];
    
    mysql(QUERY);
    mysql('close')
end
    
% --- Executes on button press in Prot_pb.
function Prot_pb_Callback(hObject, eventdata, handles)
% hObject    handle to Prot_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = inputdlg('New protocol', '');
if ~isempty(answer)
    handles.VC.protocols =  [ handles.VC.protocols;  answer ];
    set(handles.e_protocol, 'string', handles.VC.protocols );
    handles.record.Protocol = answer{1};
    set(handles.e_protocol, 'Value', length(handles.VC.protocols))
    
    guidata(hObject, handles);
    
    dgc = mysql('open', handles.dbpar.Server, handles.dbpar.User, handles.dbpar.Passw);
    dgc = mysql('use', handles.dbpar.Database);
    QUERY = ['INSERT INTO Protocols '  ...
        '(strname) ' ...
        'VALUES( "' handles.record.Protocol '" ) ' ];
    
    mysql(QUERY);
    mysql('close')
end

% --- Executes on button press in Subject_pb.
function Subject_pb_Callback(hObject, eventdata, handles)
% hObject    handle to Subject_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


answer = inputdlg({'Name for new subject', 'Species (human, monkey, mouse)', 'Sex', 'Genotype'}, 'New' );

if ~isempty(answer)
    handles.VC.subjects =  [ handles.VC.subjects;  answer{1} ];
    set(handles.e_subject, 'string', handles.VC.subjects )
    set(handles.e_subject, 'Value', length(handles.VC.subjects))
    handles.record.Subject = answer{1};
    
    dgc = mysql('open', handles.dbpar.Server, handles.dbpar.User, handles.dbpar.Passw);
    dgc = mysql('use', handles.dbpar.Database);
    QUERY = ['INSERT INTO Subjects '  ...
        '(strname, species, sex, genotype) ' ...
        'VALUES( "' answer{1} '" , "' answer{2} '" , "' answer{3} '" , "' answer{4} '" ) ' ];
    
    mysql(QUERY);
    mysql('close');
    
    guidata(hObject, handles);
end
    
% --- Executes on button press in date_pb.
function date_pb_Callback(hObject, eventdata, handles)
% hObject    handle to date_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
res = uical();
set(handles.e_date, 'String', datestr(res, 'yyyymmdd' ))
handles.record.Date = datestr(res, 'yyyymmdd' );

guidata(hObject, handles);

% --- Executes on selection change in e_setup.
function e_setup_Callback(hObject, eventdata, handles)
% hObject    handle to e_setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns e_setup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from e_setup
setups = get(hObject,'String');
sel = get(hObject,'Value');
handles.record.Setup = setups{sel};
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function e_setup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setup_pb.
function setup_pb_Callback(hObject, eventdata, handles)
% hObject    handle to setup_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


answer = inputdlg('New setup', '');
if ~isempty(answer)
    handles.VC.setups =  [ handles.VC.setups;  answer{1} ];
    set(handles.e_setup, 'string', handles.VC.setups );
    set(handles.e_setup, 'Value', length(handles.VC.setups));
    
    handles.record.Setup = answer{1};
    
    guidata(hObject, handles);
    
    dgc = mysql('open', handles.dbpar.Server, handles.dbpar.User, handles.dbpar.Passw);
    dgc = mysql('use', handles.dbpar.Database);
    QUERY = ['INSERT INTO Setups '  ...
        '(strname) ' ...
        'VALUES( "' handles.record.Setup '" ) ' ];
    
    mysql(QUERY);
    mysql('close')
end

% --- Executes on selection change in e_stim.
function e_stim_Callback(hObject, eventdata, handles)
% hObject    handle to e_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns e_stim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from e_stim
    stims = get(hObject,'String');
    sel = get(hObject,'Value');
    handles.record.Stimulus = stims{sel};
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function e_stim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stim_pb.
function stim_pb_Callback(hObject, eventdata, handles)
% hObject    handle to stim_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = inputdlg({'Name for new stimulus'}, 'New' );
if ~isempty(answer)
    handles.VC.stims =  [ handles.VC.stims;  answer{1} ];
    set(handles.e_stim, 'string', handles.VC.stims )
    set(handles.e_stim, 'Value', length(handles.VC.stims))
    handles.record.Stimulus = answer{1};
    guidata(hObject, handles);
    
    dgc = mysql('open', handles.dbpar.Server, handles.dbpar.User, handles.dbpar.Passw);
    dgc = mysql('use', handles.dbpar.Database);
    QUERY = ['INSERT INTO Stimulus '  ...
        '(strname) ' ...
        'VALUE( "' handles.record.Stimulus '" ) ' ];
    
    mysql(QUERY);
    mysql('close');
end
    
% --- Executes on selection change in e_researcher.
function e_researcher_Callback(hObject, eventdata, handles)
% hObject    handle to e_researcher (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns e_researcher contents as cell array
%        contents{get(hObject,'Value')} returns selected item from e_researcher
    researchers = get(hObject,'String');
    sel = get(hObject,'Value');
    handles.record.Researcher = researchers{sel};
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function e_researcher_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_researcher (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Research_pb.
function Research_pb_Callback(hObject, eventdata, handles)
% hObject    handle to Research_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    answer = inputdlg({'Name for new researcher'}, 'New' );
    if ~isempty(answer)
        handles.VC.researchers =  [ handles.VC.researchers;  answer{1} ];
        set(handles.e_researcher, 'string', handles.VC.researchers)
        set(handles.e_researcher, 'Value', length(handles.VC.researchers))
        handles.record.Researcher= answer{1};
        
        dgc = mysql('open', handles.dbpar.Server, handles.dbpar.User, handles.dbpar.Passw);
        dgc = mysql('use', handles.dbpar.Database);
        QUERY = ['INSERT INTO Researcher '  ...
            '(strname) ' ...
            'VALUES( "' answer{1} '" ) ' ];
        
        mysql(QUERY);
        mysql('close');
        
        guidata(hObject, handles);
    end
    
   


% --- Executes on button press in Done_pb.
function Done_pb_Callback(hObject, eventdata, handles)
% hObject    handle to Done_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(gcbf)


% --- Executes on selection change in e_dataset.
function e_dataset_Callback(hObject, eventdata, handles)
% hObject    handle to e_dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns e_dataset contents as cell array
%        contents{get(hObject,'Value')} returns selected item from e_dataset
    datasets = get(hObject,'String');
    sel = get(hObject,'Value');
    handles.record.Dataset = datasets{sel};
    guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function e_dataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dataset_pb.
function dataset_pb_Callback(hObject, eventdata, handles)
% hObject    handle to dataset_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = inputdlg({'Name for new dataset'}, 'New' );
if ~isempty(answer)
    handles.VC.datasets =  [ handles.VC.datasets;  answer{1} ];
    set(handles.e_dataset, 'string', handles.VC.datasets)
    set(handles.e_dataset, 'Value', length(handles.VC.datasets))
    handles.record.Dataset = answer{1};
    
    dgc = mysql('open', handles.dbpar.Server, handles.dbpar.User, handles.dbpar.Passw);
    dgc = mysql('use', handles.dbpar.Database);
    QUERY = ['INSERT INTO Datasets '  ...
        '(strname) ' ...
        'VALUES( "' answer{1} '" ) ' ];
    
    mysql(QUERY);
    mysql('close');
    
    guidata(hObject, handles);
end

% --- Executes on selection change in e_group.
function e_group_Callback(hObject, eventdata, handles)
% hObject    handle to e_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns e_group contents as cell array
%        contents{get(hObject,'Value')} returns selected item from e_group
    groups = get(hObject,'String');
    sel = get(hObject,'Value');
    handles.record.Group = groups{sel};
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function e_group_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Group_pb.
function Group_pb_Callback(hObject, eventdata, handles)
% hObject    handle to Group_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = inputdlg({'Name for new group'}, 'New' );
if ~isempty(answer)
    handles.VC.groups =  [ handles.VC.groups;  answer{1} ];
    set(handles.e_group, 'string', handles.VC.groups)
    set(handles.e_group, 'Value', length(handles.VC.groups))
    handles.record.Group = answer{1};
    
    dgc = mysql('open', handles.dbpar.Server, handles.dbpar.User, handles.dbpar.Passw);
    dgc = mysql('use', handles.dbpar.Database);
    QUERY = ['INSERT INTO Groups '  ...
        '(strname) ' ...
        'VALUES( "' answer{1} '" ) ' ];
    
    mysql(QUERY);
    mysql('close');
    
    guidata(hObject, handles);
end
