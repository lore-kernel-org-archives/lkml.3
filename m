Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab3IBXzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 19:55:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab3IBXzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 19:55:03 -0400
Date: Mon, 2 Sep 2013 16:57:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc patches for 3.12-rc1
Message-ID: <20130902235737.GB4544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.12-rc1

for you to fetch changes up to 3cc1f95283a125cf54ccf1e25065321d4385133b:

  drivers: uio: Kconfig: add MMU dependancy for UIO (2013-08-30 14:19:46 -0700)

----------------------------------------------------------------
Char/Misc patches for 3.12-rc1

Here is the big char/misc driver pull request for 3.12-rc1

Lots of driver updates all over the char/misc tree, full details in the
shortlog below.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alessandro Rubini (1):
      FMC: fix locking in sample chardev driver

Alexandru Juncu (1):
      pcmcia: synclink_cs: replace sum of bitmasks with OR operation.

Andy King (2):
      VMCI: Remove non-blocking/pinned queuepair support
      VMCI: Add support for virtual IOMMU

Chen Gang (2):
      drivers: parport: Kconfig: exclude h8300 for PARPORT_PC
      drivers: uio: Kconfig: add MMU dependancy for UIO

Greg Kroah-Hartman (5):
      misc: c2port: use dev_bin_attrs instead of hand-coding it
      Revert "misc: c2port: use dev_bin_attrs instead of hand-coding it"
      Merge 3.11-rc3 into char-misc-next.
      Merge tag 'extcon-next-for-3.12' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next
      Merge 3.11-rc6 into char-misc-next

Heiko Stübner (1):
      misc: sram: fix error path in sram_probe

Jan-Simon Möller (1):
      misc: vmw_balloon: Remove braces to fix build for clang.

Jingoo Han (9):
      FMC: Staticize local symbols
      vme: vme_tsi148.c: add missing __iomem annotation
      vme: vme_ca91cx42.c: add missing __iomem annotation
      vme: vme_vmivme7805.c: add missing __iomem annotation
      parport: amiga: remove unnecessary platform_set_drvdata()
      uio: uio_pruss: remove unnecessary platform_set_drvdata()
      drivers: uio_dmem_genirq: use dev_get_platdata()
      drivers: uio_pruss: use dev_get_platdata()
      drivers: uio_pdrv_genirq: use dev_get_platdata()

K. Y. Srinivasan (4):
      Drivers: hv: util: Fix a bug in version negotiation code for util services
      Drivers: hv: balloon: Initialize the transaction ID just before sending the packet
      Drivers: hv: vmbus: Fix a bug in the handling of channel offers
      Drivers: hv: vmbus: Do not attempt to negoatiate a new version prematurely

Kees Cook (4):
      lkdtm: fix stack protector trigger
      lkdtm: add "WARNING" trigger
      lkdtm: add "SPINLOCKUP" trigger
      lkdtm: add "EXEC_*" triggers

Kishon Vijay Abraham I (3):
      extcon: Add an API to get extcon device from dt node
      usb: dwc3: use extcon fwrk to receive connect/disconnect
      extcon: palmas: remove assigning "edev.name" to palmas

Laxman Dewangan (6):
      extcon: palmas: rename device tree binding matching with file name
      extcon: palmas: devicetree: remove non-require property details
      extcon: palmas: remove unused member from palams_usb structure
      extcon: palmas: enable ID_GND and ID_FLOAT detection always
      extcon: palams: add support for suspend/resume
      extcon: palmas: Option to disable ID/VBUS detection based on platform

Mark Brown (3):
      extcon: arizona: Use power efficient workqueue
      extcon: gpio: Use power efficient workqueue for debounce
      extcon: adc-jack: Use power efficient workqueue

Mark Rusk (1):
      drivers/misc/hpilo: Correct panic when an AUX iLO is detected

Michal Simek (1):
      uio: Remove uio_pdrv and use uio_pdrv_genirq instead

Olaf Hering (7):
      Drivers: hv: remove HV_DRV_VERSION
      Tools: hv: fix send/recv buffer allocation
      Tools: hv: check return value of daemon to fix compiler warning.
      Tools: hv: in kvp_set_ip_info free mac_addr right after usage
      Tools: hv: check return value of system in hv_kvp_daemon
      Tools: hv: correct payload size in netlink_send
      Tools: hv: use full nlmsghdr in netlink_send

Oleksandr Kozaruk (1):
      drivers: misc: ti-st: fix potential race if st_kim_start fails

Rostislav Lisovy (1):
      drivers: uio: Add driver for Humusoft MF624 DAQ PCI card

Tomas Hozza (3):
      tools: hv: Improve error logging in VSS daemon.
      tools: hv: Check return value of poll call
      tools: hv: Check return value of setsockopt call

Tomas Winkler (4):
      mei: wake also writers on reset
      mei: bus: do not overflow the device name buffer
      mei: don't get stuck in select during reset
      mei: me: fix hardware reset flow

Uwe Kleine-König (3):
      mm: make generic_access_phys available for modules
      uio: provide vm access to UIO_MEM_PHYS maps
      uio: drop unused vma_count member in uio_device struct

Wei Yongjun (1):
      vme: vme_ca91cx42.c: fix to pass correct device identity to free_irq()

Wolfram Sang (1):
      drivers/misc: don't use devm_pinctrl_get_select_default() in probe

 .../extcon/{extcon-twl.txt => extcon-palmas.txt}   |   6 +-
 Documentation/devicetree/bindings/usb/omap-usb.txt |   5 +
 drivers/char/pcmcia/synclink_cs.c                  |  26 +-
 drivers/extcon/Kconfig                             |   4 +
 drivers/extcon/Makefile                            |   2 +
 drivers/extcon/extcon-adc-jack.c                   |   3 +-
 drivers/extcon/extcon-arizona.c                    |  25 +-
 drivers/extcon/extcon-class.c                      |   3 +-
 drivers/extcon/extcon-gpio.c                       |   2 +-
 drivers/extcon/extcon-palmas.c                     | 134 ++++++---
 drivers/extcon/of_extcon.c                         |  64 +++++
 drivers/fmc/fmc-chardev.c                          |   9 +-
 drivers/fmc/fmc-write-eeprom.c                     |   4 +-
 drivers/hid/hid-hyperv.c                           |   1 -
 drivers/hv/channel_mgmt.c                          |  89 ++++--
 drivers/hv/connection.c                            |   5 +-
 drivers/hv/hv_balloon.c                            |   5 +-
 drivers/hv/hv_kvp.c                                |  26 +-
 drivers/hv/hv_snapshot.c                           |  18 +-
 drivers/hv/hv_util.c                               |  22 +-
 drivers/hv/vmbus_drv.c                             |   1 -
 drivers/misc/atmel-ssc.c                           |   8 -
 drivers/misc/hpilo.c                               |   4 +-
 drivers/misc/lkdtm.c                               |  63 ++++-
 drivers/misc/mei/amthif.c                          |  14 +-
 drivers/misc/mei/bus.c                             |   4 +-
 drivers/misc/mei/client.c                          |  15 +-
 drivers/misc/mei/client.h                          |   9 +-
 drivers/misc/mei/hw-me.c                           |   9 +-
 drivers/misc/mei/init.c                            |  11 +-
 drivers/misc/mei/main.c                            |  22 +-
 drivers/misc/sram.c                                |   3 +-
 drivers/misc/ti-st/st_core.c                       |   2 +
 drivers/misc/vmw_balloon.c                         |   2 +-
 drivers/misc/vmw_vmci/vmci_driver.c                |   2 +-
 drivers/misc/vmw_vmci/vmci_driver.h                |   7 +
 drivers/misc/vmw_vmci/vmci_guest.c                 |  22 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            | 315 ++++++++-------------
 drivers/misc/vmw_vmci/vmci_queue_pair.h            |  18 --
 drivers/net/hyperv/netvsc_drv.c                    |   2 -
 drivers/parport/Kconfig                            |   2 +-
 drivers/parport/parport_amiga.c                    |   1 -
 drivers/scsi/storvsc_drv.c                         |   1 -
 drivers/uio/Kconfig                                |  21 +-
 drivers/uio/Makefile                               |   2 +-
 drivers/uio/uio.c                                  |  40 ++-
 drivers/uio/uio_dmem_genirq.c                      |   2 +-
 drivers/uio/uio_mf624.c                            | 247 ++++++++++++++++
 drivers/uio/uio_pdrv.c                             | 113 --------
 drivers/uio/uio_pdrv_genirq.c                      |   2 +-
 drivers/uio/uio_pruss.c                            |   3 +-
 drivers/usb/dwc3/Kconfig                           |   1 +
 drivers/usb/dwc3/dwc3-omap.c                       | 125 ++++++--
 drivers/video/hyperv_fb.c                          |   1 -
 drivers/vme/boards/vme_vmivme7805.c                |   2 +-
 drivers/vme/bridges/vme_ca91cx42.c                 |  10 +-
 drivers/vme/bridges/vme_tsi148.c                   |   4 +-
 include/linux/extcon/of_extcon.h                   |  31 ++
 include/linux/hyperv.h                             |  31 +-
 include/linux/mfd/palmas.h                         |   8 +-
 include/linux/usb/dwc3-omap.h                      |  30 --
 mm/memory.c                                        |   1 +
 tools/hv/hv_kvp_daemon.c                           |  44 +--
 tools/hv/hv_vss_daemon.c                           |  59 ++--
 64 files changed, 1093 insertions(+), 674 deletions(-)
 rename Documentation/devicetree/bindings/extcon/{extcon-twl.txt => extcon-palmas.txt} (67%)
 create mode 100644 drivers/extcon/of_extcon.c
 create mode 100644 drivers/uio/uio_mf624.c
 delete mode 100644 drivers/uio/uio_pdrv.c
 create mode 100644 include/linux/extcon/of_extcon.h
 delete mode 100644 include/linux/usb/dwc3-omap.h
