function res = songPlayer(notes, loc, axesHandle, len_x)
    % Initialize variables
    song = [];
    fs = 44100; % Set the desired sampling frequency

    % Loop through each note and concatenate the corresponding audio
    for i = 1:length(notes)
        % Create the full file path

        noteFilename = fullfile('Notes', [char(notes{i}(1)), '.mp3']);

        % Check if the file exists
        if ~exist(noteFilename, 'file')
            disp(['Note file not found: ' noteFilename]);
        else
            % Load the note from the corresponding MP3 file
            [note, fsNote] = audioread(noteFilename);

            % Calculate the start and end indices based on the timing
            startIndex = round(loc(i) * fs) + 1;
            endIndex = startIndex + length(note) - 1;
    
            % Ensure the song array is large enough to accommodate the current note
            if endIndex > length(song)
                % Resize the song array to fit the current note
                song = [song; zeros(endIndex - length(song), 1)];
            end
    
            % Insert the note into the song array
            song(startIndex:endIndex) = song(startIndex:endIndex) + note;
        end

    end

    % Normalize the volume of the song
    song = song / max(abs(song));

    res = song;

    % Plot the audio on the specified axes
    cla(axesHandle);
    original_time = (0:length(song)-1)/fs;
    plot(axesHandle, original_time, song); 
    grid(axesHandle, 'on');
    %axis(axesHandle, [min(original_time), len_x, min(song), max(song)]);

    writeToFile(notes, loc);


end


function [] = writeToFile(notes, loc)

    % Open a text file for writing (clearing existing data)
    fileID = fopen('MusicSheet.txt', 'w');
    
    % Check if the file is successfully opened
    if fileID == -1
        error('Could not open the file for writing.');
    end
    
    
    % Loop through the array of arrays and write each array to a separate line
    for i = 1:length(notes)
        fprintf(fileID, '%.2f\t%s\n', loc(i), mat2str(notes{i}));
    end


    
    % Close the file
    fclose(fileID);
    
    % Display a message indicating that the music sheet is updated
    disp('Music Sheet updated');
    
end

