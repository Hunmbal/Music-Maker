% Author: Mustafa Ali #372704
%This class will help you create and manipulate periodic waves

classdef Wave

    properties
        N = 1000; % Fundamental period (N) for the discrete signal
        max_t = 1000; %Max value of x-axis (must be >= than N)
        t 
        k = [] % Frequency
        A = [] % Amplitude
        wave = [] % Final Wave        
    end

 
    methods
        %% Constructor
        function obj = Wave(kk,aa)            
            if (length(kk) == length(aa))
                obj.k = kk;
                obj.A = aa;
                obj.t = 0:1:obj.max_t;
                obj = obj.update();
            else
                disp("Wave parameters should be of equal length!");
            end
        end
        
        %% Stem plot
        function [] = plt(obj, r, c, i, lbl)
            subplot(r,c,i);
            stem(obj.t,obj.wave);
            xlabel(lbl);
            axis([0, obj.max_t, min(obj.wave)-3, max(obj.wave)+3]), grid;
        end

        %% Synthesis (Adds all harmonics together and updates the final wave)
        function res = update(obj)
            y=zeros(size(obj.t));
            for row = 1:length(obj.k)
                y = y + real(obj.A(row) * exp(1j*(2*pi/obj.N)*obj.k(row)*obj.t));
            end
            obj.wave = y;
            res = obj;
        end
    
    end



end

