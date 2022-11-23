clc;
clear;
close all;

[ses,fs] = audioread('tel.wav');

%tus sayisini degistirmeyi unutmayin.
n = 7;
d = floor(length(ses)/n);

freq1 = [697 770 852 941];
freq2 = [1209 1336 1477];
pad = [
    '1' '2' '3' ;
    '4' '5' '6' ;
    '7' '8' '9' ;
    '*' '0' '#' ];


for j = 1:n
    if j-1 == 0
        start = 1;
    else
        start = (j-1)*d;
    end
    
    ses1 = ses(start:j*d);
    
    data_fft = fftshift(fft(ses1));
    data_abs = abs(data_fft);
    data_fft_unique= sort(unique(abs(data_fft)),"descend");
    
    %frekans ekseni belirlenir.
    N = length(ses1);
    if rem(N,2) == 0
        f = ((-N/2:N/2-1)*(fs/N));
    else
        f = ((-(N-1)/2:(N-1)/2)*(fs/N));
    end
    
    %en buyuk degerin indexi ve f'teki degeri bulunur.
    in1 = find(data_abs == data_fft_unique(1));
    f1 = f(in1(2));
    
    %2. en buyuk degerin indexi ve f'teki degeri bulunur.
    in2 = find(data_abs == data_fft_unique(2));
    f2 = f(in2(2));
    
    %f1'e dusuk frekans aktarilir.
    if f2 < f1
        [f2,f1] = deal(f1,f2);
    end
    
    %basilan tusun satiri bulunur.
    for i=1:4
        if abs(f1 - freq1(i)) < 10
            ind1 = i;
        end
    end
    
    %basilan tusun sutunu bulunur.
    for i=1:3
        if abs(f2 - freq2(i)) < 10
            ind2 = i;
        end
    end
    %basilan tuslar ekrana yazdirilir.
    disp(pad(ind1,ind2))

    subplot(4,3,j)
    plot(f,abs(data_fft))
    xlabel('Frequency')
    ylabel('Amplitude')
    title(pad(ind1,ind2))
end
figure
subplot(2,1,1)
plot(ses)
subplot(2,1,2)
stem(ses)
