{ config, pkgs, ... }:
let
  nvpn = pkgs.stdenv.mkDerivation rec {
    pname = "nvpn";
    version = "0.2.27";
    src = pkgs.fetchurl {
      url = "https://github.com/mmalmi/nostr-vpn/releases/download/v${version}/nvpn-v${version}-x86_64-unknown-linux-musl.tar.gz";
      sha256 = "sha256-Cy0A/1lx3QhPqx1fl2AaoYRIvwVhGsyNG3f7red/UBI=";
    };
    sourceRoot = "nvpn";
    installPhase = ''
      mkdir -p $out/bin
      cp nvpn $out/bin/
      chmod +x $out/bin/nvpn
    '';
  };
in
{
  home.packages = [ nvpn ];
}
