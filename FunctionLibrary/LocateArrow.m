%[text] # Locate the center and orientation of a line with respect to a figure
%[text] `[axVals,ayVals] = LocateArrow(xVals,yVals,ax)` computes the center and orientation of a line defined by the points `(xVals(i),yVals(i))`. These values are scaled according to the relationship between the axis and the corresponding figure and returned as the `(x,y)` coordinates `(axVals(1),ayVals(1))` and `(axVals(2),ayVals(2))`. 
function [axVals,ayVals] = LocateArrow(xVals,yVals,ax)
    % LOCATEARROW Function to calculate arrow positions based on input values
    %
    % Input Arguments:
    %     xVals - x-coordinates of the line that needs an arrow
    %     yVals - y-coordinates of the line that needs an arrow
    %     ax - axes object containing the current limits
    %
    % Output Arguments:
    %     axVals - Calculated x-coordinates for the arrow
    %     ayVals - Calculated y-coordinates for the arrow

    % Get the current position and limits of the axes
    scVals = ax.Position;
    newXLims = ax.XLim;
    newYLims = ax.YLim;
    ell = numel(xVals); % Number of elements in xVals

    if ell == 2
        % If there are exactly two points, calculate the arrow endpoints
        xi = xVals(1);
        xf = xVals(2);
        yi = yVals(1);
        yf = yVals(2);
        
        if xi ~= xf
            % Calculate x limits for the arrow
            xmi = mean(xVals)-0.01*(xf-xi);
            xmf = xmi+0.02*(xf-xi);
        else
            % If x values are the same, use the same value for both limits
            xmi = xi;
            xmf = xf;
        end
        
        if yi ~= yf
            % Calculate y limits for the arrow
            ymi = mean(yVals)-0.01*(yf-yi);
            ymf = ymi+0.02*(yf-yi);
        else
            % If y values are the same, use the same value for both limits
            ymi = yi;
            ymf = yf;
        end
    else
        % If there are more than two points, calculate limits based on the middle points
        try
            xmi = xVals(ell/2);
            ymi = yVals(ell/2);
            xmf = xVals(ell/2+1);
            ymf = yVals(ell/2+1);
        catch
            % Fallback in case of an odd number of elements
            xmi = xVals((ell-1)/2);
            ymi = yVals((ell-1)/2);
            xmf = xVals((ell+1)/2);
            ymf = yVals((ell+1)/2);
        end
    end

    % Normalize the arrow positions based on the axes limits
    axVals = ([xmi xmf]-newXLims(1))./(newXLims(2)-newXLims(1))*(scVals(3))+scVals(1);
    ayVals = ([ymi ymf]-newYLims(1))./(newYLims(2)-newYLims(1))*(scVals(4))+scVals(2);
end

%[appendix]{"version":"1.0"}
%---
