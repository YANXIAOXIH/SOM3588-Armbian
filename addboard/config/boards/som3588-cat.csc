# Rockchip RK3588 octa core 4/8/16GB RAM SoC SPI NVMe 2x USB2 2x USB3 2x HDMI
BOARD_NAME="SOM3588 Cat"
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

	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi1-sound", ENV{SOUND_DESCRIPTION}="HDMI1 Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmiin-sound", ENV{SOUND_DESCRIPTION}="HDMI-In Audio"' >> ${chroot_dir}/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-dp0-sound", ENV{SOUND_DESCRIPTION}="DP0 Audio"' >> ${chroot_dir}/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-es8388-sound", ENV{SOUND_DESCRIPTION}="ES8388 Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules

	return 0
}

function post_family_tweaks_bsp__som3588-cat_bluetooth() {
	display_alert "$BOARD" "Installing ap6611s-bluetooth.service" "info"

	# Bluetooth on this board is handled by a Broadcom (AP6611S) chip and requires
	# a custom brcm_patchram_plus binary, plus a systemd service to run it at boot time
	install -m 755 $SRC/packages/bsp/rk3399/brcm_patchram_plus_rk3399 $destination/usr/bin
	cp $SRC/packages/bsp/rk3399/rk3399-bluetooth.service $destination/lib/systemd/system/ap6611s-bluetooth.service

	# Reuse the service file, ttyS0 -> ttyS7; BCM4345C5.hcd -> SYN43711A0.hcd
	sed -i 's/ttyS0/ttyS7/g' $destination/lib/systemd/system/ap6611s-bluetooth.service
	sed -i 's/BCM4345C5.hcd/SYN43711A0.hcd/g' $destination/lib/systemd/system/ap6611s-bluetooth.service
	return 0
}

function post_family_tweaks__som3588-cat_enable_bluetooth_service() {
	display_alert "$BOARD" "Enabling ap6611s-bluetooth.service" "info"
	chroot_sdcard systemctl enable ap6611s-bluetooth.service
	return 0
}
