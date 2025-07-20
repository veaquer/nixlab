self: super: {
  picom = super.picom.overrideAttrs (oldAttrs: rec {
    pname = "picom-jonaburg";
    version = "git";

    src = super.fetchFromGitHub {
      owner = "jonaburg";
      repo = "picom";
      rev = "master"; # or specific commit
      sha256 =
        "sha256-L1mD7KiC8SmB3b+XubTnYz6gT0E7q9TrEiLBzXBeS0o="; # placeholder
    };

    mesonFlags = [ "-Dwith_docs=false" "-Dbuildtype=release" "-Dbackend=glx" ];

    nativeBuildInputs = oldAttrs.nativeBuildInputs
      ++ [ super.meson super.ninja super.pkg-config ];

    buildInputs = oldAttrs.buildInputs ++ [
      super.xorg.libX11
      super.xorg.libXcomposite
      super.xorg.libXdamage
      super.xorg.libXfixes
      super.libconfig
      super.pcre
      super.xorg.libXrender
      super.dbus
      super.xorg.libXext
      super.xorg.libXrandr
      super.xorg.libXinerama
      super.xorg.xorgproto
    ];
  });
}
