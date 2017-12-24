#!/bin/bash
LC_ALL=en_US.UTF-8
# configures/installs common CHIP features (including enabling disabled ones)
# run 'sudo chmod +x setup.sh && ./setup.sh' to run the installation
clear
res=
dtc=
rboot=
uname -a
cat << _EOF_
===========================================================================

                          ▒▒▒       ▒▒▒       ▒▒░
                          ▒▒▒       ▒▒▒       ▒▒░
                          ▒▒▒       ▒▒▒       ▒▒░
                   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
                   ▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒
                   ▒▒░                              ░▒▒
             ▒▒▒▒▒▒▒▒░                              ░▒▒▒▒▒▒▒▒▒
                   ▒▒░       ▒▒▒▒                   ░▒▒
                   ▒▒░     ▒▒▒▒▒▒▒▒                 ░▒▒
                   ▒▒░     ▒▒▒▒▒▒▒▒░                ░▒▒
                   ▒▒░      ▒▒▒▒▒▒▒▒▒▒              ░▒▒
             ▒▒▒▒▒▒▒▒░       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
                   ▒▒░                              ░▒▒
                   ▒▒░                              ░▒▒
                   ▒▒░                              ░▒▒
             ▒▒▒▒▒▒▒▒░                              ░▒▒▒▒▒▒▒▒▒
                   ▒▒░                              ░▒▒
                   ▒▒░                              ░▒▒
                   ▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒
                   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
                          ▒▒▒        ▒▒▒       ▒▒▒
                          ▒▒▒        ▒▒▒       ▒▒▒
                          ▒▒▒        ▒▒▒       ▒▒▒

                   ____      _   _      ___       ____
                  / ___|    | | | |    |_ _|     |  _ \
                 | |        | |_| |     | |      | |_) |
                 | |___   _ |  _  |  _  | |      | |__/
                  \____| (_)|_| |_| (_)|___| (_) |_|   (_)
===========================================================================
                   ______  ______ _______ _     _  _____
                  |______ |______    |    |     | |_____]
                  ______| |______    |    |_____| |
===========================================================================
_EOF_

# install build-essential
echo "==========================================================================="
yn=("*** Skip ***" "Install required \"build-essential\" for C/C++ compilation")
yna=
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna || -z "$yna" ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  sudo apt-get -y install build-essential
fi

# enable device tree overlay hw
echo "==========================================================================="
dtcInstall() {
  if [[ $dtc != 1 ]]; then
    sudo apt install device-tree-compiler
    # sudo dtc -I dtb -O dts -o /boot/sun5i-r8-chip.dts /boot/sun5i-r8-chip.dtb
    # # decompile DTB
    sudo cp /boot/sun5i-r8-chip.dtb /boot/sun5i-r8-chip.dtb.bak.$(date -d "today" +"%Y%m%d%H%M")
    dtc=1
  fi
}
# enable /dev/i2c-1
echo "---------------------------------------------------------------------------"
echo "By default /dev/i2c-1 (I2C on bus 1) is \"disabled\" in CHIP's DTB."
echo "Enabling i2c-1 will allow you to use the TWI1-SDA/TWI1-SCK pins on your CHIP."
echo "This process requires an update to /boot/sun5i-r8-chip.dtb"
yn=("*** Skip ***" "Update CHIP's DTB to enable /dev/i2c-1")
yna=
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna || -z "$yna" ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  read -p "Enter the clock-frequency for /dev/i2c-1 between 3814-400000 (default 100000): " res
  if [[ -z "$res" || ! "$res" =~ ^[0-9]*$ ]]; then
    res=100000
  elif [[ $res -lt 3814 ]]; then
    res=3814
  elif [[ $res -gt 400000 ]]; then
    res=400000
  fi
  echo "Setting clock-frequency to $res"
  dtcInstall "i2c1"
  sudo fdtput -t s /boot/sun5i-r8-chip.dtb "/aliases" "i2c1" "/soc@01c00000/i2c@01c2b000"
  sudo fdtput -t s /boot/sun5i-r8-chip.dtb "/soc@01c00000/i2c@01c2b000" "status" "okay"
  sudo fdtput -t s /boot/sun5i-r8-chip.dtb "/soc@01c00000/i2c@01c2b000" "pinctrl-names" "default"
  sudo fdtput -t x /boot/sun5i-r8-chip.dtb "/soc@01c00000/i2c@01c2b000" "pinctrl-0" "0x38" # 0x5e for older v4.4
  sudo fdtput -t i /boot/sun5i-r8-chip.dtb "/soc@01c00000/i2c@01c2b000" "clock-frequency" "${res}";
  rboot=1
fi
# enable pwm0
echo "---------------------------------------------------------------------------"
echo "By default /sys/class/pwm/pwmchip0 is \"disabled\" in CHIP's DTB."
echo "Enabling pwm0 will allow you to use the PWM0 pin on your CHIP."
echo "This process requires an update to /boot/sun5i-r8-chip.dtb"
yn=("*** Skip ***" "Update CHIP's DTB to enable PWM0")
yna=
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna || -z "$yna" ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  dtcInstall "pwm0"
  sudo fdtput -t s /boot/sun5i-r8-chip.dtb "/soc@01c00000/pwm@01c20e00" "status" "okay"
  sudo fdtput -t s /boot/sun5i-r8-chip.dtb "/soc@01c00000/pwm@01c20e00" "pinctrl-names" "default"
  sudo fdtput -t x /boot/sun5i-r8-chip.dtb "/soc@01c00000/pwm@01c20e00" "pinctrl-0" "0x67" # 0x63 for older v4.4
  rboot=1
fi

# generate self-signed certificate for node.js HTTPS/TLS connections
yn=("*** Skip ***" "Generate required self-signed certificate for HTTPS/TLS")
yna=
echo "==========================================================================="
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  sudo openssl req -x509 -sha256 -newkey rsa:2048 -keyout /etc/ssl/private/key.pem -out /etc/ssl/certs/cert.pem -days 18250 -nodes
  echo "Generated /etc/ssl/private/key.pem and /etc/ssl/certs/cert.pem"
fi
exit 0 #Exit with success
