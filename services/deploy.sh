#!/usr/bin/env bash

cp services/llm-* $HOME/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now llm-serve-start.timer llm-serve-stop.timer
