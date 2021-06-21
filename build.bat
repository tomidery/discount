@echo on

set CC=c:\software\mingw64\bin\gcc.exe -Wno-return-type -Wno-implicit-int
set CFLAGS=-g
set LDFLAGS=-g
set AR=c:\software\mingw64\bin\ar.exe
set RANLIB=c:\software\mingw64\bin\ranlib.exe
set BRANCH=v2maint
set VERSION=2.2.7

set BUILD=%CC% -I. %CFLAGS%
set LINK=%CC% -L. %LDFLAGS%

set MKDLIB=libmarkdown.a

REM clean:
REM	rm -f %PGMS% %TESTFRAMEWORK% %SAMPLE_PGMS% *.o
REM	rm -f %MKDLIB% `./librarian.sh files %MKDLIB% VERSION`
del *.o
del *.exe
del *.a
del *.ilk

REM version.o: version.c VERSION branch
%BUILD% -DBRANCH=%BRANCH% -DVERSION=%VERSION% -c version.c -o version.o

REM mktags: mktags.o
%BUILD% -c mktags.c -o mktags.o
%LINK% -o mktags mktags.o

REM blocktags: mktags
mktags.exe > blocktags

REM compile library
REM %MKDLIB%: %OBJS%
REM	./librarian.sh make %MKDLIB% VERSION %OBJS%
%BUILD% -c mkdio.c -o mkdio.o 
%BUILD% -c markdown.c -o markdown.o 
%BUILD% -c dumptree.c -o dumptree.o 
%BUILD% -DTYPORA -c generate.c -o generate.o 
%BUILD% -c resource.c -o resource.o 
%BUILD% -c docheader.c -o docheader.o 
%BUILD% -c version.c -o version.o 
%BUILD% -c toc.c -o toc.o 
%BUILD% -c css.c -o css.o 
%BUILD% -c xml.c -o xml.o 
%BUILD% -c Csio.c -o Csio.o 
%BUILD% -c xmlpage.c -o xmlpage.o 
%BUILD% -c basename.c -o basename.o 
%BUILD% -c emmatch.c -o emmatch.o 
%BUILD% -c github_flavoured.c -o github_flavoured.o 
%BUILD% -c setup.c -o setup.o 
%BUILD% -c tags.c -o tags.o 
%BUILD% -c html5.c -o html5.o 
%BUILD% -c flags.c -o flags.o

REM create library
%AR% crv %MKDLIB% mkdio.o markdown.o dumptree.o generate.o resource.o docheader.o version.o toc.o css.o xml.o Csio.o xmlpage.o basename.o emmatch.o github_flavoured.o setup.o tags.o html5.o flags.o
%RANLIB% %MKDLIB%

REM # modules that markdown, makepage, mkd2html, &tc use
set COMMON=pgm_options.o gethopt.o notspecial.o

%BUILD% -c pgm_options.c -o pgm_options.o 
%BUILD% -c gethopt.c -o gethopt.o 
%BUILD% -c notspecial.c -o notspecial.o

REM # example programs
REM theme:  theme.o %COMMON% %MKDLIB% mkdio.h
REM	%LINK% -o theme theme.o %COMMON% -lmarkdown 
%BUILD% -c theme.c -o theme.o
%LINK% -o theme theme.o %COMMON% -lmarkdown 

REM mkd2html:  mkd2html.o %MKDLIB% mkdio.h gethopt.h %COMMON%
REM %LINK% -o mkd2html mkd2html.o %COMMON% -lmarkdown 
%BUILD% -c mkd2html.c -o mkd2html.o
%LINK% -o mkd2html mkd2html.o %COMMON% -lmarkdown 

REM markdown: main.o %COMMON% %MKDLIB%
REM	%LINK% -o markdown main.o %COMMON% -lmarkdown 
%BUILD% -c main.c -o main.o
%LINK% -o markdown main.o %COMMON% -lmarkdown 

REM makepage.o: makepage.c mkdio.h
REM 	%BUILD% -c makepage.c
REM makepage:  makepage.o %COMMON% %MKDLIB%
REM	%LINK% -o makepage makepage.o %COMMON% -lmarkdown 
%BUILD% -c makepage.c -o makepage.o
%LINK% -o makepage makepage.o %COMMON% -lmarkdown 

copy /y libmarkdown.a ..\..\src\hastyscribepkg\vendor\libmarkdown_windows_x64.a
copy /y markdown.exe c:\MALT\MediaRepo\discount
markdown.exe -ffootnotes test.md
pause