clear
FileList = dir(pwd);

for ii = 1 :length(FileList)
    if ~isempty(strfind(FileList(ii).name,'.mat'))
%         disp(FileList(ii).name)
        data = load(FileList(ii).name);
        data.SegmRot(:,1:3) = -data.SegmRot(:,1:3); % Flip the sign because of an error in the initial calculation.
        save(FileList(ii).name,'-struct','data')
        fprintf('Sign changed and saved for %s\n',FileList(ii).name)
        
%         pause
    end
end

