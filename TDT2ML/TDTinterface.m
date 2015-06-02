function varargout = TDTinterface(varargin)
% TDTINTERFACE MATLAB code for TDTinterface.fig
%      TDTINTERFACE, by itself, creates a new TDTINTERFACE or raises the existing
%      singleton*.
%
%      H = TDTINTERFACE returns the handle to a new TDTINTERFACE or the handle to
%      the existing singleton*.
%
%      TDTINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TDTINTERFACE.M with the given input arguments.
%
%      TDTINTERFACE('Property','Value',...) creates a new TDTINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TDTinterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TDTinterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TDTinterface

% Last Modified by GUIDE v2.5 22-May-2013 17:45:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TDTinterface_OpeningFcn, ...
                   'gui_OutputFcn',  @TDTinterface_OutputFcn, ...
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


% --- Executes just before TDTinterface is made visible.
function TDTinterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TDTinterface (see VARARGIN)

% Choose default command line output for TDTinterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TDTinterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TDTinterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function activex1_TankChanged(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
    handles.activex2.ActiveBlock = '';    
    handles.activex2.UseTank = hObject.ActiveTank;
    handles.activex2.Refresh
    handles.activex3.UseTank = hObject.ActiveTank;
    handles.activex3.Refresh
    handles.Mytank = char(hObject.ActiveTank);
    
    %set(handles.ParamPanel, 'Visible', 'off');
    guidata(handles.OBJ, handles);

% --------------------------------------------------------------------
function activex2_BlockChanged(hObject, eventdata, handles)
% hObject    handle to activex2 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
    handles.activex3.UseBlock = hObject.ActiveBlock;
    handles.activex3.ActiveEvent = '';
    handles.activex3.Refresh
    
 guidata(handles.OBJ, handles); 
    
    
