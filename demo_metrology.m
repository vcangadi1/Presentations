clc;
close all;
clear all;

%% Define constants

N  = 100; % Number of samples
rt = 45; % Rotation angle
r  = 50; % Image size (rows)
c  = 50; % Image size (columns)

% Image noise parameters
M  = 0; %Mean
V  = 1; %Variance

%% Create test reference image

I0 = zeros(r,c);
I0(15:end-15,20:end-20) = 1; I = I0;
I = imnoise(I0,'gaussian', M, V); % Add gaussian noise

%% Create fault image by rotation
I_r = imrotate(I0, rt, 'bilinear', 'crop'); % Rotate image
I_r = imnoise(I_r,'gaussian', M, V); % Add gaussian noise


%% Cascade to create batch
A = repmat(I,1,1,N);
A(:,:,round(N/2)) = I_r;

%I_r = imrotate(I0, 5, 'bilinear', 'crop'); % Rotate image
%I_r = imnoise(I_r,'gaussian', M, V); % Add gaussian noise
%A(:,:,N) = I_r;

%I_r = imrotate(I0, 10, 'bilinear', 'crop'); % Rotate image
%I_r = imnoise(I_r,'gaussian', M, V); % Add gaussian noise
%A(:,:,N-10) = I_r;

figure;
subplot 131
imshow(I0)
subplot 132
imshow(I)
subplot 133
imshow(I_r)

%% Apply PCA

X = reshape(A, r*c, N);

[COEFF,SCORE,LATENT] = pca(X);

%% Plot Eigen values of Covariance matrix

figure;
loglog(LATENT, '*-', 'LineWidth', 2)
xlabel('Principle Components (PC)');
ylabel('Var\{PC\} or Eig\{Cov[X]\}');
grid on
grid minor

figure;
%bar(LATENT./sum(LATENT))
pie(LATENT./sum(LATENT))

%% Calculate PC1 and PC2

figure;
vbls = cellstr(string(1:N));
biplot(COEFF(:,1:2),'Scores',SCORE(:,1:2),'VarLabels',vbls)

