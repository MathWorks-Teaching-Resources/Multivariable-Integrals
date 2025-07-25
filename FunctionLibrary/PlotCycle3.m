function ax = PlotCycle3(Units1,Units2,Units3,Values1,Values2,Values3,opts)
    % PLOTCYCLE3 Function to plot a 3D cycle with specified units and values
    %
    % Input Arguments:
    %     Units1 - label for the x-axis
    %     Units2 - label for the y-axis
    %     Units3 - label for the z-axis
    %     Values1 - values for the x-axis, can be repeated
    %     Values2 - values for the y-axis, can be repeated
    %     Values3 - values for the z-axis, can be repeated
    %     opts - options for the plot including title, axis, limits, etc.
    %
    % Output Arguments:
    %     ax - handle to the axes of the plot

    arguments
        Units1 (1,1) string 
        Units2 (1,1) string
        Units3 (1,1) string
    end
    arguments(Repeating)
        Values1 (1,:) {mustBeReal,mustBeNumeric}
        Values2 (1,:) {mustBeReal,mustBeNumeric}
        Values3 (1,:) {mustBeReal,mustBeNumeric}
    end
    arguments
         opts.TitleStr (1,1) string = "Curve"
         opts.Axis = gca
         opts.ResetLimits (1,1) logical = true
         opts.FillRegion (1,1) logical = true
         opts.SeriesIndex = 1
         opts.LineWidth = 1
    end

    ax = opts.Axis; % Assign the axis from options
    allVals1 = [Values1{:,:}]; % Concatenate all x-values
    allVals2 = [Values2{:,:}]; % Concatenate all y-values
    allVals3 = [Values3{:,:}]; % Concatenate all z-values
    xlabel(Units1) % Set x-axis label
    ylabel(Units2) % Set y-axis label
    zlabel(Units3) % Set z-axis label
    title(opts.TitleStr,Interpreter="latex") % Set plot title with LaTeX interpreter

    if opts.ResetLimits
        % Reset axis limits based on the data
        SetLabels(allVals1,"x",true)
        SetLabels(allVals2,"y",true)
        SetLabels(allVals3,"z",true)
        xlim(GetBounds(allVals1)) % Set x-axis limits based on the range of the x values
        ylim(GetBounds(allVals2)) % Set y-axis limits based on the range of the y values
        zlim(GetBounds(allVals3)) % Set z-axis limits based on the range of the z values
    end

    ax.PositionConstraint = "innerposition"; % Set position constraint for the axes to try to ensure the title is visible
    pvLinePlot(ax,Values1,Values2,Values3,opts.SeriesIndex,opts.LineWidth); % Call helper function to plot lines

    if opts.FillRegion
        % Fill the region if the first and last points are the same
        if allVals1(1)==allVals1(end) && allVals2(1)==allVals2(end) && allVals3(1)==allVals3(end)
            fill3(allVals1,allVals2,allVals3,[0.9 0.9 0.9],"EdgeColor","none") % Fill the 3D area
        end
    end

    ax.Children = flipud(ax.Children); % Flip the order of children for proper layering
end

function pvLinePlot(ax,Values1,Values2,Values3,SeriesColor,Width)
    % PVLINEPLOT Helper function to plot the lines in the 3D space
    %
    % Input Arguments:
    %     ax - handle to the axes
    %     Values1 - x-values for the plot
    %     Values2 - y-values for the plot
    %     Values3 - z-values for the plot
    %     SeriesColor - color for the series
    %     Width - line width for the plot

    arguments
        ax 
        Values1
        Values2
        Values3
        SeriesColor
        Width
    end

    % Reshape values for plotting
    z = reshape([Values1;Values2;Values3],1,[]);
    ax.NextPlot = "add"; % Set the next plot to add to the current axes
    p = plot3(ax,z{:},SeriesIndex=SeriesColor,LineWidth=Width); % Plot the 3D line
    series1Color = p(1).Color; % Get the color of the first series

    for k = 2:numel(p)
        p(k).Color = series1Color; % Set the color for all segments to match the first
    end

    % Uncomment to add arrows to the plot
    % [axVals,ayVals,azVals] = cellfun(@(V1,V2,V3) LocateArrow3(ax,V1,V2,V3),Values1,Values2,Values3,'UniformOutput',false);
    % cellfun(@(x,y,z) annotation("arrow",x,y,z,"Color",series1Color),axVals,ayVals,azVals)

    % Define endpoints for the scatter plot
    endPts = [Values1{1}(1) Values2{1}(1) Values3{1}(1); Values1{end}(end) Values2{end}(end) Values3{end}(end)];
    ax.NextPlot = "add"; % Set the next plot to add to the current axes
    scatter3(ax,endPts(:,1),endPts(:,2),endPts(:,3),50,"Filled",MarkerFaceColor=series1Color) % Scatter plot for endpoints

    for NumSegment = 1:numel(Values1)
        % Locate and add arrows on the curve
        [pt1,pt2] = LocateArrowOnCurve(Values1{NumSegment},Values2{NumSegment},Values3{NumSegment});
        AddArrow(ax,pt1,pt2,Color=series1Color,SeriesIndex=SeriesColor) % Add arrows to the plot
    end    
end

%[appendix]{"version":"1.0"}
%---
