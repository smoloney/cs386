%% Toy example: Create step edge and apply first and second order derivatives
a = [1:0.05:1.2   2:.05:2.2]; %Generate a 1-dimensional step edge with values between 1 and 2.2

f1 = [-1 0 1]; %First-order derivative
f2 = [1 -2 1]; %Second order derivative

a_fod = imfilter(a, f1, 'symmetric');
%a_sod = imfilter(a, f2, 'symmetric');
 a_sod = imfilter(a_fod, f1, 'symmetric');

x = 1:numel(a);
figure, plot(x, a, 'r-*', x, a_fod, 'b--o',x, a_sod, 'k-.v')
legend('1-D data','First order derivative', 'Second order derivative', 'location', 'Best');

%% Toy example: Create ramp edge and apply first & second order derivatives

%TODO 1: Discuss with your partner the difference between a step edge and
%ramp edge and how zero crossings manifest in each of them

e = [1:0.1:1.5  2.5:5.5  6.5:.1:7]; %Generate a 1-dimensional ramp edge with values between 1 and 7

g = normpdf(-1:0.5:1, 0, 0.25); %Generate a gaussian of sigma = 1. 
g = g/sum(g); %Normalize it such that sum of elements of the filter = 1

a = conv(e, g, 'valid'); %Great example for using convolution to smooth e 

f1 = [-1 0 1]; %First-order derivative
f2 = [1 -2 1]; %Second order derivative

a_fod = imfilter(a, f1, 'symmetric');
a_sod = imfilter(a, f2, 'symmetric');
% a_sod = imfilter(a_fod, f1, 'symmetric');

x = 1:numel(a);
figure, plot(x, a, 'r-*', x, a_fod, 'b--o',x, a_sod, 'k-.v')
legend('1-D data','First order derivative', 'Second order derivative', 'location', 'Best');


%% Load Image
s = imread('stairs.png');
% s = imread('westconcordorthophoto.png');
figure, imshow(s)

%% Edge detection: Prewitt
s = im2double(s); % no automatic trunctions
px = [-1 0 1;-1 0 1;-1 0 1]; %Filter will respond to changes in x-direction
py = px';  %Filter will respond to changes in y-direction

sx = imfilter(s, px, 'replicate'); %sx = im2double(imfilter(s, px, 'replicate); loses data because truncated
sy = imfilter(s, py, 'replicate');

%TODO 2: What is the range of sx and sy? What values will it be displaying?
figure, imshow(sx) 
figure, imshow(sy)

%TODO 3: Fix the Error that's reported when you run the line below
edge_p = sqrt(sx.^2 + sy.^2); % error originally occurs here becaue trying to perform sqrt on uint.
figure, imshow(edge_p), impixelinfo


%% Edge detection: laplacian
f = fspecial('laplacian', 0);
%Apply it to  image
s_lap = imfilter(double(s), f); %Let us convert to double so that values are not clipped when filtering

%s_lap is of type double and by default, imshow will only show values between 0 and 1. 
figure, imshow(s_lap); 
title('Laplacian wont look good!');
	
%Truncate values to lie between 0 to 255 
figure, imshow(s_lap, [0 255]); 
title('Good looking Laplacian');

%TODO 4: How can you show the entire range of s_lap using imshow? Hint: help imshow
figure, imshow(s_lap, [] ); 
title('Entire range of Laplacian');
	
figure, imshow(abs(s_lap), [0 255]); %Why is this brighter?
title('Absolute of Laplacian');

%Better to show zero crossings because it better identifies the position of edge
%Compute zero crossings directly from original image s using matlab function "edge"
[zc, thresh] = edge(s, 'zerocross', [], f);
figure, imshow(zc)
title('Zero crossings of Laplacian');
fprintf('Chosen threshold (zero crossing of Laplacian) = %f\n', thresh);


%% Edge detection: laplacian of gaussian (LoG) 
%(Marr-hildreth method )

%1.	Smooth the image with a Gaussian filter
%2.	Convolve the result with a Laplacian
%3.	Find the zero crossings 

%Combining steps 1 and 2
% f = fspecial('log', 13, 2);
%f = fspecial('log', 7, 1);
 f = fspecial('log', 19, 3);
s_lap = imfilter(s, f);
figure, imshow(s_lap, []); % To transform the entire range of values to the visible range
title('Laplacian of Gaussian');

s_lapd = imfilter(double(s), f);
figure, imshow(abs(s_lapd), []); % To normalize the range of values to the visible range
title('Laplacian of Gaussian (Absolute)');

%The filter f can be used on original image s directly to find the zero
%crossings
[zc, thresh] = edge(s, 'zerocross', [], f); %Gives same output as: edge(s, 'log')
figure, imshow(zc)
title('Zero crossings of LoG');
fprintf('Chosen threshold (zero crossing of LoG) = %f\n', thresh);

%TODO 5: Change the log filter (f) above by modifying the sigma. What is the effect of increasing sigma of LoG filter?

%% Difference between gaussian, laplacian and LoG filters


filter_gaussian = fspecial('gaussian', 25, 4);
filter_laplacian = fspecial('laplacian', 0);
filter_log = fspecial('log', 25, 4);

figure, surf(1:25, 1:25, filter_gaussian)
figure, surf(1:3, 1:3, filter_laplacian)
figure, surf(1:25, 1:25, filter_log)

