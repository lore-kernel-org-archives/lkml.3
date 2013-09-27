Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3I0A0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 20:26:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3I0A0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 20:26:16 -0400
Date: Thu, 26 Sep 2013 17:26:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.13
Message-ID: <20130927002615.GA8394@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.13 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/DocBook/media_api.tmpl            |    4=20
 Makefile                                        |    2=20
 arch/arm/boot/dts/at91rm9200.dtsi               |    6=20
 arch/arm/boot/dts/at91sam9260.dtsi              |    8 -
 arch/arm/boot/dts/at91sam9263.dtsi              |    8 -
 arch/arm/boot/dts/at91sam9g45.dtsi              |    8 -
 arch/arm/boot/dts/at91sam9n12.dtsi              |    8 -
 arch/arm/boot/dts/at91sam9x5.dtsi               |    8 -
 arch/arm/boot/dts/sama5d3.dtsi                  |    4=20
 arch/arm/boot/dts/sun4i-a10.dtsi                |    4=20
 arch/arm/boot/dts/sun5i-a13.dtsi                |    4=20
 arch/arm/kvm/coproc.c                           |   26 +++-
 arch/arm/kvm/coproc.h                           |    3=20
 arch/arm/kvm/coproc_a15.c                       |    6=20
 arch/arm/mach-versatile/include/mach/platform.h |    2=20
 arch/arm/mach-versatile/pci.c                   |   47 ++++---
 arch/arm/xen/enlighten.c                        |    5=20
 arch/arm64/kernel/perf_event.c                  |    7 -
 arch/mips/ath79/clock.c                         |    2=20
 arch/powerpc/kernel/align.c                     |   10 +
 arch/powerpc/kvm/book3s_xics.c                  |    1=20
 arch/powerpc/platforms/pseries/setup.c          |   31 +++--
 arch/um/include/shared/os.h                     |    1=20
 arch/um/kernel/Makefile                         |    2=20
 arch/um/kernel/maccess.c                        |   24 +++
 arch/um/os-Linux/process.c                      |   52 ++++++++
 arch/x86/ia32/ia32_signal.c                     |    2=20
 arch/x86/include/asm/checksum_32.h              |   22 ++-
 arch/x86/include/asm/mce.h                      |   13 +-
 arch/x86/include/asm/mmu_context.h              |   20 ++-
 arch/x86/kernel/amd_nb.c                        |   13 +-
 arch/x86/kernel/signal.c                        |    6=20
 arch/x86/lib/csum-wrappers_64.c                 |   12 +
 crypto/api.c                                    |    7 -
 drivers/acpi/acpi_lpss.c                        |    3=20
 drivers/block/rbd.c                             |   14 +-
 drivers/clk/clk-wm831x.c                        |    2=20
 drivers/cpuidle/coupled.c                       |  127 +++++++++++++++-----
 drivers/edac/amd64_edac.c                       |    9 +
 drivers/gpu/drm/drm_edid.c                      |    3=20
 drivers/hid/hid-core.c                          |   17 ++
 drivers/hid/hid-ids.h                           |    7 -
 drivers/hid/hid-input.c                         |   12 +
 drivers/hid/hid-ntrig.c                         |    3=20
 drivers/hid/hid-picolcd_cir.c                   |    3=20
 drivers/hid/hid-picolcd_core.c                  |    2=20
 drivers/hid/hid-picolcd_fb.c                    |    6=20
 drivers/hid/hid-pl.c                            |   10 +
 drivers/hid/hid-sensor-hub.c                    |    3=20
 drivers/hid/hid-speedlink.c                     |   11 +
 drivers/hid/hidraw.c                            |   60 ++++-----
 drivers/hid/usbhid/hid-quirks.c                 |    2=20
 drivers/input/mouse/bcm5974.c                   |    6=20
 drivers/iommu/intel-iommu.c                     |   72 +++++------
 drivers/leds/leds-wm831x-status.c               |    4=20
 drivers/media/common/siano/smsdvb-main.c        |    3=20
 drivers/media/dvb-frontends/mb86a20s.c          |   16 +-
 drivers/media/platform/coda.c                   |    2=20
 drivers/media/platform/exynos-gsc/gsc-core.c    |    9 +
 drivers/media/platform/exynos-gsc/gsc-core.h    |    1=20
 drivers/media/platform/exynos-gsc/gsc-m2m.c     |    1=20
 drivers/media/platform/exynos4-is/media-dev.c   |    2=20
 drivers/media/platform/s5p-g2d/g2d.c            |    1=20
 drivers/media/usb/hdpvr/hdpvr-core.c            |   11 -
 drivers/mmc/host/tmio_mmc_dma.c                 |    4=20
 drivers/mtd/nand/nand_base.c                    |    8 -
 drivers/mtd/ubi/wl.c                            |    3=20
 drivers/net/wireless/ath/ath9k/ar9003_phy.c     |    4=20
 drivers/net/wireless/ath/ath9k/ath9k.h          |    5=20
 drivers/net/wireless/ath/ath9k/recv.c           |   17 ++
 drivers/net/wireless/ath/ath9k/xmit.c           |    1=20
 drivers/net/wireless/brcm80211/brcmsmac/dma.c   |   15 +-
 drivers/of/base.c                               |    1=20
 drivers/pinctrl/pinctrl-at91.c                  |    4=20
 drivers/scsi/mpt3sas/Makefile                   |    2=20
 drivers/scsi/sd.c                               |   11 -
 drivers/staging/comedi/drivers/dt282x.c         |    3=20
 drivers/staging/iio/adc/mxs-lradc.c             |   18 +-
 drivers/target/target_core_alua.c               |    2=20
 drivers/target/target_core_pr.c                 |    2=20
 drivers/tty/tty_io.c                            |    3=20
 drivers/usb/class/cdc-wdm.c                     |   13 +-
 drivers/usb/core/config.c                       |    3=20
 drivers/usb/core/hub.c                          |   65 ++++------
 drivers/usb/core/port.c                         |   13 --
 drivers/usb/dwc3/gadget.c                       |   39 +++---
 drivers/usb/gadget/uvc_queue.c                  |    6=20
 drivers/usb/host/ehci-mxc.c                     |    2=20
 drivers/usb/host/ohci-pci.c                     |    2=20
 drivers/usb/host/xhci-plat.c                    |    2=20
 drivers/usb/host/xhci.c                         |   29 ++++
 drivers/usb/host/xhci.h                         |    1=20
 drivers/usb/serial/mos7720.c                    |    6=20
 drivers/xen/grant-table.c                       |   13 +-
 fs/btrfs/ioctl.c                                |    3=20
 fs/ceph/ioctl.c                                 |    4=20
 fs/cifs/connect.c                               |    2=20
 fs/cifs/smb2misc.c                              |  148 ++++++++++++-------=
-----
 fs/ext4/inode.c                                 |  109 +++++++----------
 fs/fuse/dir.c                                   |   15 ++
 fs/fuse/file.c                                  |   11 +
 fs/fuse/fuse_i.h                                |    2=20
 fs/fuse/inode.c                                 |    3=20
 fs/isofs/inode.c                                |   16 --
 fs/ocfs2/extent_map.c                           |    1=20
 fs/proc/root.c                                  |    3=20
 include/linux/compat.h                          |    7 +
 include/linux/hid.h                             |    4=20
 include/linux/pci_ids.h                         |    2=20
 include/linux/rculist.h                         |    5=20
 include/linux/signal.h                          |    8 +
 include/linux/usb/hcd.h                         |    2=20
 include/media/v4l2-ctrls.h                      |    1=20
 kernel/events/uprobes.c                         |    4=20
 kernel/fork.c                                   |    7 -
 kernel/pid.c                                    |    1=20
 mm/huge_memory.c                                |    2=20
 mm/memcontrol.c                                 |    8 +
 net/ceph/osd_client.c                           |    2=20
 net/ceph/osdmap.c                               |    2=20
 net/core/scm.c                                  |    2=20
 sound/pci/hda/hda_intel.c                       |    1=20
 sound/pci/hda/patch_hdmi.c                      |   52 ++++++--
 sound/soc/codecs/mc13783.c                      |    4=20
 sound/soc/codecs/wm8960.c                       |    6=20
 125 files changed, 1013 insertions(+), 521 deletions(-)

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

Alexander Shiyan (1):
      media: media: coda: Fix DT driver data pointer for i.MX27

Alexey Khoroshilov (1):
      media: hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Anand Avati (1):
      fuse: invalidate inode attributes on xattr modification

Andrzej Hajda (2):
      media: DocBook: upgrade media_api DocBook version to 4.2
      media: v4l2: added missing mutex.h include to v4l2-ctrls.h

Andy Lutomirski (1):
      net: Check the correct namespace when spoofing pid over SCM_RIGHTS

Anssi Hannula (1):
      ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA

Anton Blanchard (1):
      powerpc: Handle unaligned ldbrx/stdbrx

Aravind Gopalakrishnan (2):
      pci_ids: Add PCI device ID functions 3 and 4 for newer F15h models.
      x86, amd_nb: Clarify F15h, model 30h GART and L3 support

Arnd Bergmann (1):
      ARM: dts: add missing cpu #address-cell values

Arun Kumar K (1):
      media: exynos-gsc: Register v4l2 device

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

Christoffer Dall (1):
      ARM: KVM: Fix 64-bit coprocessor handling

Colin Cross (2):
      cpuidle: coupled: abort idle if pokes are pending
      cpuidle: coupled: fix race condition between pokes and safe state

Dan Carpenter (2):
      staging: comedi: dt282x: dt282x_ai_insn_read() always fails
      USB: mos7720: use GFP_ATOMIC under spinlock

Daniel Mack (1):
      usb: ehci-mxc: check for pdata before dereferencing

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
      Linux 3.10.13

Greg Thelen (1):
      memcg: fix multiple large threshold notifications

H. Peter Anvin (1):
      x86, smap: Handle csum_partial_copy_*_user()

Hans de Goede (1):
      usb: config->desc.bLength may not exceed amount of data returned by t=
he device

Henrik Rydberg (1):
      HID: Correct the USB IDs for the new Macbook Air 6

Herbert Xu (1):
      crypto: api - Fix race condition in larval lookup

Jan Kara (2):
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

Laurent Pinchart (1):
      usb: gadget: uvc: Fix error handling in uvc_queue_buffer()

Libin (1):
      mm/huge_memory.c: fix potential NULL pointer dereference

Lorenzo Pieralisi (2):
      ARM: dts: at91: cpus/cpu node dts updates
      ARM: dts: sunxi: cpus/cpu nodes dts updates

Manoj Chourasia (1):
      HID: hidraw: correctly deallocate memory on device disconnect

Marek Vasut (2):
      iio: mxs-lradc: Fix misuse of iio->trig
      iio: mxs-lradc: Remove useless check in read_raw

Mark Brown (2):
      leds: wm831x-status: Request a REG resource
      clk: wm831x: Initialise wm831x pointer on init

Mauro Carvalho Chehab (1):
      media: mb86a20s: Fix TS parallel mode

Maxim Patlasov (2):
      fuse: postpone end_page_writeback() in fuse_writepage_locked()
      fuse: hotfix truncate_pagecache() issue

Mika Westerberg (1):
      ACPI / LPSS: don't crash if a device has no MMIO resources

Mike Dyer (1):
      ASoC: wm8960: Fix PLL register writes

Miklos Szeredi (1):
      fuse: readdir: check for slash in names

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

Sachin Kamat (1):
      media: s5p-g2d: Fix registration failure

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


--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSRNCnAAoJEDjbvchgkmk+NkIP/0ZJPhZngOfoeK1OsooAgMNe
GKw9v/2TqqJCTLtgb4wQaPOPNU/dmzvhzB5Uc74GuV9PdCbrNFoVReaCRr5MW2rh
Q+0OW94qhp1rn5ewhi4XfYQTesBokYYSrrc6bw+fo4boqmIV2OhnG2V64lxuqsa7
oSYZ0lUY2dqUU5LyPediZblMWzNyiyYqLKnmG+0KHeK2EqhFAEEKQTwtGxqir3fW
dvJapkbY9p6w94+fVseFozGYVFwmGKWmJPn7HdnSeISCt6F94s/NsEoMiTZDVvYQ
VoRMNNCandD69aK+cUbwU1RvBosh9WqS75Yroksj0WcsyAfBc2BL9vMsrdoPkgRT
bKNGinGwv+yUH3nP7T8WDGKF5jGydrL4E4tZiaUHdZaNXgRc5FN8FIa4jkwnoLFf
W2lpH6EfVLLwjUx0GnVX9t6lml8qO3kOpzymtApGI9X2yWA59bSRGjf1cN7VV27C
fCop1kOQVHyMCUArrcQ3BfAhkgWiXSefhPJiVeYKpl/JnngSqqjtZbmiVyj7VVhr
kGsFD/kdGRcOmZRIdLfCKJpnD6FCcE8h07UuSO1Vq0+HiADf8rGR/9Q+r7xxRWoQ
Q0s+ricsHgSRqy10jmhLgvZF7y4kkWfSxawivmp3sD6CAJ4OUciX4uAqz/kgJHvh
8yFpBPntsgiQ2hkHmSMP
=i2OS
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
