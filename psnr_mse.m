function [psnrVal, mseVal] = psnr_mse(orig, stego)
orig = double(orig);
stego = double(stego);
if ~isequal(size(orig), size(stego))
    error('Images must be same size');
end
err = orig - stego;
mseVal = mean(err(:).^2);
if mseVal == 0
    psnrVal = Inf;
else
    MAX = 255;
    psnrVal = 10 * log10((MAX^2)/mseVal);
end
end
