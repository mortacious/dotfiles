alias config '/usr/bin/git --git-dir=/home/mortacious/.cfg/ --work-tree=/home/mortacious'
set FZF_DEFAULT_COMMAND 'ag -g ""'
set FZF_ALT_C_COMMAND 'bfs -type d -nohidden'

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
