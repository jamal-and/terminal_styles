
# Enhanced ZSH Terminal Setup

# Enable colors and prompt substitution
autoload -U colors && colors
setopt PROMPT_SUBST

# Color definitions (using 256-color palette)
COLOR_RESET='%f'
COLOR_USER='%F{81}'          # Bright cyan
COLOR_AT='%F{243}'           # Gray
COLOR_HOST='%F{141}'         # Purple
COLOR_DIR='%F{220}'          # Gold/yellow
COLOR_GIT='%F{82}'           # Bright green
COLOR_GIT_DIRTY='%F{196}'    # Bright red
COLOR_ARROW='%F{39}'         # Blue
COLOR_TIME='%F{102}'         # Muted green
COLOR_JOBS='%F{166}'         # Orange

# Symbols
ARROW_SYMBOL="➜"
GIT_SYMBOL="⎇"
DIRTY_SYMBOL="✗"
CLEAN_SYMBOL="✓"
JOBS_SYMBOL="⚡"

# Get current time
get_time() {
    echo "%D{%H:%M:%S}"
}

# Enhanced git branch function with status
parse_git_branch() {
    local branch
    branch=$(git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    
    if [[ -n "$branch" ]]; then
        local git_status
        git_status=$(git status --porcelain 2>/dev/null)
        
        if [[ -n "$git_status" ]]; then
            echo "${COLOR_GIT_DIRTY}${GIT_SYMBOL} $branch ${DIRTY_SYMBOL}${COLOR_RESET}"
        else
            echo "${COLOR_GIT}${GIT_SYMBOL} $branch ${CLEAN_SYMBOL}${COLOR_RESET}"
        fi
    fi
}

# Show background jobs count
show_jobs() {
    local job_count=$(jobs | wc -l | tr -d ' ')
    if [[ $job_count -gt 0 ]]; then
        echo "${COLOR_JOBS}${JOBS_SYMBOL}$job_count${COLOR_RESET} "
    fi
}

# Get directory with ~ substitution and path shortening
get_pwd() {
    local current_dir="${PWD/#$HOME/~}"
    
    # If path is too long, show only last 3 directories
    if [[ ${#current_dir} -gt 50 ]]; then
        echo "${current_dir}" | sed 's|^.*/\([^/]*/[^/]*/[^/]*\)$|…/\1|'
    else
        echo "${current_dir}"
    fi
}

# Main prompt
PROMPT='
╭─ ${COLOR_TIME}$(get_time)${COLOR_RESET} ${COLOR_USER}%n${COLOR_AT}@${COLOR_HOST}%m${COLOR_RESET} ${COLOR_DIR}$(get_pwd)${COLOR_RESET} $(parse_git_branch)
╰─ $(show_jobs)${COLOR_ARROW}${ARROW_SYMBOL}${COLOR_RESET} '

# Right prompt (appears on the right side)
RPROMPT='%(?..%F{196}✘ %?)' # Shows exit code if non-zero

# Enhanced ls colors (if using GNU ls)
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls --color=auto'
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
fi

# Better grep colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Additional terminal enhancements
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# Auto-completion enhancements
autoload -U compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Key bindings for better navigation
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word      # Ctrl+Right
bindkey '^[[1;5D' backward-word     # Ctrl+Left

# Useful aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Directory navigation
alias lh='ls -lh'
alias lt='ls -lt'
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'

# System information
alias myip='curl -s https://ipinfo.io/ip'
alias ports='netstat -tuln'
