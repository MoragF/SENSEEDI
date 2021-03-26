function marMSK2(tifname)
    [a,m]=readfile(tifname);
    [xx,yy]=readfile2meshgrid(m);
    for nj =1:4
        MARf = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MARv3.11.2-6km-daily-ERA5-',num2str(2000+nj),'.nc'];
        sf = ncread(MARf, 'SF');
        me = ncread(MARf, 'ME');
        time = ncread(MARf,'TIME');
        mlat = ncread(MARf, 'LAT');
        mlon = ncread(MARf, 'LON');
        for ni = 1:length(time)
            ni
            %project variable on to the mesh for the mask(tif)
            SF(:,:,ni) = griddata(double(mlon),double(mlat),sf(:,:,ni),double(xx),double(yy),'linear');
            %project variable on to the mesh for the mask(tif)
            ME(:,:,ni) = griddata(double(mlon),double(mlat),me(:,:,1,ni),double(xx),double(yy),'linear');       
        end
        nj
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_',num2str(2000+nj),'.nc'];
        size(SF)
        nccreate(file,'sf','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'me','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        ncwrite(file,'sf',SF);
        ncwrite(file,'me',ME);
    end
end
