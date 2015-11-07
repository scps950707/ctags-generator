sed -n '/#include/p' *.[ch] | sed -e 's/[<>"" ]//g' | sed -e 's/#include//g' | sed -e 's/^.*\///g' | sort -u > myincludeheaders
gcc -M  *.[ch] | sed -e 's/[\\ ]/\n/g'|sed -e '/^$/d' -e '/\.o:[ \t]*$/d'| grep -f myincludeheaders | sort -u | ctags -L - --sort=yes --c-kinds=defgpstux --fields=+iaS --extra=+q -I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW
rm myincludeheaders
