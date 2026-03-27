classdef FunctionTests < matlab.unittest.TestCase

    % https://www.mathworks.com/help/matlab/matlab_prog/use-parameters-in-class-based-tests.html

    methods(Test)    

        function testPlotCycle3WithValidNonDefaultInputs(testCase)
            % Test with valid inputs
            Units1 = "X-axis";
            Units2 = "Y-axis";
            Units3 = "Z-axis";
            MyTitle = "Test Plot";
            SerIndex = 4;
            Alpha = linspace(0,2*pi,100);
            
            fig = figure('Visible','off');
            ax = PlotCycle3(Units1, Units2, Units3,[5 7],[4 -4],[-1 1],[7 9],...
                [-4 -4],[1 3],[9 11],[-4 4],[3 1],8+3*cos(Alpha(1:50)),...
                [4+sin(Alpha(1:49)*5) 4],linspace(1,-1,50),...
                TitleStr=MyTitle,ResetLimits=false,FillRegion=false,...
                SeriesIndex=SerIndex,LineWidth=3);
            testCase.verifyNotEmpty(ax)
            testCase.verifyEqual(string(ax.XLabel.String), Units1)
            testCase.verifyEqual(string(ax.YLabel.String), Units2)
            testCase.verifyEqual(string(ax.ZLabel.String), Units3)
            testCase.verifyEqual(string(ax.Title.String), MyTitle)
            testCase.verifyEqual(ax.Children(end).SeriesIndex,SerIndex)
            testCase.verifyEqual(numel(ax.Children),9)
            clf(fig)
        end

        function testPlotCycle3WithDefaultInputs(testCase)
            % Test with valid inputs
            Units1 = "X";
            Units2 = "Y";
            Units3 = "Z";
            Alpha = linspace(0,2*pi,100);
            fig = figure('Visible','off');
            ax = PlotCycle3(Units1,Units2,Units3,[5 7],[4 -4],[-1 1],[7 9],...
                [-4 -4],[1 3],[9 11],[-4 4],[3 1],[8+3*cos(Alpha(1:49)) 5],...
                [4+sin(Alpha(1:49)*5) 4],linspace(1,-1,50));
            testCase.verifyNotEmpty(ax);
            testCase.verifyEqual(string(ax.XLabel.String), Units1);
            testCase.verifyEqual(string(ax.YLabel.String), Units2);
            testCase.verifyEqual(string(ax.ZLabel.String), Units3);
            testCase.verifyEqual(string(ax.Title.String), "Curve")
            testCase.verifyEqual(ax.Children(end-1).SeriesIndex,1)
            testCase.verifyEqual(numel(ax.Children),10)
            clf(fig)
        end

        function testAddArrowDraw2DDefaultOptions(testCase)
            % Verify AddArrow runs on 2D axes with default options and
            % creates a patch object with expected properties.

            f = figure('Visible','off'); %#ok<UNRCH>
            ax = axes(f);
            ax.XLim = [0 10];
            ax.YLim = [0 5];

            pt1 = [1 1];
            pt2 = [8 3];

            % Call the function under test
            AddArrow(ax, pt1, pt2);

            % Find patch objects created on the axes
            patches = findall(ax, 'Type', 'patch');

            testCase.verifyGreaterThanOrEqual(numel(patches), 1, ...
                'Expected at least one patch (arrow) to be created on 2D axes.');

            % Inspect the most recently created patch for basic consistency
            p = patches(1);
            testCase.verifyEqual(p.FaceColor, [1 0 0], ...
                'Default Color option should create a red patch.');

            % The patch XData and YData should contain coordinates consistent with pts
            xData = double(p.XData);
            yData = double(p.YData);
            testCase.verifyGreaterThan(max(xData), min([pt1(1), pt2(1)]));
            testCase.verifyGreaterThan(max(yData), min([pt1(2), pt2(2)]));

            close(f);
        end

        function testAddArrowDraw3DWithOptions(testCase)
            % Verify AddArrow runs on 3D axes with custom options and
            % creates a 3D patch (fill3) with provided color and series index.

            f = figure('Visible','off');
            ax = axes(f);
            view(ax,3);
            ax.XLim = [0 10];
            ax.YLim = [0 5];
            ax.ZLim = [-2 2];

            pt1 = [1 1 0];
            pt2 = [8 3 1];

            opts.SeriesIndex = 3;
            opts.Color = [0 1 0]; % green
            opts.Line = true;

            % Call the function under test
            AddArrow(ax, pt1, pt2, SeriesIndex = 3,Color = [0 1 0],Line = true);

            % Find patch objects created on the axes (fill3 creates patch)
            patches = findall(ax, 'Type', 'patch');
            testCase.verifyGreaterThanOrEqual(numel(patches), 1, ...
                'Expected at least one patch (arrow) to be created on 3D axes.');

            p = patches(1);
            testCase.verifyEqual(p.FaceColor, opts.Color);


            % The patch should have 3D coordinate arrays
            xData = p.XData;
            yData = p.YData;
            zData = p.ZData;

            testCase.verifySize(xData, size(zData));
            testCase.verifyGreaterThan(max(zData), min([pt1(3), pt2(3)]));

            close(f);
        end

        function testAddArrowNoLineOptionUsesFullSpan(testCase)
            % Verify AddArrow when Line option is false, tip is at pt2 and tail at pt1
            % by checking that the arrow spans approximately from pt1 to pt2.

            f = figure('Visible','off');
            ax = axes(f);
            ax.XLim = [0 100];
            ax.YLim = [0 100];

            pt1 = [10 20];
            pt2 = [90 80];

            opts.Line = false;
            opts.Color = "b";

            AddArrow(ax, pt1, pt2, Line=false, Color="b");

            p = findall(ax, 'Type', 'patch', '-depth', 1);
            testCase.verifyNotEmpty(p, 'Expected patch to be created when Line=false.');

            % Examine the bounding box of the patch to ensure it spans near the points
            p = p(1);
            xData = double(p.XData);
            yData = double(p.YData);

            tol = 5; % allow some tolerance because arrowhead may not reach exact endpoints
            testCase.verifyLessThanOrEqual(abs(min(xData) - min(pt1(1), pt2(1))), tol);
            testCase.verifyLessThanOrEqual(abs(max(xData) - max(pt1(1), pt2(1))), tol);
            testCase.verifyLessThanOrEqual(abs(min(yData) - min(pt1(2), pt2(2))), tol);
            testCase.verifyLessThanOrEqual(abs(max(yData) - max(pt1(2), pt2(2))), tol);

            close(f);
        end

        function testAddArrowUnexpectedDimensionThrows(testCase)
            % Provide points with dim ~= 2 or 3 to ensure the function AddArrow errors.

            f = figure('Visible','off');
            ax = axes(f);
            ax.XLim = [0 1];
            ax.YLim = [0 1];

            % Provide a 1D point which should trigger the "Unexpected dimension" error
            pt1 = 0;
            pt2 = 1;

            testCase.verifyError(@() AddArrow(ax, pt1, pt2), "AddArrow:IncorrectDimension");

            % Also test a 4-element point triggers the custom error branch
            pt1 = [1 2 3 4];
            pt2 = [2 3 4 5];
            testCase.verifyError(@() AddArrow(ax, pt1, pt2), "MATLAB:assertion:failed");

            close(f);
        end

        % TestCreatePumpkin Unit tests for CreatePumpkin function.
        %
        % These tests exercise the public interface of CreatePumpkin and verify
        % that outputs have the expected types, sizes, and basic value ranges.

        function testCreatePumpkinReturnsFourOutputs(testCase)
            % Verify the function returns four outputs and correct types.
            [Cavity,Punkin,StemData,Cpunkin] = CreatePumpkin();

            testCase.verifyClass(Cavity, 'struct', 'Cavity should be a struct');
            testCase.verifyClass(Punkin, 'struct', 'Punkin should be a struct');
            testCase.verifyClass(StemData, 'struct', 'StemData should be a struct');
            testCase.verifyClass(Cpunkin,'double', 'Cpunkin should be a double');
        end

        function testCreatePumpkinPunkinFieldsAndSizes(testCase)
            % Verify Punkin has X,Y,Z fields and they are same sized matrices.
            [~,Punkin,~,~] = CreatePumpkin();

            testCase.verifyTrue(isfield(Punkin,'X') && isfield(Punkin,'Y') && isfield(Punkin,'Z'), ...
                'Punkin must contain X, Y, and Z fields');

            X = Punkin.X; Y = Punkin.Y; Z = Punkin.Z;

            testCase.verifyEqual(size(X), size(Y), 'X and Y must be same size');
            testCase.verifyEqual(size(X), size(Z), 'X and Z must be same size');

            % Values should be finite and not NaN
            testCase.verifyTrue(all(isfinite(X(:))), 'X contains non-finite values');
            testCase.verifyTrue(all(isfinite(Y(:))), 'Y contains non-finite values');
            testCase.verifyTrue(all(isfinite(Z(:))), 'Z contains non-finite values');
        end

        function testCreatePumpkinCavityFieldsAndRanges(testCase)
            % Verify Cavity fields exist and radii are reasonable.
            [Cavity,~,~,~] = CreatePumpkin();

            testCase.verifyTrue(isfield(Cavity,'X') && isfield(Cavity,'Y') && isfield(Cavity,'Z'), ...
                'Cavity must contain X, Y, and Z fields');

            Xc = Cavity.X; Yc = Cavity.Y; Zc = Cavity.Z;

            % Cavity generated from ellipsoid of modest size: check ranges
            testCase.verifyLessThanOrEqual(max(abs(Xc(:))), 1, 'Cavity X values unexpectedly large');
            testCase.verifyLessThanOrEqual(max(abs(Yc(:))), 1, 'Cavity Y values unexpectedly large');
            testCase.verifyLessThanOrEqual(max(abs(Zc(:))), 1, 'Cavity Z values unexpectedly large');
        end

        function testCreatePumpkinStemDataContents(testCase)
            % Verify StemData contains expected fields and numeric arrays.
            [~,~,StemData,~] = CreatePumpkin();

            expectedFields = {'Xstem','Ystem','Zstem','heightratio','numVerts','Zsphere'};
            for k = 1:numel(expectedFields)
                fld = expectedFields{k};
                testCase.verifyTrue(isfield(StemData,fld), sprintf('StemData missing field %s', fld));
            end

            testCase.verifyClass(StemData.Xstem,"double");
            testCase.verifyClass(StemData.Ystem,"double");
            testCase.verifyClass(StemData.Zstem,"double");
            testCase.verifyGreaterThan(StemData.numVerts, 0);
            testCase.verifyGreaterThanOrEqual(StemData.heightratio, 0);
            testCase.verifyLessThanOrEqual(StemData.heightratio, 1.5);
        end

        function testCreatePumpkinCpunkinMatchesPunkinMagnitude(testCase)
            % Cpunkin should represent radial magnitude comparable to Punkin coords.
            [~,Punkin,~,Cpunkin] = CreatePumpkin();

            X = Punkin.X; Y = Punkin.Y; ZsphereLike = Punkin.Z; % Z used to compute magnitude in code
            % Compute magnitude as hypot(hypot(X,Y), abs(ZsphereLike)) - expect values non-negative
            computedMag = hypot(hypot(X, Y), abs(ZsphereLike));

            testCase.verifySize(Cpunkin, size(computedMag));
            % Values should be positive and finite
            testCase.verifyTrue(all(Cpunkin(:) >= 0));
            testCase.verifyTrue(all(isfinite(Cpunkin(:))));
        end

        function testCreatePumpkinRepeatableOutputShapes(testCase)
            % Running multiple times should produce outputs of same shapes.
            [C1,P1,S1,Cp1] = CreatePumpkin();
            [C2,P2,S2,Cp2] = CreatePumpkin();

            testCase.verifyEqual(size(C1.X), size(C2.X));
            testCase.verifyEqual(size(P1.X), size(P2.X));
            testCase.verifyEqual(size(S1.Xstem), size(S2.Xstem));
            testCase.verifyEqual(size(Cp1), size(Cp2));
        end

        % Unit tests for DrawCartesianVolumeElement function.
        function testDrawCartesianVolumeElementDefaultCallCreatesPatchAndAxes(testCase)
            % Test that the function runs with default arguments and creates patch and axes limits.

            % Create a fresh figure to avoid contaminating other tests
            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            % Call the function with no inputs (rely on defaults)
            DrawCartesianVolumeElement();

            % Verify that there is at least one patch object in the axes
            ax = gca;
            patches = findobj(ax, 'Type', 'Patch');
            testCase.verifyGreaterThan(numel(patches), 0, 'Expected a patch object to be created.');

            % Verify axes limits were set to expected ranges [0 3]
            xlimVal = xlim(ax);
            ylimVal = ylim(ax);
            zlimVal = zlim(ax);

            testCase.verifyEqual(xlimVal, [0 3], 'AbsTol', 1e-12);
            testCase.verifyEqual(ylimVal, [0 3], 'AbsTol', 1e-12);
            testCase.verifyEqual(zlimVal, [0 3], 'AbsTol', 1e-12);
        end

        function testDrawCartesianVolumeElementCustomDimensionsAndColorOption(testCase)
            % Test the function with custom dx,dy,dz and a valid colormap name.

            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            dx = 0.6;
            dy = 0.8;
            dz = 0.5;
            Lx = 2;
            Ly = 0.5;
            Lz = 0.2;
            cmapName = "parula";

            % Call the function with explicit arguments
            DrawCartesianVolumeElement(cmapName, dx, dy, dz, Lx, Ly, Lz);

            ax = gca;
            % Verify patch exists
            patches = findobj(ax, 'Type', 'Patch');
            testCase.verifyGreaterThan(numel(patches), 0, 'Expected a patch object to be created for custom inputs.');

            % Verify subtitle shows the computed volume string
            % subtitle returns a Text object on newer MATLAB; search for matching string in all text objects
            expectedVolumeStr = "V = " + (dx*dy*dz);
            txtObjs = findall(ax.Parent, 'Type', 'Text'); % includes title/subtitle/labels
            texts = arrayfun(@(t) string(get(t, 'String')), txtObjs, 'UniformOutput', false);
            texts = string([texts{:}]);

            testCase.verifyTrue(any(texts == expectedVolumeStr), ...
                sprintf('Expected subtitle/text "%s" to be present.', expectedVolumeStr));
        end

        function testDrawCartesianVolumeElementDifferentColormapStringInput(testCase)
            % Test that passing a different colormap string produces a patch with FaceColor matching colormap entry.

            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            cmapName = "hot";
            dx = 0.1; dy = 0.1; dz = 0.1;

            DrawCartesianVolumeElement(cmapName, dx, dy, dz);

            ax = gca;
            p = findobj(ax, 'Type', 'Patch');
            testCase.verifyNotEmpty(p, 'Patch object should be created.');

            % Verify the patch FaceColor matches the first row of the colormap
            cmap = colormap(cmapName);
            expectedFaceColor = cmap(1,:);
            actualFaceColor = get(p(1), 'FaceColor');

            testCase.verifyEqual(actualFaceColor, expectedFaceColor, 'AbsTol', 1e-12);
        end

        function testDrawCartesianVolumeElementVolumeComputationConsistency(testCase)
            % Test that the subtitle's numeric value matches dx*dy*dz for a range of inputs.

            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            dx = 0.3; dy = 0.4; dz = 0.2;
            DrawCartesianVolumeElement("summer", dx, dy, dz);

            % Extract subtitle/text values
            txtObjs = findall(gcf, 'Type', 'Text');
            texts = arrayfun(@(t) string(get(t, 'String')), txtObjs, 'UniformOutput', false);
            texts = string([texts{:}]);

            expected = "V = " + (dx*dy*dz);
            testCase.verifyTrue(any(texts == expected), 'Subtitle volume does not match computed dx*dy*dz.');
        end

% Unit tests for DrawCylindricalVolumeElement function.
       function testDrawCylindricalVolumeElementDefaultCallCreatesFigureAndCorrectVolume(testCase)
            % Test calling with no arguments creates a figure and sets subtitle to expected volume.

            % Ensure a fresh figure environment
            figsBefore = findall(groot, 'Type', 'figure');

            % Call function with default arguments
            DrawCylindricalVolumeElement();

            % Verify a new figure was created
            figsAfter = findall(groot, 'Type', 'figure');
            testCase.verifyGreaterThanOrEqual(numel(figsAfter) , numel(figsBefore));

            % Get the most recent figure and its children
            fig = figsAfter(1); %#ok<FNDSB>
            ax = findobj(fig, 'Type', 'axes');
            testCase.verifyNotEmpty(ax, 'Expected axes to be present in the figure.');

            % Compute expected volume from default argument values used in function
            r0 = sqrt(2);
            dr = 0.6;
            dtheta = pi/6;
            dz = 0.5;
            expectedVol = r0 * dr * dtheta * dz;

            % Find subtitle text object (MATLAB places subtitle as a Text object under axes)
            % Accept either text object with matching string or a title-like object.
            txtObjs = findall(ax, 'Type', 'text');
            found = false;
            for k = 1:numel(txtObjs)
                s = string(get(txtObjs(k), 'String'));
                if any(contains(s, "V ="))
                    % Extract numeric portion from string and compare
                    numStr = extractAfter(s, "V = ");
                    % Convert to numeric if possible
                    val = str2double(numStr);
                    if ~isnan(val)
                        testCase.verifyEqual(val, expectedVol, 'AbsTol', 1e-5);
                        found = true;
                        break;
                    end
                end
            end
            testCase.verifyTrue(found, 'Expected a subtitle text containing the computed volume.');

            close(fig);
        end

        function testDrawCylindricalVolumeElementCustomParametersProduceExpectedVolume(testCase)
            % Test that custom input parameters result in a subtitle showing the correct volume.

            r0 = 1.5;
            dr = 0.2;
            dtheta = pi/4;
            dz = 0.7;
            theta0 = 0.1;
            z0 = 0.3;
            Copt = "parula";

            figsBefore = findall(groot, 'Type', 'figure');

            % Call function with explicit parameters
            DrawCylindricalVolumeElement(Copt, dr, dtheta, dz, r0, theta0, z0);

            figsAfter = findall(groot, 'Type', 'figure');
            testCase.verifyGreaterThanOrEqual(numel(figsAfter), numel(figsBefore));

            fig = figsAfter(1); %#ok<FNDSB>
            ax = findobj(fig, 'Type', 'axes');
            testCase.verifyNotEmpty(ax);

            expectedVol = r0 * dr * dtheta * dz;

            txtObjs = findall(ax, 'Type', 'text');
            found = false;
            for k = 1:numel(txtObjs)
                s = string(get(txtObjs(k), 'String'));
                if any(contains(s, "V ="))
                    numStr = extractAfter(s, "V = ");
                    val = str2double(numStr);
                    if ~isnan(val)
                        testCase.verifyEqual(val, expectedVol, 'AbsTol', 1e-5);
                        found = true;
                        break;
                    end
                end
            end
            testCase.verifyTrue(found, 'Expected a subtitle text containing the computed volume.');

            close(fig);
        end

        function testDrawCylindricalVolumeElementSurfaceAndPatchObjectsAreCreated(testCase)
            % Test that calling the function creates expected surface and patch graphics objects.

            figsBefore = findall(0, 'Type', 'figure');
            DrawCylindricalVolumeElement();
            figsAfter = findall(0, 'Type', 'figure');
            fig = setdiff(figsAfter, figsBefore);
            if isempty(fig)
                fig = figsAfter(1);
            else
                fig = fig(1);
            end

            % Find surface and patch objects in the figure
            surfaces = findall(fig, 'Type', 'surface');
            patches = findall(fig, 'Type', 'patch');
            fills = findall(fig, 'Type', 'patch'); % fill3 also creates patch objects

            testCase.verifyGreaterThanOrEqual(numel(surfaces), 2, 'Expected at least two surface objects (inner/outer curved faces).');
            testCase.verifyGreaterThanOrEqual(numel(patches), 1, 'Expected patch objects for the connecting faces or filled caps.');

            close(fig);
        end

        function testDrawKnifeDefaultInvocationCreatesGraphics(testCase)
            % Verify calling DrawKnife with no arguments produces graphics objects
            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            % Call the function with default args
            DrawKnife();

            % Get children of current axes
            ax = gca;
            children = allchild(ax);

            % Expect at least one surface and one patch/fill object
            isSurface = arrayfun(@(h) isa(h,'matlab.graphics.chart.primitive.Surface'), children);
            isPatch  = arrayfun(@(h) isa(h,'matlab.graphics.primitive.Patch'), children);

            testCase.verifyTrue(any(isSurface), 'Expected at least one Surface object on axes.');
            testCase.verifyTrue(any(isPatch) || any(arrayfun(@(h) isprop(h,'Faces') || isprop(h,'Vertices'), children)), ...
                'Expected a Patch object representing the handle or tip.');
        end

        function testDrawKnifeWithShiftsAffectsPositions(testCase)
            % Verify that applying shifts changes surface X/Y/Z data accordingly
            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            xShift = 0.5;
            yShift = -0.3;
            zShift = 0.1;

            % Create first knife at origin
            DrawKnife();
            ax = gca;
            children1 = findobj(ax, '-property', 'XData'); % objects with XData
            % capture some numeric data from first surface
            h1 = children1(1);
            X1 = get(h1,'XData');
            Y1 = get(h1,'YData');
            Z1 = get(h1,'ZData');

            cla(ax); % clear axes
            % Create second knife with shifts
            DrawKnife(xShift,yShift,zShift);
            children2 = findobj(ax, '-property', 'XData');
            h2 = children2(1);
            X2 = get(h2,'XData');
            Y2 = get(h2,'YData');
            Z2 = get(h2,'ZData');

            % Verify that the second knife data is offset by the shifts (compare a sample element)
            idx = sub2ind(size(X1),1,1);
            testCase.verifyEqual(X2(idx), X1(idx) + xShift, 'AbsTol', 1e-10);
            testCase.verifyEqual(Y2(idx), Y1(idx) + yShift, 'AbsTol', 1e-10);
            testCase.verifyEqual(Z2(idx), Z1(idx) + zShift, 'AbsTol', 1e-10);
        end

        function testDrawKnifeVerticalOrientationRotatesGeometry(testCase)
            % Verify that specifying Orientation "vertical" transforms vertices of the handle patch
            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            % Draw horizontal (default) and capture handle patch vertices
            DrawKnife();
            ax = gca;
            % find patch with Faces property corresponding to handle (a Patch)
            patches = findobj(ax, 'Type', 'patch');
            % choose one patch and get vertices
            if isempty(patches)
                % If no patch found, fail the test
                testCase.verifyFail('No patch objects found for horizontal knife.');
            end
            hPatchH = patches(1);
            Vh = get(hPatchH, 'Vertices');

            cla(ax);
            % Draw vertical knife
            DrawKnife(0,0,0,"vertical");
            patchesV = findobj(ax, 'Type', 'patch');
            if isempty(patchesV)
                testCase.verifyFail('No patch objects found for vertical knife.');
            end
            hPatchV = patchesV(1);
            Vv = get(hPatchV, 'Vertices');

            % A 90-degree rotation about x should swap y and z (with sign). Check that norms preserved.
            testCase.verifySize(Vh, size(Vv));
            % distances from origin should be preserved after rotation (within tolerance)
            dH = sqrt(sum(Vh.^2,2));
            dV = sqrt(sum(Vv.^2,2));
            testCase.verifyEqual(dH, dV, 'RelTol', 1e-6);
        end

        function testDrawKnifeInvalidOrientationErrors(testCase)
            % Verify that passing an invalid Orientation value errors due to argument validation
            testCase.verifyError(@() DrawKnife(0,0,0,"diagonal"), 'MATLAB:validators:mustBeMember');
        end

        % Unit tests for DrawPumpkin function.
        %
        % These tests exercise the public interface of DrawPumpkin by calling it
        % with minimal synthetic geometry and verifying that it returns the
        % current axes and creates expected graphics objects with properties set.

        function testDrawPumpkinReturnsAxesHandle(testCase)
            % Verify that DrawPumpkin returns an axes handle.

            % Minimal synthetic geometry for cavity and pumpkin surfaces
            [Xc,Yc,Zc] = ellipsoid(0,0,0,0.3,0.3,0.25);
            Cavity = struct("X",Xc,"Y",Yc,"Z",Zc);

            [Xp,Yp,Zp] = ellipsoid(0,0,0,1,1,0.9);
            Punkin = struct("X",Xp,"Y",Yp,"Z",Zp);

            % StemData structure with required fields used by the function
            StemData.Xstem = [0.9 0.9; 1.0 1.0];
            StemData.Ystem = [0.0 0.1; 0.0 0.1];
            StemData.Zstem = [0.9 0.9; 1 1];
            StemData.heightratio = 0.1;
            StemData.numVerts = size(Xp,2);

            % CData for pumpkin surface must match pumpkin grid size
            Cpunkin = ones(size(Xp));

            % Call function under test
            ax = DrawPumpkin(Cavity,Punkin,StemData,Cpunkin);

            % Verify output is an axes handle
            testCase.verifyClass(ax, 'matlab.graphics.axis.Axes');

            % Clean up figure
            if isvalid(ax)
                fig = ancestor(ax, 'figure');
                if isvalid(fig)
                    close(fig);
                end
            end
        end

        function testDrawPumpkinCreatesExpectedGraphicsObjects(testCase)
            % Verify that calling DrawPumpkin creates surf/patch objects with
            % expected properties (FaceAlpha, EdgeColor, and CData usage).

            [Xc,Yc] = meshgrid(linspace(-1,1,6));
            Zc = zeros(size(Xc));
            Cavity = struct("X",Xc,"Y",Yc,"Z",Zc);

            [Xp,Yp] = meshgrid(linspace(-0.8,0.8,5));
            Zp = 0.15*ones(size(Xp));
            Punkin = struct("X",Xp,"Y",Yp,"Z",Zp);

            StemData.Xstem = [0.9 0.9; 1.0 1.0];
            StemData.Ystem = [0.0 0.1; 0.0 0.1];
            StemData.Zstem = [0.15 0.15; 0.17 0.17];
            StemData.heightratio = 0.1;
            StemData.numVerts = size(Xp,2);

            Cpunkin = rand(size(Xp)); % random CData

            ax = DrawPumpkin(Cavity,Punkin, StemData, Cpunkin);

            % Find all child graphics objects of the axes
            children = findall(ax);

            % Expect at least one surf and one patch in the children
            isSurf = arrayfun(@(h) isa(h,'matlab.graphics.chart.primitive.Surface'), children);
            isPatch = arrayfun(@(h) isa(h,'matlab.graphics.primitive.Patch'), children);

            testCase.verifyTrue(any(isSurf), 'No surface objects were created.');
            testCase.verifyTrue(any(isPatch), 'No patch objects were created.');

            % Inspect the pumpkin surface (one of the surfaces should have FaceColor 'interp')
            surfHandles = children(isSurf);
            interpFound = false;
            for k = 1:numel(surfHandles)
                try
                    fc = surfHandles(k).FaceColor;
                    if (ischar(fc) && strcmp(fc,'interp')) || (isstring(fc) && fc == "interp")
                        interpFound = true;
                        % Verify that CData was set (non-empty numeric array)
                        cdata = surfHandles(k).CData;
                        testCase.verifyNotEmpty(cdata);
                        testCase.verifySize(cdata, size(Xp));
                        break
                    end
                catch
                    % ignore handles that do not expose properties
                end
            end
            testCase.verifyTrue(interpFound, 'Pumpkin surface with FaceColor="interp" not found.');

            % Clean up
            if isvalid(ax)
                fig = ancestor(ax, 'figure');
                if isvalid(fig)
                    close(fig);
                end
            end
        end

        function testDrawPumpkinHandlesDifferentStemSizes(testCase)
            % Verify DrawPumpkin runs for different StemData.numVerts values without error.

            [Xc,Yc] = meshgrid(linspace(-1,1,6));
            Zc = zeros(size(Xc));
            Cavity = struct("X",Xc,"Y",Yc,"Z",Zc);

            [Xp,Yp] = meshgrid(linspace(-0.5,0.5,5));
            Zp = 0.1*ones(size(Xp));
            Punkin = struct("X",Xp,"Y",Yp,"Z",Zp);

            for n = [3, 6, 10]
                StemData.Xstem = repmat(linspace(0.6,0.9,n), 2, 1);
                StemData.Ystem = repmat(linspace(0,0.2,n), 2, 1);
                StemData.Zstem = zeros(2,n);
                StemData.heightratio = 0.05;
                StemData.numVerts = size(Xp,2);

                Cpunkin = zeros(size(Xp));

                % Ensure function does not throw for varied stem sizes
                testCase.verifyWarningFree(@() DrawPumpkin(Cavity,Punkin, StemData, Cpunkin));

                % Close created figure
                ax = gca;
                if isvalid(ax)
                    fig = ancestor(ax, 'figure');
                    if isvalid(fig)
                        close(fig);
                    end
                end
            end
        end

        % DrawSolidRegion tests
        function testDrawSolidRegionWithConstantZValues(testCase)
            % Test drawing when zMin and zMax are constant doubles.
            f = figure('Visible','off'); % create invisible figure for drawing
            cleanup = onCleanup(@() close(f));

            xMin = 0; xMax = 1;
            yMin = 0; yMax = 1;
            zMin = 0; zMax = 1;

            % Call the function under test; should run without error.
            DrawSolidRegion(xMin,xMax,yMin,yMax,zMin,zMax);

            % Verify that at least one surface object was created in the axes.
            ax = gca;
            surfObjs = findobj(ax, 'Type', 'surface');
            testCase.verifyGreaterThanOrEqual(numel(surfObjs), 2, ...
                'Expected at least two surface objects for top and bottom.');
        end

        function testDrawSolidRegionDrawWithSymbolicZFunction(testCase)
            % Test drawing when zMin and zMax are symbolic expressions using x and y.
            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            syms x y
            % zMax depends on both x and y, zMin is constant symbolic
            zMax = x.^2 + y.^2;
            zMin = 0;

            xMin = -1; xMax = 1;
            yMin = -1; yMax = 1;

            % Call the function under test; should run without error.
            DrawSolidRegion(xMin,xMax,yMin,yMax,zMin,zMax);

            % Verify that surfaces exist and axes labels set
            ax = gca;
            surfObjs = findobj(ax, 'Type', 'surface');
            testCase.verifyGreaterThanOrEqual(numel(surfObjs), 2);

            % Check axis labels were set to x, y, z (as strings)
            xl = get(get(ax,'XLabel'),'String');
            yl = get(get(ax,'YLabel'),'String');
            zl = get(get(ax,'ZLabel'),'String');
            testCase.verifyEqual(char(xl), 'x');
            testCase.verifyEqual(char(yl), 'y');
            testCase.verifyEqual(char(zl), 'z');
        end

        function testDrawSolidRegionCustomFaceColorsArgument(testCase)
            % Test that supplying custom FaceColors does not error and is accepted.
            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            xMin = 0; xMax = 2;
            yMin = 0; yMax = 2;
            zMin = 0; zMax = 1;
            FaceColors = ["c" "m" "y" "k"];

            % Call the function under test with custom FaceColors.
            DrawSolidRegion(xMin,xMax,yMin,yMax,zMin,zMax,FaceColors);

            % Verify plotted patch objects exist (faces created by fill3)
            ax = gca;
            patchObjs = findobj(ax, '-property', 'FaceAlpha'); % includes surface and patch
            testCase.verifyGreaterThanOrEqual(numel(patchObjs), 4, ...
                'Expected face patches for boundaries when valid.');
        end

        function testDrawSolidRegionComputeZValsSingleVariableSymbolic(testCase)
            % Indirect test: ensure DrawSolidRegion handles z functions that depend on x only or y only.
            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            syms x y
            zMax_x = x;       % depends only on x
            zMin_y = y*3;     % depends only on y (constant three)

            xMin = 0; xMax = 1;
            yMin = 0; yMax = 1;

            % Should not error when z functions depend on a single variable.
            DrawSolidRegion(xMin,xMax,yMin,yMax,zMin_y,zMax_x);

            ax = gca;
            surfObjs = findobj(ax, 'Type', 'surface');
            testCase.verifyGreaterThanOrEqual(numel(surfObjs), 2);
        end

        function testDrawSolidRegionInvalidFaceColorsLengthDoesNotError(testCase)
            % Provide an invalid FaceColors length; function should still run (uses indexing).
            f = figure('Visible','off');
            cleanup = onCleanup(@() close(f));

            xMin = 0; xMax = 1;
            yMin = 0; yMax = 1;
            zMin = 0; zMax = 0.5;
            FaceColors = "r"; % too short, but function indexes up to 4

            % Expect no error 
            % (Expands FaceColors into 1xn vector where n >= 4)
            DrawSolidRegion(xMin,xMax,yMin,yMax,zMin,zMax,FaceColors)

            ax = gca;
            surfObjs = findobj(ax, 'Type', 'surface');
            testCase.verifyGreaterThanOrEqual(numel(surfObjs), 2);
        end

        function testSphericalVolumeElementDefaultCallCreatesGraphicObjects(testCase)
            % Ensure calling with no args creates figure and graphics objects.

            % Close figures to start fresh
            close all force

            % Call the function with defaults
            DrawSphericalVolumeElement();

            % There should be at least one figure open
            figs = findall(0, 'Type', 'figure');
            testCase.verifyGreaterThanOrEqual(numel(figs), 1);

            % Inspect the current axes for surface and line objects
            ax = findall(figs(1), 'Type', 'axes');
            testCase.verifyGreaterThanOrEqual(numel(ax), 1);

            % Check that there are surface objects (the two spherical shells)
            srf = findall(ax(1), 'Type', 'surface');
            testCase.verifyGreaterThanOrEqual(numel(srf), 2);

            % Check that there are patch/fill objects for the side faces
            patchObjs = findall(ax(1), 'Type', 'patch');
            testCase.verifyGreaterThanOrEqual(numel(patchObjs), 4);

            % Check that there are line-like objects (plot3 calls produce line objects)
            lines = findall(ax(1), 'Type', 'line');
            testCase.verifyGreaterThanOrEqual(numel(lines), 4);

            % Verify title and subtitle text exist and contain expected text
            t = get(ax(1), 'Title');
            testCase.verifyNotEmpty(t);
            titleStr = string(get(t, 'String'));
            testCase.verifyNotEmpty(titleStr);
            testCase.verifyTrue(contains(titleStr, "Spherical Volume Element"), ...
                "Title should mention 'Spherical Volume Element'");

            % Verify subtitle was set (for newer MATLAB versions subtitle is a separate object)
            % Accept either subtitle via annotation or as part of title (function uses subtitle())
            try
                subt = get(ax(1), 'Subtitle');
                subtStr = string(get(subt, 'String'));
                testCase.verifyTrue(contains(subtStr, "V ="));
            catch
                % If 'Subtitle' not supported, check title / figure children for text containing "V ="
                txt = findall(figs(1), 'Type', 'text');
                hasVol = any(contains(string(get(txt, 'String')), "V ="));
                testCase.verifyTrue(hasVol);
            end
        end

        function testSphericalVolumeElementCustomParametersAffectLimitsAndVolume(testCase)
            % Test that different input parameters change axes limits and computed volume string.

            close all force

            % Choose custom parameters
            Copt = "parula";
            drho = 0.2;
            dphi = pi/6;
            dtheta = pi/3;
            rho0 = 1.5;
            phi0 = pi/6;
            theta0 = pi/8;

            DrawSphericalVolumeElement(Copt, drho, dphi, dtheta, rho0, phi0, theta0);

            figs = findall(0, 'Type', 'figure');
            testCase.verifyGreaterThanOrEqual(numel(figs), 1);
            ax = findall(figs(1), 'Type', 'axes');
            testCase.verifyNotEmpty(ax);
            ax = ax(1);

            % Check axis limits encompass expected range [0,3] was used in function,
            % but ensure xlim/ylim/zlim return numeric 2-element vectors.
            xl = xlim(ax);
            yl = ylim(ax);
            zl = zlim(ax);
            testCase.verifySize(xl, [1 2]);
            testCase.verifySize(yl, [1 2]);
            testCase.verifySize(zl, [1 2]);

            % Verify computed volume string appears in subtitle or text
            CurVol = rho0^2 * sin(phi0) * drho * dtheta * dphi;
            volStr = "V = " + CurVol;

            found = false;
            % Try subtitle
            try
                subt = get(ax, 'Subtitle');
                subtStr = string(get(subt, 'String'));
                found = contains(subtStr, volStr);
            catch
                % Fallback to searching text objects in figure
                txt = findall(figs(1), 'Type', 'text');
                txtStrs = string(get(txt, 'String'));
                found = any(contains(txtStrs, volStr));
            end
            testCase.verifyTrue(found, "Volume string should appear in the figure");
        end

        function testSphericalVolumeElementInvalidInputsErrorHandling(testCase)
            % Verify that passing invalid types causes an error (arguments block enforces types)

            % Passing a non-numeric drho should error
            testCase.verifyError(@() DrawSphericalVolumeElement("summer", "notNumeric"), ...
                'MATLAB:math:mustBeNumericCharOrLogical'); % arguments block errors can vary; accept general error

            % Passing negative rho0 may still run but is physically odd; ensure function executes
            close all force
            testCase.verifyWarningFree(@() DrawSphericalVolumeElement("summer", 0.1, pi/8, pi/6, -2, pi/4, pi/4));
            figs = findall(0, 'Type', 'figure');
            testCase.verifyGreaterThanOrEqual(numel(figs), 1);
        end
        
        function testGetBoundsTwoDistinctValuesDefaultSF(testCase)
            % Verify bounds for two distinct values with default scale factor.
            vals = [2, 10];

            actual = GetBounds(vals);

            % range = 8, sf default 0.125 -> newScale = 1
            % newLims = [min-1, max+1] = [1, 11]
            testCase.verifyEqual(actual, [1, 11]);
        end

        function testGetBoundsTwoDistinctValuesCustomSF(testCase)
            % Verify bounds for two distinct values with custom scale factor.
            vals = [0, 4];
            sf = 0.5;

            actual = GetBounds(vals, sf);

            % range = 4, newScale = 4*0.5 = 2 -> [min-2, max+2] = [-2,6]
            testCase.verifyEqual(actual, [-2, 6]);
        end

        function testGetBoundsSingleValueUsesDefaultInterval(testCase)
            % When all input values are identical, function should return
            % an interval of length 2 centered on that value (using newScale=1).
            vals = 3.7 * ones(1,5);

            actual = GetBounds(vals);

            % newScale = 1 -> [3.7-1, 3.7+1]
            expected = [2.7, 4.7];
            testCase.verifyEqual(actual, expected);
        end

        function testGetBoundsSingleValueIgnoresProvidedSF(testCase)
            % Even if a scale factor is provided, identical input values
            % should produce newScale == 1 (per implementation).
            vals = 0;
            sf = 100; %#ok<NASGU>

            actual = GetBounds(vals, sf);

            expected = [-1, 1];
            testCase.verifyEqual(actual, expected);
        end

        function testGetBoundsArrayWithNegativeValues(testCase)
            % Verify behavior with negative and positive values.
            vals = [-5, -1, 0, 2];
            sf = 0.25;

            actual = GetBounds(vals, sf);

            % min = -5, max = 2, range = 7, newScale = 7*0.25 = 1.75
            expected = [-6.75, 3.75];
            testCase.verifyEqual(actual, expected);
        end

        function testGetBoundsMustBeRealValidation(testCase)
            % Verify that providing complex input triggers validation error.
            vals = [1+1i, 2];
            testCase.verifyError(@() GetBounds(vals), 'MATLAB:validators:mustBeReal');
        end

        function testGetBoundsMustBePositiveValidation(testCase)
            % Verify that non-positive scale factor triggers validation error.
            vals = [0,1];
            testCase.verifyError(@() GetBounds(vals, 0), 'MATLAB:validators:mustBePositive');
        end

        function testLocateArrowTwoDistinctPointsHorizontal(testCase)
            % Verify arrow positions for two distinct horizontal points
            xVals = [1 3];
            yVals = [2 2];

            ax = axes('Units','normalized','Position',[0.1 0.2 0.7 0.6]);
            ax.XLim = [0 4];
            ax.YLim = [0 4];

            [axVals, ayVals] = LocateArrow(xVals, yVals, ax);

            % Expected: xmi = mean([1 3]) - 0.01*(3-1) = 2 - 0.02 = 1.98
            %           xmf = xmi + 0.02*(3-1) = 1.98 + 0.04 = 2.02
            expected_xmi = 1.98;
            expected_xmf = 2.02;

            % Normalize to axes position: ((x - XLim(1))/(XLim(2)-XLim(1))) * width + left
            expected_axVals = ([expected_xmi expected_xmf] - ax.XLim(1)) ./ (ax.XLim(2)-ax.XLim(1)) * ax.Position(3) + ax.Position(1);

            % For y both equal, ymi = yi = 2, ymf = yf = 2
            expected_ayVals = ([2 2] - ax.YLim(1)) ./ (ax.YLim(2)-ax.YLim(1)) * ax.Position(4) + ax.Position(2);

            testCase.verifyEqual(axVals, expected_axVals, 'AbsTol', 1e-12);
            testCase.verifyEqual(ayVals, expected_ayVals, 'AbsTol', 1e-12);

            close(get(ax,'Parent')); %#ok<HCLOSE>
        end

        function testLocateArrowTwoDistinctPointsVertical(testCase)
            % Verify arrow positions for two distinct vertical points
            xVals = [5 5];
            yVals = [0 10];

            ax = axes('Units','normalized','Position',[0.05 0.05 0.9 0.9]);
            ax.XLim = [0 10];
            ax.YLim = [0 10];

            [axVals, ayVals] = LocateArrow(xVals, yVals, ax);

            % For x both equal, xmi = xi = 5, xmf = xf = 5
            expected_axVals = ([5 5] - ax.XLim(1)) ./ (ax.XLim(2)-ax.XLim(1)) * ax.Position(3) + ax.Position(1);

            % ymi = mean([0 10]) - 0.01*(10-0) = 5 - 0.1 = 4.9
            % ymf = ymi + 0.02*(10-0) = 4.9 + 0.2 = 5.1
            expected_ymi = 4.9;
            expected_ymf = 5.1;
            expected_ayVals = ([expected_ymi expected_ymf] - ax.YLim(1)) ./ (ax.YLim(2)-ax.YLim(1)) * ax.Position(4) + ax.Position(2);

            testCase.verifyEqual(axVals, expected_axVals, 'AbsTol', 1e-12);
            testCase.verifyEqual(ayVals, expected_ayVals, 'AbsTol', 1e-12);

            close(get(ax,'Parent'));
        end

        function testLocateArrowMultiplePointsEvenCount(testCase)
            % Verify selection of middle pair for even number of points
            xVals = [0 1 2 3];
            yVals = [0 1 2 3];

            ax = axes('Units','normalized','Position',[0 0 1 1]);
            ax.XLim = [0 3];
            ax.YLim = [0 3];

            [axVals, ayVals] = LocateArrow(xVals, yVals, ax);

            % For ell=4, ell/2 = 2 -> indices 2 and 3 -> xmi=1, xmf=2
            expected_axVals = ([1 2] - ax.XLim(1)) ./ (ax.XLim(2)-ax.XLim(1)) * ax.Position(3) + ax.Position(1);
            expected_ayVals = ([1 2] - ax.YLim(1)) ./ (ax.YLim(2)-ax.YLim(1)) * ax.Position(4) + ax.Position(2);

            testCase.verifyEqual(axVals, expected_axVals, 'AbsTol', 1e-12);
            testCase.verifyEqual(ayVals, expected_ayVals, 'AbsTol', 1e-12);

            close(get(ax,'Parent'));
        end

        function testLocateArrowMultiplePointsOddCountFallback(testCase)
            % Verify fallback branch for odd number of points (uses catch branch logic)
            xVals = [0 1 2];
            yVals = [0 1 2];

            ax = axes('Units','normalized','Position',[0.2 0.1 0.5 0.7]);
            ax.XLim = [0 2];
            ax.YLim = [0 2];

            [axVals, ayVals] = LocateArrow(xVals, yVals, ax);

            % For ell=3, the try block indexing ell/2 would error; fallback uses
            % xmi = xVals((ell-1)/2) = xVals(1) = 0
            % xmf = xVals((ell+1)/2) = xVals(2) = 1
            expected_axVals = ([0 1] - ax.XLim(1)) ./ (ax.XLim(2)-ax.XLim(1)) * ax.Position(3) + ax.Position(1);
            expected_ayVals = ([0 1] - ax.YLim(1)) ./ (ax.YLim(2)-ax.YLim(1)) * ax.Position(4) + ax.Position(2);

            testCase.verifyEqual(axVals, expected_axVals, 'AbsTol', 1e-12);
            testCase.verifyEqual(ayVals, expected_ayVals, 'AbsTol', 1e-12);

            close(get(ax,'Parent'));
        end

        function testLocateArrowOnCurveTwoPointCellsReturnsEndpoints(testCase)
            % Test that when each cell contains two coordinates, the
            % function returns the first as pt1 and second as pt2.

            % Prepare input: two-dimensional point with two entries per cell

            [pt1, pt2] = LocateArrowOnCurve([1 4],[2 5]);

            testCase.verifyEqual(pt1, [1, 2]);
            testCase.verifyEqual(pt2, [4, 5]);
        end

        function testLocateArrowOnCurveEvenNumberOfElementsReturnsMiddlePair(testCase)
            % Test that when each cell has an even number of elements,
            % the function returns the middle two as pt1 and pt2.

            % Prepare input: 1x6 vectors in each cell
            x = [0, 1, 2, 3, 4, 5];
            y = [10,11,12,13,14,15];

            % For NumElements = 6, NumElements/2 = 3 -> expect indices 3 and 4
            [pt1, pt2] = LocateArrowOnCurve(x,y);

            expectedPt1 = [ x(3), y(3) ];
            expectedPt2 = [ x(4), y(4) ];

            testCase.verifyEqual(pt1, expectedPt1);
            testCase.verifyEqual(pt2, expectedPt2);
        end

        function testLocateArrowOnCurveOddNumberOfElementsUsesSlopeAdjustment(testCase)
            % Test that when each cell has an odd number of elements,
            % the function computes a midpoint and adjusts by 0.1*slope.

            % Prepare input: odd-length sequences
            x = [0, 1, 2, 3, 4];    % Mid index = 3 -> mid = 2
            y = [10,11,12,13,14];   % slope = next - prev = (3rd+1) - (3rd-1) ...

            MidIdx = ceil(numel(x)/2); % 3
            midPoint = [ x(MidIdx), y(MidIdx) ]; % [2,12]
            slope = [ x(MidIdx+1) - x(MidIdx-1), y(MidIdx+1) - y(MidIdx-1) ]; % [2,2]

            expectedPt1 = midPoint - 0.1 * slope;
            expectedPt2 = midPoint + 0.1 * slope;

            [pt1, pt2] = LocateArrowOnCurve(x,y);

            testCase.verifyEqual(pt1, expectedPt1);
            testCase.verifyEqual(pt2, expectedPt2);
        end

        function testLocateArrowOnCurveHigherDimensionTwoPointCells(testCase)
            % Test behavior for 3D data when each cell contains two values.

            [pt1, pt2] = LocateArrowOnCurve([1, 9], [2, 8], [3, 7]);

            testCase.verifyEqual(pt1, [1, 2, 3]);
            testCase.verifyEqual(pt2, [9, 8, 7]);
        end

        function testLocateArrowOnCurveEvenNumberMultipleDimensions(testCase)
            % Test even-length vectors for 3D case selecting middle pair.

            x = [0,1,2,3];
            y = [10,11,12,13];
            z = [20,21,22,23];

            % NumElements=4 -> middle indices 2 and 3
            [pt1, pt2] = LocateArrowOnCurve(x,y,z);

            expectedPt1 = [ x(2), y(2), z(2) ];
            expectedPt2 = [ x(3), y(3), z(3) ];

            testCase.verifyEqual(pt1, expectedPt1);
            testCase.verifyEqual(pt2, expectedPt2);
        end
    end % methods

end % classdef