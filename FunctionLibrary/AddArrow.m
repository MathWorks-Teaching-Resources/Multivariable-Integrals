function AddArrow(ax,pt1,pt2,opts)
    % ADDARROW Function to draw an arrow on a specified axes
    %
    % Input Arguments:
    %     ax      - Axes handle where the arrow will be drawn
    %     pt1     - Starting point of the arrow
    %     pt2     - Ending point of the arrow
    %   Name=Value optional arguments
    %     SeriesIndex - Index for the series (default is 8)
    %     Color       - Color of the arrow (default is red)
    %     Line        - Boolean to indicate if line should be drawn (default is true)

    arguments
        ax 
        pt1 
        pt2 
        opts.SeriesIndex (1,1) double {mustBeInteger,mustBePositive} = 8
        opts.Color = "r"
        opts.Line (1,1) logical = true
    end
    
    % Determine the dimensionality of the points
    dim = length(pt1);
    % Ensure both points have the same length
    assert(length(pt1)==length(pt2))
    
    % Calculate the scale based on the axes limits
    xScale = range(ax.XLim);
    yScale = range(ax.YLim);
    scale = [xScale yScale];
    
    % If in 3D, include the z-axis scale
    if dim == 3
        zScale = range(ax.ZLim);
        scale = [scale zScale];
    end
    
    % Calculate the slope vector between the two points
    slope = pt2-pt1;
    NormedSlope = norm(slope./scale);
    
    % Adjust points based on the normalized slope
    if NormedSlope < 0.75
        ExtraDistance = 0.75/NormedSlope*slope;
        pt1 = pt1-(ExtraDistance-slope)/2;
        pt2 = pt2+(ExtraDistance-slope)/2;
        slope = ExtraDistance;
    elseif NormedSlope > 0.9
        NewDistance = 0.9/NormedSlope*slope;
        pt1 = pt1 + (slope-NewDistance)/2;
        pt2 = pt2 - (slope-NewDistance)/2;
        slope = NewDistance;
    end
    
    % Determine the tip, tail, and indent of the arrow based on options
    if opts.Line
        tip = pt1 + 0.55*slope;
        tail = pt1 + 0.45*slope;
        indent = pt1 + 0.48*slope;
    else
        tip = pt2;
        tail = pt1;
        indent = pt1 + 0.2*(tip-tail);
    end
    
    % Calculate the perpendicular direction for the arrowhead
    if dim == 3
        % perpdir = [0 slope(3) -slope(2)];
        perpdir = cross(slope,[-1 -1 1]);
    elseif dim == 2
        perpdir = [-slope(2) slope(1)];
    else
        error("Unexpected dimension: " + dim)
    end
    
    % Normalize the perpendicular direction
    perpdir = perpdir/norm(perpdir);
    
    % Calculate the positions for the arrowhead
    tail1 = tail + 0.03*norm(slope)*perpdir;
    tail2 = tail - 0.03*norm(slope)*perpdir;
    arrowhead = [tail1; tip; tail2; indent; tail1];
    
    % Draw the arrow in 3D or 2D based on the dimensionality
    if dim == 3
        fill3(ax,arrowhead(:,1), arrowhead(:,2), arrowhead(:,3),opts.Color,SeriesIndex=opts.SeriesIndex)
    else
        fill(ax,arrowhead(:,1), arrowhead(:,2),opts.Color,SeriesIndex=opts.SeriesIndex)
    end
end

%[appendix]{"version":"1.0"}
%---
