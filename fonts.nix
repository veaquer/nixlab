{ pkgs,lib, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.monaspace
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Monaspace Krypton" "JetBrains Mono" ];
        sansSerif = [ "Noto Sans CJK JP" "Noto Sans" ];
        serif     = [ "Noto Serif CJK JP" "Noto Serif" ];
      };
    };
  };
}

