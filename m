Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaIABpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 21:45:16 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:42891 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaIABpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 21:45:12 -0400
MIME-Version: 1.0
Date: Sun, 31 Aug 2014 18:45:11 -0700
X-Google-Sender-Auth: GyYjAYDC-dvKlrKaSn52K6jEymQ
Message-ID: <CA+55aFym7DG1kYzc0e+SP7ztqAPRYcrXTurSQ1psVJrtWPv-hg@mail.gmail.com>
Subject: Linux 3.17-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm back to the usual Sunday release schedule, and -rc3 is out there
now. As expected, it is larger than rc2, since people are clearly
getting back from their Kernel Summit travels etc. But happily, it's
not *much* larger than rc2 was, and there's nothing particularly odd
going on, so I'm going to just ignore the whole "it's summer"
argument, and hope that things are just going that well.

Please don't prove me wrong,

           Linus

---

Addy Ke (1):
      spi/rockchip: fixup incorrect dma direction setting

Alan Cox (2):
      spi/pxa2xx: Add ACPI ID for Intel Braswell
      ACPI / LPSS: Add ACPI IDs for Intel Braswell

Alan Douglas (1):
      xtensa: fix address checks in dma_{alloc,free}_coherent

Alex Deucher (1):
      drm/radeon: handle broken disabled rb mask gracefully (6xx/7xx) (v2)

Alex Shi (1):
      vexpress/spc: fix a build warning on array bounds

Alex Williamson (1):
      radeon: Test for PCI root bus before assuming bus->self

Alexander Usyskin (2):
      mei: reset client state on queued connect request
      mei: nfc: fix memory leak in error path

Alexey Khoroshilov (1):
      usb: dbgp gadget: fix use after free in dbgp_unbind()

Anand Jain (2):
      Btrfs: device_list_add() should not update list when mounted
      btrfs: check generation as replace duplicates devid+uuid

Andi Kleen (1):
      intel_pstate: Turn per cpu printk into pr_debug

Andreas Noever (1):
      thunderbolt: Clear hops before overwriting

Andrey Ryabinin (1):
      ARM: 8127/1: module: add support for R_ARM_TARGET1 relocations

Andy Shevchenko (3):
      x86: Fix non-PC platform kernel crash on boot due to NULL dereference
      spi: dw-pci: fix bug when regs left uninitialized
      spi: dw: fix kernel crash due to NULL pointer dereference

Arjun Sreedharan (1):
      usb: phy: return -ENODEV on failure of try_module_get

Bartlomiej Zolnierkiewicz (1):
      drivers/rtc/rtc-s5m.c: re-add support for devices without irq specified

Ben Hutchings (1):
      ocfs2: do not write error flag to user structure we cannot copy from/to

Benjamin Tissoires (1):
      HID: logitech-dj: prevent false errors to be shown

Bjorn Andersson (1):
      pinctrl: qcom: apq8064: Correct interrupts in example

Bo Shen (1):
      usb: atmel_usba_udc: fix it to deal with final dma channel

Brennan Ashton (1):
      USB: option: add VIA Telecom CDS7 chipset device id

Brian Norris (1):
      ARM: brcmstb: revert SMP support

Bryan O'Donoghue (1):
      usb: pch_udc: usb gadget device support for Intel Quark X1000

Chao Yu (1):
      zram: fix incorrect stat with failed_reads

Chris Mason (1):
      Btrfs: fix filemap_flush call in btrfs_file_release

Christian König (1):
      drm/radeon: save/restore the PD addr on suspend/resume

Christoph Hellwig (2):
      block: cleanup error handling in sg_io
      block: support > 16 byte CDBs for SG_IO

Clemens Ladisch (1):
      ALSA: core: fix buffer overflow in snd_info_get_line()

Dan Carpenter (4):
      pinctrl: tegra-xusb: fix an off by one test
      pinctrl: tegra-xusb: testing wrong variable in probe()
      usb: dwc3: omap: signedness bug in dwc3_omap_set_utmi_mode()
      video: of: display_timing: double free on error

Darrick J. Wong (3):
      jbd2: fix infinite loop when recovering corrupt journal blocks
      jbd2: fix descriptor block size handling errors with journal_csum
      ext4: fix same-dir rename when inline data directory overflows

Dave Jones (1):
      lib: turn CONFIG_STACKTRACE into an actual option.

David Herrmann (1):
      drm: fix division-by-zero on dumb_create()

Dmitry Monakhov (5):
      brd: add ram disk visibility option
      ext4: move i_size,i_disksize update routines to helper function
      ext4: fix incorect journal credits reservation in ext4_zero_range
      ext4: fix transaction issues for ext4_fallocate and ext_zero_range
      ext4: update i_disksize coherently with block allocation on error path

Doug Anderson (1):
      spi/rockchip: Avoid accidentally turning off the clock

Eric Sandeen (1):
      btrfs: fix leak in qgroup_subtree_accounting() error path

Fabio Estevam (2):
      ARM: dts: imx53-qsrb: Fix suspend/resume
      mfd: ab8500-core: Use 'ifdef' for config options

Filipe Brandenburger (1):
      xattr: fix check for simultaneous glibc header inclusion

Filipe Manana (5):
      Btrfs: race free update of commit root for ro snapshots
      Btrfs: ensure tmpfile inode is always persisted with link count of 0
      Btrfs: fix hole detection during file fsync
      Btrfs: don't monopolize a core when evicting inode
      Btrfs: clone, don't create invalid hole extent map

Geert Uytterhoeven (3):
      spi: sh-msiof: Fix leaking of unused DMA descriptors
      spi: rspi: Fix leaking of unused DMA descriptors
      spi: sh-msiof: Fix transmit-only DMA transfers

Gioh Kim (1):
      Documentation/dma-buf-sharing.txt: update API descriptions

Greg KH (3):
      USB: serial: pl2303: add device id for ztek device
      Revert "usb: ehci/ohci-exynos: Fix PHY getting sequence"
      USB: fix build error with CONFIG_PM_RUNTIME disabled

Grygorii Strashko (1):
      spi: davinci: fix SPI_NO_CS functionality

Guenter Roeck (1):
      unicore32: Fix build error

Hans Wennborg (5):
      pinctrl: pinctrl-at91.c: fix decimal printf format specifiers
prefixed with 0x
      usb: musb: ux500: fix decimal printf format specifiers prefixed with 0x
      mfd: omap-usb-host: Fix %d confusingly prefixed with 0x in format string
      mfd: htc-i2cpld: Fix %d confusingly prefixed with 0x in format string
      ARM: OMAP: fix %d confusingly prefixed with 0x in format string

Hans de Goede (2):
      xhci: Treat not finding the event_seg on COMP_STOP the same as
COMP_STOP_INVAL
      xhci: Disable streams on Via XHCI with device-id 0x3432

Heiko Carstens (2):
      s390: wire up seccomp and getrandom syscalls
      s390: wire up memfd_create syscall

Heiko Stübner (1):
      MAINTAINERS: catch special Rockchip code locations

Himangi Saraogi (1):
      usb: phy: drop kfree of devm_kzalloc's data

Holger Paradies (1):
      staging/rtl8188eu: add 0df6:0076 Sitecom Europe B.V.

HuKeping (1):
      Documentation/kdump/kdump.txt: add ARM description

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk

Hugh Dickins (1):
      x86,mm: fix pte_special versus pte_numa

Ian Abbott (1):
      video: da8xx-fb: preserve display width when changing HSYNC

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response

Jaša Bartelj (1):
      USB: ftdi_sio: Added PID for new ekey device

Jeff Layton (1):
      locks: pass correct "before" pointer to locks_unlink_lock in
generic_add_lease

Jens Axboe (3):
      blk-mq: get rid of unused BLK_MQ_F_SHOULD_SORT flag
      blk-mq: don't allow merges if turned off for the queue
      blk-mq: correct a few wrong/bad comments

Jiang Liu (2):
      x86: irq: Fix bug in setting IOAPIC pin attributes
      x86, irq, PCI: Keep IRQ assignment for runtime power management

Jingoo Han (3):
      usb: phy: samsung: Fix wrong bit mask for PHYPARAM1_PCS_TXDEEMPH
      usb: dwc2: gadget: Set the default EP max packet value as 8 bytes
      drm: sti: Add missing dependency on RESET_CONTROLLER

Jiri Kosina (2):
      HID: magicmouse: sanity check report size in raw_event() callback
      HID: picolcd: sanity check report size in raw_event() callback

Joe Perches (1):
      checkpatch: relax check for length of git commit IDs

Johan Hovold (7):
      USB: option: reduce interrupt-urb logging verbosity
      Revert "USB: option,zte_ev: move most ZTE CDMA devices to zte_ev"
      USB: zte_ev: remove duplicate Gobi PID
      USB: zte_ev: remove duplicate Qualcom PID
      USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID
      USB: serial: fix potential stack buffer overflow
      USB: serial: fix potential heap buffer overflow

Jon Medhurst (Tixy) (1):
      video: ARM CLCD: Fix calculation of bits-per-pixel

Jorge A. Ventura (1):
      spi/omap-mcspi: Fix the spi task hangs waiting dma_rx

Josef Bacik (1):
      trace: Fix epoll hang when we race with new entries

Julia Lawall (2):
      usb: gadget: fix error return code
      drivers: video: fbdev: atmel_lcdfb.c: fix error return code

Junxiao Bi (3):
      ocfs2: o2net: don't shutdown connection when idle timeout
      ocfs2: o2net: set tcp user timeout to max value
      ocfs2: quorum: add a log for node not fenced

Juri Lelli (1):
      ARM: 8130/1: cpuidle/cpuidle-big_little: fix reading cpu id part number

Kees Cook (1):
      mm/zpool: use prefixed module loading

Kiran Padwal (1):
      drm: sti: Make of_device_id array const

Kuninori Morimoto (2):
      ARM: shmobile: r8a7790: add missing 0x0100 for SDCKCR
      ARM: shmobile: r8a7791: add missing 0x0100 for SDCKCR

Lan Tianyu (1):
      ACPI: Run fixed event device notifications in process context

Larry Finger (1):
      staging: r8188eu: Add new USB ID

Li RongQing (1):
      Revert "usb: gadget: u_ether: synchronize with transmit when
stopping queue"

Linus Torvalds (1):
      Linux 3.17-rc3

Linus Walleij (1):
      mfd: tc3589x: Add device tree bindings

Liu Bo (3):
      Btrfs: fix regression of btrfs device replace
      Btrfs: fix crash on endio of reading corrupted block
      Btrfs: fix task hang under heavy compressed write

Lothar Waßmann (1):
      pwm-backlight: Fix bogus request for GPIO#0 when instantiated from DT

Lv Zheng (2):
      ACPI / EC: Add support to disallow QR_EC to be issued when
SCI_EVT isn't set
      ACPI / EC: Add support to disallow QR_EC to be issued before
completing previous QR_EC

Manuel Lauss (1):
      spi: spi-au1550: fix build failure

Mark (1):
      USB: storage: add quirk for Newer Technology uSCSI SCSI-USB converter

Mark Brown (2):
      ARM: dts: Remove twl6030 clk32g "regulator"
      cpufreq: s5pv210: Remove spurious __init annotation

Mark Einon (1):
      staging: et131x: Fix errors caused by phydev->addr accesses
before initialisation

Mark Rutland (2):
      ARM: 8128/1: abort: don't clear the exclusive monitors
      ARM: 8129/1: errata: work around Cortex-A15 erratum 830321 using
dummy strex

Markus Pargmann (1):
      ARM: OMAP2+: omap_device: remove warning that clk alias already exists

Martin Schwidefsky (3):
      s390: add system information as device randomness
      s390/3215: fix tty output containing tabs
      s390/sclp: remove unnecessary XTABS flag

Mathias Nyman (1):
      xhci: rework cycle bit checking for new dequeue pointers

Matthew Wilcox (1):
      mm: actually clear pmd_numa before invalidating

Max Filippov (23):
      xtensa: simplify addition of new core variants
      xtensa: make MMU-related configuration options depend on MMU
      xtensa: sort 'select' statements in Kconfig
      xtensa: select HAVE_IDE only on platforms that may have it
      xtensa: remove orphan MATH_EMULATION symbol
      xtensa: replace IOCTL code definitions with constants
      xtensa: fix access to THREAD_RA/THREAD_SP/THREAD_DS
      xtensa: make fixmap region addressing grow with index
      xtensa: allow fixmap and kmap span more than one page table
      xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss
      xtensa: implement clear_user_highpage and copy_user_highpage
      xtensa: support aliasing cache in k[un]map_atomic
      xtensa: support aliasing cache in kmap
      xtensa: support highmem in aliasing cache flushing code
      xtensa: configure kc705 for highmem
      xtensa: fix kernel/user jump out of fast_unaligned
      xtensa: add double exception fixup handler for fast_unaligned
      xtensa: make fast_unaligned store restartable
      xtensa: move invalid unaligned instruction handler closer to its users
      xtensa: allow single-stepping through unaligned load/store
      xtensa: fix a6 and a7 handling in fast_syscall_xtensa
      xtensa: don't allow overflow/underflow on unaligned stack
      xtensa: deprecate fast_xtensa and fast_spill_registers syscalls

Miao Xie (7):
      Btrfs: fix put dio bio twice when we submit dio bio fail
      Btrfs: fix unzeroed members in fs_devices when creating a fs from seed fs
      Btrfs: fix wrong missing device counter decrease
      Btrfs: Fix the problem that the replace destroys the seed filesystem
      Btrfs: don't write any data into a readonly device when scrub
      Btrfs: Fix wrong device size when we are resizing the device
      Btrfs: don't consider the missing device when allocating new chunks

Michael Cree (1):
      alpha: Wire up sched_setattr, sched_getattr, and renameat2 syscalls.

Michael Grzeschik (1):
      usb: gadget: uvc: fix possible lockup in uvc gadget

Michael Holzheu (1):
      s390/kdump: Clear subchannel ID to signal non-CCW/SCSI IPL

Michael Welling (1):
      kexec: purgatory: add clean-up for purgatory directory

Michal Hocko (1):
      hugetlb_cgroup: use lockdep_assert_held rather than spin_is_locked

Michal Simek (1):
      block: systemace: Remove .owner field for driver

Mika Westerberg (1):
      cpufreq: intel_pstate: Add CPU ID for Braswell processor

Miklos Szeredi (1):
      xtensa: add renameat2 syscall

Mikulas Patocka (1):
      dm crypt: fix access beyond the end of allocated space

Ming Lei (1):
      blk-mq: fix WARNING "percpu_ref_kill() called more than once!"

Nishanth Menon (1):
      ARM: dts: DRA7: fix interrupt-cells for GPIO

Patrice CHOTARD (1):
      pinctrl: abx500: remove useless check

Peter Chen (4):
      usb: dwc2: gadget: fix below build warning
      usb: core: fix below build warning
      usb: wusbcore: fix below build warning
      usb: ehci: using wIndex + 1 for hub port

Philippe Reynes (1):
      usb: gadget: remove $(PWD) in ccflags-y

Phong Tran (1):
      tools: selftests: fix build issue with make kselftests target

Pranith Kumar (4):
      staging: lustre: Remove circular dependency on header
      fbdev: Remove __init from chips_hw_init() to fix build failure
      Documentation: this_cpu_ops.txt: Update description of this_cpu_ops
      flush_icache_range: export symbol to fix build errors

Qu Wenruo (2):
      btrfs: Return right extent when fiemap gives unaligned offset and len.
      btrfs: Use right extent length when inserting overlap extent map.

Rabeeh Khoury (1):
      ARM: dts: microsom-ar8035: MDIO pad must be set open drain

Rafael J. Wysocki (1):
      ACPI / scan: Allow ACPI drivers to bind to PNP device objects

Rajendra Nayak (2):
      ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x() variants
      ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists

Randy Dunlap (1):
      scripts/kernel-doc: recognize __meminit

Rasmus Villemoes (2):
      ALSA: hda: ca0132_regs.h: Fix typo in include guard
      ALSA: ctxfi: ct20k1reg: Fix typo in include guard

Rickard Strandqvist (1):
      staging: lustre: lustre: libcfs: workitem.c: Cleaning up missing
null-terminate after strncpy call

Rob Clark (4):
      drm/msm: avoid flood of kernel logs on faults
      drm/msm/mdp4: request vblank during modeset
      drm/msm: fix compile error for non-dt builds
      ww-mutex: clarify help text for DEBUG_WW_MUTEX_SLOWPATH

Roger Quadros (5):
      mtd: nand: omap: Revert to using software ECC by default
      ARM: OMAP2+: GPMC: Support Software ECC scheme via DT
      ARM: dts: omap3430-sdp: Revert to using software ECC for NAND
      mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()
      usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1

Russell King (2):
      ARM: dts: hummingboard/cubox-i: add USB OC pinctrl configuration
      ARM: dts: hummingboard/cubox-i: change SPDIF output to be more descriptive

Sabrina Dubroca (1):
      block: fix error handling in sg_io

Sagi Grimberg (1):
      block: Fix BUG_ON when pi errors occur

Sergei Shtylyov (1):
      sh-pfc: r8a7791: fix CAN pin groups

Seunghun Lee (1):
      staging: android: fix a possible memory leak

Simon Horman (1):
      ARM: shmobile: sh73a0: Remove spurious 0x from SCIFB clock name

Sonny Rao (1):
      pinctrl: rockchip: fix rk3288 gpio0 configuration

Stephen Hemminger (1):
      USB: sisusb: add device id for Magic Control USB video

Takashi Iwai (3):
      usbcore: Fix wrong device in an error message in hub_port_connect()
      ALSA: pcm: Fix the silence data for DSD formats
      ALSA: hda - Set up initial pins for Acer Aspire V5

Tang Chen (1):
      memblock, memhotplug: fix wrong type in memblock_find_in_range_node().

Tejun Heo (1):
      blk-mq: blk_mq_freeze_queue() should allow nesting

Tero Kristo (1):
      ARM: dts: omap54xx-clocks: Fix the l3 and l4 clock rates

Tetsuo Handa (1):
      tomoyo: Fix pathname calculation breakage.

Theodore Ts'o (2):
      ext4: propagate errors up to ext4_find_entry()'s callers
      ext4: fix BUG_ON in mb_free_blocks()

Thierry Reding (3):
      spi: Add missing kerneldoc bits
      dma-buf/fence: Fix a kerneldoc warning
      dma-buf/fence: Fix one more kerneldoc warning

Tomasz Figa (1):
      pinctrl: exynos: Lock GPIOs as interrupts when used as EINTs

Tony Battersby (2):
      scsi-mq: fix requests that use a separate CDB buffer
      fix regression in SCSI_IOCTL_SEND_COMMAND

Tony Lindgren (3):
      ARM: dts: Enable UART wake-up events for beagleboard
      ARM: OMAP2+: hwmod: Rearm wake-up interrupts for DT when MUSB is idled
      mfd: twl4030-power: Fix PM idle pin configuration to not
conflict with regulators

Toshiaki Makita (2):
      cfq-iosched: Fix wrong children_weight calculation
      cfq-iosched: Add comments on update timing of weight

Trond Myklebust (3):
      NFSv4: Fix problems with close in the presence of a delegation
      NFSv4: Don't clear the open state when we just did an OPEN_DOWNGRADE
      NFSv3: Fix another acl regression

Valentina Manea (4):
      usbip: move usbip userspace code out of staging
      usbip: move usbip kernel code out of staging
      usbip: remove struct usb_device_id table
      MAINTAINERS: Add an entry for USB/IP driver

Vivek Gautam (1):
      usb: ehci/ohci-exynos: Fix PHY getting sequence

Vivek Goyal (4):
      resource: fix the case of null pointer access
      kexec: create a new config option CONFIG_KEXEC_FILE for new syscall
      kexec: remove CONFIG_KEXEC dependency on crypto
      x86/purgatory: use approprate -m64/-32 build flag for arch/x86/purgatory

Wang Shilong (2):
      Btrfs: fix wrong write range for filemap_fdatawrite_range()
      Btrfs: fix wrong extent mapping for DirectIO

Wei Yongjun (8):
      usb: gadget: Fix return value check in ep_write()
      usb: gadget: Fix return value check in r8a66597_probe()
      usb: phy: msm: Fix return value check in msm_otg_probe()
      drm: sti: tvout: fix return value check in sti_tvout_probe()
      drm: sti: hdmi: fix return value check in sti_hdmi_probe()
      drm: sti: hda: fix return value check in sti_hda_probe()
      drm: sti: Fix return value check in sti_drm_platform_probe()
      drm/msm: Fix missing unlock on error in msm_fbdev_create()

Will Deacon (1):
      alpha: io: implement relaxed accessor macros for writes

Y.C. Chen (1):
      drm/ast: Add missing entry to dclk_table[]

chandan (1):
      Btrfs: fill_holes: Fix slot number passed to hole_mergeable() call.
