# Easy fps Editor -> EFPSE-CE -> .script
.Script File syntax highlight, and code folding, 
FOR the Code Text Editor, SciTE by Scintilla
Get it from here:
https://sourceforge.net/projects/scintilla/files/SciTE/

https://www.scintilla.org/SciTEDownload.html

lexers got into scitehome directory as it is called, if its a full install or you have already scite, in recent WINDOWS:
# \programdata\scite\lexers\
properties files got into 
# \programdata\scite\

protible scite will look there frist, and then if nothing exists, it will use the same directory as it self
ergo place properies files next to the scite.exe and make a lexers folder

the scite installer included in this repo is expeirimental as I coded it with ncis installer framework
this adds option for right click menu open in scite tab or new window.

SciTE is like notepad++ but less pink and smaller memory useage. 

TODO:

* .api file to add calltips and code completeion (a magor boon for scite and it's easy to formate one)
* figure out a good way to call efpsce with script to text syntax, since scite supports compiler hooks
 (that's why i use it, instant repl with python and so forth)
* Comming soon, lexer for efpse FSM state files, or you could adjust this for that, the hard work is done thankyou

![image](https://github.com/user-attachments/assets/e29adcb6-7e16-4732-a984-d23bbc35178b)
