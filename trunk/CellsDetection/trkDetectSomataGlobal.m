function Somata = trkDetectSomataGlobal(M, Green, parameters)

h = [1;1];
Somata = cell(size(Green));

%parfor t = 1:TMAX
for t = 1:parameters.TMAX
    if mod(t,10) == 0
        fprintf('|');
    end
    Im = double(Green{t});
    mean_std = zeros(2, max(M{t}(:)));
    for i=1:max(M{t}(:))
       mean_std(1, i) = mean(Im(M{t} == i));
       mean_std(2, i) = std(Im(M{t} == i));
    end
    meanGlobal = mean(Im(M{t} == 0));
    stdGlobal  = std(Im(M{t} == 0));
    [U, V, L] = RegionGrowingSomata(h, Im, M{t}, mean_std, parameters.StdMultFactor, meanGlobal, stdGlobal, parameters.LengthThresh);
    SomaM  	= imfill(U < parameters.GeodesicDistanceThresh, 'holes');
    V(~SomaM) = 0;
    Somata{t} = V;
end