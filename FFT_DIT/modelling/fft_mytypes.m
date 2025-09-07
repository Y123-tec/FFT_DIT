function T = fft_mytypes(dt)

switch(dt)

        case 'double'
        T.x      = complex(double([]));
        T.y      = complex(double([]));
        T.indx_1 = complex(double([]));
        T.indx_2 = complex(double([]));
        T.par_a  = complex(double([]));
        T.stg_1  = complex(double([]));
        T.stg_2  = complex(double([]));
        T.stg_3  = complex(double([]));
        T.temp   = complex(double([]));

    case 'single'

        T.x      = complex(single([]));
        T.y      = complex(single([]));
        T.indx_1 = complex(single([]));
        T.indx_2 = complex(single([]));
        T.par_a  = complex(single([]));
        T.stg_1  = complex(single([]));
        T.stg_2  = complex(single([]));
        T.stg_3  = complex(single([]));
        T.temp   = complex(single([]));


    case "FxPt"
        % Fixed-point settings with your original format but improved precision
        % Format: fi([], Signed, WordLength, FractionLength)
        
        % Input: 16-bit (1 sign, 4 integer, 12 fractional)
        T.x      = complex(fi([], 1, 4+12, 12));
        
        % Output: 18-bit (1 sign, 5 integer, 14 fractional)
        T.y      = complex(fi([], 1, 5+12, 12));
        
        % Twiddle factors (higher precision)
        T.indx_1 = complex(fi([], 1, 1+1, 1));
        T.indx_2 = complex(fi([], 1, 2+14, 14));
        
        % Parameter (cos(pi/4)) with good precision
        T.par_a  = complex(fi([], 1, 2+14, 14));
        
        % Intermediate stages with guard bits
        % Stage 1: 
        T.stg_1  = complex(fi([], 1, 4+12, 12));
        
        % Stage 2
        T.stg_2  = complex(fi([], 1, 5+12, 12));
        
        % Stage 3: +6 bits (22 total)
        T.stg_3  = complex(fi([], 1, 5+12, 12));
        
        % Temp variable (same as input)
        T.temp   = complex(fi([], 1, 4+12, 12));

end 
end



