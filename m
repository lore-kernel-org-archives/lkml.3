Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaKIXGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 18:06:12 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54957 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaKIXGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 18:06:11 -0500
MIME-Version: 1.0
Date: Sun, 9 Nov 2014 15:06:09 -0800
X-Google-Sender-Auth: NmPGKZHp3DvaULFydACZjZuG0q4
Message-ID: <CA+55aFxCHAoCPDCp3HexZNXdMtM=omX586CizLz5=ydV9Lmbgg@mail.gmail.com>
Subject: Linux 3.18-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, things are finally calming down. In fact, it looked *really* calm
until yesterday, at which point some people clearly realized "hey, I
should push my stuff to Linus so that it makes it into -rc4", and then
a third of all changes came in the last day, but despite that, rc4
finally looks like things are falling into place, and we'll get to
stabilize this release after all.

Here's to hoping the trend holds...

Things look fairly normal. A bit over half is drivers, and almost a
third is architecture patches (arm, powerpc, mips and s390). The rest
is  a few filesystem updates (mainly XFS) and misc random stuff.

The shortlog gives a feel for the details, and nothing looks
particularly scary or odd.

                        Linus

---

Aaron Lu (1):
      toshiba_acpi: Add Toshiba TECRA A50-A to the alt keymap dmi list

Adel Gadllah (2):
      USB: quirks: enable device-qualifier quirk for another Elan touchscreen
      USB: quirks: enable device-qualifier quirk for yet another Elan
touchscreen

Akihiro Tsukada (3):
      [media] dvb:tc90522: fix stats report
      [media] dvb-core: set default properties of ISDB-S
      [media] dvb:tc90522: fix always-false expression

Al Viro (1):
      fix breakage in o2net_send_tcp_msg()

Alan Stern (1):
      usb-storage: handle a skipped data phase

Alexander Stein (1):
      spi: fsl-dspi: Fix CTAR selection

Alexander Sverdlin (1):
      MIPS: Octeon: Make Octeon GPIO IRQ chip CPU hotplug-aware

Amit Daniel Kachhap (1):
      arm64: psci: fix cpu_suspend to check idle state type for index

Andreas Färber (1):
      ARM: dts: zynq: Enable PL clocks for Parallella

Anton Blanchard (1):
      powerpc: do_notify_resume can be called with bad thread_info
flags argument

Aristeu Rozanski (1):
      tiny: reverse logic for DISABLE_DEV_COREDUMP

Arnd Bergmann (1):
      dma: edma: move device registration to platform code

Axel Lin (1):
      soc: versatile: Add terminating entry for realview_soc_of_match

Bartlomiej Zolnierkiewicz (10):
      thermal: exynos: remove unused struct exynos_tmu_registers entries
      thermal: exynos: remove dead code for HW_MODE calibration
      thermal: exynos: remove redundant pdata checks from
exynos_tmu_initialize()
      thermal: exynos: remove redundant threshold_code checks from
exynos_tmu_initialize()
      thermal: exynos: simplify temp_to_code() and code_to_temp()
      thermal: exynos: cache non_hw_trigger_levels in pdata
      thermal: exynos: remove redundant pdata checks from exynos_tmu_control()
      thermal: exynos: remove identical values from
exynos*_tmu_registers structures
      thermal: samsung: Exynos5260 and Exynos5420 should not use
TRIM_RELOAD flag
      thermal: exynos: fix IRQ clearing on TMU initialization

Benjamin Herrenschmidt (1):
      powerpc/powernv: Properly fix LPC debugfs endianness

Brian Foster (1):
      xfs: rework zero range to prevent invalid i_size updates

Catalin Marinas (1):
      arm64: compat: Enable bpf syscall

Chanwoo Choi (2):
      thermal: exynos: Add support for many TRIMINFO_CTRL registers
      thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250

Chris Mason (1):
      Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup

Dan Carpenter (1):
      USB: HWA: fix a warning message

Dan Murphy (1):
      iio: tsl4531: Fix compiler error when CONFIG_PM_OPS is not defined

Dan Streetman (1):
      powerpc: use device_online/offline() instead of cpu_up/down()

Daniel Baluta (1):
      io: accel: kxcjk-1013: Fix iio_event_spec direction

Dave Chinner (7):
      xfs: bulkstat doesn't release AGI buffer on error
      xfs: bulkstat btree walk doesn't terminate
      xfs: bulkstat chunk formatting cursor is broken
      xfs: bulkstat chunk-formatter has issues
      xfs: bulkstat main loop logic is a mess
      xfs: bulkstat error handling is broken
      xfs: track bulkstat progress by agino

David Cohen (2):
      pinctrl: use linux-gpio mailing list
      pinctrl: baytrail: show output gpio state correctly on Intel Baytrail

David Henningsson (2):
      ALSA: hda - Set GPIO 4 low for a few HP machines
      ALSA: hda - change three SSID quirks to one pin quirk

Dinh Nguyen (1):
      ARM: socfpga_defconfig: Update defconfig for SoCFPGA

Dmitry Eremin-Solenikov (1):
      spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM

Fabian Frederick (1):
      powerpc: Fix section mismatch warning

Fabio Estevam (2):
      ARM: imx: Fix the removal of CONFIG_SPI option
      iio: adc: mxs-lradc: Disable the clock on probe failure

Fengguang Wu (1):
      [media] sp2: sp2_init() can be static

Francesco Ruggeri (1):
      tty: Fix pty master poll() after slave closes v2

Geert Uytterhoeven (2):
      m68k: Wire up bpf
      thermal: rcar: Add binding docs for new R-Car Gen2 SoCs

George McCollister (1):
      iio: as3935: allocate correct iio_device size

Grant Likely (1):
      of: Fix overflow bug in string property parsing functions

Greg Kroah-Hartman (1):
      Revert "storage: Replace magic number with define in
usb_stor_euscsi_init()"

Grzegorz Jaszczyk (2):
      irqchip: armada-370-xp: Fix MSI interrupt handling
      irqchip: armada-370-xp: Fix MPIC interrupt handling

Hans Verkuil (1):
      [media] vivid: default to single planar device instances

Hans de Goede (7):
      samsung-laptop: Add broken-acpi-video quirk for NC210/NC110
      acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80
      usb: Do not allow usb_alloc_streams on unconfigured devices
      uas: Add US_FL_NO_ATA_1X quirk for 1 more Seagate model
      xhci: Disable streams on Asmedia 1042 xhci controllers
      uas: Add NO_ATA_1X for VIA VL711 devices
      uas: Add US_FL_NO_ATA_1X quirk for 2 more Seagate models

Hari Bathini (1):
      powerpc/fadump: Fix endianess issues in firmware assisted dump handling

Heiko Carstens (2):
      s390/vdso: fix stack corruption
      s390/ftrace: add ftrace_graph_is_dead() check

Hui Wang (1):
      ALSA: hda - fix mute led problem for three HP laptops

Ilya Dryomov (2):
      rbd: use a single workqueue for all devices
      libceph: eliminate unnecessary allocation in process_one_ticket()

Imre Deak (1):
      tty/vt: don't set font mappings on vc not supporting this

Isamu Mogi (1):
      MIPS: R3000: Fix debug output for Virtual page number

Jan Kara (4):
      xfs: Check error during inode btree iteration in xfs_bulkstat()
      mm: Remove false WARN_ON from pagecache_isize_extended()
      rbd: Fix error recovery in rbd_obj_read_sync()
      mm: Fix comment before truncate_setsize()

Javier Martinez Canillas (5):
      regulator: max1586: zero-initialize regulator match table array
      regulator: max77686: zero-initialize regulator match table
      regulator: max77802: zero-initialize regulator match table
      regulator: max8660: zero-initialize regulator match table array
      regulator: s2mpa01: zero-initialize regulator match table array

Jim Paris (1):
      cdc-acm: ensure that termios get set when the port is activated

Jingchang Lu (1):
      serial: of-serial: fix uninitialized kmalloc variable

Johan Hovold (5):
      USB: kobil_sct: fix non-atomic allocation in write path
      USB: opticon: fix non-atomic allocation in write path
      USB: cdc-acm: add device id for GW Instek AFG-2225
      USB: cdc-acm: only raise DTR on transitions from B0
      USB: cdc-acm: add quirk for control-line state requests

Johannes Berg (1):
      tiny: rename ENABLE_DEV_COREDUMP to ALLOW_DEV_COREDUMP

Kailang Yang (2):
      ALSA: hda/realtek - Update Initial AMP for EAPD control
      ALSA: hda/realtek - Restore default value for ALC668

Kristina Martsenko (1):
      mmc: core: fix card detection regression

Krzysztof Kozlowski (1):
      regulator: max77693: Fix use of uninitialized regulator config

Lad, Prabhakar (1):
      MAINTAINERS: drop list entry for davinci

Lars-Peter Clausen (5):
      staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
      staging:iio:ad5933: Drop "raw" from channel names
      staging:iio:ade7758: Fix NULL pointer deref when enabling buffer
      staging:iio:ade7758: Fix check if channels are enabled in prenable
      staging:iio:ade7758: Remove "raw" from channel name

Laurent Pinchart (5):
      mm: cma: Don't crash on allocation if CMA area can't be activated
      mm: cma: Always consider a 0 base address reservation as dynamic
      mm: cma: Ensure that reservations never cross the low/high mem boundary
      mm: cma: Use %pa to print physical addresses
      i2c: core: Dispose OF IRQ mapping at client removal time

Linus Torvalds (1):
      Linux 3.18-rc4

Loic Poulain (1):
      pinctrl: baytrail: Clear DIRECT_IRQ bit

Luis Henriques (1):
      usb: storage: fix build warnings !CONFIG_PM

Lukas Bossard (1):
      ALSA: hda - Add ultra dock support for Thinkpad X240.

Manuel Lauss (1):
      MIPS: Fix build with binutils 2.24.51+

Marek Szyprowski (1):
      usb: dwc2: gadget: fix enumeration issues

Mark Brown (1):
      regulator: of: Lower the severity of the error with no container

Mark Einon (1):
      MAINTAINERS: Remove duplicate entry for usbip driver

Mark Knibbs (2):
      USB: storage: Fix timeout in usb_stor_euscsi_init() and
usb_stor_huawei_e220_init()
      USB: Update default usb-storage delay_use value in kernel-parameters.txt

Martin Schwidefsky (2):
      s390/time: use stck clock fast for do_account_vtime
      s390: update default configuration

Matthias Brugger (1):
      tty: serial: 8250_mtk: Fix quot calculation

Mauro Carvalho Chehab (1):
      [media] rc5-decoder: BZ#85721: Fix RC5-SZ decoding

Mike Christie (1):
      libceph: use memalloc flags for net IO

Miklos Szeredi (1):
      ovl: don't poison cursor

Oliver Neukum (1):
      xhci: no switching back on non-ULT Haswell

Olof Johansson (1):
      ARM: dts: vf610: add SD node to cosmic dts

Oussama Ghorbel (1):
      phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly

Peter Chen (1):
      usb: core: notify disconnection when core detects disconnect

Peter Hurley (3):
      serial: Fix divide-by-zero fault in uart_get_divisor()
      tty: Fix high cpu load if tty is unreleaseable
      tty: Prevent "read/write wait queue active!" log flooding

Ralf Baechle (2):
      MIPS: Wire up bpf syscall.
      MIPS: Fix strnlen_user() return value in case of overlong strings.

Robert Jarzmik (1):
      ARM: pxa: fix hang on startup with DEBUG_LL

Robin van der Gracht (1):
      iio: st_sensors: Fix buffer copy

Soren Brinkmann (1):
      MAINTAINERS: Add Soren as reviewer for Zynq

Srinivas Kandagatla (1):
      ARM: multi_v7_defconfig: fix support for APQ8084

Stanislaw Gruszka (1):
      asus-nb-wmi: Add wapf4 quirk for the X550VB

Stefan Agner (1):
      ARM: imx: clk-vf610: define PLL's clock tree

Stefan Hengelein (1):
      ARM: ixp4xx: remove compilation warnings in io.h

Stephan Mueller (1):
      quirk for Lenovo Yoga 3: no rfkill switch

Stephen Warren (1):
      MAINTAINERS: update bcm2835 entry

Steven Rostedt (Red Hat) (1):
      ftracetest: Take the first debugfs mount found

Sylwester Nawrocki (1):
      usb: Remove references to non-existent PLAT_S5P symbol

Takashi Iwai (1):
      ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect

Tomas Melin (1):
      [media] rc-core: fix protocol_change regression in ir_raw_event_register

Tony Lindgren (3):
      ARM: omap2plus_defconfig: Fix bloat caused by having ipv6 built-in
      ARM: omap2plus_defconfig: Fix errors with NAND BCH
      ARM: OMAP2+: Warn about deprecated legacy booting mode

Tony Zheng (1):
      usb: core: need to call usb_phy_notify_connect after device setup

Ulrich Eckhardt (2):
      [media] ds3000: fix LNB supply voltage on Tevii S480 on initialization
      [media] imon: fix other RC type protocol support

Vladimir Zapolskiy (1):
      thermal: fix multiple disbalanced device node counters

Weijie Yang (1):
      mm, cma: make parameters order consistent in func declaration
and definition

Will Deacon (1):
      arm64: defconfig: update defconfig for 3.18

Wolfram Sang (2):
      i2c: remove FSF address
      i2c: at91: don't account as iowait

Yao Dongdong (1):
      Thermal:Remove usless if(!result) before return tz

Yijing Wang (2):
      MIPS/Xlp: Remove the dead function destroy_irq() to fix build error
      sysfs: driver core: Fix glue dir race condition by gdp_mutex

Yinghai Lu (1):
      PCI: Don't oops on virtual buses in acpi_pci_get_bridge_handle()

Zhangfei Gao (1):
      [media] ir-hix5hd2 fix build warning

Zubair Lutfullah Kakakhel (1):
      MIPS: CMA: Do not reserve memory if not required
