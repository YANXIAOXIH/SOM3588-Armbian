# Rockchip RK3588 core 8/16GB RAM SoC 64/128GB eMMC SATA NVMe 1x USB3 2x USB-C 2x GbE 2x HDMI
BOARD_NAME="SOM3588 Cat"
BOARDFAMILY="rockchip-rk3588"
BOARD_MAINTAINER=""
BOOTCONFIG="som3588-cat_defconfig"
KERNEL_TARGET="vendor,edge"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/som3588-cat.dtb"
BOOT_SCENARIO="spl-blobs"
BOOT_SOC="rk3588"
IMAGE_PARTITION_TABLE="gpt"

function post_family_tweaks__som3588cat_naming_audios() {
	display_alert "$BOARD" "Renaming som3588-cat audios" "info"
	mkdir -p $SDCARD/etc/udev/rules.d/
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi0-sound", ENV{SOUND_DESCRIPTION}="HDMI1 Audio"' > $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmiin-sound", ENV{SOUND_DESCRIPTION}="HDMI-In Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules

	return 0
}

function post_family_config_branch_vendor__kernel_som3588-cat() {

    display_alert "$BOARD" " up kernel ${KERNEL_MAJOR_MINOR} for" "${BOARD}" "info"
	declare -g KERNEL_MAJOR_MINOR="6.1" 
	declare -g KERNELSOURCE='https://github.com/radxa/kernel.git'
	declare -g KERNELBRANCH='branch:linux-6.1-stan-rkr4.1'
    declare -g -i KERNEL_GIT_CACHE_TTL=120 # 2 minutes; this is a high-traffic repo

}
