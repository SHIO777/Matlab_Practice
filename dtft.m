clear all;  % close all figures
clear;      % clear all variables
f = @(t) exp(-abs(t));
w = -3*pi: pi/100: 3*pi;
% T = [1/10]
T = 1/20
F = dtftC(f, T, 600, w);

function F = dtftC(f,T,N,w)
% length(T)
%     for i=1:length(T)
%         t = T(i)
        t = T
        F = 0;
        for n=-N:1:N
            F = F + f(n*t) * exp(i*w*n);
        end
        plot(w, abs(F)*t,'LineWidth',2,'DisplayName',num2str(t,2))
        hold on
        axis tight
%         ylim([0 2.5])
%     end
    legend
    hold off
end