clear all;  % close all figures
clear;      % clear all variables
clc;    % clear the command terminal

% font size
set(0, "DefaultTextFontSize", 20)
set(0, "DefaultAxesFontSize", 20)

% font name
set(0, "DefaultTextFontName", "Times New Roman")
set(0, "DefaultAxesFontName", "Times New Roman")
set(0, "DefaultTextInterpreter", "latex")
set(0, "DefaultLegendInterpreter", "latex")


global M1 M2 L1 L2 g
L1 = 0.2;
L2 = 0.2;
R = L1 + L2;
M1 = 0.1;
M2 = 0.1;
g = 9.8;
nPendulum = 100;
filename = "test10.gif";
dt = 0.1;
tspan = [0:dt:60];
XY = zeros(length(tspan), 4, nPendulum);
ColorSet = varycolor(nPendulum);

% compute
%     initCond = [1; 2+iPendulum*10^(-12); 0; 0];    % theta1, theta2, dtheta1, dtheta2
%     initCond = [1; 0.02*iPendulum; 0; 0];
%     initCond = [30; 150; 0; 0]; % gif7
%     initCond = [63.95; 63.95; 0; 0];  % deg  gif8
initCond = [60; 60; 0; 0]; % gif9
for iPendulum = 1:nPendulum
    initCond = [60; 0; 0; 0]; % gif10
    if iPendulum == 1
        initial = initCond;
    end
    initCond(2) = initCond(2)+(iPendulum-1)*10^(-12);    
    initCond = deg2rad(initCond);
    [t, x] = ode45(@(t, x) odePendulum(t, x), tspan, initCond);
    for n = 1:length(tspan)
        XY(n, :, iPendulum) = theta2xy(x(n, :));
    end
end


% draw
for iFrame = 1:length(tspan)
  clf;                  % clear fig 
  axis([-R R -R R]);
  axis manual;
%   axis equal;
  hold on
  for iPendulum = 1:nPendulum
    x1 = XY(iFrame, 1, iPendulum);
    y1 = XY(iFrame, 2, iPendulum);
    x2 = XY(iFrame, 3, iPendulum);
    y2 = XY(iFrame, 4, iPendulum);
    
    line([0, x1, x2], [0, y1, y2], "Color", ColorSet(iPendulum, :));
  end
%   text(1.0, 1.0, ["Timer: " num2str(t(iFrame), 2)]);
  str = {"Timer: "+num2str(t(iFrame), 3)};
  text(L1-0.1, L1, str);
    title_str = "$$\\theta_1=%d^\\circ, \\theta_2=%d^\\circ, \\dot \\theta_1=%d^\\circ, \\dot \\theta_2=%d^\\circ$$";
    title_str2 = sprintf(title_str, initial(1), initial(2), initial(3), initial(4));
    title(title_str2, "interpreter", "latex");
  hold off
  [A, map] = rgb2ind(frame2im(getframe(gcf)), 256);
  if iFrame == 1
    imwrite(A, map, filename, "gif", "Loopcount", inf, "DelayTime", dt);
  else
    imwrite(A, map, filename, "gif", "WriteMode", "append", "DelayTime", dt);
  end
end


% save file as a mp4
% see: https://jp.mathworks.com/help/symbolic/writeanimation.html
% vidObj = VideoWriter("myFile", "MPEG-4");
% open(vidObj)
% writeAnimation(vidObj)
% close(vidObj)


function dxdt=odePendulum(t, x)
  global L1 L2 M1 M2 g;
  theta1 = x(1);  theta2 = x(2);  dtheta1 = x(3);  dtheta2 = x(4);
  M12 = M1 + M2;
  delta = theta1 - theta2;
  C = cos(delta);
  S = sin(delta);
  LHS = [M12*L1, M2*L2*C;
                 L1*C, L2];
  RHS = [-M12*g*sin(theta1)-M2*L2*S*dtheta2^2;
         -g*sin(theta2)+L1*S*dtheta1^2];
  ddtheta = inv(LHS) * RHS;
  dxdt = [dtheta1; dtheta2; ddtheta(1); ddtheta(2)];
end

function XY = theta2xy(x)
    global L1 L2;
    theta1 = x(1);
    theta2 = x(2);
    x1 = L1*sin(theta1); 
    y1 = -L1*cos(theta1);
    x2 = x1 + L2*sin(theta2);
    y2 = y1 - L2*cos(theta2);
    XY = [x1; y1; x2; y2];
end