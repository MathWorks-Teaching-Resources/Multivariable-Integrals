classdef FunctionTests < matlab.unittest.TestCase

    % https://www.mathworks.com/help/matlab/matlab_prog/use-parameters-in-class-based-tests.html

    methods(Test)    

        function testPlotWithValidNonDefaultInputs(testCase)
            % Test with valid inputs
            Units1 = "X-axis";
            Units2 = "Y-axis";
            Units3 = "Z-axis";
            MyTitle = "Test Plot";
            SerIndex = 4;
            Alpha = linspace(0,2*pi,100);
            
            fig = figure;
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

        function testPlotWithDefaultInputs(testCase)
            % Test with valid inputs
            Units1 = "X";
            Units2 = "Y";
            Units3 = "Z";
            Alpha = linspace(0,2*pi,100);
            fig = figure;
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

    end % methods

end % classdef