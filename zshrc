wsl.exe -d wsl-vpnkit service wsl-vpnkit start >/dev/null 2>&1


# /etc/zsh/zshrc ou ~/.zshrc
#
# Basé sur :
# Fichier de configuration principal de zsh
# Formation Debian GNU/Linux par Alexis de Lattre
# http://formation-debian.via.ecp.fr/

PATH=$PATH:~/.bin:~/.local/bin
#export KUBECONFIG=$(find ~/.kube/clusters -type f | sort -r | sed ':a;N;s/\n/:/;ba')

source ~/.bin/kube-ps1.sh

alias helm='https_proxy=http://o3ib2506.ctr.ibp:8889 no_proxy=intrabpce.fr helm'
alias octail='oc logs --tail 100 --follow'
alias scout='https_proxy=http://o3ib2506.ctr.ibp:8888 docker scout cves --only-severity high,critical'
alias snyktest='https_proxy=http://o3ib2506.ctr.ibp:8888 snyk container test --severity-threshold=high'

export MAVEN_OPTS=-Dmaven.wagon.http.ssl.insecure=true


fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

#################
# 1.1 Les alias #
#################

# Gestion du 'ls' : couleur & ne touche pas aux accents
alias ls='ls -F -T0 -h --color=auto --group-directories-first'

# Demande confirmation avant d'écraser un fichier
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Raccourcis pour 'ls'
alias ll='ls -l'
alias l='ll'
alias lll='ll'
alias lla='ls -la'
alias lt='ls -lrt'
alias lta='ls -lart'

# Quelques alias pratiques
alias c='clear'
alias less='less -q'
alias s='cd ..'
alias df='df -h'
alias du='du -h'
alias md='mkdir'
alias rd='rmdir'
alias upgrade='apt-get update && apt-get upgrade && apt-get clean'

alias su='su -l'

alias vi='vim'

alias ipwan='curl ifconfig.me'

alias rescreen='screen -R -D'


# Git
alias gs="git status" #N.B. Overrides ghostscript (probably not important if you don't use it)
alias gd="git diff"
alias gc="git commit"
alias gl='git log --graph --full-history --all --color --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'




#####################
# 1.2 Les fonctions #
#####################

function mkcd() {
    mkdir -p "$1" && cd "$1";
}



#######################################
# 2. Prompt et définition des touches #
#######################################

# Exemple : ma touche HOME, cf  man termcap, est codifiee K1 (upper left
# key  on keyboard)  dans le  /etc/termcap.  En me  referant a  l'entree
# correspondant a mon terminal (par exemple 'linux') dans ce fichier, je
# lis :  K1=\E[1~, c'est la sequence  de caracteres qui sera  envoyee au
# shell. La commande bindkey dit simplement au shell : a chaque fois que
# tu rencontres telle sequence de caractere, tu dois faire telle action.
# La liste des actions est disponible dans "man zshzle".

# Correspondance touches-fonction
bindkey ''    beginning-of-line                   # Home
bindkey ''    end-of-line                         # End
bindkey ''    delete-char                         # Del
bindkey '[3~' delete-char                         # Del
bindkey '[2~' overwrite-mode                      # Insert
bindkey '[5~' history-search-backward             # PgUp
bindkey '[6~' history-search-forward              # PgDn
bindkey '^R'    history-incremental-search-backward # Ctrl R


# Prompt couleur (la couleur n'est pas la même pour le root et
# pour les simples utilisateurs)
cyan="%{[36m%}"
blue="%{[34m%}"
yellow="%{[33m%}"
white="%{[37m%}"
green="%{[32m%}"
red="%{[31m%}"
bold="%{[1m%}"
thin="%{[0m%}"

if [ "`id -u`" -eq 0 ]; then
    usercolor=${red}
else
    usercolor=${blue}
fi

autoload -U add-zsh-hook
setopt PROMPT_SUBST

# Get the current Git branch without parenthesis
function getGitBranch {
    git symbolic-ref HEAD | sed --expression 's!refs/heads/!!' --expression 's/feature/f/' --expression 's/bugfix/b/' --expression 's/release/r/'
}

# Get the current Git status
#   ok = Current Git branch is clean
#   nok = Current Git branch is dirty
#   notgit = Not in a git repository
function getGitStatus {

    if [[ $(git symbolic-ref HEAD 2> /dev/null) != "" ]]; then
        git status | grep -E "nothing to commit|rien à valider" > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo "ok"
        else
            echo "nok"
        fi
    else
        echo "nogit"
    fi
}

# Build the prompt
function gitPrompt {
    gitStatus=$(getGitStatus)

    if [[ $gitStatus != "nogit" ]]; then
        branch=$(getGitBranch)
        if [[ $gitStatus == "ok" ]]; then
            # The current branch is clean
            echo "${green}✓ $branch "
        else
            # The current branch is dirty
            echo "${red}∆ $branch "
        fi
    fi
}

PROMPT='${bold}${cyan}%D{%H:%M:%S} ${usercolor}%n${yellow}@${white}%m ${blue}%~ $(gitPrompt)${yellow}%# ${white}${thin}'
RPROMPT='$(kube_ps1)'


# Console linux, dans un screen ou un rxvt
if [ "$TERM" = "linux" -o "$TERM" = "screen" -o "$TERM" = "rxvt" ]
then
  # Correspondance touches-fonction spécifique
  bindkey '[1~' beginning-of-line       # Home
  bindkey '[4~' end-of-line             # End
fi

# xterm
if [ "$TERM" = "xterm" ]
then
  # Correspondance touches-fonction spécifique
  bindkey '[H'  beginning-of-line       # Home
  bindkey '[F'  end-of-line             # End
fi

# gnome-terminal
if [ "$COLORTERM" = "gnome-terminal" ]
then
  # Correspondance touches-fonction spécifique
  bindkey 'OH'  beginning-of-line       # Home
  bindkey 'OF'  end-of-line             # End
fi

# Titre de la fenêtre d'un xterm
case $TERM in
   xterm*)
       precmd () {print -Pn "\e]0;%n@%m: %~\a"}
       ;;
esac

# Gestion de la couleur pour 'ls' (exportation de LS_COLORS)
if [ -x /usr/bin/dircolors ]
then
  if [ -r ~/.dir_colors ]
  then
    eval "`dircolors ~/.dir_colors`"
  elif [ -r /etc/dir_colors ]
  then
    eval "`dircolors /etc/dir_colors`"
  else
    eval "`dircolors`"
  fi
fi


###########################################
# 3. Options de zsh (cf 'man zshoptions') #
###########################################

# Je ne veux JAMAIS de beeps
unsetopt beep
unsetopt hist_beep
unsetopt list_beep
# >| doit être utilisés pour pouvoir écraser un fichier déjà existant ;
# le fichier ne sera pas écrasé avec '>'
unsetopt clobber
# Ctrl+D est équivalent à 'logout'
unsetopt ignore_eof
# Affiche le code de sortie si différent de '0'
setopt print_exit_value
# Demande confirmation pour 'rm *'
unsetopt rm_star_silent
# Correction orthographique des commandes
# Désactivé car, contrairement à ce que dit le "man", il essaye de
# corriger les commandes avant de les hasher
#setopt correct
# Si on utilise des jokers dans une liste d'arguments, retire les jokers
# qui ne correspondent à rien au lieu de donner une erreur
setopt nullglob

# Schémas de complétion

# - Schéma A :
# 1ère tabulation : complète jusqu'au bout de la partie commune
# 2ème tabulation : propose une liste de choix
# 3ème tabulation : complète avec le 1er item de la liste
# 4ème tabulation : complète avec le 2ème item de la liste, etc...
# -> c'est le schéma de complétion par défaut de zsh.

# Schéma B :
# 1ère tabulation : propose une liste de choix et complète avec le 1er item
#                   de la liste
# 2ème tabulation : complète avec le 2ème item de la liste, etc...
# Si vous voulez ce schéma, décommentez la ligne suivante :
#setopt menu_complete

# Schéma C :
# 1ère tabulation : complète jusqu'au bout de la partie commune et
#                   propose une liste de choix
# 2ème tabulation : complète avec le 1er item de la liste
# 3ème tabulation : complète avec le 2ème item de la liste, etc...
# Ce schéma est le meilleur à mon goût !
# Si vous voulez ce schéma, décommentez la ligne suivante :
unsetopt list_ambiguous
# (Merci à Youri van Rietschoten de m'avoir donné l'info !)

# Options de complétion
# Quand le dernier caractère d'une complétion est '/' et que l'on
# tape 'espace' après, le '/' est effaçé
setopt auto_remove_slash
# Ne fait pas de complétion sur les fichiers et répertoires cachés
unsetopt glob_dots

# Traite les liens symboliques comme il faut
setopt chase_links

# Quand l'utilisateur commence sa commande par '!' pour faire de la
# complétion historique, il n'exécute pas la commande immédiatement
# mais il écrit la commande dans le prompt
setopt hist_verify
# Si la commande est invalide mais correspond au nom d'un sous-répertoire
# exécuter 'cd sous-répertoire'
setopt auto_cd
# L'exécution de "cd" met le répertoire d'où l'on vient sur la pile
setopt auto_pushd
# Ignore les doublons dans la pile
setopt pushd_ignore_dups
# N'affiche pas la pile après un "pushd" ou "popd"
setopt pushd_silent
# "pushd" sans argument = "pushd $HOME"
setopt pushd_to_home

# Les jobs qui tournent en tâche de fond sont nicé à '0'
unsetopt bg_nice
# N'envoie pas de "HUP" aux jobs qui tourent quand le shell se ferme
unsetopt hup


###############################################
# 4. Paramètres de l'historique des commandes #
###############################################

# Nombre d'entrées dans l'historique
export HISTORY=1000
export SAVEHIST=1000

# Fichier où est stocké l'historique
export HISTFILE=$HOME/.history

# Ajoute l'historique à la fin de l'ancien fichier
#setopt append_history

# Chaque ligne est ajoutée dans l'historique à mesure qu'elle est tapée
setopt inc_append_history

setopt SHARE_HISTORY

# Ne stocke pas  une ligne dans l'historique si elle  est identique à la
# précédente
setopt hist_ignore_dups

# Supprime les  répétitions dans le fichier  d'historique, ne conservant
# que la dernière occurrence ajoutée
#setopt hist_ignore_all_dups

# Supprime les  répétitions dans l'historique lorsqu'il  est plein, mais
# pas avant
setopt hist_expire_dups_first

# N'enregistre  pas plus d'une fois  une même ligne, quelles  que soient
# les options fixées pour la session courante
#setopt hist_save_no_dups

# La recherche dans  l'historique avec l'éditeur de commandes  de zsh ne
# montre  pas  une même  ligne  plus  d'une fois,  même  si  elle a  été
# enregistrée
setopt hist_find_no_dups


###########################################
# 5. Complétion des options des commandes #
###########################################

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' use-compctl false

autoload -U compinit
compinit




copy-search-as-buffer() {
    zle end-of-history
    BUFFER="$LASTSEARCH"
    CURSOR="$#BUFFER"
}
zle -N copy-search-as-buffer
#bindkey ^e copy-search-as-buffer



#
# Mise à jour auto de la conf
#
#cd ~/my-conf && git pull >> /dev/null

#cd -

if type "notify-send" > /dev/null; then

    # end and compare timer, notify-send if needed
    function notifyosd-precmd() {
        if [ ! -z "$cmd" ]
        then
            cmd_end=`date +%s`
            ((cmd_time=$cmd_end - $cmd_start))

            if [ $cmd_time -gt 10 ]
            then
                notify-send -i utilities-terminal -u low "$cmd_basename completed" "\"$cmd\" took $cmd_time seconds"
            fi
            unset cmd
        fi
    }

    # make sure this plays nicely with any existing precmd
    #precmd_functions+=( notifyosd-precmd )
    precmd_functions=( notifyosd-precmd )

    # get command name and start the timer
    function notifyosd-preexec() {
        cmd=$1
        cmd_basename=${cmd[(ws: :)1]}
        cmd_start=`date +%s`
    }

    # make sure this plays nicely with any existing preexec
    #preexec_functions+=( notifyosd-preexec )
    preexec_functions=( notifyosd-preexec )
fi


# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.
export SCREENDIR=$HOME/.screen
if [ "$PS1" != "" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]
then
  STARTED_SCREEN=1 ; export STARTED_SCREEN
  [ -d $HOME/lib/screen-logs ] || mkdir -p $HOME/lib/screen-logs
  sleep 1
  screen -R -D && exit 0
  # normally, execution of this rc script ends here...
  echo "Screen failed! continuing with normal bash startup"
fi
# [end of auto-screen snippet]

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


sudo /home/inefoul/.bin/addHost.sh

get_cert_chain()
{
  openssl s_client -showcerts -verify 5 -connect $1:443 -proxy proxy.ctr.ibp:8080 < /dev/null |
    awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{ if(/BEGIN CERTIFICATE/){a++}; out="cert"a".pem"; print >out}'
  for cert in *.pem; do
    newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').crt
    echo "${newname}"; mv "${cert}" "${newname}"
  done
}
