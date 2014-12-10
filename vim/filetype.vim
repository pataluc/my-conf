augroup filetype
    au BufNewFile,BufRead named.conf*   setf named
    au BufNewFile,BufRead *.zone        setf bindzone
    au BUfNewFile,BufRead *.identity    setf dosini
augroup END

au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif 
autocmd BufRead,BufNewFile /etc/php5/fpm/* set syntax=dosini
