clc;

%% Define constants

% Number of samples
N = 20;
% Rotation angle
rt = 5;

% Image size
r = 50;
c = 50;

% Image noise parameters
M = 0; %Mean
V = 5; %Variance

%% Create test images

I = zeros(r,c);
I(15:end-15,15:end-15) = 1;
% Add gaussian noise
I = imnoise(I,'gaussian',0,5); % Reference

I_r = imrotate(I, rt, 'bilinear', 'crop');
% Add gaussian noise
I_r = imnoise(I_r,'gaussian',0,5); % 

A = repmat(I,1,1,N);

A(:,:,10) = I_r;

%% Apply PCA

X = reshape(A, r*c, N);

[COEFF,SCORE,LATENT] = pca(X);

%% Plot Eigen values of Covariance matrix

loglog(LATENT, '*-', 'LineWidth', 2)
xlabel('Principle Components (PC)');
ylabel('Var\{PC\} or Eig\{Cov[X]\}');
grid on
grid minor
