clf % initialize a plot area
syms theta_1(t) theta_2(t) L_1 L_2 m_1 m_2 g

x_1 = L_1*sin(theta_1);
y_1 = -L_1*cos(theta_1);
x_2 = x_1 + L_2*sin(theta_2);
y_2 = y_1 - L_2*cos(theta_2);

vx_1 = diff(x_1);
vy_1 = diff(x_1);
vx_2 = diff(x_2);
vy_2 = diff(y_2);

ax_1 = diff(vx_1);
ay_1 = diff(vx_1);
ax_2 = diff(vx_2);
ay_2 = diff(vy_2);

syms T_1 T_2    % tension
eqx_1 = m_1 * ax_1(t) == -T_1*sin(theta_1(t)) + T_2*sin(theta_2(t))
eqy_1 = m_1 * ax_1(t) == T_1*cos(theta_1(t)) - T_2*cos(theta_2(t)) - m_1*g

eqx_2 = m_1 * ax_2(t) == -T_2 * sin(theta_2(t))
eqy_2 = m_2 * ay_2(t) == T_2 * cos(theta_2(t)) - m_2*g

Tension = solve([eqx_1, eqy_1], [T_1 T_2])
eqRed_1 = subs(eqx_2, [T_1 T_2], [Tension.T_1 Tension.T_2]);
eqRed_2 = subs(eqy_2, [T_1 T_2], [Tension.T_1 Tension.T_2]);

% system equation
L_1 = 1.5;
L_2 = 1.0;
m_1 = 2;
m_2 = 1;
g = 9.8;
eqn_1 = subs(eqRed_1)
eqn_2 = subs(eqRed_2)

% convert 2D? differenttial equation to 1D differential equation
[V, S] = odeToVectorField(eqn_1, eqn_2);
S   % state variable
M = matlabFunction(V, 'vars', {'t', 'Y'});  % convert to Matlab function

fig = figure;
ColorSet = varycolor(10);

for index = 1:10
    initCond = [pi/180*2*index, 0, pi/180*index, 0];
    sols = ode45(M, [0 60], initCond);
    % making animation
    x_1 = @(t) L_1*sin(deval(sols, t, 3));
    y_1 = @(t) -L_1*cos(deval(sols, t, 3));
    x_2 = @(t) L_1*sin(deval(sols, t, 3))+L_2*sin(deval(sols, t, 1));
    y_2 = @(t) -L_1*cos(deval(sols, t, 3))-L_2*cos(deval(sols, t, 1));
    
%     fanimator(@(t) plot(x_1(t), y_1(t), 'ro', 'MarkerSize', m_1*10, 'MarkerFaceColor', color));
    axis equal;
    hold on;
    fanimator(@(t) plot([0 x_1(t)], [0 y_1(t)], 'Color', ColorSet(index, :)));
%     fanimator(@(t) plot(x_2(t), y_2(t), 'go', 'MarkerSize', m_2*10, 'MarkerFaceColor', color));
    fanimator(@(t) plot([x_1(t) x_2(t)], [y_1(t) y_2(t)], 'Color', ColorSet(index, :)));
%     disp(index)
    disp(t)
end

% add text
fanimator(@(t) text(1.0, -0.25, "Timer: "+num2str(t, 2)));
hold off;

% input the "playAnimation" command to command window
% https://jp.mathworks.com/help/symbolic/writeanimation.html#:~:text=%E9%96%A2%E6%95%B0%20writeAnimation%20%E3%81%AF%E3%80%81MATLAB%C2%AE,%E3%83%AB%E3%83%BC%E3%83%97%E5%9B%9E%E6%95%B0%E3%81%A0%E3%81%91%E7%B9%B0%E3%82%8A%E8%BF%94%E3%81%97%E3%81%BE%E3%81%99%E3%80%82
writeAnimation(fig, "pendulam.gif", "LoopCount", 1)

