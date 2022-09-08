\NeedsTeXFormat{LaTeX2e}

\def\thesisversion{1.0}
\ProvidesClass{lundphdthesis}[2020-04-29 Version \thesisversion\relax/Lund PhD thesis class]\relax
\ClassInfo{lundphdthesis}{%
^^J
^^J
 Version 1.0 written by Brian Thorsbro, 2020 (brian@thorsbro.dk)
^^J
 Adapted from previous versions by Matthäus Schulik, Simona Pirani, Asli Pehlivan Rhodin, Daniel Carrera, Daniel Michalik, Berry Holl, Helene Jönsson, Jonas Palm
^^J
^^J
}


% ==================================
% ==================================
%
%  OPTIONS SECTION
%
% ==================================
% ==================================

% package to define booleans
\RequirePackage{ifthen}

% ==================================
% PAGE SIZE -- G5 OR E5
% ==================================

\DeclareOption{E5}{
    \AtEndOfPackage{
        \geometry{
            paperwidth  =   155mm,
            paperheight =   220mm,
            footskip    =   38.8441pt,
            total       =   {12cm,18cm},
            top         =   1.8cm,
            ignorehead,
            centering
        }
    }
}
\DeclareOption{G5}{
    \AtEndOfPackage{
        \geometry{
            paperwidth  =   169mm,
            paperheight =   239mm,
            footskip    =   38.8441pt,
            total       =   {13.3cm,19.6cm},
            top         =   1.8cm,
            ignorehead,
            centering
        }
    }
}


% ==================================
% CONFIGURE THE FONTS
% ==================================
% Note using overleaf: Compile with "XeLaTeX" if you want LU fonts

\newboolean{LUFontsBool}
\DeclareOption{LUFonts}{
    \setboolean{LUFontsBool}{true}
    \AtEndOfPackage{
        \ifxetex
            \setmainfont[
                Path=fonts/,
                Ligatures=TeX,
                Extension=.otf,
                UprightFont=*-Regular,
                BoldFont=*-Semibold,
                ItalicFont=*-Italic,
                BoldItalicFont=*-Italic
            ]{AGaramondPro}
            \setsansfont[
                Path=fonts/,
                Ligatures=TeX,
                Extension=.otf,
                UprightFont=*-Light,
                BoldFont=*-Roman,
                ItalicFont=*-LightItalic,
                BoldItalicFont=*-Italic
            ]{FrutigerLTStd}
        \fi
    }
}

\newboolean{MathFontsBool}
\DeclareOption{MathFonts}{
    \setboolean{MathFontsBool}{true}
    \AtEndOfPackage{
        \ifxetex
            \setmathfont(Greek,Latin)[Path=fonts/]{AGaramondPro-Italic.otf}
            \setmathfont(Digits)[Path=fonts/]{AGaramondPro-Regular.otf}
        \fi
    }
}


% ==================================
% DEFINE DEFAULTS
% ==================================

\ExecuteOptions{E5}

% ==================================
% PROCESS CHOSEN OPTIONS
% ==================================

\ProcessOptions


% ==================================
% ==================================
%
%  PACKAGE LOADING
%
% ==================================
% ==================================

% everything is based on book with 11pt font size
\LoadClass[11pt]{book}

% classes for geometry
\RequirePackage{geometry}

% used both by this and later for article table setup
\RequirePackage{etoolbox}

% classes for fonts
\RequirePackage{ifxetex}
\ifxetex
    \ifthenelse{\boolean{MathFontsBool}}{
        \RequirePackage{mathspec}
        \RequirePackage[no-math]{fontspec}
        \AtEndOfPackage{
            \makeatletter
            \begingroup\lccode`~=`"
            \lowercase{\endgroup
                \everymath{\let~\eu@active@quote}
                \everydisplay{\let~\eu@active@quote}
            }
            \makeatother
        }
    }{\ifthenelse{\boolean{LUFontsBool}}{
        \RequirePackage{fontspec}
    }{}}
\else
    \ifthenelse{\boolean{LUFontsBool}}{\ClassError{lundphdthesis}{Need to enable XeLaTeX compiler if LUFonts are wanted}}{\ifthenelse{\boolean{MathFontsBool}}{\ClassError{lundphdthesis}{Need to enable XeLaTeX compiler if MathFonts are wanted}}{}}
\fi

% Must come in the beginning. Changes the spacing in the table of contents to look more pleasing
\RequirePackage{tocloft}
\setlength{\cftbeforepartskip}{5.0mm}
\setlength{\cftbeforechapskip}{2.0mm}
\setlength{\cftbeforesecskip}{0.0mm}

% Figure captions in bold (i.e. "Figure 1" in bold), sans serif, smaller font size, hanging label, always starting on the left side
\RequirePackage{subfig}
\DeclareCaptionFont{ssmall}{\ssmall}
\DeclareCaptionFont{tiny}{\tiny}% "scriptsize" is defined by floatrow, "tiny" not
%\captionsetup{margin=0em,font={small,sf},labelfont={bf},format=hang,singlelinecheck=false}
\captionsetup{margin=0em,font={small,sf},labelfont={bf},singlelinecheck=false}

% Figures centred, smaller font in tables, captions on top for tables
\RequirePackage{floatrow}
\DeclareFloatFont{ssmall}{\small}% "scriptsize" is defined by floatrow, "tiny" not
\DeclareFloatFont{tiny}{\ssmall}
\floatsetup[table]{font={small},position=top}

% not every page needs to go to the same bottom line. Allows nicer page breaks.
\raggedbottom

% Define nice headers and footers
% To keep the thesis non-cluttered we only put the page number into
% the footer, and avoid headers
\RequirePackage{fancyhdr}
\fancyheadoffset{0cm}
\pagestyle{plain}
\cfoot{\fancyplain{\thepage}{}} %page number in the foot centre




% ==================================
% ==================================
%
%  FRONT MATTER STUFF
%
% ==================================
% ==================================

\RequirePackage{eso-pic}
\RequirePackage{graphicx}
\RequirePackage{pdfpages}

\let\@subtitle ~
\newcommand{\subtitle}[1]{\renewcommand{\@subtitle}{#1}}
\let\@degree ~
\newcommand{\degree}[1]{\renewcommand{\@degree}{#1}}
\let\@titleblurb ~
\newcommand{\titleblurb}[1]{\renewcommand{\@titleblurb}{#1}}
\let\@announcement ~
\newcommand{\announcement}[1]{\renewcommand{\@announcement}{#1}}

\newcommand{\maketitleshort}{\pagestyle{empty}\vspace*{5cm}\begin{minipage}{0.8\linewidth}\centering\large\@title\end{minipage}\cleardoublepage}

\newcommand{\@maketitle}{
{\Huge \@title}
\\[2mm]
{\LARGE \@subtitle}
\\[12mm]
{\large \@author}
\\[12mm]
\includegraphics[width=0.25\textwidth]{logo/LundUniversity_logo.eps}
}

\renewcommand{\maketitle}{
\pagestyle{empty}
\vfill
\begin{center}
\@maketitle
\end{center}
}

\newcommand{\maketitlewithblurb}{
\pagestyle{empty}
\vfill
\begin{center}
\@maketitle\\
\vspace{15mm}
{\large\@degree}\\[1cm]
{\large\@titleblurb}\\[7mm]
{\footnotesize\@announcement}
\end{center}
}



% ==================================
% CHAPTERS, SECTIONS, SUBSECTIONS WITHOUT NUMBERS
% ==================================
% define commands for chapters, sections, and subsections
% that do not have a number, but are entered as candidates
% for the table of contents.
\newcommand\chapterhidenum[1]{%
  \chapter*{#1}%
  \addcontentsline{toc}{chapter}{#1}
  \markboth{#1}{#1}
}
\newcommand\sectionhidenum[1]{%
  \section*{#1}%
  \addcontentsline{toc}{section}{#1}
  \markright{#1}
}
\newcommand\subsectionhidenum[1]{%
  \subsection*{#1}%
  \addcontentsline{toc}{subsection}{#1}
}


% ==================================
% Articles
% ==================================


\RequirePackage{longtable}
\RequirePackage{makecell}
\newcommand{\RNum}[1]{\uppercase\expandafter{\romannumeral #1\relax}}

\newcounter{phdarticlecount}
\def\phdarticletablecontent{}
\newcommand{\phdarticle}[3]{
    \appto\phdarticletablecontent{\stepcounter{phdarticlecount}
    \makecell[t]{\RNum{\thephdarticlecount}} & \makecell[t{p{0.84\linewidth}}]{\textbf{#1}\\[1mm]#2\\#3\\[1mm]} \\
    }
}
\newcommand{\makephdarticletable}{
{\small\begin{longtable}{ll}
\phdarticletablecontent{}\\
\end{longtable}}
}

\newcounter{otherarticlecount}
\def\otherarticletablecontent{}
\newcommand{\otherarticle}[3]{
    \appto\otherarticletablecontent{\stepcounter{otherarticlecount}
    \makecell[t]{\RNum{\theotherarticlecount}} & \makecell[t{p{0.84\linewidth}}]{\textbf{#1}\\[1mm]#2\\#3\\[1mm]} \\
    }
}
\newcommand{\makeotherarticletable}{
{\small\begin{longtable}{ll}
\otherarticletablecontent{}\\
\end{longtable}}
}


% macro to create page marking the beginning of articles at the end of the thesis
% using hfuzz to suppress overfull hbox warnings
\newlength{\paperpagemarklength}
\newcounter{paperpagemarkcounter}
\newcommand{\paperpagemark}[1]{
\addtolength{\paperpagemarklength}{2cm}  % IMORTANT: Increase by 2cm each time.
\stepcounter{paperpagemarkcounter}
\def\paperpagemarktitle{}
\appto\paperpagemarktitle{Paper \RNum{\thepaperpagemarkcounter}: #1}
\cleardoublepage
\addcontentsline{toc}{section}{\paperpagemarktitle{}}
\thispagestyle{empty}
\vspace*{\paperpagemarklength}
\hfill{
	\fontsize{20}{30}
	\selectfont {\bf Paper \RNum{\thepaperpagemarkcounter}}
}
\marginpar{\hfuzz 100pt\rule[-4mm]{50mm}{14mm}}
\vfill
\cleardoublepage
}




% ==================================
% Other
% ==================================

% Reference in style of Natural Sciences
\RequirePackage{natbib}

% Provides total number of pages on command \ztotpages
\RequirePackage{zref-totpages}

% support for URLs
\RequirePackage{url}
%% if we take away the xx before UrlBreaks we will get a url that breaks
%% at any letter or number. It might be better to break only at / however...
\expandafter\def\expandafter\xxUrlBreaks\expandafter{\UrlBreaks%  save the current one
  \do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j%
  \do\k\do\l\do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t%
  \do\u\do\v\do\w\do\x\do\y\do\z\do\A\do\B\do\C\do\D%
  \do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L\do\M\do\N%
  \do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X%
  \do\Y\do\Z\do\1\do\2\do\3\do\4\do\5\do\6\do\7\do\8\do\9}
\PassOptionsToPackage{hyphens}{url}
\RequirePackage{nohyperref}  % enable hyperref commands used by some bibliography libraries but does nothing
\newcommand{\nolinkurl}[1]{#1}

% english babel for hyphens and utf8 input
\RequirePackage[english]{babel}

% text greek for non-italic greek symbols in the text, supports both LUFonts and non-LUFonts
\RequirePackage{textgreek}

% math libraries
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathrsfs}
\RequirePackage{mathtools}
