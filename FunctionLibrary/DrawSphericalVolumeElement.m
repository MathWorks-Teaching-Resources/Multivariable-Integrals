function DrawSphericalVolumeElement(Copt,drho,dphi,dtheta,rho0,phi0,theta0)
arguments
    Copt = "summer"
    drho = 0.6
    dphi = pi/8
    dtheta = pi/6
    rho0 = sqrt(3)
    phi0 = pi/4
    theta0 = pi/4
end

colormap(Copt)
% Create spherical patch representing area element on sphere of radius rho
phi = linspace(phi0, phi0+dphi, 30);
theta = linspace(theta0, theta0+dtheta, 40);
[Phi, Theta] = meshgrid(phi, theta);
Xs = rho0 * sin(Phi) .* cos(Theta);
Ys = rho0 * sin(Phi) .* sin(Theta);
Zs = rho0 * cos(Phi);
surf(Xs, Ys, Zs, FaceColor="interp",EdgeColor="none",FaceAlph=0.9)
hold on
% Outer spherical shell (slightly scaled)
Xs2 = (rho0+drho) * sin(Phi) .* cos(Theta);
Ys2 = (rho0+drho) * sin(Phi) .* sin(Theta);
Zs2 = (rho0+drho) * cos(Phi);
surf(Xs2, Ys2, Zs2, FaceColor="interp",EdgeColor="none",FaceAlph=0.9)

% Add code around line 76 to draw the four faces between the two spherical shells. Use fill3()
% We will create the four boundary "quadrilateral" faces: two along constant phi (ends of phi range)
% and two along constant theta (ends of theta range). For this we extract the four edge curves

% Edge at phi = phi0 (inner and outer)
X_edge_in_phi1 = Xs(:,1);
Y_edge_in_phi1 = Ys(:,1);
Z_edge_in_phi1 = Zs(:,1);
X_edge_out_phi1 = Xs2(:,1);
Y_edge_out_phi1 = Ys2(:,1);
Z_edge_out_phi1 = Zs2(:,1);
fill3([X_edge_in_phi1; flipud(X_edge_out_phi1)], ...
      [Y_edge_in_phi1; flipud(Y_edge_out_phi1)], ...
      [Z_edge_in_phi1; flipud(Z_edge_out_phi1)], ...
      [Z_edge_in_phi1; flipud(Z_edge_out_phi1)], EdgeColor="none", FaceAlpha=0.9);

% Edge at phi = phi0 + dphi
X_edge_in_phi2 = Xs(:,end);
Y_edge_in_phi2 = Ys(:,end);
Z_edge_in_phi2 = Zs(:,end);
X_edge_out_phi2 = Xs2(:,end);
Y_edge_out_phi2 = Ys2(:,end);
Z_edge_out_phi2 = Zs2(:,end);
fill3([X_edge_in_phi2; flipud(X_edge_out_phi2)], ...
      [Y_edge_in_phi2; flipud(Y_edge_out_phi2)], ...
      [Z_edge_in_phi2; flipud(Z_edge_out_phi2)], ...
      [Z_edge_in_phi2; flipud(Z_edge_out_phi2)], EdgeColor="none", FaceAlpha=0.9);

% Edge at theta = theta1 (start)
X_edge_in_th1 = Xs(1,:);
Y_edge_in_th1 = Ys(1,:);
Z_edge_in_th1 = Zs(1,:);
X_edge_out_th1 = Xs2(1,:);
Y_edge_out_th1 = Ys2(1,:);
Z_edge_out_th1 = Zs2(1,:);
fill3([X_edge_in_th1, fliplr(X_edge_out_th1)], ...
      [Y_edge_in_th1, fliplr(Y_edge_out_th1)], ...
      [Z_edge_in_th1, fliplr(Z_edge_out_th1)], ...
      [Z_edge_in_th1, fliplr(Z_edge_out_th1)], EdgeColor="none", FaceAlpha=0.9);

% Edge at theta = theta1 + dtheta2 (end)
X_edge_in_th2 = Xs(end,:);
Y_edge_in_th2 = Ys(end,:);
Z_edge_in_th2 = Zs(end,:);
X_edge_out_th2 = Xs2(end,:);
Y_edge_out_th2 = Ys2(end,:);
Z_edge_out_th2 = Zs2(end,:);
fill3([X_edge_in_th2, fliplr(X_edge_out_th2)], ...
      [Y_edge_in_th2, fliplr(Y_edge_out_th2)], ...
      [Z_edge_in_th2, fliplr(Z_edge_out_th2)], ...
      [Z_edge_in_th2, fliplr(Z_edge_out_th2)], EdgeColor="none", FaceAlpha=0.9);

% Additionally trace the boundary curves of the filled side faces (so their contour is visible)
% For phi-constant faces: take the sampled curve along theta and connect to scaled version
% t_theta = linspace(theta0, theta0+dtheta, 60);

X_in = Xs(:,1); Y_in = Ys(:,1); Z_in = Zs(:,1);
X_out = Xs2(:,1); Y_out = Ys2(:,1); Z_out = Zs2(:,1);
plot3(X_in, Y_in, Z_in, LineWidth=1, SeriesIndex="none");
plot3(X_out, Y_out, Z_out, LineWidth=1, SeriesIndex="none");

X_in = Xs(:,end); Y_in = Ys(:,end); Z_in = Zs(:,end);
X_out = Xs2(:,end); Y_out = Ys2(:,end); Z_out = Zs2(:,end);
plot3(X_in, Y_in, Z_in, LineWidth=1, SeriesIndex="none");
plot3(X_out, Y_out, Z_out, LineWidth=1, SeriesIndex="none");

% 
% % For theta-constant faces: take sampled curve along phi and connect to scaled version
for it = [1, size(Phi,1)] % size(Phi,2)=end
    X_in = Xs(it,:); Y_in = Ys(it,:); Z_in = Zs(it,:);
    X_out = Xs2(it,:); Y_out = Ys2(it,:); Z_out = Zs2(it,:);
    plot3(X_in, Y_in, Z_in, LineWidth=1,SeriesIndex="none")
    plot3(X_out, Y_out, Z_out, LineWidth=1,SeriesIndex="none")
    plot3([X_in(1) X_out(1)],[Y_in(1) Y_out(1)],[Z_in(1) Z_out(1)],LineWidth=1,SeriesIndex="none")
    plot3([X_in(end) X_out(end)],[Y_in(end) Y_out(end)],[Z_in(end) Z_out(end)],LineWidth=1,SeriesIndex="none")
end

xlim([0 3])
ylim([0 3])
zlim([0 3])
xlabel("x"), ylabel("y"), zlabel("z")
title("Spherical Volume Element")
CurVol = rho0^2*sin(phi0)*drho*dtheta*dphi;
subtitle("V = " + CurVol)
view(35,20)
grid on
hold off
end

%[appendix]{"version":"1.0"}
%---
