# setting up new environment.


## change bash to fish

```
$ chsh -s /usr/bin/fish
```

## change directory color (for windows WSL)

1. go to ~/.config/fish
2. execute `dircolors --print-database >> .dircolors`
    this will output dircolors to a file called `.dircolors`
3. edit `config.fish`, add `eval (dircolors -c ~/.config/fish/.dircolors)`
    this will make fish use the `.dircolors` specified.
    we can now change colors setting in .dircolors file to change the
    directory color printed in fish shell.

## add alias, forexample, make `vi` equals to `nvim` in fish

It's just two lines of shell script. First we type:
```
alias vi "nvim"
```
to make vi equals "nvim" in current shell. Then we type:
```
funcsave vi
```
to write this alias vi to `~/.config/fish/funtions/vi.fish`,
so that each time we're in fish, this alias is already known by fish.
