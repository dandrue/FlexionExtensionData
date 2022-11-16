function [dummy]=PlotDirVec(T,linewidth,c,linestyle)

if nargin ==1
    c = 50;
    linewidth = 1;
elseif nargin <= 2
    c = 50;
end

if nargin <= 3
    linestyle = '-';
end

x=T(1:3,1);y=T(1:3,2);z=T(1:3,3);
p=T(1:3,4);

plot3(p(1),p(2),p(3),'o','Tag','DirVec')
% Arrow for x-axis
x1=c*x+p;
text(x1(1),x1(2),x1(3),' X','fontsize',10,'Tag','DirVec');
plotarrow([x;p]',c,'b');
% Arrow for y-axis
y1=c*y+p;
text(y1(1),y1(2),y1(3),' Y','fontsize',10,'Tag','DirVec');
plotarrow([y;p]',c,'g');
% Arrow for z-axis
z1=c*z+p;
text(z1(1),z1(2),z1(3),' Z','fontsize',10,'Tag','DirVec');
plotarrow([z;p]',c,'r');

% hold off (changed to comment in 01-Aug-07)

function [hcyl]=plotarrow(par,l,color)
        end1 = par(4:6);
        end2 = par(4:6)+l*par(1:3);
        arrowend = end2 + 0.3*l*par(1:3);
        radius = l/20;
        [xc,yc,zc]=cylinder2P(radius, 20,end1,end2);
        hold on        
        hcyl = surf(xc,yc,zc,'FaceColor',color,'FaceAlpha',0.5,'EdgeColor','none','Tag','DirVec');
        radius = [l/10 0];
        holdstate = ishold(gca);
        [xc,yc,zc]=cylinder2P(radius, 20,end2,arrowend);
        hcyl = surf(xc,yc,zc,'FaceColor',color,'FaceAlpha',0.5,'EdgeColor','none','Tag','DirVec');
        % Restore previous hold state
        if holdstate == 0
            hold off
        end
            
end

function [X, Y, Z] = cylinder2P(R, N,r1,r2)
%  CYLINDER:  A function to draw a N-sided cylinder based on the
%             generator curve in the vector R.
%
%  Usage:      [X, Y, Z] = cylinder(R, N)
%
%  Arguments:  R - The vector of radii used to define the radius of
%                  the different segments of the cylinder.
%              N - The number of points around the circumference.
%
%  Returns:    X - The x-coordinates of each facet in the cylinder.
%              Y - The y-coordinates of each facet in the cylinder.
%              Z - The z-coordinates of each facet in the cylinder.
%
%  Author:     Luigi Barone
%  Date:       9 September 2001
%  Modified:   Per Sundqvist July 2004


    % The parametric surface will consist of a series of N-sided
    % polygons with successive radii given by the array R.
    % Z increases in equal sized steps from 0 to 1.

    % Set up an array of angles for the polygon.
    theta = linspace(0,2*pi,N);

    m = length(R);                 % Number of radius values
                                   % supplied.

    if m == 1                      % Only one radius value supplied.
        R = [R; R];                % Add a duplicate radius to make
        m = 2;                     % a cylinder.
    end


    X = zeros(m, N);             % Preallocate memory.
    Y = zeros(m, N);
    Z = zeros(m, N);
    
    v=(r2-r1)/sqrt((r2-r1)*(r2-r1)');    %Normalized vector;
    %cylinder axis described by: r(t)=r1+v*t for 0<t<1
    R2=rand(1,3);              %linear independent vector (of v)
    x2=v-R2/(R2*v');    %orthogonal vector to v
    x2=x2/sqrt(x2*x2');     %orthonormal vector to v
    x3=cross(v,x2);     %vector orthonormal to v and x2
    x3=x3/sqrt(x3*x3');
    
    r1x=r1(1);r1y=r1(2);r1z=r1(3);
    r2x=r2(1);r2y=r2(2);r2z=r2(3);
    vx=v(1);vy=v(2);vz=v(3);
    x2x=x2(1);x2y=x2(2);x2z=x2(3);
    x3x=x3(1);x3y=x3(2);x3z=x3(3);
    
    time=linspace(0,1,m);
    for j = 1 : m
      t=time(j);
      X(j, :) = r1x+(r2x-r1x)*t+R(j)*cos(theta)*x2x+R(j)*sin(theta)*x3x; 
      Y(j, :) = r1y+(r2y-r1y)*t+R(j)*cos(theta)*x2y+R(j)*sin(theta)*x3y; 
      Z(j, :) = r1z+(r2z-r1z)*t+R(j)*cos(theta)*x2z+R(j)*sin(theta)*x3z;
    end

    %surf(X, Y, Z);

end
end
