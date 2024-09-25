{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      ctrlp
      editorconfig-vim
      fzf-vim
      gruvbox-community
      gruvbox-material
      mini-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      vim-airline
      vim-elixir
      vim-nix
    ];
    extraConfig = ''
      colorscheme shine
      let g:context_nvim_no_redraw = 1
      set mouse=a
      set number
      set nobackup
      set nowritebackup
      set noswapfile
      set title
      set history=1000
      set undolevels=1000
      set autoread
      set ignorecase
      set wildmenu
      set hlsearch
      nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

      set clipboard=unnamed
      set expandtab
      set shiftwidth=4
      set tabstop=4
      set smarttab

      set ai
      set si
      set wrap
      set autochdir
      set nofoldenable
    '';
  };
}
