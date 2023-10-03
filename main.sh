#/bin/bash

set -e

silent=false

while (( $# >= 1 )); do.
    case $1 in
    --silent) silent=true;;
    *) break;
    esac;
    shift
done

if [ "$silent" = false ] ; then
    read -p "Обновление SSL-сертификатов Let's Encrypt на основании конфигурации nginx. Продолжить? (Y/N):"  confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1;
fi
nginx -T | grep "server_name " > ./s1.list
grep -o '^[^#]*' ./s1.list | sort | uniq  > ./s2.list
sed -i -e 's/server_name//g' ./s2.list
sed -i -e 's/[[:blank:]]//g' ./s2.list
sed -i -e 's/;//g' ./s2.list
rm ./s1.list

echo "Следующие сертификаты будут обновлены:"
cat ./s2.list

if [ $silent = false ]; then
    read -p "Продолжить? (Y/N):"  confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1;
fi

while read p; do
echo 'certbot --nginx -d '
  #certbot --nginx -d "$p"
done <s2.list

rm ./s2.list

