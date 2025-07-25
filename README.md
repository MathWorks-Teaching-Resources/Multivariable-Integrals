
<a id="T_DEF03274"></a>

# <span style="color:rgb(213,80,0)">Multivariable Calculus: Integrals</span>
<a id="H_053613DF"></a>


[![View on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/XXXXX-PROJECTNAME) or [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Multivariable-Integrals&project=Integrals.prj&file=README.mlx)

[![MATLAB Versions Tested](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2FMathWorks-Teaching-Resources%2FMultivariable-Integrals%2Frelease%2FImages%2FTestedWith.json)](https://MathWorks-Teaching-Resources.github.io/Multivariable-Integrals)

**Curriculum Module**

_Created with R2025a. Compatible with R2025a and later releases._

# Information

This curriculum module contains interactive [MATLAB® live scripts](https://www.mathworks.com/products/matlab/live-editor.html) that teach and apply standard concepts in integral multivariable calculus.

<a id="H_F00D98E4"></a>

## Background

You can use these live scripts as demonstrations in lectures, class activities, or interactive assignments outside class. The first script released in this collection is It also includes examples of computing work and area. 


The instructions inside the live scripts will guide you through the exercises and activities. Get started with each live script by running it one section at a time. To stop running the script or a section midway (for example, when an animation is in progress), use the <img src="Images/EndIcon.png" width="19" alt="EndIcon.png"> Stop button in the **RUN** section of the **Live Editor** tab in the MATLAB Toolstrip.

## Contact Us

Solutions are available upon instructor request. Contact the [MathWorks teaching resources team](mailto:onlineteaching@mathworks.com) if you would like to request solutions, provide feedback, or if you have a question.

<a id="H_30BC7141"></a>

## Prerequisites

This module assumes knowledge of single variable calculus and vectors, including vector fields, as covered in the courseware listed here:

| **Courseware Module** <br>  | **Sample content** <br>  | **Available on:** <br>   |
| :-- | :-- | :-- |
| [**Vector Arithmetic**](https://www.mathworks.com/matlabcentral/fileexchange/94555-vector-arithmetic) <br>  | <img src="Images/image_1.png" width="171" alt="image_1.png"> <br>  | [<img src="Images/OpenInFX.png" width="91" alt="OpenInFX.png">](https://www.mathworks.com/matlabcentral/fileexchange/94555-vector-arithmetic)  <br> [<img src="Images/OpenInMO.png" width="136" alt="OpenInMO.png">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Vector-Arithmetic&project=VectorArithmetic.prj&file=README.mlx) <br> [GitHub](https://github.com/MathWorks-Teaching-Resources/Vector-Arithmetic)  <br>   |
| [**Multivariable: Space and Functions**](https://www.mathworks.com/matlabcentral/fileexchange/180356-multivariable-space-and-functions) <br>  | <img src="Images/image_4.png" width="159" alt="image_4.png"> <br>  | [<img src="Images/OpenInFX.png" width="91" alt="OpenInFX.png">](https://www.mathworks.com/matlabcentral/fileexchange/180356-multivariable-space-and-functions) <br> [<img src="Images/OpenInMO.png" width="136" alt="OpenInMO.png">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Multivariable-Space-and-Functions&project=Space.prj&file=README.mlx) <br> [GitHub](https://github.com/MathWorks-Teaching-Resources/Multivariable-Space-and-Functions) <br>   |
| [**Calculus: Integrals**](https://www.mathworks.com/matlabcentral/fileexchange/105740-calculus-integrals) <br>  | <img src="Images/image_7.png" width="171" alt="image_7.png"> <br>  | [<img src="Images/OpenInFX.png" width="91" alt="OpenInFX.png">](https://www.mathworks.com/matlabcentral/fileexchange/105740-calculus-integrals) <br> [<img src="Images/OpenInMO.png" width="136" alt="OpenInMO.png">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Calculus-Integrals&project=Integrals.prj&file=README.mlx)  <br> [GitHub](https://github.com/MathWorks-Teaching-Resources/Calculus-Integrals)  <br>   |

<a id="H_330E72C3"></a>

## Getting Started
### Accessing the Module
### **On MATLAB Online:**

Use the [<img src="Images/OpenInMO.png" width="136" alt="OpenInMO.png">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Multivariable-Integrals&project=Integrals.prj) link to download the module. You will be prompted to log in or create a MathWorks account. The project will be loaded, and you will see an app with several navigation options to get you started.

### **On Desktop:**

Download or clone this repository. Open MATLAB, navigate to the folder containing these scripts and double\-click on [Integrals.prj](<matlab: openProject("Integrals.prj")>). It will add the appropriate files to your MATLAB path and open an app that asks you where you would like to start. 


Ensure you have all the required products ([listed below](#H_E850B4FF)) installed. If you need to include a product, add it using the Add\-On Explorer. To install an add\-on, go to the **Home** tab and select  <img src="Images/AddOnsIcon.png" width="16" alt="AddOnsIcon.png"> **Add-Ons** > **Get Add-Ons**. 

<a id="H_E850B4FF"></a>

## Products

MATLAB® and Symbolic Math Toolbox™ are used throughout, and Statistics and Machine Learning Toolbox™ is used in `AddArrow.m`. 

<a id="H_E8C62B23"></a>

# Scripts
## **MultipleIntegrals.m** (planned)
||||
| :-- | :-- | :-- |
| <img src="Images/IrregularMeasurement.png" width="171" alt="IrregularMeasurement.png"> <br>  | **In this script, students will...** <br> $\bullet$ Compute and visualize double and triple integrals <br> $\bullet$ Use change of variables to simplify and evaluate multiple integrals <br>  | **Academic disciplines** <br> $\bullet$ Physics <br> $\bullet$ Mathematics <br>   |

## [**LineIntegrals.m**](Scripts/LineIntegrals.m) 
||||
| :-- | :-- | :-- |
| <img src="Images/image_13.png" width="171" alt="image_13.png"> <br>  | **In this script, students will...** <br> $\bullet$ Compute line integrals given a path and vector field <br> $\bullet$ Identify conservative vector fields and use this to compute line integrals <br> $\bullet$ Apply Green's Theorem to compute area <br>  | **Academic disciplines** <br> $\bullet$ Electrical Engineering <br> $\bullet$ Physics <br> $\bullet$ Mathematics <br>   |

## **SurfaceIntegrals.m** (planned)
||||
| :-- | :-- | :-- |
| <img src="Images/image_14.png" width="171" alt="image_14.png"> <br>  | **In this script, students will...** <br> $\bullet$ Explore the concepts of control surfaces and control volumes <br> $\bullet$ Use the divergence theorem <br>  | **Academic disciplines** <br> $\bullet$ Electrical Engineering <br> $\bullet$ Physics <br> $\bullet$ Mathematics <br>   |

<a id="H_F61733D7"></a>

# License

The license for this module is available in the [LICENSE.md](https://github.com/MathWorks-Teaching-Resources/Multivariable-Integrals/blob/release/LICENSE.md).

# Related Courseware Modules
| **Courseware Module** <br>  | **Sample Content** <br>  | **Available on:** <br>   |
| :-- | :-- | :-- |
| [**Applied Partial Differential Equations**](https://www.mathworks.com/matlabcentral/fileexchange/172650-applied-partial-differential-equations) <br>  | <img src="Images/image_15.png" width="171" alt="image_15.png"> <br>  | [<img src="Images/OpenInFX.png" width="91" alt="OpenInFX.png">](https://www.mathworks.com/matlabcentral/fileexchange/172650-applied-partial-differential-equations) <br> [<img src="Images/OpenInMO.png" width="136" alt="OpenInMO.png">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Applied-PDEs&project=AppliedPDEs.prj&file=README.mlx) <br> [GitHub](https://github.com/MathWorks-Teaching-Resources/Applied-PDEs) <br>   |
| [**Multivariable: Space and Functions**](https://www.mathworks.com/matlabcentral/fileexchange/180356-multivariable-space-and-functions) <br>  | <img src="Images/image_18.png" width="159" alt="image_18.png"> <br>  | [<img src="Images/OpenInFX.png" width="91" alt="OpenInFX.png">](https://www.mathworks.com/matlabcentral/fileexchange/180356-multivariable-space-and-functions) <br> [<img src="Images/OpenInMO.png" width="136" alt="OpenInMO.png">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Multivariable-Space-and-Functions&project=Space.prj&file=README.mlx) <br> [GitHub](https://github.com/MathWorks-Teaching-Resources/Multivariable-Space-and-Functions) <br>   |


Or feel free to explore our other [modular courseware content](https://www.mathworks.com/matlabcentral/profile/authors/37969341).

# Educator Resources
-  [Educator Page](https://www.mathworks.com/academia/educators.html) 
<a id="H_0FA5DA18"></a>

# Contribute 

Looking for more? Find an issue? Have a suggestion? Please contact the [MathWorks teaching resources team](mailto:%20onlineteaching@mathworks.com). If you want to contribute directly to this project, you can find information about how to do so in the [CONTRIBUTING.md](https://github.com/MathWorks-Teaching-Resources/Multivariable-Integrals/blob/release/CONTRIBUTING.md) page on GitHub.


*©* Copyright 2025 The MathWorks, Inc


