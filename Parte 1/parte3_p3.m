function parte3_p3
  
  % Esta funcion aplica la tecnica de seleccion de color transferido a una imagen
  % Los colores disponibles a elegir son: rojo, amarillo, verde, cyan, azul y magenta
  
  pkg load image;
  clear;
  clc;
  close all;
  
  inColorStr = 'green';
  outColorStr = 'blue';
  [inColorAng outColorAng] = select_colors(inColorStr, outColorStr);
  
  imageRGB = imread('parte3.jpeg');
  imageRGB = im2double(imageRGB);
  
  imageHSV = rgb2hsv(imageRGB);
  imageH = imageHSV(:, :, 1);
  imageS = imageHSV(:, :, 2);
  imageV = imageHSV(:, :, 3);
 
  imageMask = abs(imageH .- (inColorAng / 360));
  
  if (inColorAng != 360)
    
    imageDistance = imageMask > 0.5;
    imageMask = abs(imageDistance - imageMask);
    
  endif
  
  imageThreshold = graythresh(imageMask);
  
  imageMask = im2bw(imageMask, imageThreshold);
  
  imageMask = cat(3, imageMask, imageMask, imageMask);
  
  imageH = mod(imageH .+ (outColorAng / 360), 1);
  
  imageHSV = cat(3, imageH, imageS, imageV);
  imageModified = hsv2rgb(imageHSV);
   
  imageSCT = (imageRGB .* imageMask) + (imageModified .* (1 - imageMask));
  
  ogImage = im2uint8(imageRGB);
  newImage = im2uint8(imageSCT);
 
  subplot(1, 2, 1);
  imshow(ogImage);
  title('Imagen Original');
  
  subplot(1, 2, 2);
  imshow(newImage);
  title('Imagen con el Color Seleccionado Transferido');
  
endfunction

function [inColorAng outColorAng] = select_colors(inColorStr, outColorStr)
  
  switch(inColorStr)
  
    case 'red'
      inColorAng = 360;
      
    case 'yellow'
      inColorAng = 60;
      
    case 'green'
      inColorAng = 120;
      
    case 'cyan'
      inColorAng = 180;

    case 'blue'
      inColorAng = 240;
      
    case 'magenta'
      inColorAng = 300;
    
  endswitch
  
  offsetAng = 360 - inColorAng;
  
  switch(outColorStr)
  
    case 'red'
      outColorAng = offsetAng;
      
    case 'yellow'
      outColorAng = offsetAng + 60;
      
    case 'green'
      outColorAng = offsetAng + 120;
      
    case 'cyan'
      outColorAng = offsetAng + 180;

    case 'blue'
      outColorAng = offsetAng + 240;
      
    case 'magenta'
      outColorAng = offsetAng + 300;
    
  endswitch
  
endfunction