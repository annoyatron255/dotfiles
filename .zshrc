# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/jack/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	fzf
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

if [ -n "$WINDOWID" ]; then
	mkdir -p /tmp/urxvtc_ids/
	echo $$ > /tmp/urxvtc_ids/$WINDOWID
fi

# User configuration

function yta() {
	PLAYLIST=~/.config/mpd/playlists/yt-playlist.m3u

	printf "#EXTM3U\n#EXTINF:" > $PLAYLIST

	youtube-dl -f bestaudio -j ytsearch:"$*" | jq -cMr .duration | tr '\n' ',' >> $PLAYLIST
	youtube-dl -f bestaudio --get-title ytsearch:"$*" >> $PLAYLIST
	youtube-dl -f bestaudio -g ytsearch:"$*" >> $PLAYLIST

	mpc load $(basename -s .m3u $PLAYLIST)
	mpc play $(mpc playlist | wc -l)
}

function yt() {
	mpv ytdl://ytsearch:"$*"
}

function m() {
	if [ $# -eq 0 ]
	then
		TRACK="$(mpc listall -f "%file%\t%title%\t%artist%\t%album%" | fzf | head -n 1 | sed "s/\t.*//")"
	else
		TRACK="$(mpc listall -f "%file%\t%title%\t%artist%\t%album%" | fzf -f "$*" | head -n 1 | sed "s/\t.*//")"
	fi
	if $(mpc playlist -f "%file%" | grep -Fxq "$TRACK")
	then
		mpc play $(mpc playlist -f "%file%" | grep -nFx "$TRACK" | sed "s/:.*//" | head -n 1)
	else
		mpc add "$TRACK"
		mpc play $(mpc playlist | wc -l)
	fi
}

function o() {
	if [ $# -eq 0 ]
	then
		FILE=$(fzf)
	else
		FILE=$(fzf -f "$*" | head -n 1)
	fi
	#xdg-open $FILE < /dev/null > /dev/null 2>&1 & disown
	mimeo $FILE
	sleep 5
}

function notes() {
	DATE="$(date "+%Y-%m-%d")"
	FOLDER="$DATE"
	index=0
	while [ -d "$FOLDER" ]; do
		printf -v FOLDER -- '%s_%01d' "$DATE" "$((++index))"
	done
	mkdir $FOLDER
	cd $FOLDER
	cp ~/.vim/templates/notes.tex ./
	sed -i "s/DATE/$(date "+%B %d, %Y")/g" ./notes.tex
	sed -i "s/SUBJECT/$(basename "$(dirname "$(dirname "$(pwd)")")")/g" ./notes.tex
	vim +11 +VimtexCompile ./notes.tex
}

function t() {
	zsh
}

function za() {
	zathura $* & disown
}

function xyzzy() {
	echo "Nothing happens."
}

function tx() {
	LATEX_DIR=/tmp/latex_temp
	mkdir -p $LATEX_DIR
	if [[ "$*" != *"edit"* ]]
	then
		echo -e "\\\\begin{align*}\n\t\n\\\\end{align*}" > $LATEX_DIR/latex_input.tex
	fi
	vim +2 +"call vimtex#syntax#p#amsmath#load()" $LATEX_DIR/latex_input.tex
	echo -E "${$(<$HOME/.vim/templates/shortdoc.tex)//CONTENTS/$(<$LATEX_DIR/latex_input.tex)}" > $LATEX_DIR/latex.tex
	( cd $LATEX_DIR ; pdflatex $LATEX_DIR/latex.tex )
	pdfcrop --margins 12 $LATEX_DIR/latex.pdf $LATEX_DIR/latex.pdf
	pdf2svg $LATEX_DIR/latex.pdf $LATEX_DIR/latex.svg
	pdftoppm $LATEX_DIR/latex.pdf $LATEX_DIR/latex -png -f 1 -singlefile -rx 600 -ry 600
	if [[ "$*" == *"svg"* ]]
	then
		nohup xclip -selection clipboard -target image/x-inkscape-svg -i $LATEX_DIR/latex.svg 1>&- 2>&- 0<&-
	else
		nohup xclip -selection clipboard -target image/png -i $LATEX_DIR/latex.png 1>&- 2>&- 0<&-
	fi
}

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export QUOTING_STYLE=literal
export SAVEHIST=1000000
#alias za="zathura"
alias tdir='mkdir $(date "+%Y-%m-%d")'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles_git/ --work-tree=$HOME'
