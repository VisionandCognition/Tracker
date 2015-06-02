function varargout = tdtaccess(varargin)
% TDTACCESS MATLAB code for tdtaccess.fig
%      TDTACCESS, by itself, creates a new TDTACCESS or raises the existing
%      singleton*.
%
%      H = TDTACCESS returns the handle to a new TDTACCESS or the handle to
%      the existing singleton*.
%
%      TDTACCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TDTACCESS.M with the given input arguments.
%
%      TDTACCESS('Property','Value',...) creates a new TDTACCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tdtaccess_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tdtaccess_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tdtaccess

% Last Modified by GUIDE v2.5 03-May-2013 16:47:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tdtaccess_OpeningFcn, ...
                   'gui_OutputFcn',  @tdtaccess_OutputFcn, ...
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


% --- Executes just before tdtaccess is made visible.
function tdtaccess_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tdtaccess (see VARARGIN)

% Choose default command line output for tdtaccess
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tdtaccess wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tdtaccess_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_T_Callback(hObject, eventdata, handles)
% hObject    handle to File_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_T_Callback(hObject, eventdata, handles)
% hObject    handle to Open_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
    folder_name = uigetdir();
    
  if ischar(folder_name)
    handles.Filename = folder_name; %get tdt tank name
    set(handles.Tankname, 'String', folder_name);
    set(handles.Tankname, 'Visible', 'on');
    
    list = dir(folder_name);
    
    %clear stuff
    set( handles.ListEvents, 'String',  ' '  )
    set( handles.ListEvents, 'Visible', 'off' )
    set( handles.Blocktxt, 'Visible', 'off')
    
    j = 0;
    handles.list = {};
    for i = 3:length(list)
       if list(i).isdir
          j = j+1; 
          handles.list{j} = list(i).name;          
       end
    end
   
    %list blocks    
    if j > 0
        Pos = get( handles.ListBlocks, 'Position');
        if j < 10
            Hght =  j+1;
        else Hght = 10;
        end
        Pos(4) = Hght; 
        set( handles.ListBlocks, 'Position', Pos )
        set( handles.ListBlocks, 'String', handles.list );
        set( handles.ListBlocks, 'Value', 1 );
        set( handles.ListBlocks, 'Visible', 'on' )
        
        set( handles.Infotxt, 'String', 'Select Block to access events!!')
    end
  end
  
    guidata(hObject, handles);
    


% --- Executes on selection change in ListBlocks.
function ListBlocks_Callback(hObject, eventdata, handles)
% hObject    handle to ListBlocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ListBlocks contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ListBlocks

contents = cellstr(get(hObject,'String'));
SelectedBlock = contents{get(hObject,'Value')};

button = questdlg(['Retrieve event info for ' SelectedBlock] ,'TDT INFO');

if strcmp(button, 'Yes')
    
    EVENT.Mytank = handles.Filename;
    EVENT.Myblock = SelectedBlock;    
    EVENT = Exinf4(EVENT);
    
    set(handles.Blocktxt, 'String', [SelectedBlock '  ' EVENT.BlockStrTimes ])
    set(handles.Blocktxt, 'Visible', 'on')
    
    j = 0;
    Elist = {};
    
    if isfield(EVENT, 'strms')
       handles.numofstrms = length(EVENT.strms);
       for i = 1:length(EVENT.strms) 
           j = j+1;
           Elist{j} = [EVENT.strms(i).name '      sf:' num2str(EVENT.strms(i).sampf) '      chns:' num2str(EVENT.strms(i).channels) ...
                      '       length:' EVENT.BlockStrLength 's'];
       end
    end
    
    if isfield(EVENT, 'strons')
        snames = fieldnames(EVENT.strons);
        nnum = length(snames);
        Elist = [Elist snames'];
        
        
    end
    
    if ~isempty(Elist)
        Pos = get( handles.ListEvents, 'Position');
        if length(Elist) < 10
            Hght =  length(Elist);
        else Hght = 10;
        end
        Pos(4) = Hght+1; %adapt height
        set( handles.ListEvents, 'Position', Pos )
        set( handles.ListEvents, 'String',  Elist  )
        set( handles.ListEvents, 'Value', 1 );
        set( handles.ListEvents, 'Visible', 'on' )
        
    end
    set( handles.Infotxt, 'String', 'Select stream event to retrieve data!!')


    if ~strcmp(EVENT.Mytank, handles.Filename)
        %saved EVENT may point to file that is currently nonexistent
        EVENT.Mytank = handles.Filename;
    end
    
    handles.EVENT = EVENT;
    
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function ListBlocks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListBlocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ListEvents.
function ListEvents_Callback(hObject, eventdata, handles)
% hObject    handle to ListEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

       %contents = cellstr(get(hObject,'String')); %returns ListEvents contents as cell array
       Evnum = get(hObject,'Value'); %returns selected item from ListEvents
       
       %fns = fieldnames(handles.EVENT.strons);
       if isfield(handles.EVENT, 'Trials')
           
           if Evnum <= handles.numofstrms
               handles.EVENT.Myevent = handles.EVENT.strms(Evnum).name;
               prompt={'Enter length of trial time',...
                   'Enter begin with respect to onset', ...
                   'Enter channel numbers'};
               name= ['Input for ' handles.EVENT.Myevent ] ;
               numlines = 1;
               chans = handles.EVENT.strms(Evnum).channels;
               if chans > 1
                   defaultanswer={'1.0','-0.3', ['1:' num2str(chans)] };
               else
                    defaultanswer={'1.0','-0.3', '1'};
               end
               
               answer=inputdlg(prompt,name,numlines,defaultanswer);
               
               if ~isempty(answer)
                   Triallngth = str2double(answer{1});
                   Start = str2double(answer{2});
                   CHAN = str2num(answer{3});
                   
                   if ~isnan(Triallngth) && ~isnan(Start)
                       handles.EVENT.Start = Start;
                       handles.EVENT.Triallngth = Triallngth;
                       handles.EVENT.CHAN = CHAN;
                       
                       vix = ~isnan(handles.EVENT.Trials.stim_onset);
                       trials = handles.EVENT.Trials.stim_onset(vix);
                       set( handles.Infotxt, 'String', 'Retrieving valid trials ....')
                       sig = Exd4(handles.EVENT, trials);
                       assignin('base', 'Sig', sig)
                       assignin('base', 'EVENT', handles.EVENT)
                       set( handles.Infotxt, 'String', 'Finished ....')
                   else
                       warndlg('Enter valid values')
                   end
               end
           else
               warndlg('This is not a stream event')
           end
       else
           warndlg('No trials structure!!')
       end
       
       
       
      
       guidata(hObject, handles);
       

% --- Executes during object creation, after setting all properties.
function ListEvents_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ExEvent_Callback(hObject, eventdata, handles)
% hObject    handle to ExEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'EVENT')
  assignin('base', 'EVENT', handles.EVENT)
end


% --------------------------------------------------------------------
function Hdf_Callback(hObject, eventdata, handles)
% hObject    handle to Hdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %Names = fieldnames(handles.EVENT.Trials);
    %ston = find(strcmp(Names,'stim_onset'));
    if isfield(handles, 'EVENT') && isfield(handles.EVENT, 'Trials')
        %Stmlist = handles.EVENT.Trials.stim_onset;
        
        [OUTP, EVENT] = Hdfsi('Block', handles.EVENT, handles.Filename);
        if OUTP
            set( handles.Infotxt, 'String', 'Saving to HDF5')
            handles.EVENT = H5save(EVENT);
            set( handles.Infotxt, 'String', 'Finished ....')
            
            guidata(hObject, handles);
        end
    
    else
        
    end
 
