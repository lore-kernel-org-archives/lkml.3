Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3I0A0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 20:26:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3I0A0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 20:26:44 -0400
Date: Thu, 26 Sep 2013 17:26:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.2
Message-ID: <20130927002642.GA8452@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.11.2 kernel.

All users of the 3.11 kernel series must upgrade.

The updated 3.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.11.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/arc/include/asm/sections.h                 |    1=20
 arch/arc/kernel/head.S                          |    5=20
 arch/arc/kernel/irq.c                           |    1=20
 arch/arc/kernel/setup.c                         |    3=20
 arch/arm/mach-versatile/include/mach/platform.h |    2=20
 arch/arm/mach-versatile/pci.c                   |   47 ++--
 arch/arm/xen/enlighten.c                        |    5=20
 arch/arm64/kernel/perf_event.c                  |    7=20
 arch/mips/ath79/clock.c                         |    2=20
 arch/powerpc/kernel/align.c                     |   10=20
 arch/powerpc/kvm/book3s_xics.c                  |    1=20
 arch/powerpc/platforms/pseries/setup.c          |   31 +-
 arch/s390/net/bpf_jit_comp.c                    |    2=20
 arch/um/include/shared/os.h                     |    1=20
 arch/um/kernel/Makefile                         |    2=20
 arch/um/kernel/maccess.c                        |   24 ++
 arch/um/os-Linux/process.c                      |   52 ++++
 arch/x86/ia32/ia32_signal.c                     |    2=20
 arch/x86/include/asm/checksum_32.h              |   22 +-
 arch/x86/include/asm/mce.h                      |   13 +
 arch/x86/include/asm/mmu_context.h              |   20 +
 arch/x86/kernel/amd_nb.c                        |   13 +
 arch/x86/kernel/signal.c                        |    6=20
 arch/x86/lib/csum-wrappers_64.c                 |   12 -
 arch/xtensa/kernel/xtensa_ksyms.c               |    1=20
 crypto/api.c                                    |    7=20
 drivers/acpi/acpi_lpss.c                        |    3=20
 drivers/acpi/pci_root.c                         |   62 +++--
 drivers/base/firmware_class.c                   |   11 -
 drivers/base/regmap/regmap-debugfs.c            |    4=20
 drivers/block/rbd.c                             |   14 -
 drivers/clk/clk-wm831x.c                        |    2=20
 drivers/cpuidle/coupled.c                       |  127 ++++++++---
 drivers/edac/amd64_edac.c                       |    9=20
 drivers/gpu/drm/drm_edid.c                      |    3=20
 drivers/gpu/drm/i915/intel_display.c            |   13 +
 drivers/hid/hid-core.c                          |   18 +
 drivers/hid/hid-ids.h                           |    8=20
 drivers/hid/hid-input.c                         |   12 -
 drivers/hid/hid-kye.c                           |   45 ++--
 drivers/hid/hid-ntrig.c                         |    3=20
 drivers/hid/hid-picolcd_cir.c                   |    3=20
 drivers/hid/hid-picolcd_core.c                  |    2=20
 drivers/hid/hid-picolcd_fb.c                    |    6=20
 drivers/hid/hid-pl.c                            |   10=20
 drivers/hid/hid-sensor-hub.c                    |    3=20
 drivers/hid/hid-speedlink.c                     |   11 -
 drivers/hid/hid-wiimote-core.c                  |   10=20
 drivers/hid/hidraw.c                            |   60 ++---
 drivers/hid/usbhid/hid-quirks.c                 |    2=20
 drivers/input/mouse/bcm5974.c                   |    6=20
 drivers/iommu/intel-iommu.c                     |   72 +++---
 drivers/leds/leds-wm831x-status.c               |    4=20
 drivers/media/common/siano/smsdvb-main.c        |    3=20
 drivers/media/dvb-frontends/mb86a20s.c          |   16 -
 drivers/media/pci/cx88/cx88.h                   |    2=20
 drivers/media/platform/exynos-gsc/gsc-core.c    |    9=20
 drivers/media/platform/exynos-gsc/gsc-core.h    |    1=20
 drivers/media/platform/exynos-gsc/gsc-m2m.c     |    1=20
 drivers/media/platform/exynos4-is/fimc-lite.c   |    4=20
 drivers/media/platform/exynos4-is/media-dev.c   |    2=20
 drivers/mmc/host/tmio_mmc_dma.c                 |    4=20
 drivers/mtd/nand/nand_base.c                    |    8=20
 drivers/mtd/ubi/wl.c                            |    3=20
 drivers/net/ethernet/marvell/mvneta.c           |   13 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c     |    4=20
 drivers/net/wireless/ath/ath9k/ath9k.h          |    5=20
 drivers/net/wireless/ath/ath9k/recv.c           |   17 +
 drivers/net/wireless/ath/ath9k/xmit.c           |    1=20
 drivers/net/wireless/brcm80211/brcmsmac/dma.c   |   15 +
 drivers/of/base.c                               |    1=20
 drivers/pinctrl/pinctrl-at91.c                  |    4=20
 drivers/scsi/mpt3sas/Makefile                   |    2=20
 drivers/scsi/sd.c                               |   11 -
 drivers/staging/comedi/drivers/dt282x.c         |    3=20
 drivers/staging/zram/zram_drv.c                 |   75 ++++++
 drivers/staging/zram/zram_drv.h                 |   10=20
 drivers/target/target_core_alua.c               |    2=20
 drivers/target/target_core_pr.c                 |    2=20
 drivers/tty/tty_io.c                            |    3=20
 drivers/usb/class/cdc-wdm.c                     |   13 -
 drivers/usb/core/config.c                       |    3=20
 drivers/usb/core/hub.c                          |   65 ++---
 drivers/usb/core/port.c                         |   13 -
 drivers/usb/dwc3/gadget.c                       |   39 ++-
 drivers/usb/gadget/uvc_queue.c                  |    6=20
 drivers/usb/host/ehci-mxc.c                     |    2=20
 drivers/usb/host/ohci-pci.c                     |    2=20
 drivers/usb/host/xhci-ext-caps.h                |    2=20
 drivers/usb/host/xhci-plat.c                    |    2=20
 drivers/usb/host/xhci.c                         |   29 ++
 drivers/usb/host/xhci.h                         |    1=20
 drivers/usb/serial/mos7720.c                    |    6=20
 drivers/xen/grant-table.c                       |   13 +
 fs/btrfs/ioctl.c                                |    3=20
 fs/ceph/ioctl.c                                 |    4=20
 fs/cifs/connect.c                               |    2=20
 fs/cifs/smb2misc.c                              |  148 +++++++------
 fs/ext4/inode.c                                 |  263 +++++++++++++------=
-----
 fs/fuse/dir.c                                   |   15 +
 fs/fuse/file.c                                  |   11 -
 fs/fuse/fuse_i.h                                |    2=20
 fs/fuse/inode.c                                 |    3=20
 fs/isofs/inode.c                                |   16 -
 fs/ocfs2/extent_map.c                           |    1=20
 fs/proc/root.c                                  |    3=20
 include/linux/compat.h                          |    7=20
 include/linux/hid.h                             |    4=20
 include/linux/pci_ids.h                         |    2=20
 include/linux/rculist.h                         |    5=20
 include/linux/signal.h                          |    8=20
 include/linux/usb/hcd.h                         |    2=20
 ipc/msg.c                                       |   12 -
 kernel/events/uprobes.c                         |    4=20
 kernel/fork.c                                   |    7=20
 kernel/pid.c                                    |    1=20
 mm/huge_memory.c                                |    2=20
 mm/memcontrol.c                                 |    8=20
 net/ceph/osd_client.c                           |    2=20
 net/ceph/osdmap.c                               |    2=20
 net/mac80211/mlme.c                             |   11 -
 sound/pci/hda/hda_intel.c                       |    1=20
 sound/pci/hda/patch_hdmi.c                      |   52 +++-
 sound/soc/codecs/mc13783.c                      |    4=20
 sound/soc/codecs/wm8960.c                       |    6=20
 126 files changed, 1217 insertions(+), 628 deletions(-)

Al Viro (1):
      Introduce [compat_]save_altstack_ex() to unbreak x86 SMAP

Alan Stern (4):
      SCSI: sd: Fix potential out-of-bounds access
      USB: OHCI: Allow runtime PM without system sleep
      USB: fix build error when CONFIG_PM_SLEEP isn't enabled
      USB: handle LPM errors during device suspend correctly

Alex Deucher (1):
      drm/edid: add quirk for Medion MD30217PG

Alex Williamson (1):
      intel-iommu: Fix leaks in pagetable freeing

Anand Avati (1):
      fuse: invalidate inode attributes on xattr modification

Anssi Hannula (1):
      ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA

Anton Blanchard (1):
      powerpc: Handle unaligned ldbrx/stdbrx

Aravind Gopalakrishnan (2):
      pci_ids: Add PCI device ID functions 3 and 4 for newer F15h models.
      x86, amd_nb: Clarify F15h, model 30h GART and L3 support

Arun Kumar K (2):
      media: exynos4-is: Fix fimc-lite bayer formats
      media: exynos-gsc: Register v4l2 device

Benjamin Tissoires (1):
      HID: kye: Add report fixup for Genius Gx Imperator Keyboard

Bj=F8rn Mork (1):
      media: siano: fix divide error on 0 counters

Boris BREZILLON (1):
      pinctrl: at91: fix get_pullup/down function return

Borislav Petkov (1):
      amd64_edac: Fix single-channel setups

Brian Norris (1):
      mtd: nand: fix NAND_BUSWIDTH_AUTO for x16 devices

Bruno Pr=E9mont (1):
      HID: picolcd: Prevent NULL pointer dereference on _remove()

Colin Cross (2):
      cpuidle: coupled: abort idle if pokes are pending
      cpuidle: coupled: fix race condition between pokes and safe state

Dan Carpenter (2):
      staging: comedi: dt282x: dt282x_ai_insn_read() always fails
      USB: mos7720: use GFP_ATOMIC under spinlock

Daniel Mack (1):
      usb: ehci-mxc: check for pdata before dereferencing

David Herrmann (1):
      HID: wiimote: work around broken DRM_KAI on GEN10

Eric W. Biederman (2):
      pidns: Fix hang in zap_pid_ns_processes by sending a potentially extr=
a wakeup
      proc: Restrict mounting the proc filesystem

Felipe Balbi (1):
      usb: dwc3: gadget: don't request IRQs in atomic

Felix Fietkau (4):
      ath9k: always clear ps filter bit on new assoc
      ath9k: fix rx descriptor related race condition
      ath9k: avoid accessing MRC registers on single-chain devices
      MIPS: ath79: Fix ar933x watchdog clock

Gera Kazakov (1):
      target: Fix >=3D v3.9+ regression in PR APTPL + ALUA metadata write-o=
ut

Grant Likely (1):
      of: Fix missing memory initialization on FDT unflattening

Greg Kroah-Hartman (2):
      SCSI: Allow MPT Fusion SAS 3.0 driver to be built into the kernel
      Linux 3.11.2

Greg Thelen (1):
      memcg: fix multiple large threshold notifications

Guenter Roeck (1):
      xtensa: Fix broken allmodconfig build

H. Peter Anvin (1):
      x86, smap: Handle csum_partial_copy_*_user()

Hans Verkuil (1):
      media: cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0

Hans de Goede (1):
      usb: config->desc.bLength may not exceed amount of data returned by t=
he device

Heiko Carstens (1):
      s390/bpf,jit: fix address randomization

Henrik Rydberg (1):
      HID: Correct the USB IDs for the new Macbook Air 6

Herbert Xu (1):
      crypto: api - Fix race condition in larval lookup

Imre Deak (1):
      drm/i915: make user mode sync polarity setting explicit

Jan Kara (4):
      ext4: move test whether extent to map can be extended to one place
      ext4: fix ext4_writepages() in presence of truncate
      ext4: simplify truncation code in ext4_setattr()
      isofs: Refuse RW mount of the filesystem instead of making it RO

Jeff Layton (1):
      cifs: ensure that srv_mutex is held when dealing with ssocket pointer

Jie Liu (1):
      ocfs2: fix the end cluster offset of FIEMAP

Jiri Kosina (1):
      HID: battery: don't do DMA from stack

Johan Hovold (1):
      USB: mos7720: fix big-endian control requests

Johannes Berg (1):
      mac80211: ignore (E)CSA in probe response frames

John W. Linville (1):
      brcmsmac: Fix WARNING caused by lack of calls to dma_mapping_error()

Josh Durgin (1):
      rbd: fix I/O error propagation for reads

Kees Cook (6):
      HID: pantherlord: validate output report details
      HID: sensor-hub: validate feature report details
      HID: validate HID report id size
      HID: picolcd_core: validate output report details
      HID: ntrig: validate feature report details
      HID: check for NULL field when setting values

Lan Tianyu (1):
      usb: don't check pm qos NO_POWER_OFF flag in usb_port_suspend()

Lars-Peter Clausen (1):
      regmap: debugfs: Fix continued read from registers file

Laurent Pinchart (1):
      usb: gadget: uvc: Fix error handling in uvc_queue_buffer()

Libin (1):
      mm/huge_memory.c: fix potential NULL pointer dereference

Manfred Spraul (1):
      ipc/msg.c: Fix lost wakeup in msgsnd().

Manoj Chourasia (1):
      HID: hidraw: correctly deallocate memory on device disconnect

Mark Brown (2):
      leds: wm831x-status: Request a REG resource
      clk: wm831x: Initialise wm831x pointer on init

Mathias Nyman (1):
      xhci: fix port BESL LPM capability checking

Mauro Carvalho Chehab (1):
      media: mb86a20s: Fix TS parallel mode

Maxim Patlasov (2):
      fuse: postpone end_page_writeback() in fuse_writepage_locked()
      fuse: hotfix truncate_pagecache() issue

Maxime Bizon (1):
      firmware loader: fix pending_fw_head list corruption

Mika Westerberg (1):
      ACPI / LPSS: don't crash if a device has no MMIO resources

Mike Dyer (1):
      ASoC: wm8960: Fix PLL register writes

Miklos Szeredi (1):
      fuse: readdir: check for slash in names

Minchan Kim (2):
      zram: fix invalid memory access
      zram: don't grab mutex in zram_slot_free_noity

Neil Horman (1):
      PCI/ACPI: Fix _OSC ordering to allow PCIe hotplug use when available

Noam Camus (1):
      ARC: SMP failed to boot due to missing IVT setup

Oleg Nesterov (3):
      tty: disassociate_ctty() sends the extra SIGCONT
      uprobes: Fix utask->depth accounting in handle_trampoline()
      pidns: fix vfork() after unshare(CLONE_NEWPID)

Oliver Neukum (1):
      USB: cdc-wdm: fix race between interrupt handler and tasklet

Paul Mackerras (1):
      KVM: PPC: Book3S: Fix compile error in XICS emulation

Pavel Shilovsky (2):
      CIFS: Fix a memory leak when a lease break comes
      CIFS: Fix missing lease break

Peter Maydell (3):
      ARM: PCI: versatile: Fix map_irq function to match hardware
      ARM: PCI: versatile: Fix PCI I/O
      ARM: PCI: versatile: Fix SMAP register offsets

Richard Weinberger (2):
      UBI: Fix PEB leak in wear_leveling_worker()
      um: Implement probe_kernel_read()

Rik van Riel (1):
      sched/x86: Optimize switch_mm() for multi-threaded workloads

Rob Herring (1):
      ARM: xen: only set pm function ptrs for Xen guests

Roger Pau Monne (1):
      xen-gnt: prevent adding duplicate gnt callbacks

Sage Weil (1):
      libceph: use pg_num_mask instead of pgp_num_mask for pg.seed calc

Sarah Sharp (2):
      xhci-plat: Don't enable legacy PCI interrupts.
      usb: Don't fail port power resume on device disconnect.

Sergei Shtylyov (1):
      mmc: tmio_mmc_dma: fix PIO fallback on SDHI

Shawn Nematbakhsh (1):
      usb: xhci: Disable runtime PM suspend for quirky controllers

Stefan Behrens (1):
      Btrfs: don't allow the replace procedure on read only filesystems

Stefan Kriwanek (1):
      HID: Fix Speedlink VAD Cezanne support for some devices

Steffen Trumtrar (1):
      ASoC: mc13783: add spi errata fix

Sylwester Nawrocki (1):
      media: exynos4-is: Fix entity unregistration on error path

Takashi Iwai (2):
      ALSA: hda - Re-setup HDMI pin and audio infoframe on stream switches
      ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist

Tejun Heo (1):
      rculist: list_first_or_null_rcu() should use list_entry_rcu()

Thomas Petazzoni (1):
      net: mvneta: properly disable HW PHY polling and ensure adjust_link()=
 works

Tony Luck (1):
      x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC' erro=
rs

Vaidyanathan Srinivasan (1):
      powerpc: Default arch idle could cede processor on pseries

Vasily Titskiy (1):
      HID: usbhid: quirk for N-Trig DuoSense Touch Screen

Will Deacon (2):
      arm64: perf: fix group validation when using enable_on_exec
      arm64: perf: fix ARMv8 EVTYPE_MASK to include NSH bit

majianpeng (2):
      libceph: unregister request in __map_request failed and nofail =3D=3D=
 false
      ceph: Don't forget the 'up_read(&osdc->map_sem)' if met error.


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSRNDCAAoJEDjbvchgkmk+hREQAI2XI9RlfPFhviKiiRcC0ZuI
YjvK0yGUtI7mxUHsk+frhBKgzZ2hhl/Oc3ZdUd7MlF/4xPSzFs+6/HJfuSn4b+na
7r4FFvYESA62QUY3bQGUrkjtn3yY3pFz4vK7elzb2mMaGKkQJK/rJrVM+kTxT8sA
/xlpu91LOl8w2K2Ut2QaoFHeQAetVt4W+oEtASRG5yFed4BU5zTymQueMekVb07O
/NkVq+X/pJtfSEsw2isEGsrdJJ3L3v1t5oI6fHQ6lmB66W3emcYrVNvuFA9/7cKb
KUSrZroXvfnl/1M47uyHS+C4TI+RpIfA11d4tDpwUE3MWM/J1nc9lMkJ0PaoxuD6
vq/kTWm+KGiNUwX0M1vcKpsGOM9kGRj9/a6ufZx3lTAj0wxxoCdiGzMrld0FeKSG
cFkNhZXH6eYOINLu4gMTqBLuWme22PE3arW6ZOb86Z/DLt6md0EM9wJXpHMkSfSY
YkngMKj3Bf+rFRrOFwnG6PkhU74Sfczot7XsHT3YAuvI+8PXH2C94NrDFY1iG1XE
08PO3QUTgx6IkeRfml2AOgK3VQFceFx6S0oNXdcvqoKtxgrTYFq0P8h3qER7gmIb
nxBlabV++td1VyCIRqMVDrT1xecjfOYjRM5kuQzB0fynFJnVnFFKuLe+9G0SnfWO
g+NnOxlXMBX8/y0spoFN
=7Hwo
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
