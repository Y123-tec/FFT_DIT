function y = fft_DIT_algo(x,T)

% first the input must be radix 
% we start by bitreverse
% we applay the butterflies stage by stage 
    % Manual bit-reverse for N=8
    par_a = cos(pi/4); % parameter that contril the error
%====================================================    
 % Cast input to chosen type
    x        = cast(x,'like',T.x);
    par_a    = cast(par_a,'like',T.par_a);

    % Initialize stage variables with correct type
    stg_1 = cast(zeros(1,8),'like',T.stg_1);
    stg_2 = cast(zeros(1,8),'like',T.stg_2);
    stg_3 = cast(zeros(1,8),'like',T.stg_3);
    temp  = cast(zeros(1,8),'like',T.temp);
    indx_1 = cast([1, -1j],'like',T.indx_1);
    indx_2 = cast([1, (par_a - 1j*par_a), -1j, (-par_a - 1j*par_a)],'like',T.indx_2);

%====================================================
     % Manual bit-reverse for N=8
    temp = x ;
    x(1) = temp(1);
    x(2) = temp(5);
    x(3) = temp(3);
    x(4) = temp(7);
    x(5) = temp(2);
    x(6) = temp(6);
    x(7) = temp(4);
    x(8) = temp(8);
%====================================================



%====================================================
    % Stage 1 (distance = 4)


    stg_1(1) = x(1) + x(2);
    stg_1(2) = x(1) - x(2);
    stg_1(3) = x(3) + x(4);
    stg_1(4) = x(3) - x(4);
    stg_1(5) = x(5) + x(6);
    stg_1(6) = x(5) - x(6);
    stg_1(7) = x(7) + x(8);
    stg_1(8) = x(7) - x(8);
%====================================================
    % Stage 2 (distance = 2)
  

    stg_2(1) = stg_1(1) + stg_1(3);
    stg_2(2) = stg_1(2) + stg_1(4) * indx_1(2);
    stg_2(3) = stg_1(1) - stg_1(3);
    stg_2(4) = stg_1(2) - stg_1(4) * indx_1(2);

    stg_2(5) = stg_1(5) + stg_1(7);
    stg_2(6) = stg_1(6) + stg_1(8) * indx_1(2);
    stg_2(7) = stg_1(5) - stg_1(7);
    stg_2(8) = stg_1(6) - stg_1(8) * indx_1(2);

%====================================================
    % Stage 3 (distance = 1)


    stg_3(1) = stg_2(1) + stg_2(5);
    stg_3(2) = stg_2(2) + stg_2(6) * indx_2(2);
    stg_3(3) = stg_2(3) + stg_2(7) * indx_2(3);
    stg_3(4) = stg_2(4) + stg_2(8) * indx_2(4);


    stg_3(5) = stg_2(1) - stg_2(5);
    stg_3(6) = stg_2(2) - stg_2(6) * indx_2(2);
    stg_3(7) = stg_2(3) - stg_2(7) * indx_2(3);
    stg_3(8) = stg_2(4) - stg_2(8) * indx_2(4);
%====================================================
    y = cast(stg_3,'like',T.y);
    
end
