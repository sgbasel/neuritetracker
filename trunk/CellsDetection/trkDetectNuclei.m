function Nuclei = trkDetectNuclei(R, parameters)




TMAX = length(R);
Nuclei = cell(size(R));
EightBitsImages = cell(size(R));

%parfor  t = 1:TMAX
for t = 1:TMAX
    if mod(t,10) == 0
        fprintf('|');
    end
    Rt = mat2gray(double(R{t}));
    I = imgaussian(Rt, parameters.SmoothingNuc);
	I = uint8(255*mat2gray(I));
    EightBitsImages{t} = I;
    Nuclei{t} = vl_mser(I, 'MinDiversity', parameters.MinNucleusArea/parameters.MaxNucleusArea,...
                                'MaxVariation', parameters.MSER_MaxVariation,...
                                'MinArea', parameters.MinNucleusArea/numel(I), ...
                                'MaxArea', parameters.MaxNucleusArea/numel(I), ...
                                'BrightOnDark', 1, ...
                                'Delta',parameters.MSER_Delta) ;
end
%%
for t = 1:TMAX
%     if mod(t,10) == 0
%         fprintf('|');
%     end
    mm = zeros(size(R{1}));
    for x = Nuclei{t}'
        s = vl_erfill(EightBitsImages{t}, x);
        mm(s) = mm(s)+1;
    end
    Nuclei{t} = mm;
    Nuclei{t}  	= imfill(Nuclei{t} > 0, 'holes');
    Nuclei{t} = bwlabel(Nuclei{t});
end
clear EightBitsImages;