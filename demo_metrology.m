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

[COEFF,SCORE,LATENT] = pca(zscore(X));

%% Plot Eigen values of Covariance matrix

loglog(LATENT, '*-', 'LineWidth', 2)
xlabel('Principle Components (PC)');
ylabel('Var\{PC\} or Eig\{Cov[X]\}');
grid on
grid minor

%% Calculate PC1 and PC2

PC1 = zeros(size(COEFF));
PC1(:,1) = COEFF(:,1);
PC1 = reshape((SCORE*PC1'), r, c, N);
Ipc1 = PC1(:,:,1);

PC2 = zeros(size(COEFF));
PC2(:,2) = COEFF(:,2);
PC2 = reshape((SCORE*PC2'), r, c, N);
Ipc2 = PC2(:,:,2);


reshape(Itransformed(:,1),size(I,1),size(I,2));
