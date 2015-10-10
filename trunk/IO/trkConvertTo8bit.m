function mv = trkConvertTo8bit(Images, invert)




mv = cell(size(Images));

TMAX = length(Images);
for t = 1:TMAX
    
    if mod(t,10) == 0
        fprintf('|');
    end
    
    % convert the image
    I = double(Images{t});
    
    if invert
        I = 1- mat2gray(I);
    end

	I2 = I - min(I(:));
	I2 = I2 * (255/max(I2(:)));
    I2 =  round(I2);
    Iout = uint8(I2);
    
    % clip 7 pixels from the edges
%     Iout = Iout(7:end-7, 7:end-7); 
    
    mv{t} = Iout;
end