# NixOS config

## clone repo



## Sops

First, generete age key from ssh key :
```
mkdir -p ~/.config/sops/age/
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/key.txt
```

### Create .sops.yaml file


### Add secret to sops


### Use secret with home manager
