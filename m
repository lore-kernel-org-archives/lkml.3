Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaEQKml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 06:42:41 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:65082 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbaEQKmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 06:42:35 -0400
Message-ID: <53773D16.7040406@suse.cz>
Date: Sat, 17 May 2014 12:42:30 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.20
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 3.12.20 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

----------------------------------------------------------------
Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Alan Stern (2):
      USB: fix crash during hotplug of PCI USB controller card
      USB: unbind all interfaces before rebinding any

Alec Berg (1):
      iio: querying buffer scan_mask should return 0/1

Alexander Gordeev (1):
      ahci: Do not receive interrupts sent by dummy ports

Alexander Usyskin (1):
      mei: ignore client writing state during cb completion

Andrew Lunn (1):
      ARM: Fix default CPU selection for ARCH_MULTI_V5

Andy Grover (1):
      target/tcm_fc: Fix use-after-free of ft_tpg

Antoine Ténart (1):
      video: atmel_lcdfb: ensure the hardware is initialized with the
correct mode

Anton Blanchard (1):
      powerpc/compat: 32-bit little endian machine name is ppcle, not ppc

Antti Palosaari (1):
      media: em28xx: fix PCTV 290e LNA oops

Bart Van Assche (1):
      dlm: Avoid that dlm_release_lockspace() incorrectly returns -EBUSY

Benjamin LaHaise (1):
      aio: v4 ensure access to ctx->ring_pages is correctly serialised
for migration

Brian Austin (3):
      ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC,
PCM, and Analog kcontrols
      ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE
      ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE

Catalin Marinas (2):
      arm64: Do not synchronise I and D caches for special ptes
      arm64: Make DMA coherent and strongly ordered mappings not
executable

Charles Keepax (1):
      regulator: arizona-ldo1: Correct default regulator init_data

Christian Borntraeger (1):
      KVM: s390: Optimize ucontrol path

Christopher Covington (1):
      ARM: 8007/1: Remove extraneous kcmp syscall ignore

Colin Ian King (1):
      rtlwifi: rtl8188ee: initialize packet_beacon

Dan Carpenter (4):
      SCSI: qla2xxx: fix error handling of qla2x00_mem_alloc()
      SCSI: arcmsr: upper 32 of dma address lost
      mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()
      mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers

David Cohen (1):
      usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

David Fries (1):
      w1: fix w1_send_slave dropping a slave id

David Milburn (1):
      ahci: do not request irq for dummy port

Denis Turischev (1):
      xhci: Switch Intel Lynx Point ports to EHCI on shutdown.

Dennis Dalessandro (1):
      IB/ipath: Fix potential buffer overrun in sending diag packet
routine

Emmanuel Grumbach (1):
      iwlwifi: dvm: take mutex when sending SYNC BT config command

Fam Zheng (1):
      virtio-scsi: Skip setting affinity on uninitialized vq

Felipe Balbi (2):
      usb: dwc3: fix randconfig build errors
      usb: musb: avoid NULL pointer dereference

Felipe Franciosi (2):
      mtip32xx: Set queue bounce limit
      mtip32xx: Unmap the DMA segments before completing the IO request

Felix Fietkau (2):
      mac80211: exclude AP_VLAN interfaces from tx power calculation
      ath9k: fix ready time of the multicast buffer queue

Florian Vaussard (1):
      media: omap3isp: preview: Fix the crop margins

Gerd Hoffmann (1):
      drm: cirrus: add power management support

Giacomo Comes (1):
      Skip intel_crt_init for Dell XPS 8700

Gregory CLEMENT (1):
      usb: gadget: atmel_usba: fix crashed during stopping when DEBUG
is enabled

Guenter Roeck (1):
      mfd: kempld-core: Fix potential hang-up during boot

H Hartley Sweeten (1):
      staging: comedi: usbdux: bug fix for accessing 'ao_chanlist' in
private data

H. Peter Anvin (1):
      x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Haibin Wang (1):
      KVM: ARM: vgic: Fix sgi dispatch problem

Hans Verkuil (4):
      media: videodev2.h: add parenthesis around macro arguments
      media: v4l2-dv-timings: add module name, description, license
      media: v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32
support
      media: saa7134: fix WARN_ON during resume

Hans de Goede (2):
      Input: synaptics - add min/max quirk for ThinkPad T431s, L440,
L540, S1 Yoga and X1
      Input: synaptics - add min/max quirk for ThinkPad Edge E431

Herve Codina (1):
      mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC

Himangi Saraogi (1):
      staging:serqt_usb2: Fix sparse warning restricted __le16
degrades to integer

Huacai Chen (1):
      MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

Hui Wang (1):
      ALSA: hda - automute via amp instead of pinctl on some AIO models

J. Bruce Fields (6):
      nfsd4: session needs room for following op to error out
      nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
      nfsd4: fix test_stateid error reply encoding
      nfsd4: leave reply buffer space for failed setattr
      nfsd: notify_change needs elevated write count
      nfsd4: fix setclientid encode size

James Hogan (1):
      MIPS: KVM: Pass reserved instruction exceptions to guest

Jan Kara (1):
      ext4: fix jbd2 warning under heavy xattr load

Jarkko Nikula (1):
      ASoC: dapm: Fix widget double free with auto-disable DAPM kcontrol

Jean-Jacques Hiblot (1):
      PCI: mvebu: Fix potential issue in range parsing

Jeff Layton (3):
      nfsd: set timeparms.to_maxval in setup_callback_client
      locks: allow __break_lease to sleep even when break_time is 0
      lockd: ensure we tear down any live sockets when socket creation
fails during lockd_up

Jeff Mahoney (1):
      reiserfs: fix race in readdir

Jens Axboe (1):
      lib/percpu_counter.c: fix bad percpu counter state during suspend

Jiri Slaby (1):
      Linux 3.12.20

Joe Thornber (2):
      dm transaction manager: fix corruption due to non-atomic
transaction commit
      dm: take care to copy the space map roots before locking the
superblock

Johannes Berg (3):
      mac80211: fix potential use-after-free
      mac80211: fix suspend vs. authentication race
      mac80211: fix software remain-on-channel implementation

Johannes Weiner (1):
      mm: page_alloc: spill to remote nodes before waking kswapd

Julius Werner (1):
      usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

Junxiao Bi (2):
      ocfs2: dlm: fix lock migration crash
      ocfs2: dlm: fix recovery hung

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Negotiate version 3.0 when running on
ws2012r2 hosts

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC288 codec
      ALSA: hda/realtek - Add headset Mic support for Dell machine

Kazuya Mio (1):
      ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS

Kees Cook (1):
      usb: gadget: tcm_usb_gadget: stop format strings

Kinglong Mee (1):
      NFSD: Traverse unconfirmed client through hash-table

Krzysztof Kozlowski (11):
      mfd: sec-core: Fix possible NULL pointer dereference when
i2c_new_dummy error
      mfd: 88pm860x: Fix possible NULL pointer dereference on
i2c_new_dummy error
      mfd: 88pm860x: Fix I2C device resource leak on regmap init fail
      mfd: 88pm800: Fix I2C device resource leak if probe fails
      mfd: max77686: Fix possible NULL pointer dereference on
i2c_new_dummy error
      mfd: max77693: Fix possible NULL pointer dereference on
i2c_new_dummy error
      mfd: max8925: Fix possible NULL pointer dereference on
i2c_new_dummy error
      mfd: max8998: Fix possible NULL pointer dereference on
i2c_new_dummy error
      mfd: max8997: Fix possible NULL pointer dereference on
i2c_new_dummy error
      mfd: tps65910: Fix possible invalid pointer dereference on
regmap_add_irq_chip fail
      clk: s2mps11: Fix possible NULL pointer dereference

Larry Finger (6):
      staging: r8712u: Fix case where ethtype was never obtained and
always be checked against 0
      staging: r8188eu: Calling rtw_get_stainfo() with a NULL sta_addr
will return NULL
      rtlwifi: rtl8723ae: Fix too long disable of IRQs
      rtlwifi: rtl8188ee: Fix too long disable of IRQs
      rtlwifi: rtl8192cu: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix too long disable of IRQs

Leigh Brown (1):
      ARM: dts: am335x: update USB DT references

Liu Hua (1):
      ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo

Lv Zheng (1):
      ACPICA: Restore code that repairs NULL package elements in
return values.

Malcolm Priestley (2):
      media: m88rs2000: prevent frontend crash on continuous
transponder scans
      media: m88rs2000: add caps FE_CAN_INVERSION_AUTO

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call

Mark Salter (1):
      arm: KVM: fix possible misalignment of PGDs and bounce page

Martin K. Petersen (1):
      libata: Update queued trim blacklist for M5x0 drives

Martin Schwidefsky (1):
      s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH

Martin Svec (1):
      Target/sbc: Initialize COMPARE_AND_WRITE write_sg scatterlist

Mathias Nyman (1):
      xhci: Prevent runtime pm from autosuspending during initialization

Matt Fleming (2):
      x86/efi: Correct EFI boot stub use of code32_start
      sh: fix format string bug in stack tracer

Matthew Daley (2):
      floppy: ignore kernel-only members in FDRAWCMD ioctl input
      floppy: don't write kernel-only members to FDRAWCMD ioctl output

Matthew Wilcox (1):
      ext4: note the error in ext4_end_bio()

Michael Braun (1):
      mac80211: fix WPA with VLAN on AP side with ps-sta again

Michael Neuling (1):
      powerpc/tm: Disable IRQ in tm_recheckpoint

Michael Welling (1):
      tty: serial: 8250_core.c Bug fix for Exar chips.

Michal Simek (1):
      usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210

Mike Marciniszyn (2):
      IB/qib: Fix debugfs ordering issue with multiple HCAs
      ib_srpt: Use correct ib_sg_dma primitives

Mike Snitzer (2):
      dm cache: prevent corruption caused by discard_block_size >
cache_block_size
      dm thin: fix dangling bio in process_deferred_bios error path

Mikulas Patocka (5):
      framebuffer: fix cfb_copyarea
      matroxfb: restore the registers M_ACCESS and M_PITCH
      mach64: use unaligned access
      mach64: fix cursor when character width is not a multiple of 8
pixels
      tgafb: fix data copying

Mizuma, Masayoshi (1):
      mm: hugetlb: fix softlockup when a large number of hugepages are
freed.

Mugunthan V N (1):
      ARM: dts: am33xx: correcting dt node unit address for usb

Nicholas Bellinger (3):
      iser-target: Match FRMR descriptors to available session tags
      iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err
      iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug

Nishanth Menon (1):
      ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM

Oleksij Rempel (1):
      media: uvcvideo: Do not use usb_set_interface on bulk EP

Paul Gortmaker (1):
      hvc: ensure hvc_init is only ever called once in hvc_console.c

Peter Hurley (2):
      tty: Fix lockless tty buffer race
      n_tty: Fix n_tty_write crash when echoing in raw mode

Petr Mladek (1):
      ftrace/x86: One more missing sync after fixup of function
modification failure

Rafał Miłecki (1):
      b43: Fix machine check error due to improper access of
B43_MMIO_PSM_PHY_HDR

Richard Weinberger (1):
      ARC: Remove ARC_HAS_COH_RTSC

Roger Quadros (2):
      ARM: OMAP3: hwmod data: Correct clock domains for USB modules
      usb: gadget: zero: Fix SuperSpeed enumeration for alternate
setting 1

Russell King (1):
      mmc: sdhci-bcm-kona: fix build errors when built-in

Sebastian Ott (2):
      s390/cio: fix driver callback initialization for ccw consoles
      s390/chsc: fix SEI usage on old FW levels

Sekhar Nori (1):
      dma: edma: fix incorrect SG list handling

Serge Hallyn (1):
      xattr: guard against simultaneous glibc header inclusion

Stanislav Kinsbursky (1):
      nfsd: check passed socket's net matches NFSd superblock's one

Stefan Sørensen (1):
      ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Takashi Iwai (2):
      ALSA: ice1712: Fix boundary checks in PCM pointer ops
      ALSA: hda - Fix silent speaker output due to mute LED fixup

Tetsuo Handa (1):
      ocfs2: fix panic on kfree(xattr->name)

Theodore Ts'o (2):
      ext4: move ext4_update_i_disksize() into
mpage_map_and_submit_extent()
      ext4: use i_size_read in ext4_unaligned_aio()

Thomas Petazzoni (2):
      ARM: mvebu: ensure the mdio node has a clock reference on Armada
370/XP
      Revert "net: mvneta: fix usage as a module on RGMII configurations"

Tomas Winkler (2):
      mei: fix memory leak of pending write cb objects
      mei: me: do not load the driver if the FW doesn't support MEI
interface

Tomasz Figa (1):
      ARM: dts: Keep G3D regulator always on for exynos5250-arndale

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

Trond Myklebust (1):
      NFSv4: Fix a use-after-free problem in open()

Tyler Stachecki (1):
      mpt2sas: Don't disable device twice at suspend.

Uwe Kleine-König (1):
      spi: efm32: use $vendor,$device scheme for compatible string

Vineet Gupta (1):
      ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe

Vlastimil Babka (1):
      mm: try_to_unmap_cluster() should lock_page() before mlocking

W. Trevor King (1):
      ALSA: hda - Enable beep for ASUS 1015E

Will Deacon (1):
      ARM: 7954/1: mm: remove remaining domain support from ARMv6

Wolfram Sang (1):
      media: media: gspca: sn9c20x: add ID for Genius Look 1320 V2

Xiangyu Lu (1):
      ARM: 8027/1: fix do_div() bug in big-endian systems

Yann Droneaud (4):
      IB/nes: Return an error on ib_copy_from_udata() failure instead
of NULL
      IB/mthca: Return an error on ib_copy_to_udata() failure
      IB/ehca: Returns an error on ib_copy_to_udata() failure
      IB/qib: add missing braces in do_qib_user_sdma_queue_create()

alex chen (1):
      ocfs2: do not put bh when buffer_uptodate failed

 .../devicetree/bindings/spi/efm32-spi.txt    |   4 +-
 Documentation/video4linux/gspca.txt          |   1 +
 Makefile                                     |   2 +-
 arch/arc/kernel/entry.S                      |   8 +-
 arch/arc/plat-arcfpga/Kconfig                |   1 -
 arch/arm/Kconfig                             |   2 +-
 arch/arm/boot/dts/am335x-bone-common.dtsi    |   4 +-
 arch/arm/boot/dts/am335x-evm.dts             |   4 +-
 arch/arm/boot/dts/am335x-evmsk.dts           |   2 +-
 arch/arm/boot/dts/am33xx.dtsi                |   4 +-
 arch/arm/boot/dts/armada-370-xp.dtsi         |   1 +
 arch/arm/boot/dts/exynos5250-arndale.dts     |   1 +
 arch/arm/include/asm/div64.h                 |   2 +-
 arch/arm/include/asm/futex.h                 |   6 -
 arch/arm/include/asm/pgtable-2level.h        |   1 +
 arch/arm/include/asm/unistd.h                |   1 -
 arch/arm/kernel/machine_kexec.c              |   7 +
 arch/arm/kvm/mmu.c                           |  15 +-
 arch/arm/mach-omap2/irq.c                    |   8 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |   4 +-
 arch/arm/mach-omap2/pm.h                     |   2 +-
 arch/arm/mm/Kconfig                          |   3 +-
 arch/arm/mm/mmu.c                            |  10 +
 arch/arm/mm/proc-macros.S                    |  19 +-
 arch/arm/mm/proc-v7-2level.S                 |   7 -
 arch/arm64/include/asm/pgtable.h             |   8 +-
 arch/mips/kvm/kvm_mips_emul.c                |   7 +-
 arch/mips/power/hibernate.S                  |   1 +
 arch/powerpc/include/asm/compat.h            |   4 +
 arch/powerpc/include/asm/reg.h               |   1 +
 arch/powerpc/kernel/process.c                |  34 ++-
 arch/powerpc/kernel/signal_32.c              |   2 +
 arch/powerpc/kernel/signal_64.c              |   2 +
 arch/powerpc/kernel/tm.S                     |   2 +-
 arch/s390/include/asm/ccwdev.h               |   2 +-
 arch/s390/kvm/kvm-s390.c                     |   3 +-
 arch/s390/net/bpf_jit_comp.c                 |   1 -
 arch/sh/kernel/dumpstack.c                   |   2 +-
 arch/x86/boot/compressed/eboot.c             |   5 +-
 arch/x86/boot/compressed/head_32.S           |  14 +-
 arch/x86/boot/compressed/head_64.S           |   9 +-
 arch/x86/kernel/ftrace.c                     |   2 +-
 arch/x86/kernel/ldt.c                        |  11 +
 drivers/acpi/acpica/nsrepair.c               |  25 +-
 drivers/ata/ahci.c                           |  18 +-
 drivers/ata/libata-core.c                    |  27 +-
 drivers/block/floppy.c                       |  11 +-
 drivers/block/mtip32xx/mtip32xx.c            |  25 +-
 drivers/clk/clk-s2mps11.c                    |   2 +-
 drivers/dma/edma.c                           |   6 +-
 drivers/gpio/gpio-mxs.c                      |   3 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c          |  42 +++
 drivers/gpu/drm/cirrus/cirrus_mode.c         |   3 +
 drivers/gpu/drm/i915/intel_crt.c             |   8 +
 drivers/hv/connection.c                      |   6 +
 drivers/iio/industrialio-buffer.c            |   6 +-
 drivers/infiniband/hw/ehca/ehca_cq.c         |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c     |  66 ++---
 drivers/infiniband/hw/mthca/mthca_provider.c |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c        |   2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c     |   3 +-
 drivers/infiniband/hw/qib/qib_init.c         |  25 +-
 drivers/infiniband/ulp/isert/ib_isert.c      |  65 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  16 +-
 drivers/input/mouse/synaptics.c              |  50 ++++
 drivers/md/dm-cache-metadata.c               |  63 ++--
 drivers/md/dm-cache-target.c                 |  37 +--
 drivers/md/dm-thin-metadata.c                |  80 ++---
 drivers/md/dm-thin.c                         |   2 +-
 .../md/persistent-data/dm-block-manager.c    |  15 +-
 .../md/persistent-data/dm-block-manager.h    |   3 +-
 .../persistent-data/dm-transaction-manager.c |   5 +-
 .../persistent-data/dm-transaction-manager.h |  17 +-
 drivers/media/dvb-frontends/m88rs2000.c      |  19 +-
 drivers/media/pci/saa7134/saa7134-cards.c    |   4 +-
 drivers/media/platform/omap3isp/isppreview.c |   9 +
 drivers/media/usb/em28xx/em28xx-dvb.c        |   3 +-
 drivers/media/usb/gspca/sn9c20x.c            |   1 +
 drivers/media/usb/uvc/uvc_video.c            |  20 +-
 .../media/v4l2-core/v4l2-compat-ioctl32.c    |   4 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c    |   4 +
 drivers/mfd/88pm800.c                        |   3 +-
 drivers/mfd/88pm860x-core.c                  |   6 +
 drivers/mfd/kempld-core.c                    |   7 +-
 drivers/mfd/max77686.c                       |   4 +
 drivers/mfd/max77693.c                       |  12 +-
 drivers/mfd/max8925-i2c.c                    |   9 +
 drivers/mfd/max8997.c                        |  18 ++
 drivers/mfd/max8998.c                        |   4 +
 drivers/mfd/sec-core.c                       |   4 +
 drivers/mfd/tps65910.c                       |   4 +-
 drivers/misc/mei/client.c                    |  76 +++--
 drivers/misc/mei/client.h                    |  18 --
 drivers/misc/mei/hw-me-regs.h                |   5 +
 drivers/misc/mei/interrupt.c                 |   3 +-
 drivers/misc/mei/main.c                      |   3 +-
 drivers/misc/mei/pci-me.c                    |  30 +-
 drivers/mmc/host/sdhci-bcm-kona.c            |   2 +-
 drivers/mtd/nand/atmel_nand.c                |   1 +
 drivers/mtd/nand/nuc900_nand.c               |   2 +-
 drivers/mtd/sm_ftl.c                         |  11 +-
 drivers/net/ethernet/marvell/mvneta.c        |  41 ++-
 drivers/net/wireless/ath/ath9k/xmit.c        |   2 +-
 drivers/net/wireless/b43/phy_n.c             |  14 +-
 drivers/net/wireless/iwlwifi/dvm/main.c      |   8 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c  |  20 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  |  15 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |  27 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c  |  18 +-
 drivers/pci/host/pci-mvebu.c                 |   2 +-
 drivers/regulator/arizona-ldo1.c             |   7 +-
 drivers/s390/char/con3215.c                  |   2 +-
 drivers/s390/char/con3270.c                  |   6 +-
 drivers/s390/char/raw3270.c                  |  10 +-
 drivers/s390/char/raw3270.h                  |   2 +-
 drivers/s390/cio/chsc.c                      |  22 +-
 drivers/s390/cio/device.c                    |   3 +-
 drivers/scsi/arcmsr/arcmsr_hba.c             |   7 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |   1 -
 drivers/scsi/qla2xxx/qla_os.c                |   6 +-
 drivers/scsi/virtio_scsi.c                   |   6 +-
 drivers/spi/spi-efm32.c                      |   3 +
 drivers/staging/comedi/drivers/usbdux.c      |   9 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c    |   4 +-
 drivers/staging/rtl8712/rtl871x_recv.c       |  13 +-
 drivers/staging/serqt_usb2/serqt_usb2.c      |   2 +-
 drivers/target/iscsi/iscsi_target.c          |   4 +-
 drivers/target/target_core_sbc.c             |   3 +-
 drivers/target/tcm_fc/tfc_sess.c             |   1 +
 drivers/tty/hvc/hvc_console.c                |   8 +-
 drivers/tty/n_tty.c                          |   4 +
 drivers/tty/serial/8250/8250_core.c          |   2 +-
 drivers/tty/tty_buffer.c                     |  17 +-
 drivers/usb/core/driver.c                    |  94 +++---
 drivers/usb/core/hcd-pci.c                   |   2 +-
 drivers/usb/core/hub.c                       |   5 +-
 drivers/usb/core/usb.h                       |   2 +-
 drivers/usb/dwc3/core.h                      |  39 ++-
 drivers/usb/dwc3/gadget.h                    |  12 -
 drivers/usb/gadget/atmel_usba_udc.c          |   6 +-
 drivers/usb/gadget/tcm_usb_gadget.c          |   2 +-
 drivers/usb/gadget/zero.c                    |   2 +-
 drivers/usb/host/xhci-pci.c                  |  13 +-
 drivers/usb/host/xhci-ring.c                 |  67 ++---
 drivers/usb/host/xhci.c                      |   7 +-
 drivers/usb/host/xhci.h                      |   2 -
 drivers/usb/musb/musb_core.c                 |   5 +-
 drivers/usb/phy/phy-ulpi.c                   |   2 +
 drivers/usb/serial/pl2303.c                  |   3 +
 drivers/usb/serial/pl2303.h                  |   5 +-
 drivers/video/atmel_lcdfb.c                  |   6 +
 drivers/video/aty/mach64_accel.c             |   3 +-
 drivers/video/aty/mach64_cursor.c            |  22 +-
 drivers/video/cfbcopyarea.c                  | 153 +++++-----
 drivers/video/matrox/matroxfb_accel.c        |  38 ++-
 drivers/video/matrox/matroxfb_base.h         |   2 +
 drivers/video/tgafb.c                        | 264 ++++-------------
 drivers/w1/w1_netlink.c                      |  25 +-
 fs/aio.c                                     | 120 ++++----
 fs/dlm/lockspace.c                           |   4 +-
 fs/ext4/ext4.h                               |  17 --
 fs/ext4/file.c                               |   2 +-
 fs/ext4/inode.c                              |  20 +-
 fs/ext4/page-io.c                            |   5 +-
 fs/ext4/xattr.c                              |  23 +-
 fs/lockd/svc.c                               |   1 +
 fs/locks.c                                   |   7 +-
 fs/nfs/nfs4proc.c                            |  19 +-
 fs/nfsd/nfs4callback.c                       |   4 +-
 fs/nfsd/nfs4proc.c                           |   9 +-
 fs/nfsd/nfs4state.c                          |  13 +-
 fs/nfsd/nfs4xdr.c                            |   5 +
 fs/nfsd/nfsctl.c                             |   5 +
 fs/nfsd/nfsd.h                               |   2 +-
 fs/nfsd/vfs.c                                |   9 +
 fs/ocfs2/buffer_head_io.c                    |   2 -
 fs/ocfs2/dlm/dlmrecovery.c                   |  29 +-
 fs/ocfs2/namei.c                             |   2 -
 fs/reiserfs/dir.c                            |   6 +-
 include/linux/hyperv.h                       |   7 +-
 include/linux/libata.h                       |   1 +
 include/linux/sunrpc/svcsock.h               |   1 +
 include/uapi/linux/libc-compat.h             |   9 +
 include/uapi/linux/videodev2.h               |  10 +-
 include/uapi/linux/xattr.h                   |   7 +
 lib/percpu_counter.c                         |   2 +-
 mm/hugetlb.c                                 |   1 +
 mm/internal.h                                |   1 +
 mm/mlock.c                                   |   2 +
 mm/page_alloc.c                              |  89 +++---
 mm/rmap.c                                    |  14 +-
 net/mac80211/ieee80211_i.h                   |   1 +
 net/mac80211/main.c                          |   2 +
 net/mac80211/mlme.c                          |  28 +-
 net/mac80211/offchannel.c                    |   1 +
 net/mac80211/pm.c                            |  14 +-
 net/mac80211/tx.c                            |   2 +-
 net/sunrpc/svcsock.c                         |  16 +
 sound/pci/hda/patch_realtek.c                |  32 +-
 sound/pci/ice1712/ice1712.c                  |  15 +-
 sound/soc/codecs/cs42l51.c                   |   9 +-
 sound/soc/codecs/cs42l52.c                   |   8 +-
 sound/soc/codecs/cs42l73.c                   |   6 +-
 sound/soc/soc-dapm.c                         |   1 -
 virt/kvm/arm/vgic.c                          |   1 +
 206 files changed, 1683 insertions(+), 1121 deletions(-)

thanks,
-- 
js
