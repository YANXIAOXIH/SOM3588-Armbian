# Rockchip RK3588 core 8/16GB RAM SoC 64/128GB eMMC SATA NVMe 1x USB3 2x USB-C 2x GbE 2x HDMI
BOARD_NAME="SOM3588-Cat"
BOARDFAMILY="rockchip-rk3588"
BOARD_MAINTAINER=""
BOOTCONFIG="som3588-cat_defconfig" # vendor name, not standard, see hook below, set BOOT_SOC below to compensate
BOOT_SOC="rk3588"
KERNEL_TARGET="vendor"
KERNEL_TEST_TARGET="vendor"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/som3588-cat.dtb"
BOOT_SCENARIO="spl-blobs"
BOOT_SUPPORT_SPI="yes"
BOOT_SPI_RKSPI_LOADER="yes"
IMAGE_PARTITION_TABLE="gpt"
enable_extension "bcmdhd"
BCMDHD_TYPE="sdio"

function post_family_tweaks__som3588-cat_naming_audios() {
	display_alert "$BOARD" "Renaming som3588-cat audios" "info"

	mkdir -p $SDCARD/etc/udev/rules.d/
    echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi1-sound", ENV{SOUND_DESCRIPTION}="HDMI1 Audio"' >> ${chroot_dir}/etc/udev/rules.d/90-naming-audios.rules
    echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmiin-sound", ENV{SOUND_DESCRIPTION}="HDMI-In Audio"' >> ${chroot_dir}/etc/udev/rules.d/90-naming-audios.rules
    echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-dp0-sound", ENV{SOUND_DESCRIPTION}="DP0 Audio"' >> ${chroot_dir}/etc/udev/rules.d/90-naming-audios.rules
    echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-es8388-sound", ENV{SOUND_DESCRIPTION}="ES8388 Audio"' >> ${chroot_dir}/etc/udev/rules.d/90-naming-audios.rules
	return 0
}
