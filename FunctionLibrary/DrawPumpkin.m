function ax = DrawPumpkin(Cavity,Punkin,StemData,Cpunkin)
% Plot the pumpkin
Cavity = surf(Cavity.X,Cavity.Y,Cavity.Z,FaceColor="#fbbf4a",EdgeColor="none",FaceAlpha=0.9);

hold on
Spunkin = surf(Punkin.X,Punkin.Y,Punkin.Z,FaceColor="interp",EdgeColor="none");

colormap(validatecolor({'#da8e26' '#dfc727'},'multiple'));

Sstem = surf(StemData.Xstem,StemData.Ystem,StemData.Zstem+StemData.heightratio^2,FaceColor="#3d6766",EdgeColor="none"); 

Pstem = patch(Vertices=[StemData.Xstem(end,:)' StemData.Ystem(end,:)' StemData.Zstem(end,:)'+StemData.heightratio^2],...
    Faces=1:StemData.numVerts, ...
    FaceColor="#b1cab5",EdgeColor="none");

%daspect([1 1 1])
camlight

Cavity.CData = [];
% Spunkin.CData = Cpunkin; % Pumpkin CData
Sstem.CData = [];
Spunkin.CData = Cpunkin+randn(StemData.numVerts)*0.022; % Pumpkin CData
% set(Cavity,"CData",[])
% set(Spunkin,"CData",Cpunkin); % Pumpkin CData
% set(Sstem,"CData",[]); % Make sure the stem doesn't contribute to auto Color Limits
% set(Spunkin,"CData",Cpunkin+randn(StemData.numVerts)*0.022); % orig 0.015
daspect([1 1 1])
axis off
camzoom(1.8)
lighting gouraud
material([Spunkin Sstem Pstem],[ .6 .9 .3 2 .6 ])
hold off
ax = gca;
end

%[appendix]{"version":"1.0"}
%---
