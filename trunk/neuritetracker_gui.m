function varargout = neuritetracker_gui(varargin)
% NEURITETRACKER_GUI MATLAB code for neuritetracker_gui.fig
%      NEURITETRACKER_GUI, by itself, creates a new NEURITETRACKER_GUI or raises the existing
%      singleton*.
%
%      H = NEURITETRACKER_GUI returns the handle to a new NEURITETRACKER_GUI or the handle to
%      the existing singleton*.
%
%      NEURITETRACKER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEURITETRACKER_GUI.M with the given input arguments.
%
%      NEURITETRACKER_GUI('Property','Value',...) creates a new NEURITETRACKER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before neuritetracker_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to neuritetracker_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help neuritetracker_gui

% Last Modified by GUIDE v2.5 12-Oct-2015 14:46:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @neuritetracker_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @neuritetracker_gui_OutputFcn, ...
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


% --- Executes just before neuritetracker_gui is made visible.
function neuritetracker_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to neuritetracker_gui (see VARARGIN)

% Choose default command line output for neuritetracker_gui
handles.out = hObject;

% Update handles structure
guidata(hObject, handles);

p = mfilename('fullpath');
p = p(1:end-19);
addpath([p filesep 'IO' filesep]);
S = ini2struct('settings.ini');
output = S.output;
parameters = S.defaultparameters; clear S;
output.measurements = regexp(output.measurements, ',', 'split');

handles.parameters = parameters;
handles.output = output;
handles.NucChanVar = {};
handles.BodyChanVar = {};

set(handles.checkbox1, 'Value', handles.output.saveMat);
set(handles.checkbox2, 'Value', handles.output.saveCSVmeasurements);
set(handles.checkbox3, 'Value', handles.output.movieNucleusChannel);
set(handles.checkbox4, 'Value', handles.output.movieNeuronChannel);
set(handles.checkbox5, 'Value', handles.output.movieNucleusDetection);
set(handles.checkbox6, 'Value', handles.output.movieTubularity);
set(handles.checkbox7, 'Value', handles.output.movieNeuriteProbability);
set(handles.checkbox8, 'Value', handles.output.movieCellSegmentation);
set(handles.checkbox9, 'Value', handles.output.movieBacktracing);
set(handles.checkbox10, 'Value', handles.output.movieFinal);
set(handles.checkbox11, 'Value', handles.output.movieFinalNumbered);
set(handles.checkbox12, 'Value', handles.output.movieExtractedModel);
set(handles.checkbox13, 'Value', handles.output.writeFramesToFile);

guidata(hObject, handles);


% UIWAIT makes neuritetracker_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = neuritetracker_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.saveMat = get(hObject, 'Value');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.saveCSVmeasurements = get(hObject, 'Value');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieNucleusChannel = get(hObject, 'Value');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieNeuronChannel = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieNucleusDetection = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieTubularity = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieNeuriteProbability = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieCellSegmentation = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieBacktracing = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieFinal = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieFinalNumbered = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.movieExtractedModel = get(hObject, 'Value');
guidata(hObject, handles);


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.writeFramesToFile = get(hObject, 'Value');
guidata(hObject, handles);










function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editStr = get(hObject,'String');
fileList = regexp(editStr, '\s*,\s*', 'split');
for i = 1:numel(fileList)
    if ~exist(fileList{i}, 'file')
        h = msgbox('Invalid file', 'Error','error');
        set(hObject, 'String', '');
        handles.NucChanVar = {};
    else 
        handles.NucChanVar{i} = fileList{i};
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile({'*.*',  'All Files (*.*)'}, 'Pick file(s)', 'MultiSelect', 'on');

if iscell(filename)
    for i = 1:numel(filename)
        handles.NucChanVar{i} = fullfile(pathname, filename{i});
    end
else
    handles.NucChanVar{1} = fullfile(pathname, filename);
end
if iscell(handles.NucChanVar)
    vStrCat = handles.NucChanVar{1};
    for i = 1:numel(handles.NucChanVar)
        vStrCat = [vStrCat ',' handles.NucChanVar{i}]; %#ok<AGROW>
    end
else
    vStrCat = handles.NucChanVar;
end
set(handles.edit1, 'String', vStrCat);
guidata(hObject, handles);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editStr = get(hObject,'String');
fileList = regexp(editStr, '\s*,\s*', 'split');
for i = 1:numel(fileList)
    if ~exist(fileList{i}, 'file')
        h = msgbox('Invalid file', 'Error','error');
        set(hObject, 'String', '');
        handles.BodyChanVar = {};
    else 
        handles.BodyChanVar{i} = fileList{i};
    end
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile({'*.*',  'All Files (*.*)'}, 'Pick file(s)', 'MultiSelect', 'on');

if iscell(filename)
    for i = 1:numel(filename)
        handles.BodyChanVar{i} = fullfile(pathname, filename{i});
    end
else
    handles.BodyChanVar{1} = fullfile(pathname, filename);
end
if iscell(handles.BodyChanVar)
    vStrCat = handles.BodyChanVar{1};
    for i = 1:numel(handles.BodyChanVar)
        vStrCat = [vStrCat ',' handles.BodyChanVar{i}]; %#ok<AGROW>
    end
else
    vStrCat = handles.BodyChanVar;
end
set(handles.edit2, 'String', vStrCat);
guidata(hObject, handles);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
 
edit3Str = get(hObject,'String');
if ~isdir(edit3Str)
    h = msgbox('Not a valid directory', 'Error','error');
    set(hObject, 'String', '');
else 
    handles.output.destFolder = edit3Str;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


pathname = uigetdir(pwd, 'Pick a destination folder.');
handles.output.destFolder = pathname;

set(handles.edit3, 'String', handles.output.destFolder);
guidata(hObject, handles);
% keyboard;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

keyboard;
guidata(hObject, handles);



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editStr = get(hObject,'String');
handles.parameters.UniqueID = editStr;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editStr = get(hObject,'String');
handles.parameters.MetaData = editStr;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editStr = get(hObject,'String');
handles.parameters.Magnification = editStr;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editStr = get(hObject,'String');
handles.parameters.BitDepth = str2double(editStr);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NucChanVar = handles.NucChanVar;
BodyChanVar = handles.BodyChanVar;
parameters = handles.parameters;
output = handles.output;

if isempty(NucChanVar)
    h = msgbox('Invalid nucleus channel file(s)', 'Error','error');
    return;
end
if isempty(BodyChanVar)
    h = msgbox('Invalid cell body channel file(s)', 'Error','error');
    return;
end
if ~isdir(output.destFolder)
    h = msgbox('Invalid destination folder', 'Error','error');
    return;
end
if isempty(parameters.UniqueID)
    h = msgbox('Please provide a UniqueID string', 'Error','error');
    return;
end


set(handles.checkbox1, 'Enable', 'off');
set(handles.checkbox2, 'Enable', 'off');
set(handles.checkbox3, 'Enable', 'off');
set(handles.checkbox4, 'Enable', 'off');
set(handles.checkbox5, 'Enable', 'off');
set(handles.checkbox6, 'Enable', 'off');
set(handles.checkbox7, 'Enable', 'off');
set(handles.checkbox8, 'Enable', 'off');
set(handles.checkbox9, 'Enable', 'off');
set(handles.checkbox10, 'Enable', 'off');
set(handles.checkbox11, 'Enable', 'off');
set(handles.checkbox12, 'Enable', 'off');
set(handles.checkbox13, 'Enable', 'off');
set(handles.edit1, 'Enable', 'off');
set(handles.edit2, 'Enable', 'off');
set(handles.edit3, 'Enable', 'off');
set(handles.edit4, 'Enable', 'off');
set(handles.edit5, 'Enable', 'off');
set(handles.edit6, 'Enable', 'off');
set(handles.edit7, 'Enable', 'off');
set(handles.edit8, 'Enable', 'off');
set(handles.pushbutton1, 'Enable', 'off');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');

neuritetracker_cmd(NucChanVar, BodyChanVar, parameters, output);

% close(handles.figure1);
set(handles.checkbox1, 'Enable', 'on');
set(handles.checkbox2, 'Enable', 'on');
set(handles.checkbox3, 'Enable', 'on');
set(handles.checkbox4, 'Enable', 'on');
set(handles.checkbox5, 'Enable', 'on');
set(handles.checkbox6, 'Enable', 'on');
set(handles.checkbox7, 'Enable', 'on');
set(handles.checkbox8, 'Enable', 'on');
set(handles.checkbox9, 'Enable', 'on');
set(handles.checkbox10, 'Enable', 'on');
set(handles.checkbox11, 'Enable', 'on');
set(handles.checkbox12, 'Enable', 'on');
set(handles.checkbox13, 'Enable', 'on');
set(handles.edit1, 'Enable', 'on');
set(handles.edit2, 'Enable', 'on');
set(handles.edit3, 'Enable', 'on');
set(handles.edit4, 'Enable', 'on');
set(handles.edit5, 'Enable', 'on');
set(handles.edit6, 'Enable', 'on');
set(handles.edit7, 'Enable', 'on');
set(handles.edit8, 'Enable', 'on');
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'on');
set(handles.pushbutton3, 'Enable', 'on');
set(handles.pushbutton4, 'Enable', 'on');

