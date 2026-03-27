%[text] Original pumpkin code from Eric Ludlam, [Gourds to Graphics: The MATLAB Pumpkin](http://blogs.mathworks.com/graphics-and-apps/2023/10/31/gourds-to-graphics-the-matlab-pumpkin/blogs.mathworks.com/graphics-and-apps/2023/10/31/gourds-to-graphics-the-matlab-pumpkin/)
function [Cavity,Punkin,StemData,Cpunkin] = CreatePumpkin()

% Draw seed cavity
xrCavity = 0.5;
yrCavity = 0.5;
zrCavity = 0.35;

[Xcavity,Ycavity,Zcavity] = ellipsoid(0,0,0,xrCavity,yrCavity,zrCavity,100);

% Add irregularity
Xcavity = Xcavity + rand(size(Xcavity))/60;
Ycavity = Ycavity + rand(size(Ycavity))/60;
Zcavity = Zcavity + rand(size(Zcavity))/100;

numPrimaryBumps = 10;
totalBumps = numPrimaryBumps*2; % Add in-between creases.
vertsPerBump = 12;  % Originally 10
numVerts = totalBumps*vertsPerBump+1;
rPrimary = linspace(0,numPrimaryBumps*2,numVerts);
rSecondary = linspace(0,totalBumps*2,numVerts);
crease_depth = .04;
crease_depth2 = .01;

Rxy_primary = 0 - (1-mod(rPrimary,2)).^2*crease_depth;
Rxy_secondary = 0 - (1-mod(rSecondary,2)).^2*crease_depth2;
Rxy = Rxy_primary + Rxy_secondary;

[Xsphere,Ysphere,Zsphere] = sphere(numVerts-1); % Sphere creates +1 verts
Xpunkin = (1+Rxy).*Xsphere;
Ypunkin = (1+Rxy).*Ysphere;

dimple = .2; % Fraction to dimple into top/bottom

rho = linspace(-1,1,numVerts)';
Rz_dimple = (0-rho.^4)*dimple;


HeightRatio = .8;
Zpunkin = (1+Rxy).*Zsphere.*(HeightRatio+Rz_dimple);

Rstem = (1-(1-mod(rPrimary+1,2)).^2)*.05;

thetac = linspace(0,2,numVerts);
Xcyl = cospi(thetac);
Ycyl = sinpi(thetac);

Zcyl = linspace(0,1,11)'; % column vector
Rstemz = .7+(1-Zcyl).^2*.6;

Xstem = (.1+Rstem).*Xcyl.*Rstemz;
Ystem = (.1+Rstem).*Ycyl.*Rstemz;
Zstem = repmat(Zcyl*.15,1,numVerts);

StemData.Xstem = Xstem;
StemData.Ystem = Ystem;
StemData.Zstem = Zstem;
StemData.heightratio = HeightRatio;
StemData.numVerts = numVerts;
StemData.Zsphere = Zsphere;

Cpunkin = hypot(hypot(Xpunkin,Ypunkin),(1+Rxy).*Zsphere); % As if pumpkin were round with no dimples
Punkin = struct("X",Xpunkin,"Y",Ypunkin,"Z",Zpunkin);
Cavity = struct("X",Xcavity,"Y",Ycavity,"Z",Zcavity);
DrawPumpkin(Cavity,Punkin,StemData,Cpunkin);
end

%[appendix]{"version":"1.0"}
%---
