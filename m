Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3D2QXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:23:41 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42901 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab3D2QXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:23:39 -0400
Date: Mon, 29 Apr 2013 09:21:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc patches for 3.10-rc1
Message-ID: <20130429162115.GA6893@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 41ef2d5678d83af030125550329b6ae8b74618fa:

  Linux 3.9-rc7 (2013-04-14 17:45:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.10-rc1

for you to fetch changes up to 0e27263926699fcbbd574cff4dd6920007a50e8a:

  Tools: hv: Fix a checkpatch warning (2013-04-24 09:02:36 -0700)

----------------------------------------------------------------
Char / Misc driver update for 3.10-rc1

Here's the big char / misc driver update for 3.10-rc1

A number of various driver updates, the majority being new functionality
in the MEI driver subsystem (it's now a subsystem, it started out just a
single driver), extcon updates, memory updates, hyper-v updates, and a
bunch of other small stuff that doesn't fit in any other tree.

All of these have been in linux-next for a while

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexandru Gheorghiu (1):
      drivers: char: Use PTR_RET function

Ambresh K (1):
      memory: emif: setup LP settings on freq update

Arnd Bergmann (1):
      misc: mark spear13xx-pcie-gadget as broken

Bill Nottingham (1):
      mei: reseting -> resetting

Charles Keepax (1):
      extcon: arizona: Check we report a valid impedance

Chen Gang (1):
      drivers/misc: beautify code: chip->lux_calib is u16 which will never more than APDS_RANGE

Damian Hobson-Garcia (1):
      drivers: uio: Fix UIO device registration failure

Dan Carpenter (1):
      applicom: use correct array offset

David Brown (10):
      fix: Use EXPORT_SYMBOL_GPL
      ssbi: Fix exit mismatch in remove function
      ssbi: Allow compilation as a module
      SSBI: Convert SSBI to device tree
      ssbi: Comment the use of udelay()
      ssbi: Use regular init level
      ssbi: Remove extraneous logging
      SSBI: Remove MSM_ prefix from SSBI drivers
      MAINTAINERS: add ssbi
      mfd: pm8921: Disable driver until it gets fixed

Fabio Estevam (1):
      w1: mxc_w1: Convert to devm_ioremap_resource()

Fabio Porcedda (3):
      drivers: memory: use module_platform_driver_probe()
      drivers: char: use module_platform_driver_probe()
      parport: amiga: use module_platform_driver_probe()

Greg Kroah-Hartman (8):
      Merge tag 'arizona-extcon-asoc' of git://git.kernel.org/.../broonie/misc into char-misc-next
      Merge branch 'char-misc-linus' into char-misc-next
      Merge v3.9-rc5 into char-misc-next
      Merge tag 'extcon-arizona-v3.10' of git://git.kernel.org/.../broonie/misc into char-misc-next
      Merge tag 'extcon-for-3.10' of git://git.kernel.org/.../chanwoo/extcon into char-misc-next
      Merge 3.9-rc7 into char-misc-next
      Revert "scsi: pcmcia: nsp_cs: remove module init/exit function prototypes"
      Revert "drivers/scsi: use module_pcmcia_driver() in pcmcia drivers"

Grygorii Strashko (1):
      memory: emif: errata i743: Prohibit usage of Power-Down mode

Guenter Roeck (1):
      misc/vmw_vmci: Add dependency on CONFIG_NET

H Hartley Sweeten (12):
      pcmcia/ds.h: introduce helper for pcmcia_driver module boilerplate
      drivers/ata: use module_pcmcia_driver() in pcmcia drivers
      drivers/bluetooth: use module_pcmcia_driver() in pcmcia drivers
      drivers/isdn: use module_pcmcia_driver() in pcmcia drivers
      drivers/mmc: use module_pcmcia_driver() in pcmcia drivers
      drivers/parport: use module_pcmcia_driver() in pcmcia drivers
      drivers/scsi: use module_pcmcia_driver() in pcmcia drivers
      drivers/tty: use module_pcmcia_driver() in pcmcia drivers
      drivers/usb: use module_pcmcia_driver() in pcmcia drivers
      sound/pcmcia: use module_pcmcia_driver() in pcmcia drivers
      drivers/net: use module_pcmcia_driver() in pcmcia drivers
      scsi: pcmcia: nsp_cs: remove module init/exit function prototypes

Hiroshi Doyu (1):
      memory: tegra30: Fix build error w/o PM

Jean-Francois Dagenais (2):
      w1: ds2408: make value read-back check a Kconfig option
      w1: ds2408: use ARRAY_SIZE instead of hard-coded number

Jingoo Han (10):
      misc: arm-charlcd: use module_platform_driver_probe()
      misc: atmel_pwm: use module_platform_driver_probe()
      misc: ep93xx_pwm: use module_platform_driver_probe()
      misc: bh1780gli: add CONFIG_PM_SLEEP to suspend/resume functions
      misc: bh1770glc: add CONFIG_PM_SLEEP to suspend/resume functions
      misc: apds990x: add CONFIG_PM_SLEEP to suspend/resume functions
      misc: at25: use spi_get_drvdata() and spi_set_drvdata()
      misc: eeprom_93xx46: use spi_get_drvdata() and spi_set_drvdata()
      misc: lattice-ecp3-config: use spi_get_drvdata()
      extcon: max8997: use dev_err() instead of pr_err()

Jiri Kosina (1):
      dummy-irq: introduce a dummy IRQ handler driver

K. Y. Srinivasan (14):
      Drivers: hv: balloon: Do not request completion notification
      Drivers: hv: balloon: Execute balloon inflation in a separate context
      Drivers: hv: balloon: Execute hot-add code in a separate context
      Drivers: hv: balloon: Make the balloon driver not unloadable
      Drivers: hv: balloon: Implement hot-add functionality
      Drivers: hv: vmbus: Handle channel rescind message correctly
      Drivers: hv: Add a new driver to support host initiated backup
      Drivers: hv: balloon: Permit Linux to specify hot-add alignment requirements
      mm: export split_page()
      Drivers: hv: balloon: Support 2M page allocations for ballooning
      Drivers: hv: Notify the host of permanent hot-add failures
      Drivers: hv: vmbus: Fix a bug in hv_need_to_signal()
      Tools: hv: Fix a checkpatch warning
      Tools: hv: Fix a checkpatch warning

Kenneth Heitke (1):
      add single-wire serial bus interface (SSBI) driver

Kurt Van Dijck (3):
      softingcs: initialize spinlock with macro
      softingcs: use module_pcmcia_driver
      FIX: softingcs conversion to module_pcmcia_driver macro

Lars-Peter Clausen (4):
      misc: apds9802als: Fix suspend/resume
      misc: fsa8480: Use dev_pm_ops
      misc: isl29003: Use dev_pm_ops
      misc: tsl2550: Use dev_pm_ops

Lokesh Vutla (2):
      memory: emif: Fix the lpmode timeout calculation
      memory: emif: Load the correct custom config values from dt

Mark Brown (18):
      extcon: arizona: Factor out magic application
      ASoC: arizona: Fix interaction between headphone outputs and identification
      extcon: arizona: Fix interaction between headphone outputs and identification
      mfd: wm5102: Add registers for microphone detection level configuration
      extcon: arizona: Attempt more microphone measurements
      extcon: arizona: Allow configuration of button detection
      extcon: arizona: Don't pulse MICBIAS for HPDET identification
      extcon: arizona: Allow pull to be disabled on GPIO5 when used for JACKET
      extcon: arizona: Raise minimum microphone impedance for HPDET method
      extcon: arizona: Suppress duplicate JACKDET reports
      extcon: arizona: Tune up HPDET debounce
      extcon: arizona: Retry HPDET identification for high impedance
      extcon: arizona: Don't ground flip when using HPDET identification
      extcon: arizona: Simplify HPDET based identification
      extcon: arizona: Time out if MICDET fails to report
      extcon: arizona: Clear existing button reports before reporting new one
      extcon: arizona: Allow additional debounce during microphone detection
      extcon: arizona: Make mic detection timeout configurable

Nishanth Menon (3):
      memory: emif: handle overflow for timing for LP mode
      memory: emif: Handle devices which are not rated for >85C
      memory: emif: use restart if power_off not present when out of spec

Olaf Hering (5):
      Tools: hv: fix warnings in hv_vss_daemon
      tools: hv: fix checks for origin of netlink message in hv_vss_daemon
      tools: hv: use getmntent in hv_vss_daemon
      tools: hv: use FIFREEZE/FITHAW in hv_vss_daemon
      tools: hv: skip iso9660 mounts in hv_vss_daemon

Oleksandr Dmytryshyn (1):
      memory: emif: Fix the incorrect 'size' parameter in memcpy

Paul Bolle (1):
      misc: Remove max8997-muic.o Makefile line again

Richard Weinberger (2):
      cs5535-mfgpt: Add another reset method
      cs5535-mfgpt: Fix quotation marks

Sachin Kamat (3):
      extcon: max77693: Staticize default_init_data
      extcon: max77693: Fix return value
      extcon: max8997: Fix return value

Samuel Iglesias Gonsalvez (2):
      ipack: add ipack_get_device() ipack_put_device()
      ipack: split ipack_device_register() in several functions

Samuel Ortiz (11):
      mei: bus: Initial MEI Client bus type implementation
      mei: bus: Implement driver registration
      mei: bus: Initial implementation for I/O routines
      mei: bus: Add bus related structures to mei_cl
      mei: bus: Call bus routines from the core code
      mei: bus: Synchronous API for the data transmission
      mei: bus: Implement bus driver data setter/getter
      mei: bus: Add device enabling and disabling API
      mei: nfc: Initial nfc implementation
      mei: nfc: Add NFC device to the MEI bus
      mei: nfc: Implement MEI bus ops

Silviu-Mihai Popescu (1):
      parport: use kmemdup instead of kmalloc + memcpy

Tomas Hozza (3):
      tools: hv: daemon should subscribe only to CN_KVP_IDX group
      tools: hv: daemon setsockopt should use options macros
      tools: hv: daemon should check type of received Netlink msg

Tomas Winkler (18):
      mei: revamp mei_data2slots
      mei: add hw start callback
      mei: add mei_irq_compl_handler function
      mei: drop RECOVERING_FROM_RESET device state
      mei: unregister watchdog from mei_stop function
      mei: ME structures should be initialized in mei_device_init
      mei: rename function mei_hw_init to mei_start
      mei: prefix me hardware specific functions with mei_me_
      mei: move mei-me to separate module
      mei: add debugfs hooks
      mei: add mei_cl_write function
      mei: notify about the reset in error level
      mei: wd: fix line over 80 characters
      mei: revamp hbm state machine
      mei: revamp mei_amthif_irq_read_message
      mei: revamp mei_irq_read_client_message function
      mei: fix reading large reposnes
      mei: reduce flow control only for completed messages

Wei Yongjun (3):
      Drivers: hv: balloon: make local functions static
      mei: convert to use simple_open()
      mei: fix krealloc() misuse in in mei_cl_irq_read_msg()

Zhang Yanfei (1):
      driver: hv: remove cast for kmalloc return value

 Documentation/ABI/testing/sysfs-bus-mei            |   7 +
 Documentation/devicetree/bindings/arm/msm/ssbi.txt |  18 +
 Documentation/misc-devices/mei/mei-client-bus.txt  | 138 +++++
 MAINTAINERS                                        |   1 +
 arch/arm/boot/dts/msm8660-surf.dts                 |   6 +
 arch/arm/boot/dts/msm8960-cdp.dts                  |   6 +
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/ata/pata_pcmcia.c                          |  14 +-
 drivers/bluetooth/bluecard_cs.c                    |  15 +-
 drivers/bluetooth/bt3c_cs.c                        |  15 +-
 drivers/bluetooth/btuart_cs.c                      |  15 +-
 drivers/bluetooth/dtl1_cs.c                        |  15 +-
 drivers/char/applicom.c                            |   4 +-
 drivers/char/hw_random/mxc-rnga.c                  |  13 +-
 drivers/char/hw_random/tx4939-rng.c                |  13 +-
 drivers/char/tile-srom.c                           |   2 +-
 drivers/extcon/extcon-arizona.c                    | 498 ++++++++++++------
 drivers/extcon/extcon-max77693.c                   |  10 +-
 drivers/extcon/extcon-max8997.c                    |  12 +-
 drivers/hv/Makefile                                |   2 +-
 drivers/hv/channel_mgmt.c                          |  11 +
 drivers/hv/hv.c                                    |   5 +-
 drivers/hv/hv_balloon.c                            | 544 +++++++++++++++++---
 drivers/hv/hv_snapshot.c                           | 287 +++++++++++
 drivers/hv/hv_util.c                               |  10 +
 drivers/hv/ring_buffer.c                           |   1 +
 drivers/ipack/carriers/tpci200.c                   |  14 +-
 drivers/ipack/ipack.c                              |  36 +-
 drivers/isdn/hardware/avm/avm_cs.c                 |  14 +-
 drivers/isdn/hisax/avma1_cs.c                      |  14 +-
 drivers/isdn/hisax/elsa_cs.c                       |  14 +-
 drivers/isdn/hisax/sedlbauer_cs.c                  |  14 +-
 drivers/isdn/hisax/teles_cs.c                      |  14 +-
 drivers/memory/emif.c                              | 141 +++++-
 drivers/memory/tegra30-mc.c                        |   2 +
 drivers/mfd/Kconfig                                |   2 +-
 drivers/mfd/pm8921-core.c                          |  14 +-
 drivers/mfd/wm5102-tables.c                        |   8 +
 drivers/misc/Kconfig                               |  10 +-
 drivers/misc/Makefile                              |   2 +-
 drivers/misc/apds9802als.c                         |  25 +-
 drivers/misc/apds990x.c                            |   9 +-
 drivers/misc/arm-charlcd.c                         |  13 +-
 drivers/misc/atmel_pwm.c                           |  12 +-
 drivers/misc/bh1770glc.c                           |   7 +-
 drivers/misc/bh1780gli.c                           |  10 +-
 drivers/misc/cs5535-mfgpt.c                        |  41 +-
 drivers/misc/dummy-irq.c                           |  59 +++
 drivers/misc/eeprom/at25.c                         |   4 +-
 drivers/misc/eeprom/eeprom_93xx46.c                |   6 +-
 drivers/misc/ep93xx_pwm.c                          |  13 +-
 drivers/misc/fsa9480.c                             |  19 +-
 drivers/misc/isl29003.c                            |  19 +-
 drivers/misc/lattice-ecp3-config.c                 |   2 +-
 drivers/misc/mei/Kconfig                           |   5 +-
 drivers/misc/mei/Makefile                          |   9 +-
 drivers/misc/mei/amthif.c                          |  21 +-
 drivers/misc/mei/bus.c                             | 528 ++++++++++++++++++++
 drivers/misc/mei/client.c                          | 116 ++++-
 drivers/misc/mei/client.h                          |   7 +-
 drivers/misc/mei/debugfs.c                         | 143 ++++++
 drivers/misc/mei/hbm.c                             |  82 +--
 drivers/misc/mei/hbm.h                             |  25 +-
 drivers/misc/mei/hw-me.c                           | 124 +++--
 drivers/misc/mei/hw-me.h                           |   6 -
 drivers/misc/mei/init.c                            |  70 +--
 drivers/misc/mei/interrupt.c                       | 242 +++++----
 drivers/misc/mei/main.c                            | 127 ++---
 drivers/misc/mei/mei_dev.h                         | 166 +++++-
 drivers/misc/mei/nfc.c                             | 554 +++++++++++++++++++++
 drivers/misc/mei/pci-me.c                          |  46 +-
 drivers/misc/mei/wd.c                              |   3 +-
 drivers/misc/tsl2550.c                             |  21 +-
 drivers/mmc/host/sdricoh_cs.c                      |  20 +-
 drivers/net/arcnet/com20020_cs.c                   |  14 +-
 drivers/net/can/sja1000/ems_pcmcia.c               |  13 +-
 drivers/net/can/sja1000/peak_pcmcia.c              |  13 +-
 drivers/net/can/softing/softing_cs.c               |  16 +-
 drivers/net/ethernet/3com/3c574_cs.c               |  14 +-
 drivers/net/ethernet/3com/3c589_cs.c               |  14 +-
 drivers/net/ethernet/8390/axnet_cs.c               |  14 +-
 drivers/net/ethernet/8390/pcnet_cs.c               |  14 +-
 drivers/net/ethernet/amd/nmclan_cs.c               |  14 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |  14 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c            |  14 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |  16 +-
 drivers/net/wireless/airo_cs.c                     |  14 +-
 drivers/net/wireless/atmel_cs.c                    |  14 +-
 drivers/net/wireless/b43/pcmcia.c                  |   4 +
 drivers/net/wireless/hostap/hostap_cs.c            |  15 +-
 drivers/net/wireless/libertas/if_cs.c              |  25 +-
 drivers/net/wireless/orinoco/orinoco_cs.c          |  16 +-
 drivers/net/wireless/orinoco/spectrum_cs.c         |  16 +-
 drivers/net/wireless/wl3501_cs.c                   |  14 +-
 drivers/parport/parport_amiga.c                    |  15 +-
 drivers/parport/parport_cs.c                       |  14 +-
 drivers/parport/parport_gsc.c                      |   4 +-
 drivers/parport/parport_sunbpp.c                   |   5 +-
 drivers/parport/procfs.c                           |   6 +-
 drivers/ssbi/Kconfig                               |  16 +
 drivers/ssbi/Makefile                              |   1 +
 drivers/ssbi/ssbi.c                                | 379 ++++++++++++++
 drivers/tty/serial/8250/serial_cs.c                |  14 +-
 drivers/uio/uio.c                                  |   1 +
 drivers/usb/host/sl811_cs.c                        |  15 +-
 drivers/w1/masters/mxc_w1.c                        |   6 +-
 drivers/w1/slaves/Kconfig                          |  10 +
 drivers/w1/slaves/w1_ds2408.c                      |  25 +-
 include/linux/hyperv.h                             |  69 +++
 include/linux/ipack.h                              |  42 +-
 include/linux/mei_cl_bus.h                         |  44 ++
 include/linux/mfd/arizona/core.h                   |   3 +
 include/linux/mfd/arizona/pdata.h                  |  21 +
 include/linux/mfd/arizona/registers.h              |   4 +
 include/linux/mod_devicetable.h                    |   9 +
 include/linux/platform_data/emif_plat.h            |   1 +
 include/linux/ssbi.h                               |  38 ++
 include/pcmcia/ds.h                                |  12 +
 include/uapi/linux/connector.h                     |   5 +-
 mm/page_alloc.c                                    |   1 +
 scripts/mod/devicetable-offsets.c                  |   3 +
 scripts/mod/file2alias.c                           |  12 +
 sound/pcmcia/pdaudiocf/pdaudiocf.c                 |  15 +-
 sound/pcmcia/vx/vxpocket.c                         |  14 +-
 sound/soc/codecs/arizona.c                         |  33 ++
 sound/soc/codecs/arizona.h                         |   3 +
 sound/soc/codecs/wm5102.c                          |   8 +-
 sound/soc/codecs/wm5110.c                          |   8 +-
 tools/hv/hv_kvp_daemon.c                           |  16 +-
 tools/hv/hv_vss_daemon.c                           | 249 +++++++++
 131 files changed, 4596 insertions(+), 1331 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-mei
 create mode 100644 Documentation/devicetree/bindings/arm/msm/ssbi.txt
 create mode 100644 Documentation/misc-devices/mei/mei-client-bus.txt
 create mode 100644 drivers/hv/hv_snapshot.c
 create mode 100644 drivers/misc/dummy-irq.c
 create mode 100644 drivers/misc/mei/bus.c
 create mode 100644 drivers/misc/mei/debugfs.c
 create mode 100644 drivers/misc/mei/nfc.c
 create mode 100644 drivers/ssbi/Kconfig
 create mode 100644 drivers/ssbi/Makefile
 create mode 100644 drivers/ssbi/ssbi.c
 create mode 100644 include/linux/mei_cl_bus.h
 create mode 100644 include/linux/ssbi.h
 create mode 100644 tools/hv/hv_vss_daemon.c
