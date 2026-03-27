function DrawSolidRegion(xMin,xMax,yMin,yMax,zMin,zMax,FaceColors)
arguments
    xMin 
    xMax 
    yMin 
    yMax 
    zMin 
    zMax 
    FaceColors (1,:) = ["y" "r" "g" "b"];
end
if numel(FaceColors) < 4
    FaceColors = repmat(FaceColors,[1 ceil(4/numel(FaceColors))]);
end
Xpts = linspace(xMin,xMax,200);
Ypts = linspace(yMin,yMax,200);
[xVals,yVals] = meshgrid(Xpts,Ypts);

Ztop = ComputeZVals(zMax,xVals,yVals);
Zbot = ComputeZVals(zMin,xVals,yVals);

clf
colormap("default")
Region = isAlways(Ztop >= Zbot);
Ztop(~Region) = nan;
surf(xVals,yVals,Ztop,EdgeColor="none",FaceAlpha=0.8)
Zbot(~Region) = nan;
hold on
surf(xVals,yVals,Zbot,EdgeColor="none",FaceAlpha=0.8)

validXL = Ztop(:,1) >= Zbot(:,1);
validYL = Ztop(1,:) >= Zbot(1,:);
validYR = Ztop(end,:) >= Zbot(end,:);
validXR = Ztop(:,end) >= Zbot(:,end);

% Draw the face along the left x boundary in the yz plane
if any(validXL)
    YEdge = Ypts(validXL);
    YEdge = [YEdge fliplr(YEdge)];
    XEdge = xMin*ones(size(YEdge));
    ZTopEdge = Ztop(validXL,1);
    ZBotEdge = flipud(Zbot(validXL,1));
    fill3(XEdge,YEdge,[ZTopEdge; ZBotEdge],FaceColors(1),FaceAlpha=0.8)
end

% Draw the face along the right x boundary in the yz plane
if any(validXR)
    YEdge = Ypts(validXR);
    YEdge = [YEdge fliplr(YEdge)];
    XEdge = xMax*ones(size(YEdge));
    ZTopEdge = Ztop(validXR,end);
    ZBotEdge = flipud(Zbot(validXR,end));
    fill3(XEdge,YEdge,[ZTopEdge; ZBotEdge],FaceColors(2),FaceAlpha=0.8)
end

% Draw the face along the left y boundary in the xz plane
if any(validYL)
    XEdge = Xpts(validYL);
    XEdge = [XEdge fliplr(XEdge)];
    YEdge = yMin*ones(size(XEdge));
    ZTopEdge = fliplr(Ztop(1,validYL));
    ZBotEdge = Zbot(1,validYL);
    fill3(XEdge,YEdge,[ZBotEdge ZTopEdge],FaceColors(3),FaceAlpha=0.8)
end

% Draw the face along the right y boundary in the xz plane
if any(validYR)
    XEdge = Xpts(validYR);
    XEdge = [XEdge fliplr(XEdge)];
    YEdge = yMax*ones(size(XEdge));
    ZTopEdge = fliplr(Ztop(end,validYR));
    ZBotEdge = Zbot(end,validYR);
    fill3(XEdge,YEdge,[ZBotEdge ZTopEdge],FaceColors(4),FaceAlpha=0.8)
end


% Aesthetics
axis equal
xlabel("x")
ylabel("y")
zlabel("z")
% xlim([xMin xMax])
% ylim([yMin yMax])
view(3)
hold off
end

function ZPts = ComputeZVals(zFun,xVals,yVals)
if class(zFun) ~= "double"
    syms x y
    zFunction = matlabFunction(zFun);
    if diff(zFun,x) == 0
        ZPts = zFunction(yVals);
    elseif diff(zFun,y) == 0
        ZPts = zFunction(xVals);
    else
        ZPts = zFunction(xVals,yVals);
    end
else
    ZPts = zFun*ones(size(xVals));
end
end


%[appendix]{"version":"1.0"}
%---
