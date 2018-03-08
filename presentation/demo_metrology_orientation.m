clc;
close all;
clear all;

%% Define constants
N  = 100; % Batch size
r  = 50; % Image size (rows)
c  = 50; % Image size (columns)

% Image noise parameters
M  = 0; %Mean
V  = 2; %Variance

% Create random orientations and positions
num_rt = randi([1 5]); % Number of faulty orientation
rt = randi([1 360],1,num_rt); % Rotation angles
Pos= randi([1 N],1,length(rt)); % Frame location faulty orientation

%num_rt = 1;
%rt = 20;
%Pos = 4;

% Create test reference image
I0 = zeros(r,c);
I0(15:end-15,20:end-20) = 100; I = I0;
I = imnoise(I0,'gaussian', M, V); % Add gaussian noise

% Cascade to create batch
A = repmat(I,1,1,N);

% Create fault image by rotation
figure;
%subplot(length(sz1)+1,1,1)
imshow(I)
for ii = 1:length(rt)
    I_r = imrotate(I0, rt(ii), 'bilinear', 'crop'); % Rotate image
    I_r = imnoise(I_r,'gaussian', M, V); % Add gaussian noise
    A(:,:,Pos(ii)) = I_r;
    %subplot(length(rt),1,ii)
    figure
    imshow(A(:,:,Pos(ii)))
    title({['Orientation = ',num2str(rt(ii)),'\circ'];['Frame = ', num2str(Pos(ii))]})
end

%% Apply PCA
X = reshape(A, r*c, N);
[COEFF,SCORE,LATENT] = pca(X);

% Plot Eigen values of Covariance matrix
figure;
loglog(LATENT, '*-', 'LineWidth', 2)
xlabel('Principle Components (PC)');
ylabel('Var\{PC\} or Eig\{Cov[X]\}');
grid on
grid minor

%figure;
%pie(LATENT./sum(LATENT))

% Calculate PC1 and PC2
figure;
vbls = cellstr(string(1:N));
biplot(COEFF(:,1:2),'Scores',SCORE(:,1:2),'VarLabels',vbls)
