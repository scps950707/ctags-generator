# ctags-generator
my script file  for generating Ctags for vim omnicomplete

##Ctags arguments
```
--sort=yes
--c-kinds=defgpstux
--fields=+iaS
```
specified output file or header-list
```
-f [filename]
-L [header_list]
```
print in human readable format
```
-x
```
identifier-list
```
-I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW
```


###Example
```
ctags --sort=yes --c-kinds=defgpstux --fields=+iaS /usr/include/stdio.h
ctags --sort=yes --c-kinds=defgpstux --fields=+iaS -x /usr/include/stdio.h
ctags --sort=yes --c-kinds=defgpstux --fields=+iaS -f [filename] -L [header_list]
```


##script for generate project tags


###Full Dependency:
advantage:gcc complier will completely find all dependency as a list which ctags will use it to create project tag
defect:tags to large,so much deep or useless information

command:
```
gcc -M  *.[ch] | sed -e 's/[\\ ]/\n/g'|sed -e '/^$/d' -e '/\.o:[ \t]*$/d'| grep -f myincludeheaders | sort -u | ctags -L - --sort=yes --c-kinds=defgpstuxls --fields=+iaS --extra=+q -I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW
```
vim script:
```
function! TagFullDepend()
  let command = ''
  let command = ' gcc -M *.[ch] 
        \| sed -e ''s/[\\ ]/\n/g'' 
        \| sed -e ''/^$/d'' -e ''/\.o:[ \t]*$/d'' 
        \| ctags -L - --sort=yes --c-kinds=defgpstux --fields=+iaS --extra=+q 
        \-I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW '
  execute '!'.command
endfunction
```


###Only Included headers:
advantage:use sed to find all include headers in the current project
defect:maybe some informations are ignored

command:
```
sed -n '/#include/p' *.[ch] | sed -e 's/[<>"" ]//g' | sed -e 's/#include//g' | sed -e 's/^.*\///g' | sort -u > myincludeheaders
gcc -M  *.[ch] | sed -e 's/[\\ ]/\n/g'|sed -e '/^$/d' -e '/\.o:[ \t]*$/d'| grep -f myincludeheaders | sort -u | ctags -L - --sort=yes --c-kinds=defgpstux --fields=+iaS --extra=+q -I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW
rm myincludeheaders
```
vim script
```
function! TagFileIncluded()
  let find_include = ''
  let find_include = '
        \sed -n ''/\#include/p'' *.[ch] 
        \| sed -e ''s/[<>"" ]//g'' 
        \| sed -e ''s/\#include//g'' 
        \| sed -e ''s/^.*\///g'' 
        \| sort -u 
        \ > myincludeheaders '
  let generate_ctags = ''
  let generate_ctags = '
        \gcc -M *.[ch] 
        \| sed -e ''s/[\\ ]/\n/g'' 
        \| sed -e ''/^$/d'' -e ''/\.o:[ \t]*$/d'' 
        \| grep -f myincludeheaders 
        \| sort -u 
        \| ctags -L - --sort=yes --c-kinds=defgpstux --fields=+iaS --extra=+q 
        \-I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW '
  let remove_tmp = ''
  let remove_tmp = 'rm myincludeheaders'
  execute '!'.find_include.' && '.generate_ctags.' && '.remove_tmp
endfunction
```


##key mapping for functions above
```
map <C-F10> :<C-u>call TagFullDepend()<CR>
map <F10> :<C-u>call TagFileIncluded()<CR>
```

##list all *.h file with full path in dir
```
ls -d -1 $PWD/*.h
```


##ctags --list-kinds=c
```
c  classes
d  macro definitions
e  enumerators (values inside an enumeration)
f  function definitions
g  enumeration names
l  local variables [off]
m  class, struct, and union members
n  namespaces
p  function prototypes [off]
s  structure names
t  typedefs
u  union names
v  variable definitions
x  external and forward variable declarations [off]
```


##my options
- [ ] c  classes
- [X] d  macro definitions
- [X] e  enumerators (values inside an enumeration)
- [X] f  function definitions
- [X] g  enumeration names
- [ ] l  local variables
- [ ] m  class, struct, and union members
- [ ] n  namespaces
- [X] p  function prototypes
- [X] s  structure names
- [X] t  typedefs
- [X] u  union names
- [ ] v  variable definitions
- [X] x  external and forward variable declarations


##--fields=[+|-]flags
```
a   Access (or export) of class members
f   File-restricted scoping [enabled]
i   Inheritance information
k   Kind of tag as a single letter [enabled]
K   Kind of tag as full name
l   Language of source file containing tag
m   Implementation information
n   Line number of tag definition
s   Scope of tag definition [enabled]
S   Signature of routine (e.g. prototype or parameter list)
z   Include the "kind:" key in kind field
t   Type and name of a variable or typedef as "typeref:" field [enabled]
```

##Reference
- [ctags](http://ctags.sourceforge.net/)
- [Generate Ctags Files for C/C++ Source Files and All of Their Included Header Files](https://www.topbug.net/blog/2012/03/17/generate-ctags-files-for-c-slash-c-plus-plus-source-files-and-all-of-their-included-header-files/)
- [ctags ignore lists for libc6, libstdc++ and boost](http://stackoverflow.com/questions/5626188/ctags-ignore-lists-for-libc6-libstdc-and-boost)