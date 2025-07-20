{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = [ "git" "z" "sudo" "extract" ];
    };

    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      if [ -f ${config.home.homeDirectory}/.zshrc_custom ]; then
        source ${config.home.homeDirectory}/.zshrc_custom
      fi

      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };
}
