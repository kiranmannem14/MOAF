% Specify the folder path
folderPath = 'D:\Kiran_Mannem_Ph.D\Ph.D_coursework\Papers\4.Fourth paper\code';

% Get a list of all files in the folder and subfolders
fileList = dir(fullfile(folderPath, '**/*.m'));

% Initialize a cell array to store the file names containing the word
filesWithWord = {};

% Specify the word to search for
searchWord = 'Blocking Probability';

% Loop through each file and search for the word
for i = 1:numel(fileList)
    % Read the file contents
    fileContents = fileread(fullfile(fileList(i).folder, fileList(i).name));
    
    % Check if the word exists in the file
    if contains(fileContents, searchWord)
        % Add the file name to the list
        filesWithWord{end+1} = fileList(i).name;
    end
end

% Display the files containing the word
disp('Files containing the word:');
disp(filesWithWord);