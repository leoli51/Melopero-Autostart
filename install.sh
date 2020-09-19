#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

autostart_dir="/home/melopero-autostart/"
scripts_dir="${autostart_dir}scripts/"
uninstall_dir="${autostart_dir}uninstall/"
    
bash_script_name="StartScripts.sh"
instructions_name="instructions.txt"
uninstall_script_name="uninstall.sh"
uninstall_instructions_name="uninstall_instructions.txt"
    
systemd_dir="/etc/systemd/system/"
service_unit_name="melopero-autostart.service"

#create dirs if they do not exist
[[ -d "${autostart_dir}" ]] || mkdir "${autostart_dir}"
[[ -d "${uninstall_dir}" ]] || mkdir "${uninstall_dir}"
[[ -d "${scripts_dir}" ]] || mkdir "${scripts_dir}"

# copy scripts and txt files
cp $bash_script_name $autostart_dir
chmod 554 "${autostart_dir}${bash_script_name}"
cp $instructions_name $autostart_dir
chmod 444 "${autostart_dir}${instructions_name}"
cp $uninstall_script_name $uninstall_dir
chmod 554 "${uninstall_dir}${uninstall_script_name}"
cp $uninstall_instructions_name $uninstall_dir
chmod 444 "${uninstall_dir}${uninstall_instructions_name}"

# copy system service unit
cp $service_unit_name $systemd_dir
chmod 664 "$systemd_dir$service_unit_name"
chown root "$systemd_dir$service_unit_name"
chgrp root "$systemd_dir$service_unit_name"

# enabling service
systemctl daemon-reload && systemctl enable $service_unit_name
if [[ $? -eq 0 ]]; then 
    echo "Melopero-Autostart successfully installed  is installed "
else 
    echo "WARNING: Service could not be activated."