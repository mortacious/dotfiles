if test -n "$EMACS"
  set -x TERM eterm-color
end

function fish_title
  true
end


set -x LC_MESSAGES C
set -x LC_LANG en_US.UTF-8
set -x LANGUAGE en_US.UTF-8
set fish_greeting
set -x EDITOR /usr/bin/nvim
set -x ALTERNATE_EDITOR ""
alias config '/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
set FZF_DEFAULT_COMMAND 'ag -g ""'
set FZF_ALT_C_COMMAND 'bfs -type d -nohidden'

fundle plugin 'edc/bass'
fundle install > /dev/null

# usage: tm <session-name>
# if session-name is provided tm tries to attach to that session else fzf search is done for the sessions
function tm --argument-names 'name'
    set session
    if test -n "$name"
        set newsession "$name"
    else
        set newsession "new"
    end
    echo "newsession: $newsession"
    set session (tmux list-sessions -F "#{session_name}" | fzf --query="$name" --select-1 --exit-0)
    echo "session name: $session" 
    if test -n "$session"
        tmux attach-session -t "$session"
    else
        tmux new-session -s $newsession
    end
end

alias em "emacsclient -cn"
alias emt "emacsclient -ct"
alias clion "~/Documents/scripts/clion"


# store the bedrock context for tmux
set -x BEDROCK_CONTEXT (brw)
if test $TMUX
    set PANENUM (tmux display -p "#D" | tr -d \%)
    set BEDROCK_CONTEXT_OLD (tmux showenv -g | grep TMUX_BRCONTEXT_$PANENUM | sed 's/^.*=//')
    function restore_context --on-process %self
        # exit stuff goes here
        if test $BEDROCK_CONTEXT_OLD
            tmux setenv -g TMUX_BRCONTEXT_$PANENUM $BEDROCK_CONTEXT_OLD
            tmux refresh-client -S 
        else
            # remove the tmux variable again
            tmux setenv -g -u TMUX_BRCONTEXT_$PANENUM
        end
    end
    tmux setenv -g TMUX_BRCONTEXT_$PANENUM $BEDROCK_CONTEXT
    tmux refresh-client -S
end

# source ros stuff
bass source /bedrock/brpath/ros/kinetic/setup.bash 2>/dev/null
source /bedrock/brpath/ros/kinetic/share/rosbash/rosfish
