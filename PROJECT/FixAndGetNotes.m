
function [arr_f, arr_notes]= FixAndGetNotes(arr)

    Ref = 32.7032; %note C1
    noteNames = { 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'};

    n = 12 * log2(arr/Ref);
    n = round(n);
    n = sort(unique(n));

    arr_f = Ref * 2.^(n/12);
    arr_f = floor(sort(arr_f));

    rmv = [arr_f*2, arr_f*3, arr_f*4, arr_f*2+1, arr_f*3+1, arr_f*4+1, arr_f*2+-1, arr_f*3-1, arr_f*4-1];  
    arr_f = setdiff(arr_f, rmv);

    n = 12 * log2(arr_f/Ref);
    n = round(n);
    n = sort(unique(n));

    arr_f = Ref * 2.^(n/12);
    arr_f = sort(arr_f);

    arr_notes = noteNames(mod(n,12)+1) + string(floor(n/12)+1);

    
    




end