#! /usr/bin/env julia

pkg_dir = dirname(dirname(@__FILE__))

@windows_only begin
    try
      run(`where cl.exe`)
    catch
      error("ERROR: Could not find cl.exe.")
    end

    path = "$(pkg_dir)\\src\\"
    run(`cl.exe /D_USRDLL /D_WINDLL /EHsc /Fo$(path) $(path)voronoi.cpp /MT /link /DLL /OUT:$(path)voronoi.dll`)
end

@unix_only begin
    cd("$(pkg_dir)/src") do
        # Note: on Mac OS X, g++ is aliased to clang++.
        run(`g++ -c -fPIC -std=c++11 -I. voronoi.cpp`)
        run(`g++ -shared -o voronoi.so voronoi.o`)
    end
end
