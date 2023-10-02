#/bin/bash
read -p "Обновление SSL-сертификатов Let's Encrypt на основании конфигурации nginx. Продолжить? (Y/N):"  confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
set -e
nginx -T | grep "server_name " > ./s1.list
grep -o '^[^#]*' ./s1.list | sort | uniq  > ./s2.list
sed -i -e 's/server_name//g' ./s2.list
sed -i -e 's/[[:blank:]]//g' ./s2.list
sed -i -e 's/;//g' ./s2.list
rm ./s1.list

echo "Следующие сертификаты будут обновлены:"
cat ./s2.list
read -p "Продолжить? (Y/N):"  confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

while read p; do
  certbot --nginx -d "$p"
done <s2.list

rm ./s2.list
