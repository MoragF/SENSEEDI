function marMSK2(tifname)
    [a,m]=readfile(tifname);
    [xx,yy]=readfile2meshgrid(m);
    for nj =1:19
        MARf = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MARv3.11.2-6km-daily-ERA5-',num2str(2000+nj),'.nc'];
        su = ncread(MARf, 'SU');
        time = ncread(MARf,'TIME');
        mlat = ncread(MARf, 'LAT');
        mlon = ncread(MARf, 'LON');
        t = ncread(MARf, 'TIME');
        nt = length(t);
        SU = zeros(430,487,nt);
        for ni = 1:length(time)
            %project variable on to the mesh for the mask(tif)
            SU(:,:,ni) = griddata(double(mlon),double(mlat),su(:,:,1,ni),double(xx),double(yy),'linear');       
        end
        nj
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_',num2str(2000+nj),'.nc'];
        nccreate(file,'su','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        ncwrite(file,'su',SU);
    end
end
