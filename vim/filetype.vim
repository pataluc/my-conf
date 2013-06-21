augroup filetype
    au BufNewFile,BufRead named.conf*   setf named
    au BufNewFile,BufRead *.zone        setf bindzone
    au BUfNewFile,BufRead *.identity    setf dosini
augroup END
