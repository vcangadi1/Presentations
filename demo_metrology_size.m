clc;
close all;
clear all;

%% Define constants
N  = 100; % Batch size
r  = 50; % Image size (rows)
c  = 50; % Image size (columns)

% Image noise parameters
M  = 0; % Mean
V  = 0; % Variance

% Create random orientations and positions
num_sz = randi([1 5]); % Number of faulty orientation
sz1 = randi([1 r/2],1,num_sz); % Size rows
sz2 = randi([1 c/2],1,num_sz); % Siz columns

Pos= randi([1 N],1,length(sz1)); % Frame location faulty orientation

% Create test reference image
I0 = zeros(r,c);
I0(15:end-15,20:end-20) = 100; I = I0;
I = imnoise(I0,'gaussian', M, V); % Add gaussian noise

% Cascade to create batch
A = repmat(I,1,1,N);

% Create fault image by rotation
figure;
subplot(length(sz1)+1,1,1)
imshow(I)
title('Size = (15,15)')
for ii = 1:length(sz1)
    I_s = zeros(r,c);
    I_s(sz1(ii):end-sz1(ii),sz2(ii):end-sz2(ii)) = 100; % fault in size
    I_s = imnoise(I_s,'gaussian', M, V); % Add gaussian noise
    A(:,:,Pos(ii)) = I_s;
    subplot(length(sz1)+1,1,ii+1)
    imshow(A(:,:,Pos(ii)))
    title({['Size = (',num2str(sz1(ii)),',',num2str(sz2(ii)),')'];['Frame = ', num2str(Pos(ii))]})
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
