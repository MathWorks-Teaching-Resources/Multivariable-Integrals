function DrawKnife(xShift,yShift,zShift,Orientation)
arguments
    xShift (1,1) double = 0
    yShift (1,1) double = 0
    zShift (1,1) double = 0
    Orientation (1,1) {mustBeMember(Orientation,["horizontal","vertical"])} ="horizontal"
end
% Paring knife blade (3-D surface)
L = 1.2;        % blade length (m)
w0 = 0.2;       % max width at heel (m)
t0 = 0.003;      % max thickness at heel (m)
nx = 200; ny = 60;

x = linspace(0,L,nx);            % 0 = heel, L = tip
% width tapers from w0 to nearly zero at tip (use smooth polynomial)
w = w0*(1 - (x./L).^2);         
[X,Yu] = meshgrid(x,linspace(-1,1,ny));   % Yu in [-1,1] lateral coord
W = interp1(x,w,X(1,:));                  % width along x

% Scale Yu to physical lateral coordinate per column
Y = bsxfun(@times, Yu, W/2);

% Thickness along length (tapers faster than width)
t = t0*(1 - (x./L).^1.9);
T = repmat(t,ny,1);

% Blade geometry:
% % spine (upper surface) is nearly flat with slight taper/curve
% Z_top = 0.0003*(X/L) + 0.0001*(X/L).^2;   % tiny curvature for realism

% belly (lower surface) — convex cross-section; sharper near edge
% use normalized lateral coordinate s = 2*y/w in [-1,1]
S = bsxfun(@rdivide, Y, W/2);
% convex profile: z_drop = thickness * (1 - (1 - |s|^p) ), p controls edge sharpness
p = 2.5;
Z_bottom =  -T .* (1 + (1 - abs(S).^p));
Z_top = T.* (1 + (1 - abs(S).^p));

SharpenedWidth = 12;
for idx = SharpenedWidth-1:-1:0
    Z_bottom(idx+1,:) = Z_bottom(SharpenedWidth,:)*idx/SharpenedWidth;
    Z_top(idx+1,:) = Z_top(SharpenedWidth,:)*idx/SharpenedWidth;
end
Z_bottom(60,:) = 0;
Z_top(60,:) = 0;

% Combine to make full blade volume (plot top and bottom as surfaces)
hold on
% top surface
hTop = surf(X+xShift, Y+yShift, Z_top+zShift, FaceColor=[0.8 0.8 0.82], EdgeColor="none");
% bottom surface
hBottom = surf(X+xShift, Y+yShift, Z_bottom+zShift, FaceColor=[0.75 0.75 0.78], EdgeColor="none");


% tip edge (closing at tip)
tipIdx = nx;
hTip = fill3( X(1,tipIdx)*ones(1,ny)+xShift, Y(:,tipIdx)'+yShift, Z_bottom(:,tipIdx)'+zShift, [0.72 0.72 0.76], EdgeColor="none");

%make it look nice
axis equal off; view(30,20);
camlight headlight; material dull;
lighting gouraud;


xHandMax = 0+xShift;
xHandMin = -0.8+xShift;
yHandMin = -0.05+yShift;
yHandMax = 0.1+yShift;
zHandMin = -0.03+zShift;
zHandMax = 0.03+zShift;

HandleColor = [129 65 65]./255;

% Vertices (8 x 3)
Vhand = [ xHandMin, yHandMin, zHandMin;
    xHandMax, yHandMin, zHandMin;
    xHandMax, yHandMax, zHandMin;
    xHandMin, yHandMax, zHandMin;
    xHandMin, yHandMin, zHandMax;
    xHandMax, yHandMin, zHandMax;
    xHandMax, yHandMax, zHandMax;
    xHandMin, yHandMax, zHandMax ];

% Faces as index into V (each row is one face)
Fhand = [1 2 3 4;   % bottom (zMin)
    5 6 7 8;   % top    (zMax)
    1 2 6 5;   % y = yMin side
    2 3 7 6;   % x = xMax side
    3 4 8 7;   % y = yMax side
    4 1 5 8];  % x = xMin side

KnifeHandle = patch(Vertices=Vhand,Faces=Fhand, ...
    FaceColor=HandleColor, FaceAlpha=1, EdgeColor=[0.8 0.8 0.82]);
hold off

if Orientation == "vertical"
% Rotate the entire graphic by 90 degrees about the x-axis.
% Create rotation matrix for 90 degrees (pi/2) about x and apply to all plotted objects.
theta = pi/2;
R = [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];

% Collect all relevant graphics handles
hObjs = [hTop; hBottom; hTip; KnifeHandle];

for h = hObjs.'
    try
        if isa(h,'matlab.graphics.chart.primitive.Surface')
            Xdata = get(h,'XData'); Ydata = get(h,'YData'); Zdata = get(h,'ZData');
            pts = [Xdata(:)'; Ydata(:)'; Zdata(:)'];
            pts = R * pts;
            set(h,'XData',reshape(pts(1,:),size(Xdata)), ...
                  'YData',reshape(pts(2,:),size(Ydata)), ...
                  'ZData',reshape(pts(3,:),size(Zdata)));
        elseif isa(h,'matlab.graphics.primitive.Patch')
            V = get(h,'Vertices');
            V = (R * V')';
            set(h,'Vertices',V);
        else
            % for other object types (e.g. patch returned by fill3)
            try
                Xdata = get(h,'XData'); Ydata = get(h,'YData'); Zdata = get(h,'ZData');
                pts = [Xdata(:)'; Ydata(:)'; Zdata(:)'];
                pts = R * pts;
                set(h,'XData',reshape(pts(1,:),size(Xdata)), ...
                      'YData',reshape(pts(2,:),size(Ydata)), ...
                      'ZData',reshape(pts(3,:),size(Zdata)));
            catch
                % ignore objects that don't support transformation
            end
        end
    catch
        % ignore any that error
    end
end
    
else
    xlim([xHandMin L+xShift])
end
end

%[appendix]{"version":"1.0"}
%---
