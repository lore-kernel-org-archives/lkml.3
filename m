Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaATVEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:04:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaATVEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:04:51 -0500
Date: Mon, 20 Jan 2014 13:05:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] char/misc patches for 3.14-rc1
Message-ID: <20140120210537.GA32680@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda:

  Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.14-rc1

for you to fetch changes up to 6adb8efb024a7e413b93b22848fc13395b1a438a:

  mei: limit the number of consecutive resets (2014-01-13 14:57:21 -0800)

----------------------------------------------------------------
Char/Misc driver patches for 3.14-rc1

Here's the big char/misc driver patches for 3.14-rc1.

Lots of little things, and a new "big" driver, genwqe.  Full details are
in the shortlog.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (1):
      uio: fix devm_request_irq usage

Alexander Shiyan (3):
      w1: mxc_w1: Remove unused field "clkdiv" from private structure
      w1: mxc_w1: Add warning for base frequency calculation
      w1: mxc_w1: Check the clk_prepare_enable() return value

Alexander Usyskin (2):
      mei: drop redundant list_del_init
      mei: fix syntax in comments and debug output

Andrew Lunn (1):
      Phy: Add a PHY driver for Marvell MVEBU SATA PHY.

Arnd Bergmann (2):
      sgi-xp: open-code interruptible_sleep_on_timeout
      char: nwbutton: open-code interruptible_sleep_on

Boris BREZILLON (2):
      drivers/misc: atmel_tclib: document clock properties
      drivers/misc: atmel-ssc: document clock properties

Chanwoo Choi (2):
      MAINTAINERS: Add git repository for extcon
      extcon: max14577: Add extcon-max14577 driver to support MUIC device

Charles Keepax (5):
      extcon: arizona: Add defines for microphone detection levels
      extcon: arizona: Fix reset of HPDET after race with removal
      extcon: arizona: Fix race with microphone detection and removal
      extcon: arizona: No need to switch back down HPDET ranges
      extcon: arizona: Add support for headphone detection on wm5110 rev D

Dasaratharaman Chandramouli (1):
      misc: mic: bug fix for interrupt acknowledgement in MSI/INTx case.

Dmitry Torokhov (1):
      VMCI: fix error handling path when registering guest driver

Felipe Balbi (1):
      phy: core: properly handle failure of pm_runtime_get functions

Frank Haverkamp (12):
      GenWQE PCI support, health monitoring and recovery
      GenWQE Character device and DDCB queue
      GenWQE Utility functions
      GenWQE Debugfs interfaces
      GenWQE Sysfs interfaces
      GenWQE Enable driver
      GenWQE: Fix endian issues detected by sparse
      GenWQE: Replace dynamic_hex_dump with print_hex_dump_debug
      GenWQE: Accidently casting to u32 where u64 is required
      GenWQE: Rework return code for flash-update ioctl
      GenWQE: Fix compile problems for Alpha
      GenWQE: Fix warnings for sparc

Geert Uytterhoeven (1):
      pcmcia: Remove superfluous name casts

George Cherian (1):
      extcon: palmas: Handle ID interrupt properly using USB_ID_INT_SRC

Greg Kroah-Hartman (4):
      Merge 3.13-rc4 into char-misc-next
      Merge v3.13-rc6 into char-misc-next
      Merge tag 'for_3.14' of git://git.kernel.org/.../kishon/linux-phy into char-misc-next
      Merge tag 'extcon-next-for-3.14' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next

Guenter Roeck (15):
      i8k: Convert to use pr_ functions instead of printk
      i8k: Fix various checkpatch warnings and errors
      i8k: Convert to use to hwmon_device_register_with_groups hwmon API
      i8k: Support additional temperature sensors
      MAINTAINERS: Add myself as i8k maintainer
      i8k: Remove obsolete link to out-of-tree driver
      i8k: Drop driver version number and info message at startup
      i8k: Force SMM to run on CPU 0
      i8k: Add copyright
      i8k: Add support for Dell Studio laptops
      i8k: Add support for Dell XPS M140
      i8k: Use driver_data field of dmi_system_id to override fan multiplier
      i8k: Stop reading SMM BIOS version during driver probe
      i8k: Implement hwmon based fan speed control
      extcon: gpio: Request gpio pin before modifying its state

Jingoo Han (4):
      misc: eeprom_93xx46: remove unnecessary spi_set_drvdata()
      char: amd64-agp: remove DEFINE_PCI_DEVICE_TABLE macro
      uio: uio_mf624: remove DEFINE_PCI_DEVICE_TABLE macro
      parport_pc: remove unnecessary pci_set_drvdata()

Kees Cook (1):
      lkdtm: clean up sparse warnings

Kishon Vijay Abraham I (3):
      phy: phy-core: increment refcounting variables only on 'success'
      phy: phy-core.c: remove unnecessary initialization of local variables
      extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*

Marek Belisko (2):
      misc: bmp085: Clean up and enable use of interrupt for completion.
      misc: bmp085: devicetree irq update.

MyungJoo Ham (1):
      extcon: fix switch class porting guide (Documentation)

Olaf Hering (1):
      Tools: hv: remove inclusion of linux/types.h

Paul Bolle (1):
      Documentation/misc-devices/mei/mei-amt-version.c: remove unneeded call of mei_deinit()

Paul Gortmaker (1):
      drivers/char: don't use module_init in non-modular ttyprintk.c

Peter Hurley (1):
      drivers/misc/ti-st: Prefer tty_driver_flush_buffer

Rashika Kheria (3):
      drivers: misc: Mark function jp_generic_ide_ioctl() as static in lkdtm.c
      drivers: misc: Mark functions as static in ad525x_dpot.c
      drivers: hv: Mark the function hv_synic_free_cpu() as static in hv.c

Rongjun Ying (1):
      extcon: gpio: Add power resume support

Sebastian Andrzej Siewior (2):
      parport: parport_pc: fix id print of a device
      parport: parport_pc: remove double PCI ID for NetMos

SeongJae Park (8):
      Documentation: HOWTO: Update broken links to tpp
      Documentation: ko_KR: Update broken link to tpp
      Documentation: zh_CN: Update broken link to tpp
      Documentation: ja_JP: Update broken link to tpp
      Documentation: HOWTO: update LXR web link in ko_KR
      Documentation: HOWTO: update stable address in ko_KR
      Documentation: HOWTO: update for 2.6.x -> 3.x versioning in ko_KR
      Documentation: HOWTO: Updates on subsystem trees, patchwork, -next (vs. -mm) in ko_KR

Tomas Winkler (9):
      mei: remove flash_work_queue
      mei: cleanup mei_irq_read_handler
      mei: enable marking internal commands
      mei: me: set dma mask using DMA mapping API
      mei: do not run reset flow from the interrupt thread
      mei: use hbm idle state to prevent spurious resets
      mei: nfc: mei_nfc_free has to be called under lock
      mei: revamp mei reset state machine
      mei: limit the number of consecutive resets

Wei Yongjun (1):
      misc: genwqe: fix return value check in genwqe_device_create()

Yongjian Xu (1):
      char: Int overflow in lp_do_ioctl().

 Documentation/ABI/testing/debugfs-driver-genwqe    |   91 ++
 Documentation/ABI/testing/sysfs-driver-genwqe      |   62 +
 Documentation/HOWTO                                |    4 +-
 .../devicetree/bindings/arm/atmel-at91.txt         |    8 +
 .../devicetree/bindings/extcon/extcon-palmas.txt   |    6 +-
 .../devicetree/bindings/misc/atmel-ssc.txt         |    5 +
 Documentation/devicetree/bindings/misc/bmp085.txt  |    4 +
 Documentation/extcon/porting-android-switch-class  |    9 +-
 Documentation/ja_JP/HOWTO                          |    4 +-
 Documentation/ko_KR/HOWTO                          |  130 +-
 Documentation/misc-devices/mei/mei-amt-version.c   |    2 -
 Documentation/zh_CN/HOWTO                          |    4 +-
 MAINTAINERS                                        |    3 +-
 drivers/char/agp/amd64-agp.c                       |    2 +-
 drivers/char/i8k.c                                 |  358 ++---
 drivers/char/lp.c                                  |    2 +
 drivers/char/nwbutton.c                            |    5 +-
 drivers/char/ttyprintk.c                           |    2 +-
 drivers/extcon/Kconfig                             |   10 +
 drivers/extcon/Makefile                            |    1 +
 drivers/extcon/extcon-arizona.c                    |   73 +-
 drivers/extcon/extcon-gpio.c                       |   32 +-
 drivers/extcon/extcon-max14577.c                   |  752 +++++++++++
 drivers/extcon/extcon-palmas.c                     |   17 +-
 drivers/hv/hv.c                                    |    2 +-
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/ad525x_dpot.c                         |    4 +-
 drivers/misc/bmp085-i2c.c                          |    2 +-
 drivers/misc/bmp085-spi.c                          |    2 +-
 drivers/misc/bmp085.c                              |   39 +-
 drivers/misc/bmp085.h                              |    2 +-
 drivers/misc/eeprom/eeprom_93xx46.c                |    1 -
 drivers/misc/genwqe/Kconfig                        |   13 +
 drivers/misc/genwqe/Makefile                       |    7 +
 drivers/misc/genwqe/card_base.c                    | 1205 +++++++++++++++++
 drivers/misc/genwqe/card_base.h                    |  557 ++++++++
 drivers/misc/genwqe/card_ddcb.c                    | 1376 +++++++++++++++++++
 drivers/misc/genwqe/card_ddcb.h                    |  188 +++
 drivers/misc/genwqe/card_debugfs.c                 |  500 +++++++
 drivers/misc/genwqe/card_dev.c                     | 1414 ++++++++++++++++++++
 drivers/misc/genwqe/card_sysfs.c                   |  288 ++++
 drivers/misc/genwqe/card_utils.c                   |  944 +++++++++++++
 drivers/misc/genwqe/genwqe_driver.h                |   77 ++
 drivers/misc/lkdtm.c                               |    7 +-
 drivers/misc/mei/amthif.c                          |    6 +-
 drivers/misc/mei/client.c                          |   27 +-
 drivers/misc/mei/debugfs.c                         |    4 +-
 drivers/misc/mei/hbm.c                             |  239 ++--
 drivers/misc/mei/hbm.h                             |    7 +-
 drivers/misc/mei/hw-me.c                           |   40 +-
 drivers/misc/mei/hw.h                              |    3 +-
 drivers/misc/mei/init.c                            |  278 ++--
 drivers/misc/mei/interrupt.c                       |  122 +-
 drivers/misc/mei/main.c                            |    2 +-
 drivers/misc/mei/mei_dev.h                         |   33 +-
 drivers/misc/mei/nfc.c                             |   20 +-
 drivers/misc/mei/pci-me.c                          |   27 +-
 drivers/misc/mei/wd.c                              |    1 +
 drivers/misc/mic/host/mic_device.h                 |    3 +
 drivers/misc/mic/host/mic_main.c                   |    2 +-
 drivers/misc/mic/host/mic_virtio.c                 |    2 +-
 drivers/misc/mic/host/mic_x100.c                   |   36 +-
 drivers/misc/sgi-xp/xpc_channel.c                  |    5 +-
 drivers/misc/ti-st/st_core.c                       |    2 +-
 drivers/misc/ti-st/st_kim.c                        |    1 -
 drivers/misc/vmw_vmci/vmci_guest.c                 |   10 +-
 drivers/parport/parport_pc.c                       |   20 +-
 drivers/pcmcia/bfin_cf_pcmcia.c                    |    2 +-
 drivers/pcmcia/electra_cf.c                        |    2 +-
 drivers/phy/Kconfig                                |    6 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-core.c                             |   44 +-
 drivers/phy/phy-mvebu-sata.c                       |  137 ++
 drivers/uio/uio.c                                  |    2 +-
 drivers/uio/uio_mf624.c                            |    2 +-
 drivers/w1/masters/mxc_w1.c                        |   31 +-
 include/linux/extcon/extcon-gpio.h                 |    1 +
 include/linux/mfd/arizona/registers.h              |    9 +
 include/uapi/linux/genwqe/genwqe_card.h            |  500 +++++++
 tools/hv/hv_kvp_daemon.c                           |    1 -
 tools/hv/hv_vss_daemon.c                           |    1 -
 82 files changed, 9170 insertions(+), 675 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-driver-genwqe
 create mode 100644 Documentation/ABI/testing/sysfs-driver-genwqe
 create mode 100644 drivers/extcon/extcon-max14577.c
 create mode 100644 drivers/misc/genwqe/Kconfig
 create mode 100644 drivers/misc/genwqe/Makefile
 create mode 100644 drivers/misc/genwqe/card_base.c
 create mode 100644 drivers/misc/genwqe/card_base.h
 create mode 100644 drivers/misc/genwqe/card_ddcb.c
 create mode 100644 drivers/misc/genwqe/card_ddcb.h
 create mode 100644 drivers/misc/genwqe/card_debugfs.c
 create mode 100644 drivers/misc/genwqe/card_dev.c
 create mode 100644 drivers/misc/genwqe/card_sysfs.c
 create mode 100644 drivers/misc/genwqe/card_utils.c
 create mode 100644 drivers/misc/genwqe/genwqe_driver.h
 create mode 100644 drivers/phy/phy-mvebu-sata.c
 create mode 100644 include/uapi/linux/genwqe/genwqe_card.h
