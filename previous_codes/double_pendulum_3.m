clearvars;
clc;
pause("on");

global m1 m2 l1 l2 g;
m1=1;
m2=1;
l1=1.0;
l2=1.0;
g=9.8;

tspan = [0:1/1000:40];
x=zeros(length(tspan),4,100);
X=zeros(length(tspan),4,1000);
col=zeros(1,1,3,100);
for i=1:100
    x0=[1; 2+i*10^(-12); 0; 0];
    [t, x_]=ode45(@(t,x_) F(x_),tspan,x0);
    x(:,:,i)=x_;
    for n=1:length(tspan)
        X(n,:,i)=theta2xy(x(n,:,i));
    end
    col(:,:,:,i)=hsv2rgb(i*0.01,1,1);
end

% Animation
f = figure;
f.Position=[100,100,600,600];
axis([-3 3 -3 3]);
axis manual;

LineWidth=10;
l=gobjects(100);
p=gobjects(2,100);

for i=1:100
    l(i)=line([0,X(1,1,i),X(1,3,i)],[0,X(1,2,i),X(1,4,i)],'Color','black');hold on;
    p(1,i)=plot(X(1,1,i),X(1,2,i),'o','MarkerEdgeColor',col(1,1,:,i),'MarkerFaceColor',col(1,1,:,i));hold on;
    p(2,i)=plot(X(1,3,i),X(1,4,i),'o','MarkerEdgeColor',col(1,1,:,i),'MarkerFaceColor',col(1,1,:,i));hold on;
end
p0=plot(0,0,'o','MarkerEdgeColor','black','MarkerFaceColor','black');hold on;

global k v;
k=1;
filename='animation_0426_1.avi';
v = VideoWriter(filename);
v.FrameRate=25;
open(v);
while k<length(tspan)
    k
    draw(X,l,p);
end
close(v);

%微分方程式
function dx=F(x)
    global m1 m2 l1 l2 g;
    theta1=x(1);
    theta2=x(2);
    dtheta1=x(3);
    dtheta2=x(4);
    ddtheta=inv([(m1+m2)*l1^2 m2*l1*l2*cos(theta2-theta1);...
        m2*l1*l2*cos(theta2-theta1) m2*l2^2])...
        *[m2*l1*l2*sin(theta2-theta1)*dtheta2^2-(m1+m2)*g*l1*sin(theta1);...
        -m2*l1*l2*sin(theta2-theta1)*dtheta1^2-m2*g*l2*sin(theta2)];
    dx=[dtheta1;dtheta2;ddtheta];
end
%thetaからxy座標に変換
function X=theta2xy(x)
    global l1 l2 ;
    x1=l1*sin(x(1));
    y1=-l1*cos(x(1));
    x2=x1+l2*sin(x(2));
    y2=y1-l2*cos(x(2));
    X=[x1;y1;x2;y2];
end
%描画および動画ファイルに保存
function draw(X,l,p)
    
    global k v;
    for i=1:100
        l(i).XData=[0,X(k,1,i),X(k,3,i)];
        l(i).YData=[0,X(k,2,i),X(k,4,i)];
        p(1,i).XData=X(k,1,i);
        p(1,i).YData=X(k,2,i);
        p(2,i).XData=X(k,3,i);
        p(2,i).YData=X(k,4,i);
    end
    drawnow;
    frame=getframe;
    writeVideo(v,frame);
    k=k+1000/25;
end








