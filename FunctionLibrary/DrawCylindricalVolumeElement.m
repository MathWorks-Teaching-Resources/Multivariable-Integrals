function DrawCylindricalVolumeElement(Copt,dr,dtheta,dz,r0,theta0,z0)
arguments
    Copt = "summer"
    dr = 0.6
    dtheta = pi/6
    dz = 0.5
    r0 = sqrt(2)
    theta0 = pi/4 
    z0 = 1
end

CData = colormap(Copt);
% Create surface patch representing area element as curved rectangle on cylinder
theta = linspace(theta0, theta0+dtheta, 30);
z = [z0 z0+dz];
[Th, Z] = meshgrid(theta, z);
X = r0 * cos(Th);
Y = r0 * sin(Th);
surf(X, Y, Z,FaceColor="interp",EdgeColor="none",FaceAlpha=0.9)
hold on
% Show radial thickness by plotting inner and outer curved faces
X2 = (r0+dr) * cos(Th);
Y2 = (r0+dr) * sin(Th);
surf(X2, Y2, Z,FaceColor="interp",EdgeColor="none",FaceAlpha=0.9)
% Connect edges to form the small curved shell patch
for k = [1 size(Th,2)]% 1:size(Th,2)
    patch([X(1,k) X2(1,k) X2(2,k) X(2,k)], [Y(1,k) Y2(1,k) Y2(2,k) Y(2,k)], [Z(1,k) Z(1,k) Z(2,k) Z(2,k)],...
        sqrt(([X(1,k) X2(1,k) X2(2,k) X(2,k)]-X(1,1)).^2+([Y(1,k) Y2(1,k) Y2(2,k) Y(2,k)]-Y(1,1)).^2),...
        EdgeColor="none",FaceAlpha=0.9)
end

fill3([X(1,:) fliplr(X2(1,:))],[Y(1,:) fliplr(Y2(1,:))],z0*ones(1,2*size(Y,2)),z0*ones(1,2*size(Y,2)))
fill3([X(end,:) fliplr(X2(end,:))],[Y(end,:) fliplr(Y2(end,:))],(z0+dz)*ones(1,2*size(Y,2)),(z0+dz)*ones(1,2*size(Y,2)))

% Plot the twelve edges of the volume element using SeriesIndex="none" to set color
% Define the 8 corner points of the small curved shell (r0/r0+dr) x (theta0/theta0+dtheta) x (0/dz)
thetas = [theta0, theta0+dtheta];
rs = [r0, r0+dr];
zs = [z0, z0+dz];
Vertices = zeros(8,3); idx = 1;
for ir = 1:2
    for it = 1:2
        for iz = 1:2
            th = thetas(it); r = rs(ir); zc = zs(iz);
            Vertices(idx,:) = [r*cos(th), r*sin(th), zc];
            idx = idx+1;
        end
    end
end

for EdgeIdx = 1:4
    % Draw edge from (r,theta,z) -> (r,theta,z+dz)
    plot3(Vertices(2*EdgeIdx-1:2*EdgeIdx,1),Vertices(2*EdgeIdx-1:2*EdgeIdx,2),Vertices(2*EdgeIdx-1:2*EdgeIdx,3),SeriesIndex="none")
    % Draw edge from (r,theta,z) -> (r+dr,theta,z)
    plot3([Vertices(EdgeIdx,1) Vertices(EdgeIdx+4,1)],[Vertices(EdgeIdx,2) Vertices(EdgeIdx+4,2)],[Vertices(EdgeIdx,3) Vertices(EdgeIdx+4,3)],SeriesIndex="none")
end

plot3(X(1,:),Y(1,:),Z(1,:),SeriesIndex="none")
plot3(X(end,:),Y(end,:),Z(end,:),SeriesIndex="none")
plot3(X(:,1),Y(:,1),Z(:,1),SeriesIndex="none")
plot3(X(:,end),Y(:,end),Z(:,end),SeriesIndex="none")
plot3(X2(1,:),Y2(1,:),Z(1,:),SeriesIndex="none")
plot3(X2(end,:),Y2(end,:),Z(end,:),SeriesIndex="none")
plot3(X2(:,1),Y2(:,1),Z(:,1),SeriesIndex="none")
plot3(X2(:,end),Y2(:,end),Z(:,end),SeriesIndex="none")

xlim([0 3])
ylim([0 3])
zlim([0 3])
xlabel("x")
ylabel("y")
zlabel("z")
title("Cylindrical Volume Element")
CurVol = r0*dr*dtheta*dz;
subtitle("V = " + CurVol)
view(35,20)
grid on
hold off
end

%[appendix]{"version":"1.0"}
%---
