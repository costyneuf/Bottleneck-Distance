function [] = plotBarcodes( L, color,s )
    m = cell2mat(L);
    hold on;
    sz = length(m(:,1));
    for ii = 1:sz
        b = m(ii, 1);
        d = m(ii, 2);
        % plot([b, d], [s*ii, s*ii], 'color', 'k');
        scatter([b, d], [s * 10, s * 10], 20, color, 'fill');
    end
end

