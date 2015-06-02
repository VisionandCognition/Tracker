function [f dsets] = ParseHDF5file()

L = [];
[FileName,PathName] = uigetfile('.h5');

if isa(FileName, 'char') && isa(PathName, 'char')
    f = fullfile(PathName, FileName);
    S = hdf5info(f,'ReadAttributes', false);
else
    return;
end

List = ParseHDF(S.GroupHierarchy, L);

cnt = 0;
dsets = [];
for d = 1:length(List)
    loc = List(d).loc;
    for d2 = 1:length(List(d).List)
        block = List(d).List(d2).loc;
        %disp(['/' loc{1} '/' block{1}] )
        cnt = cnt+1;
        dsets{cnt} = ['/' loc{1} '/' block{1}];
    end
    
end


function   List = ParseHDF(Obj, List)


if ~isempty(Obj.Groups)
   
   for d = 1:length(Obj.Groups)
       
        %name = strrep(regexp(Obj.Groups(i).Name, '[^/]+$', 'match'), '-', '_');  
        name = regexp(Obj.Groups(d).Name, '[^/]+$', 'match');
         List(d).loc = name;
         
        if ~isempty(Obj.Groups(d).Datasets)
            Datasets = Obj.Groups(d).Datasets;
            dsets = cell(length(Datasets), 1);
            for j = 1:length(Datasets)
                dsets(j) =  regexp(Datasets(j).Name, '[^/]+$', 'match');
            end

            List(d).data = dsets;            
        end
        
        List(d).List = [];
        List(d).List = ParseHDF(Obj.Groups(d), List(d).List);
        
        
   end
end