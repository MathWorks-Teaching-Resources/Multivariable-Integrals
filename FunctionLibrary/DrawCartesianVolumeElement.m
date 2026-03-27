function DrawCartesianVolumeElement(Copt,dx,dy,dz,Lx,Ly,Lz)
arguments
    Copt = "summer"
    dx = 0.6
    dy = 0.8
    dz = 0.5 
    Lx = 1
    Ly = 1
    Lz = 1
end
CData = colormap(Copt);
% Define vertices of a rectangular prism centered at origin
vx = Lx + [0 dx dx 0 0 dx dx 0];
vy = Ly + [0 0 dy dy 0 0 dy dy];
vz = Lz + [0 0 0 0 dz dz dz dz];
% Faces (each row is indices into vertices)
faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];
patch(Vertices=[vx' vy' vz'],Faces=faces,FaceColor=CData(1,:),EdgeColor="none",FaceAlpha=0.8);

xlim([0 3])
ylim([0 3])
zlim([0 3])
xlabel("x"), ylabel("y"), zlabel("z")
title("Cartesian Volume Element")
CurVol = dx*dy*dz;
subtitle("V = " + CurVol)
view(35,20)
grid on
end

%[appendix]{"version":"1.0"}
%---
