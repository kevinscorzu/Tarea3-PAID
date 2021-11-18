function parte3_p2
  
  % Esta funcion aplica la tecnica de seleccion de color a una imagen
  % Los colores disponibles a elegir son: rojo, amarillo, verde, cyan, azul y magenta
  
  pkg load image;
  clear;
  clc;
  close all;
  
  colorStr = 'blue';
  colorAng = select_color(colorStr);
  
  imageRGB = imread('parte2isaac.jpeg');
  imageRGB = im2double(imageRGB);
  
  imageGray = rgb2gray(imageRGB);
  imageGray = cat(3, imageGray, imageGray, imageGray);
  
  imageHSV = rgb2hsv(imageRGB);
  imageH = imageHSV(:, :, 1);
  imageS = imageHSV(:, :, 2);
  imageV = imageHSV(:, :, 3);
  
  imageMask = abs(imageH .- (colorAng / 360));
  
  if (colorAng != 360)
    
    imageDistance = imageMask > 0.5;
    imageMask = abs(imageDistance - imageMask);
    
  endif
  
  imageThreshold = graythresh(imageMask);
  
  imageMask = im2bw(imageMask, imageThreshold);
  imageMask = cat(3, imageMask, imageMask, imageMask);
  
  imageSC = (imageRGB .* (1 - imageMask)) + (imageGray .* imageMask);
  
  ogImage = im2uint8(imageRGB);
  newImage = im2uint8(imageSC);
  
  subplot(1, 2, 1);
  imshow(ogImage);
  title('Imagen Original');
  
  subplot(1, 2, 2);
  imshow(newImage);
  title('Imagen con el Color Seleccionado');
  
endfunction

function colorAng = select_color(colorStr)
  
  switch(colorStr)
  
    case 'red'
      colorAng = 360;
      
    case 'yellow'
      colorAng = 60;
      
    case 'green'
      colorAng = 120;
      
    case 'cyan'
      colorAng = 180;

    case 'blue'
      colorAng = 240;
      
    case 'magenta'
      colorAng = 300;
    
  endswitch
  
endfunction