%[text] # Locate the center and orientation of a line with respect to a figure
%[text] `[axVals,ayVals] = LocateArrowOnCurve(Vals)` computes the center and orientation of a line defined by the points `(xVals(i),yVals(i))`. These values are scaled according to the relationship between the axis and the corresponding figure and returned as the `(x,y)` coordinates for the tail (`pt1`) and head (`pt2`) of the arrow. 
function [pt1,pt2] = LocateArrowOnCurve(Vals)
arguments (Repeating)
    Vals 
end
    % LOCATEARROWONCURVE Function to locate points for an arrow on a curve
    %
    % Input Arguments:
    %     Vals - A cell array containing coordinates for the curve
    %
    % Output Arguments:
    %     pt1 - Starting points of the arrows
    %     pt2 - Ending points of the arrows

    MyDim = numel(Vals); % Determine the number of dimensions
    pt1 = zeros(1,MyDim); % Preallocate array for starting points
    pt2 = zeros(1,MyDim); % Preallocate array for ending points
    
    if numel(Vals{1}) == 2 % Check if each element has 2 coordinates
        for dim = 1:MyDim
            % Return [(x1,y1), (x2,y2)]
            pt1(dim) = Vals{dim}(1); 
            pt2(dim) = Vals{dim}(2); 
        end
    else
        NumElements = numel(Vals{1}); % Get the number of elements in the first cell
        if mod(NumElements,2) == 0 % Check if the number of elements is even
            for dim = 1:MyDim
                pt1(dim) = Vals{dim}(NumElements/2); % Assign middle point for pt1
                pt2(dim) = Vals{dim}(NumElements/2+1); % Assign next point for pt2
            end
        else
            MidIdx = ceil(NumElements/2); % Calculate the index of the middle element
            MidPoint = Vals{:}(MidIdx); % Get the middle point
            Slope = Vals{:}(MidIdx+1)-Vals{:}(MidIdx-1); % Calculate the slope
            
            for dim = 1:MyDim
                pt1(dim) = MidPoint(dim)-0.1*Slope(dim); % Adjust pt1 based on slope
                pt2(dim) = MidPoint(dim)+0.1*Slope(dim); % Adjust pt2 based on slope
            end
        end
    end
end

%[appendix]{"version":"1.0"}
%---
