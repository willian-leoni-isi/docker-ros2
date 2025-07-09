export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="darkblood"

plugins=(git
zsh-syntax-highlighting
  )

source $ZSH/oh-my-zsh.sh

alias rc='source ~/.zshrc'
source /opt/ros/humble/setup.zsh && source /ros_humble/install/setup.zsh

eval "$(register-python-argcomplete3 ros2)"
eval "$(register-python-argcomplete3 colcon)"
