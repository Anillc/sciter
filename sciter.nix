{
stdenv,
system,
makeWrapper,
fetchFromGitLab,
autoPatchelfHook,
gtk3,
pango,
cairo,
gdk-pixbuf,
glib,
fontconfig,
freetype,
xorg,
libuuid,
...
}: let
  folder = {
    "x86_64-linux" = "x64";
    "aarch64-linux" = "arm64";
  };
in stdenv.mkDerivation rec {
  pname = "sciter";
  version = "5.0.2.18";

  src = fetchFromGitLab {
    owner = "sciter-engine";
    repo = "sciter-js-sdk";
    rev = version;
    sha256 = "sha256-3aAKWi1pAgCHXISPcQXruMdQ4AuLq56QFTa8VcYtU80=";
  };

  buildInputs = [
    gtk3
    pango
    cairo
    gdk-pixbuf
    glib
    fontconfig
    freetype
    xorg.libX11
    libuuid
  ];
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildPhase = ''
    mkdir -p $out/{bin,lib}
    cp bin/linux/${folder.${system}}/libsciter.so $out/lib
    cp bin/linux/${folder.${system}}/{scapp,inspector} $out/bin
    chmod +x $out/bin/*
    wrapProgram $out/bin/inspector --prefix LD_LIBRARY_PATH : $out/lib
  '';
}