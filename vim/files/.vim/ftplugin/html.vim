"""""""""""""""""""""""""""""""""""""""""""""""""""
"Mapping pour le html
""""""""""""""""""""""""""""""""""""""""""""""""""""
imap <html> <html><return></html><esc>O
imap <head> <head><return></head><esc>O
imap <title> <title><return></title><esc>O
imap <body> <body><return></body><esc>O
imap <div> <div><return></div><esc>O
imap <ul> <ul><return></ul><esc>O
imap <li> <li></li><esc>4<backspace>i
imap <a> <a></a><esc>3<backspace>i
imap <p> <p></p><esc>3<backspace>i
imap <h1> <h1></h1><esc>3<backspace>i
imap <h2> <h2></h2><esc>3<backspace>i
imap <h3> <h3></h3><esc>3<backspace>i
imap <b> <b></b><esc>3<backspace>i
imap é &eacute;
imap è &egrave;
imap à &agrave;
imap â &acirc;
imap ê &ecirc;
imap ç &ccedil;
imap ë &euml;
imap ô &ocirc;
imap ù &ugrave;
imap û &ucirc;


""""""""""""""""""""""""""""""""""""""""""""""""""
"Auto-completion
"""""""""""""""""""""""""""""""""""""""""""""""""""
set omnifunc=htmlcomplete#Complete
set omnifunc=csscomplete#Complete
