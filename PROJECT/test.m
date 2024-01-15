% Open the file for reading
fileID = fopen('MusicSheet.txt', 'r');

% Initialize arrays
loc = [];
notes = {};

% Read data from the file
while ~feof(fileID)
    % Read data from the current line
    currentLine = fgetl(fileID);

    % Split the line into two parts using tab as a delimiter
    parts = strsplit(currentLine, '\t');

    % Convert the first part to a numeric value and add it to loc array
    locValue = str2double(parts{1});
    loc = [loc locValue];

    % Add the second part (notes) to the notes cell array
    notesValue = parts{2};
    notes = [notes notesValue];
end
loc
notes

fclose(fileID);