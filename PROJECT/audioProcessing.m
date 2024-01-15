
function [res, loc] = audioProcessing(audioData)

    
    Fs = 44100;
    tools = utils(3,1);

    num_bins_to_average = 1500;
    smoothing_filter = ones(1, num_bins_to_average) / num_bins_to_average;
    temp_audio = conv(abs(audioData), smoothing_filter, 'same');

    original_time = (0:length(audioData)-1)/Fs;
    i = (temp_audio>0.0005);
    temp_audio = temp_audio(i);
    t1 = original_time(i);
    temp_audio = temp_audio*2;
    
    
    tools.plot(t1,temp_audio,1,"Smoothning Audio Signal");
    [~, loc] = findpeaks(temp_audio, t1, 'MinPeakProminence', 0.0025, 'Annotate', 'extents', 'MinPeakDistance', 0.2);
    findpeaks(temp_audio, t1, 'MinPeakProminence', 0.0025, 'Annotate', 'extents', 'MinPeakDistance', 0.2);


    %create windowed audio
    [data_arr, t_arr] = sectionAudio(audioData,original_time, loc);

    

    notes = {};
    for c = 1:length(data_arr)
        
        if length(data_arr{c}) > 1000
            if ~(getNotes(t_arr{c},data_arr{c},c)=="null")
                notes{c} = getNotes(t_arr{c},data_arr{c},c);
            end
        else
            c=c-1;
        end
        
    
    end
    res = replaceEmptyWithPrevious(notes)
    
    

end

%% Fourier Transform 
function res = getNotes(tim, aud, c)

    res = "null";
    tools = utils(3,1);

    [ff,mm,pp] = tools.ft(tim,aud);
    ff = ff(1:1000);
    mm = mm(1:1000);

    num_bins_to_average = 5;
    smoothing_filter = ones(1, num_bins_to_average) / num_bins_to_average;
    mm = conv(abs(mm), smoothing_filter, 'same');


    %fourier
    tools.plot(ff,mm,2,"Raw Fourier Transform");
    
    index = ff>200 & ff<800;
    ff = ff(index);
    mm = mm(index);

    i =  mm > max(mm)/15 & mm > 2*10^-4; 
    ff = ff(i);
    mm = mm(i);

    %To attenuate the graph
    impulseResponse = 2000*[1 2 11 2 1];
    mm = conv(mm, impulseResponse, 'same');
    
    %cleaned up fourier
    tools.plot(ff,mm,3,"Filtered Fourier Transform");
    %tools.plot(tim,aud,2,"audio");

    if ~isempty(mm)
        
        if length(mm) < 3
            return;
        end
        [val, ind, ~, prom] = findpeaks(mm);
        ff = ff(ind);
        i = val==max(val);
        ff = ff(i);
        val = val(i);
        %{
        i = prom >5;
        ff = ff(i);
        val = val(i);

        if length(ff) > 2
           i = val==maxk(val,2);
           ff = ff(i);
        end
        %}
        [a,b] = FixAndGetNotes(ff);
        res = b(a==max(a));
        if size(res)<1
            res = "null";
        end
    end
end

%% Audio Segmentation
function [data_arr, t_arr] = sectionAudio(data, time, loc)

    loc = loc-0.02;
    data_arr = cell(1, length(loc) + 1);
    t_arr = cell(1, length(loc) + 1);

    for i = 1:length(loc)
        t1 = find(time >= loc(i), 1);
        
        if i < length(loc)
            t2 = find(time >= loc(i + 1), 1);
            t2 = round((t1+t2)/2);
        else
            % Last Section
            t2 = length(time);
            t2 = round((t1+t2)/2);
        end

        data_arr{i} = data(t1:t2);
        t_arr{i} = time(t1:t2);
    end
end

%% replace empty
function cleaned = replaceEmptyWithPrevious(res)
    
    cleaned = cell(size(res));
    previousNotes = res{2};

    for i = 1:length(res)
        
        if ~isempty(res{i})
            
            previousNotes = res{i};
            cleaned{i} = res{i};
        else
            cleaned{i} = previousNotes;
        end
    end
end


