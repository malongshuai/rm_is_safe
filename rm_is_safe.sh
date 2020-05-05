#!/bin/bash

# 生成/bin/rm
# 它将：
#   1.创建/etc/security/rm_fileignore
#   2.备份/bin/rm到/bin/rm.bak，并生成一个/bin/rm的shell脚本
function rm_is_safe(){
  [ -f /etc/security/rm_fileignore ] || touch /etc/security/rm_fileignore
  if [ ! -f /bin/rm.bak ];then
    file /bin/rm | grep -q ELF && /bin/cp -f /bin/rm /bin/rm.bak
  fi

  cat >/bin/rm<<'eof'
#!/bin/bash

args=$(echo "$*" | tr -s '/' | tr -d "\042\047" )

safe_files=$(find / -maxdepth 1 | tr '\n' '|')$(cat /etc/security/rm_fileignore | tr '\n' '|')
echo "$args" | grep -qP "(?:${safe_files%|})(?:/?(?=\s|$))"

if [ $? -eq 0 ];then
  echo -e "'\e[1;5;33mrm $args\e[0m' is not allowed,Exit..."
  exit 1
fi

/bin/rm.bak "$@"
eof

  chmod +x /bin/rm
}

# 用于卸载
# 卸载时，执行uninstall_rm_safe函数并重新登录bash
function un_rm(){
  # 为所有用户以及未来新用户设置
  if [ ! -f /etc/profile.d/rm_is_safe.sh ];then
    shopt -s nullglob
    for uh in /home/* /root /etc/skel;do
      shopt -u nullglob

cat >>$uh/.bashrc<<'eof'

# for rm_is_safe:
[ -f /etc/profile.d/rm_is_safe.sh ] && source /etc/profile.d/rm_is_safe.sh
eof
    done
  fi

cat >/etc/profile.d/rm_is_safe.sh<<'eof'
function uninstall_rm_is_safe(){
  unset uninstall_rm_is_safe
  /bin/unlink /etc/security/rm_fileignore
  /bin/cp -f /bin/rm.bak /bin/rm
  /bin/unlink /etc/profile.d/rm_is_safe.sh
  shopt -s nullglob
  for uh in /home/* /root /etc/skel;do
    shopt -u nullglob
    sed -ri '\%# for rm_is_safe%,\%/etc/profile.d/rm_is_safe.sh%d' $uh/.bashrc
  done
}
export -f uninstall_rm_is_safe
eof
}

rm_is_safe
un_rm