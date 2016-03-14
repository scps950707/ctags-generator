# ctags-generator
my script file  for generating Ctags for vim omnicomplete

##Ctags arguments
```sh
--sort=yes
--c-kinds=defgpstux
--fields=+iaS
```
specified output file or header-list
```sh
-f [filename]
-L [header_list]
```
print in human readable format
```sh
-x
```
identifier-list
```sh
-I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW
```


###Example
```sh
ctags -R .
ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
ctags --sort=yes --c-kinds=defgpstux --fields=+iaS /usr/include/stdio.h
ctags --sort=yes --c-kinds=defgpstux --fields=+iaS -x /usr/include/stdio.h
ctags --sort=yes --c-kinds=defgpstux --fields=+iaS -f [filename] -L [header_list]
```


##script for generate project tags


###Full Dependency:
advantage:gcc complier will completely find all dependency as a list which ctags will use it to create project tag
defect:tags to large,so much deep or useless information

command:
```sh
gcc -M  *.[ch] | sed -e 's/[\\ ]/\n/g'|sed -e '/^$/d' -e '/\.o:[ \t]*$/d'| grep -f myincludeheaders | sort -u | ctags -L - --sort=yes --c-kinds=defgpstuxls --fields=+iaS --extra=+q -I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW
```
vim script:
```sh
function! TagFullDepend()
  let command = ''
  let command = ' gcc -M *.[ch] 
        \| sed -e ''s/[\\ ]/\n/g'' 
        \| sed -e ''/^$/d'' -e ''/\.o:[ \t]*$/d'' 
        \| ctags -L - --sort=yes --c-kinds=defgpstux --fields=+iaS --extra=+q 
        \ -I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW '
  execute '!'.command
endfunction
```


###Only Included headers:
advantage:use sed to find all include headers in the current project
defect:maybe some informations are ignored

command:
```sh
sed -n '/#include/p' *.[ch] | sed -e 's/[<>"" ]//g' | sed -e 's/#include//g' | sed -e 's/^.*\///g' | sort -u > myincludeheaders
gcc -M  *.[ch] | sed -e 's/[\\ ]/\n/g'|sed -e '/^$/d' -e '/\.o:[ \t]*$/d'| grep -f myincludeheaders | sort -u | ctags -L - --sort=yes --c-kinds=defgpstux --fields=+iaS --extra=+q -I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW
rm myincludeheaders
```
vim script
```sh
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
        \ -I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW '
  let remove_tmp = ''
  let remove_tmp = 'rm myincludeheaders'
  execute '!'.find_include.' && '.generate_ctags.' && '.remove_tmp
endfunction
```


##key mapping for functions above
```c++
map <C-F10> :<C-u>call TagFullDepend()<CR>
map <F10> :<C-u>call TagFileIncluded()<CR>
```

##list all *.h file with full path in dir
```sh
ls -d -1 $PWD/*.h
```

##ctags --list-kinds=c


|Enabled|Kinds|Description|
|------|---------|-------------------|
|<li>[X]</li>|d|macro definitions|
|<li>[x]</li>|e|enumerators (values inside an enumeration)|
|<li>[x]</li>|f|function definitions|
|<li>[x]</li>|g|enumeration names|
|<li>[ ]</li>|l|local variables [off]|
|<li>[ ]</li>|m|class, struct, and union members|
|<li>[ ]</li>|n|namespaces|
|<li>[x]</li>|p|function prototypes [off]|
|<li>[x]</li>|s|structure names|
|<li>[x]</li>|t|typedefs|
|<li>[x]</li>|u|union names|
|<li>[ ]</li>|v|variable definitions|
|<li>[x]</li>|x|external and forward variable declarations [off]|


##--fields=[+|-]flags

|Enabled|Kinds|Description|
|------|---------|-------------------|
|<li>[X]</li>|a|Access (or export) of class members
|<li>[ ]</li>|f|File-restricted scoping [enabled]
|<li>[X]</li>|i|Inheritance information
|<li>[ ]</li>|k|Kind of tag as a single letter [enabled]
|<li>[ ]</li>|K|Kind of tag as full name
|<li>[ ]</li>|l|Language of source file containing tag
|<li>[ ]</li>|m|Implementation information
|<li>[ ]</li>|n|Line number of tag definition
|<li>[ ]</li>|s|Scope of tag definition [enabled]
|<li>[X]</li>|S|Signature of routine (e.g. prototype or parameter list)
|<li>[ ]</li>|z|Include the "kind:" key in kind field
|<li>[ ]</li>|t|Type and name of a variable or typedef as "typeref:" field [enabled]


##Reference
- [ctags](http://ctags.sourceforge.net/)
- [Generate Ctags Files for C/C++ Source Files and All of Their Included Header Files](https://www.topbug.net/blog/2012/03/17/generate-ctags-files-for-c-slash-c-plus-plus-source-files-and-all-of-their-included-header-files/)
- [ctags ignore lists for libc6, libstdc++ and boost](http://stackoverflow.com/questions/5626188/ctags-ignore-lists-for-libc6-libstdc-and-boost)
