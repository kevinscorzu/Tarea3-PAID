function parte3_p4
  
  % Esta funcion aplica la tecnica de clave croma a un video
  % Los colores disponibles a elegir son: rojo, amarillo, verde, cyan, azul y magenta
  
  pkg load image;
  pkg load video;
  clear;
  clc;
  close all;
  
  colorStr = 'green';
  colorAng = select_color(colorStr);
  
  VO = VideoReader('parte4.mp4');
  VB = VideoReader('video_fondo_1.mp4');
  
  VCC = VideoWriter('video_con_clave_croma_fondo_1.mp4');
  
  open(VCC);
  
  fr = 0;

  while (VO.hasFrame())
    
     ZO = readFrame(VO);
     ZB = readFrame(VB);
     
     if (isempty(ZO) || isempty(ZB))
       break;
     endif
     
     [m, n, c] = size(ZO);
     ZB = imresize(ZB, [m n]);
     
     ZN = croma_key(ZO, ZB, colorAng);
     
     writeVideo(VCC, ZN);
     
     fr += 1
     
  endwhile

  close(VCC);
  
endfunction

function ZN = croma_key(ZO, ZB, colorAng)
  
  imageRGB = im2double(ZO);
  
  imageChroma = im2double(ZB);
  
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
  
  imageCK = (imageRGB .* imageMask) + (imageChroma .* (1 - imageMask));
  
  ZN = im2uint8(imageCK);
  
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