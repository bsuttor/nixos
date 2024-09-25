# Nix config on ubuntu
First copy id_ed25519 and id_rsa keys to your ~/.ssh folder and install utily libs to install computer
```bash
sudo apt install curl git
```

## Install nix

mutli user:

```
sh <(curl -L https://nixos.org/nix/install) --daemon

sudo echo "experintal-features = nix-command flakes" >> /etc/nix/nix.conf
#curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

## Sops
Generate age key from ssh key
```
mkdir -p ~/.config/sops/age/
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/key.txt
```


## Clone nix repo and start nix home manager
```
git clone git@github.com:bsuttor/nix-home.git ~/nix

home-manager switch --flake ~/nix/#$USER
```

### Add secret to sops

```bash
cd ~/nix && sops secrets/secrets.yaml
```

### Use secret with home manager


## Install with my hand
- chrome
- bitwarden desktop
- vscode
- dropbox

## To do after install
- synchro firefox with my user
- synchro vscode
- install vpn ("import from file" works with wireguard on 24.04)
- install docker engine: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
docker daemon can't connect when installing it via home-manager.
```
sudo usermod -aG docker your-user
```
