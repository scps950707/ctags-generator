ls -R | grep '\..*[ch]p*p*$' | xargs sed -n '/include/p' | sed 's/#include//g;s/[>< ]//g' | sort -u > myheaders
ls -R | grep '\..*[ch]p*p*$' | xargs gcc -M | sed 's/[\\ ]/\n/g' | sed '/^$/d;/\.o:[ \t]*$/d' | grep -f myheaders | sort -u | ctags -L - --sort=yes --c-kinds=defgpstux --fields=+iaS --extra=+q -I __attribute__,__attribute_malloc__,__attribute_pure__,__wur,__THROW
rm myheaders
