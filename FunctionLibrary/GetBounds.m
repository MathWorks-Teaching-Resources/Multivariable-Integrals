%[text] # Identify reasonable plotting bounds
%[text] `newLims = GetBounds(inValues,sf)` will return plotting bounds where the minimum and maximum center the `inValues` with scale factor `sf` on each side. If `inValues` consists of a single value then `newLims` will return an interval of length 2 centered on `inValues`. 
function newLims = GetBounds(inValues,sf)
    % GETBOUNDS Function to calculate new bounds based on input values and scale factor
    %
    % Input Arguments:
    %     inValues - array of real numbers for which bounds are calculated
    %     sf - scale factor, must be positive (default is 0.125)
    %
    % Output Arguments:
    %     newLims - array containing the new lower and upper limits

    arguments
        inValues double {mustBeReal}
        sf (1,1) double {mustBeReal,mustBePositive} = 0.125
    end
    % Calculate the maximum and minimum values from the input
    maxVal = max(inValues);
    minVal = min(inValues);
    % Determine the new scale based on the range of input values
    if maxVal > minVal
        newScale = (maxVal-minVal)*sf;
    else
        % Do not collapse the scale to a single value if minVal==maxVal
        newScale = 1; % Default scale if all values are the same
    end
    % Define the new limits based on the calculated scale
    newLims = [minVal-newScale, maxVal+newScale];
end

%[appendix]{"version":"1.0"}
%---
