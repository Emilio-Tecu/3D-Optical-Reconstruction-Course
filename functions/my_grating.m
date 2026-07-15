function my_grating(ng, ns, ppf, MNp, path)
% 
    

    
    alpX = ( MNp(2)/ppf )^( 1/(ng-1) );
    alpY = ( MNp(1)/ppf )^( 1/(ng-1) );
    
    u = linspace( -1, 1, MNp(2) );
    v = linspace( -1, 1, MNp(1) );
    [U, V] = meshgrid(u,v);
    
    % Phase shifts
    d = 2*pi*(0:ns-1)/ns;
    
    % Display grating
    
    screens = get(0,"MonitorPositions");

    idp = 2; % Projector index
    f = figure(1); f.Position = screens(idp,:);
    f.MenuBar = "none"; f.WindowState = "fullscreen";
    
    % Test grating
    g = 4;
    w = pi*alpX^(g-1);
    J = 0.5 + 0.5*cos( w*U );

    figure(f); h = imshow( J );
    set(gca,'Position',[0 0 1 1]); drawnow
    clim( [0, 1] )

    %%%%%%%%%%%%% Open Camera %%%%%%%%%%%%%%
    
    v = videoinput("winvideo", 2, "MJPG_1024x576");
    v.ReturnedColorspace = "rgb";

    src = getselectedsource(v);
    src.BacklightCompensation = "off";
    src.Exposure = -7;
    src.ExposureMode = "manual";
    src.WhiteBalanceMode = "manual";

    
    %%%%%%%%%%%% U-axis gratings %%%%%%%%%%%
    for g = 1:ng

        % Frequency
        w = pi*alpX^(g-1);

        for s = 1:ns
            
            J = 0.5 + 0.5*cos(w*U + d(s) );
            set(h,'CData', J)
            
            pause(0.2);
            
            I = getsnapshot( v );
            
            pause(0.2)
            
            imwrite( I, path + "fp_" + ...
                     num2str(ns*(g-1) + s) + ".jpg" )

        end
    end
    
    %%%%%%%%%%%% V-axis gratings %%%%%%%%%%%
    for g = 1:ng

        % Frequency
        w = pi*alpY^(g-1);

        for s = 1:ns

            J = 0.5 + 0.5*cos(w*V + d(s) );
            set(h,'CData', J)

            pause(0.2);

            I = getsnapshot( v );
            
            pause(0.2)
            
            imwrite( I, path + "fp_" + ...
                     num2str(ns*ng + ns*(g-1) + s) + ".jpg" )

        end
    end
    
    delete( v )
    clear src v
    
end