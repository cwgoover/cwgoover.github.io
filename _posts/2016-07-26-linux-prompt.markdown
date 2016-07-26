---
layout:     post
title:      "Bash Shell: Change Shell Prompt"
subtitle:   "How to change Shell Prompt under Linux or UNIX"
date:       2016-07-26
author:     "Vivi CAO"
header-img: "img/post-bg-miui6.jpg"
catalog:    true
tags:
    - Linux
    - Shell
---

## What's Shell Prompt

Once you open kind of Terminal on Linux, you should see the Unix command prompt, also known as the `"shell prompt"`, appearing at the left side of your screen. This prompt means the system is waiting for you to type in some Unix command.

Your current shell prompt setting is stored in a shell variable called `PS1`. There are other variables too, like PS2, PS3, and PS4. Bash displays the primary prompt PS1 when it is ready to read a command, and the secondary prompt PS2 when it needs more input to complete a command.

Bash allows these prompt strings to be customized by inserting a number of backslash-escaped special characters.

## Customize your Shell Prompt

The sample of the PS1:

```shell
${debian_chroot:+($debian_chroot)}\[\e[1;31m\]\u\[\e[m\]\[\e[01m\][\[\033[1;33m\]\T \d\[\e[m\]\[\e[01m\]]:\[\e[1;36m\]\w\[\e[01m\]\[\e[m\]\n\[\e[0;32m\]~\$
```

Sample output:

<img src="/img/in-post/post-shell-prompt/post-shell-promp-mine.png" width="800" />

By default the command prompt is set to `[\u@\h \W]\$`. The backslash-escaped special characters are decoded as follows:

* **\u:** display the current username.
* **\h:** display the hostname up to the first '.'.
* **\W:** print the  basename  of the current working direc­tory.
* **\$:** display #(indicates root user) if the effective UID is 0, otherwise display a $.

The sample above also used the backslash-escaped special characters as follows:

* **\T:** display the current time in 12-hour HH:MM:SS format.
* **\d:** display the date  in  "Weekday  Month  Date"  format, (e.g., "Tue May 26").
* **\n:** display newline.

Others:

* **\a:** Display an ASCII bell character (07).
* **\e:** Display an ASCII escape character (033).
* **\H:** Display FQDN hostname.
* **\j:** Display the number of jobs currently managed by the shell.
* **\l:** Display the basename of the shell's terminal device name.
* **\r:** Display a carriage return.
* **\s:** Display the  name  of  the shell, the basename of $0 (the portion following the final slash).
* **\t:** Display the current time in 24-hour HH:MM:SS format.
* **\@:** Display current time in 12-hour am/pm format.
* **\v:** Display the version of bash (e.g., 2.00).
* **\V:** Display the release of bash,  version  +  patchlevel (e.g., 2.00.0).
* **\w:** Display the current working directory.
* **\!:** Display the history number of this command.
* **\#:** Display the command number of this command.
* **\nnn:** Display the character corresponding to the octal number nnn.
* **\\:** Display a backslash.
* **\[:** Display begin a sequence of non-printing characters, which could be used to embed a terminal con­trol sequence into the prompt.
* **\]:** Display end a sequence of non-printing characters.

The colors in the shell prompt are [ANSI escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors), the next topic.

## ANSI escape sequences

**ANSI escape codes are often used in UNIX and UNIX-like terminals to provide syntax highlighting.**

Users can employ escape codes in their scripts by including them as part of standard output or standard error. There is a `sed` command which embellished the output of the make command by displaying lines containing words starting with "WARN" in [reverse video](https://en.wikipedia.org/wiki/Reverse_video) and words starting with "ERR" in bright yellow on a dark red background. ([letter case](https://en.wikipedia.org/wiki/Letter_case) is ignored). The representations of the codes are highlighted.

<img src="/img/in-post/post-shell-prompt/post-shell-promp-sed.png" width="800" />

And now, here we use `non-printing escape sequences` which have to be enclosed in `\[\033[ and \]`. For colour escape sequences, they should also be followed by a lowercase `m`.

Adding colors to the shell prompt with syntax is as below:

```shell
\[\e[x;ym\] $PS1 \[\e[m\]
```
Beware that when you use color escape sequences in your prompt, you should enclose them in escaped (`\` prefixed) square brackets, like this:

```shell
PS1="\[\033[01;32m\]MyPrompt: \[\033[0m\]"
```

Notice the `[`'s interior to the color sequence are not escaped, but the enclosing ones are. The purpose of the latter is to indicate to the shell that the enclosed sequence does not count toward the character length of the prompt. If that count is wrong, weird things will happen when you scroll back through the history, e.g., if it is too long, the excess length of the last scrolled string will appear attached to your prompt and you won't be able to backspace into it (it's ignored the same way the prompt is).

So, we can divide the above shell prompt sample into a few of parts:

1. _**${debian_chroot:+($debian_chroot)}**_
2. _**\\[\e[1;31m\\]\u\\[\e[m\\]**_: `"tcao"`
3. _**\\[\e[01m\\][**_: `"["`
4. _**\\[\033[1;33m\\]\T \d\\[\e[m\\]**_: `"04:17:29 Tue Jul 26"`
5. _**\\[\e[01m\\]]:**_: `"]:"`
6. _**\\[\e[1;36m\]\w\\[\e[01m\\]**_: `"/local/Downloads"`
7. _**\\[\e[m\\]\n**_: `"newline"`
8. _**\\[\e[0;32m\\]~\$**_: `"~$"`


Other shell alternative syntax:

```shell
'\e[x;ym $PS1 \e[m'
```

where,

* **\e[:** Start color scheme. (or `\033[`)
* **x;y:** Color pair to use (x;y)
* **PS1:** Your shell prompt variable.
* **\e[m:** Stop color scheme.

For example, this is incorrect:

```shell
\033]00m\] # white
```

`0` resets the terminal to its default (which is probably white). The actual code for white foreground is 37. Also, the escaped closing brace at the end (`\]`) is not part of the color sequence.(see the above paragraphs)

A list of the color

| **Color** | **Code** | **Color** | **Code** | **Color** | **Code** | **Color** | **Code**
| Black | 0;30 | Blue | 0;34 | Green | 0;32 | Cyan | 0;36
| Red | 0;31 | Purple | 0;35 | Brown | 0;33 | Light Gray | 0;37

| **Color** | **Code** | **Color** | **Code** | **Color** | **Code** | **Color** | **Code**
| Dark Gray | 1;30 | Light Blue | 1;34 | Light Green | 1;32 | Light Cyan | 1;36
| Light Red | 1;31 | Light Purple | 1;35 | Yellow | 1;33 | White | 1;37

## About Color

The original specification only had 8 colors, and just gave them names.

<img src="/img/in-post/post-shell-prompt/post-shell-prompt-color-table.png" width="550" />

The SGR parameters 30-37 selected the foreground color, while 40-47 selected the background. Quite a few terminals implemented "bold" (SGR code 1) as a brighter color rather than a different font, thus providing 8 additional foreground colors. The below example shows how to use background color:

```shell
echo -e "\033[1;45m[copying......]\033[0m $$<"
```

The chart below shows default RGB assignments for some common terminal programs, together with the CSS and the X Window System colors for these color names.

<img src="/img/in-post/post-shell-prompt/post-shell-prompt-color-xwindow.png" width="1000" />

In addition, if you have a 256 color GUI terminal (I think most of them are now), you can apply colors from this chart:

<img src="/img/in-post/post-shell-prompt/post-shell-promp-colors.png" width="1000" />

The ANSI sequence to select these, using the number in the bottom left corner, starts `38;5;` for the foreground and `48;5;` for the background, then the color number, so e.g.:

```shell
echo -e "\\033[48;5;95;38;5;214mhello world\\033[0m"
```

Gives me a light orange on tan (meaning, the color chart is roughly approximated).

You can see the colors in this chart as they would appear on your terminal fairly easily:

```shell
#!/bin/bash

color=16;

while [ $color -lt 245 ]; do
    echo -e "$color: \\033[38;5;${color}mhello\\033[48;5;${color}mworld\\033[0m"
    ((color++));
done  
```

The output is self-explanatory.

## Make prompt setting permanent

To have it set every time you login to your workstation add your customized PS1 to your `$HOME/.bash_profile` file or `$HOME/.bashrc` file.

```shell
$ cd
$ vi .bash_profile
```

Or

```shell
$ cd
$ vi .bash_profile
```

Append your PS1 or the following line:

```shell
export PS1="\e[0;31m[\u@\h \W]\$ \e[m"
```

save and close the file.
<br>

### Reference

* [BASH Shell: Change The Color of My Shell Prompt Under Linux or UNIX](http://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/)
* [Bash Prompt HOWTO: Colours](http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html)
* [Bash Prompt HOWTO: Bash Prompt Escape Sequences](http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html)
* [What color codes can I use in my PS1 prompt?](http://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-ps1-prompt)
