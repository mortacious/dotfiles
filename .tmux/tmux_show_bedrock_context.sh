#!/bin/bash
tmux showenv -g TMUX_BRCONTEXT_$(tmux display -p "#D" | tr -d %) | sed 's/^.*=//'
