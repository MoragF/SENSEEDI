function marMSK(tifname)
    [a,m]=readfile(tifname);
    [xx,yy]=readfile2meshgrid(m);
    xstart = 10.7139;
    ystart = 80.4708;
    Nx = 487;
    Ny = 430;
    lon = xstart + times((0:Nx-1),0.0360);
    lat = ystart + times((0:Ny-1),-0.0090);
    for nj = 17
        MARf = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/MARv3.11.2-6km-daily-ERA5-',num2str(2000+nj),'.nc'];
        smb = ncread(MARf, 'SMB');
        rf = ncread(MARf, 'RF');
        mlat = ncread(MARf, 'LAT');
        mlon = ncread(MARf, 'LON');
        time = ncread(MARf, 'TIME');
    
        for ni = 1:length(time)
            ni
            %project variable on to the mesh for the mask(tif)
            SMB(:,:,ni) = griddata(double(mlon),double(mlat),smb(:,:,1,ni),double(xx),double(yy),'linear');
            %project variable on to the mesh for the mask(tif)
            RF(:,:,ni) = griddata(double(mlon),double(mlat),rf(:,:,ni),double(xx),double(yy),'linear');       
        end
        nj
        file = ['/exports/csce/datastore/geos/groups/geos_EO/Databases/MAR/Svalbard-RA/Svalbard_Masked/Years/Svalbard_',num2str(2000+nj),'.nc'];
        nx = 487;
        nccreate(file,'lon','Dimensions',{'lon',1,nx},'DeflateLevel',7) ;
        ny = 430;
        nccreate(file,'lat','Dimensions',{'lat',1,ny},'DeflateLevel',7) ;
        nt = length(time)
        size(SMB)
        size(lat)
        size(lon)
        nccreate(file,'time','Dimensions',{'time',1,nt},'DeflateLevel',7) ;
        nccreate(file,'smb','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        nccreate(file,'rf','Dimensions',{'lat','lon','time'},'DeflateLevel',7) ;
        ncwrite(file,'smb',SMB);
        ncwrite(file,'rf',RF);
        ncwrite(file,'time',time);
        ncwrite(file,'lon',lon);
        ncwrite(file,'lat',lat);
    end
 end