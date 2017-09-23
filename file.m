
img = imread('engineer.png');
[m, n] = size(img); %Obtain width and height of image.

hist = imhist(img); %Histogram of this image
%hist
histc = cumsum(hist); %Cumulative histogram


L = 256; %Number of gray levels

%Construct histogram of a perfectly equalized image
%Assuming L bins, each bin will contain (m*n)/L pixels
idealHist(:,1) = uint8((m*n)/L);
idealHist;

idealHistc = cumsum(idealHist); %Cumulative histogram
idealHistc
%Initialize the map that will store the transformation to all zeros. 
%In addition, specify the type 'uint8' to ensure that the transform doesn't go out of bounds [0, 255] (see part 1)
map = zeros(L,1,'uint8');%Enter code here...
ind = zeros(L,1);
for i=1:L
    for j = 1:1
    ind(i,j) = abs(histc(i,j) - idealHistc(i,j));
    %For each gray-level, find the **index** ind that minimizes the difference
    %between histc(i) (defined above) and the array idealHistc (defined
    %above). Again, avoid for loops! This can be done in couple of statements that
    % 1) finds the difference (stored in an array) and 2) finds the minimum
    
    %Index ind is between 1 to 256; %Bring it back to range [0, 255]
    %map(i) = %Enter code here...
    end
end
ind
