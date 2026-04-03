
clear; clc; close all;
img_path = 'cover.jpg'; 
if ~exist(img_path, 'file')
    error('File not found! Please check if "cover.jpg" is in your Downloads folder.');
end
if ~exist('results', 'dir')
    mkdir('results');
end
enhanced_image = process_image(img_path);
imwrite(enhanced_image, 'results/final_enhanced.png');
fprintf('Success! Enhanced image saved to: %s\n', fullfile(pwd, 'results', 'final_enhanced.png'));

function enhanced = process_image(input_path)
    img_rgb = imread(input_path);
    if size(img_rgb, 3) == 3
        img_gray = rgb2gray(img_rgb);
    else
        img_gray = img_rgb;
    end
   
    fprintf('\n--- Initial Image Report ---\n');
    fprintf('Resolution: %d x %d\n', size(img_gray, 1), size(img_gray, 2));
    fprintf('Data Type: %s\n', class(img_gray));
    disp('Partial Matrix Snippet (Top 5x5):');
    disp(img_gray(1:5, 1:5));
    img_down = imresize(img_gray, 0.5); 

    img_4bit = uint8(floor(double(img_gray) / 16) * 16);
    img_rotated = imrotate(img_gray, 45, 'bilinear', 'crop');
    L = double(img_gray);
    c = 255 / log(1 + max(L(:)));
    img_log = uint8(c * log(1 + L));
    img_gamma = imadjust(img_gray, [], [], 0.5);
    img_equalized = histeq(img_gray);
    figure('Name', 'Lab 06: Image Enhancement Pipeline', 'NumberTitle', 'off');
    
    subplot(2,3,1); imshow(img_gray); title('1. Original Grayscale');
    subplot(2,3,2); imshow(img_4bit); title('2. 4-Bit Quantized');
    subplot(2,3,3); imshow(img_rotated); title('3. 45° Rotation');
    subplot(2,3,4); imshow(img_log); title('4. Log Transform');
    subplot(2,3,5); imshow(img_gamma); title('5. Gamma Correction (0.5)');
    subplot(2,3,6); imshow(img_equalized); title('6. Histogram Equalized');
    figure('Name', 'Histogram Analysis');
    subplot(1,2,1); imhist(img_gray); title('Original Histogram');
    subplot(1,2,2); imhist(img_equalized); title('Equalized Histogram');
    enhanced = imadjust(img_equalized, [], [], 0.8);
end