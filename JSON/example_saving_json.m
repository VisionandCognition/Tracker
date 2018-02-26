%example using a limited json schema for database recording
%this is the metadata that is stored in the database, but much more can be
%stored in the json files

fields = getdbfields('VC'); %retrieves info from mysql tables

%schema for stucturing fields in json file
json.project.title = fields.Project;

json.dataset.protocol = fields.Protocol; 
json.dataset.name = fields.Dataset;  
 
json.session.date = fields.Date;
json.session.subjectId = fields.Subject;
json.session.investigator = fields.Researcher;
json.session.setup = fields.Setup;
json.session.group = fields.Group;   %not essential
json.session.stimulus = fields.Stimulus; %name (str) of function
json.session.logfile ='ID_session_logfile.m'; %name for your logfile

%with matlab 2017b
%StrJson = jsonencode(json);
%save('test1.json', 'StrJson')

%otherwise use jsonlab (download), name of file is basename of data file( = sbx file)
savejson('', json, 'ID_session.json');
