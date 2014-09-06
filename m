Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaIFAI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:08:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaIFAIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:08:53 -0400
Date: Fri, 5 Sep 2014 17:08:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.18
Message-ID: <20140906000852.GA12527@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.18 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/sound/alsa/ALSA-Configuration.txt |    4 -
 Documentation/stable_kernel_rules.txt           |    3 +
 Makefile                                        |    2=20
 arch/arm/boot/dts/am4372.dtsi                   |    3 -
 arch/arm/include/asm/unistd.h                   |   10 +++
 arch/arm/include/uapi/asm/unistd.h              |   11 ---
 arch/arm/mach-omap2/control.c                   |    3 -
 arch/arm/mach-omap2/omap_hwmod.c                |    4 +
 arch/powerpc/platforms/powernv/pci-ioda.c       |    1=20
 arch/powerpc/platforms/pseries/pci_dlpar.c      |    4 -
 arch/x86/Kconfig                                |    1=20
 arch/x86/include/asm/kvm_host.h                 |    2=20
 arch/x86/kernel/resource.c                      |    8 +-
 arch/x86/kernel/vsyscall_64.c                   |    8 +-
 arch/x86/kvm/emulate.c                          |    4 +
 arch/x86/kvm/irq.c                              |    2=20
 arch/x86/kvm/lapic.c                            |   52 +++++++++++++-----
 arch/x86/pci/i386.c                             |    4 +
 arch/x86/xen/grant-table.c                      |   10 +--
 arch/x86/xen/time.c                             |    2=20
 drivers/char/tpm/tpm_i2c_stm_st33.c             |    1=20
 drivers/crypto/ux500/cryp/cryp_core.c           |   25 ++++----
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c        |    6 +-
 drivers/gpu/drm/omapdrm/omap_gem.c              |   10 +--
 drivers/gpu/drm/omapdrm/omap_plane.c            |    4 -
 drivers/gpu/drm/radeon/cik.c                    |    1=20
 drivers/hid/hid-cherry.c                        |    2=20
 drivers/hid/hid-kye.c                           |    2=20
 drivers/hid/hid-lg.c                            |    4 -
 drivers/hid/hid-logitech-dj.c                   |   13 ++--
 drivers/hid/hid-monterey.c                      |    2=20
 drivers/hid/hid-petalynx.c                      |    2=20
 drivers/hid/hid-sunplus.c                       |    2=20
 drivers/hwmon/ads1015.c                         |    4 +
 drivers/hwmon/amc6821.c                         |   17 +++---
 drivers/hwmon/dme1737.c                         |   33 ++++++-----
 drivers/hwmon/gpio-fan.c                        |    2=20
 drivers/hwmon/lm78.c                            |    2=20
 drivers/hwmon/lm85.c                            |    9 ++-
 drivers/hwmon/sis5595.c                         |    2=20
 drivers/i2c/busses/i2c-at91.c                   |    4 -
 drivers/misc/mei/client.c                       |    2=20
 drivers/misc/mei/nfc.c                          |   11 +--
 drivers/pci/pci-label.c                         |   18 ++++--
 drivers/pci/pci.c                               |   12 ++--
 drivers/scsi/hpsa.c                             |    6 +-
 drivers/staging/et131x/et131x.c                 |   68 +++++++++----------=
-----
 drivers/staging/rtl8188eu/os_dep/usb_intf.c     |    2=20
 drivers/tty/serial/serial_core.c                |    3 +
 drivers/usb/core/devio.c                        |    2=20
 drivers/usb/core/hub.c                          |   49 ++++++++++++++++-
 drivers/usb/host/ehci-hub.c                     |    2=20
 drivers/usb/host/ehci-pci.c                     |   25 ++++++++
 drivers/usb/host/ohci-dbg.c                     |    9 +--
 drivers/usb/host/ohci-hcd.c                     |   10 +--
 drivers/usb/host/ohci-q.c                       |   46 ++++++++++------
 drivers/usb/host/xhci-pci.c                     |    4 +
 drivers/usb/host/xhci-ring.c                    |    3 -
 drivers/usb/serial/ftdi_sio.c                   |    5 +
 drivers/usb/serial/ftdi_sio_ids.h               |   20 +++++--
 drivers/usb/serial/whiteheat.c                  |    7 ++
 drivers/xen/events/events_fifo.c                |    5 -
 fs/btrfs/backref.c                              |   14 ++--
 fs/btrfs/extent_io.c                            |    1=20
 fs/btrfs/file-item.c                            |    2=20
 fs/btrfs/inode.c                                |   12 ++++
 fs/btrfs/ulist.h                                |   15 +++++
 fs/debugfs/inode.c                              |   33 +++++++++--
 fs/ext4/inode.c                                 |   10 ++-
 fs/ext4/mballoc.c                               |   26 ++++++++-
 fs/ext4/super.c                                 |    5 +
 fs/isofs/inode.c                                |   15 ++---
 fs/isofs/isofs.h                                |   23 ++++++--
 fs/isofs/rock.c                                 |   39 +++++++++----
 fs/jbd2/commit.c                                |   21 ++++---
 fs/jbd2/journal.c                               |   56 +++++++++++++------
 fs/jbd2/recovery.c                              |   33 +++++++----
 fs/jbd2/revoke.c                                |    6 +-
 fs/nfs/nfs3acl.c                                |    7 +-
 fs/nfs/nfs4proc.c                               |   17 ++++--
 fs/nfsd/nfs4callback.c                          |    3 -
 fs/nfsd/nfssvc.c                                |    5 +
 include/drm/drm_pciids.h                        |    7 ++
 include/linux/jbd2.h                            |   30 ++++++++--
 include/linux/sunrpc/svc_xprt.h                 |    1=20
 kernel/sched/core.c                             |    5 +
 mm/util.c                                       |    9 +--
 net/sunrpc/svcsock.c                            |    2=20
 net/sunrpc/xprt.c                               |    2=20
 net/sunrpc/xprtrdma/svc_rdma_transport.c        |    1=20
 sound/pci/Kconfig                               |    4 -
 sound/pci/hda/patch_ca0132.c                    |    7 ++
 sound/pci/hda/patch_realtek.c                   |   28 ++++++++-
 sound/pci/hda/patch_sigmatel.c                  |   12 ++++
 sound/pci/oxygen/virtuoso.c                     |    1=20
 sound/pci/oxygen/xonar_pcm179x.c                |   12 +++-
 sound/usb/quirks-table.h                        |   29 ++++++++++
 sound/usb/quirks.c                              |    2=20
 virt/kvm/ioapic.c                               |    7 +-
 virt/kvm/iommu.c                                |   19 +++---
 100 files changed, 768 insertions(+), 347 deletions(-)

Alan Stern (2):
      USB: OHCI: fix bugs in debug routines
      USB: OHCI: don't lose track of EDs when a controller dies

Alex Deucher (3):
      drm/radeon: add new KV pci id
      drm/radeon: add new bonaire pci ids
      drm/radeon: add additional SI pci ids

Alexander Usyskin (3):
      mei: start disconnect request timer consistently
      mei: reset client state on queued connect request
      mei: nfc: fix memory leak in error path

Andrey Utkin (1):
      nfs3_list_one_acl(): check get_acl() result with IS_ERR_OR_NULL

Andy Lutomirski (1):
      x86_64/vsyscall: Fix warn_bad_vsyscall log output

Arnd Bergmann (2):
      crypto: ux500 - make interrupt mode plausible
      hpsa: fix non-x86 builds

Axel Lin (6):
      hwmon: (sis5595) Prevent overflow problem when writing large limits
      hwmon: (amc6821) Fix possible race condition bug
      hwmon: (gpio-fan) Prevent overflow problem when writing large limits
      hwmon: (ads1015) Fix off-by-one for valid channel index checking
      hwmon: (ads1015) Fix out-of-bounds array access
      hwmon: (dme1737) Prevent overflow problem when writing large limits

Baruch Siach (1):
      ARM: 8097/1: unistd.h: relocate comments back to place

Brian W Hart (1):
      powerpc/powernv: Update dev->dma_mask in pci_set_dma_mask() path

Bryan O'Donoghue (1):
      USB: ehci-pci: USB host controller support for Intel Quark X1000

Christoph Schulz (1):
      x86: don't exclude low BIOS area when allocating address space for no=
n-PCI cards

Chuck Lever (1):
      svcrdma: Select NFSv4.1 backchannel transport based on forward channel

Clemens Ladisch (2):
      ALSA: virtuoso: add Xonar Essence STX II support
      ALSA: usb-audio: fix BOSS ME-25 MIDI regression

Daniel Bristot de Oliveira (1):
      sched: Fix sched_setparam() policy =3D=3D -1 logic

Darrick J. Wong (2):
      jbd2: fix infinite loop when recovering corrupt journal blocks
      jbd2: fix descriptor block size handling errors with journal_csum

Dave Chiluk (1):
      stable_kernel_rules: Add pointer to netdev-FAQ for network patches

David Henningsson (1):
      ALSA: hda - Add mute LED pin quirk for HP 15 touchsmart

David Vrabel (3):
      xen/events/fifo: ensure all bitops are properly aligned even on x86
      x86/xen: use vmap() to map grant table pages in PVH guests
      x86/xen: resume timer irqs early

Dmitry Monakhov (1):
      ext4: update i_disksize coherently with block allocation on error path

Filipe Manana (2):
      Btrfs: fix csum tree corruption, duplicate and outdated checksums
      Btrfs: read lock extent buffer while walking backrefs

Greg Kroah-Hartman (2):
      USB: fix build error with CONFIG_PM_RUNTIME disabled
      Linux 3.14.18

Guenter Roeck (2):
      hwmon: (lm78) Fix overflow problems seen when writing large temperatu=
re limits
      hwmon: (lm85) Fix various errors on attribute writes

Hans de Goede (1):
      xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_S=
TOP_INVAL

Holger Paradies (1):
      staging/rtl8188eu: add 0df6:0076 Sitecom Europe B.V.

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk

Hui Wang (2):
      ALSA: hda - fix an external mic jack problem on a HP machine
      ALSA: hda - restore the gpio led after resume

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response

Jan Kara (1):
      isofs: Fix unbounded recursion when processing relocated directories

Jason Gunthorpe (1):
      tpm: Add missing tpm_do_selftest to ST33 I2C driver

Ja=C5=A1a Bartelj (1):
      USB: ftdi_sio: Added PID for new ekey device

Jeremy Vial (1):
      ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX rev3.=
1.2 case.

Jiri Kosina (2):
      HID: logitech: perform bounds checking on device_id early enough
      HID: fix a couple of off-by-ones

Johan Hovold (1):
      USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID

Kinglong Mee (1):
      NFSD: Decrease nfsd_users in nfsd_startup_generic fail

Larry Finger (1):
      staging: r8188eu: Add new USB ID

Liu Bo (2):
      Btrfs: fix compressed write corruption on enospc
      Btrfs: fix crash on endio of reading corrupted block

Mark Einon (1):
      staging: et131x: Fix errors caused by phydev->addr accesses before in=
itialisation

Matt Fleming (1):
      x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub

Michael S. Tsirkin (1):
      kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-=
3601)

Nadav Amit (1):
      KVM: x86: Inter-privilege level ret emulation is not implemeneted

Oleg Nesterov (1):
      vm_is_stack: use for_each_thread() rather then buggy while_each_threa=
d()

Oliver Neukum (1):
      USB: devio: fix issue with log flooding

Paolo Bonzini (2):
      KVM: x86: always exit on EOIs for interrupts listed in the IOAPIC red=
ir table
      Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"

Patrick Riphagen (2):
      USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
      USB: serial: ftdi_sio: Add support for new Xsens devices

Paul S McSpadden (1):
      ALSA: usb-audio: Adjust Gamecom 780 volume level

Peter Chen (1):
      usb: ehci: using wIndex + 1 for hub port

Peter Hurley (1):
      serial: core: Preserve termios c_cflag for console resume

Pratyush Anand (1):
      USB: Fix persist resume of some SS USB devices

Roger Quadros (1):
      usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1

Russell King (1):
      drm: omapdrm: fix compiler errors

Simone Gotti (1):
      ACPI / PCI: Fix sysfs acpi_index and label errors

Stephen M. Cameron (1):
      hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl

Steven Rostedt (1):
      debugfs: Fix corrupted loop in debugfs_remove_recursive

Suman Anna (1):
      ARM: dts: AM4372: Correct mailbox node data

Takashi Iwai (3):
      ALSA: hda/ca0132 - Don't try loading firmware at resume when already =
failed
      ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co
      Btrfs: Fix memory corruption by ulist_add_merge() on 32bit arch

Theodore Ts'o (2):
      ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa=
 struct
      ext4: fix BUG_ON in mb_free_blocks()

Tony Lindgren (1):
      ARM: OMAP2+: hwmod: Rearm wake-up interrupts for DT when MUSB is idled

Trond Myklebust (2):
      NFSv3: Fix another acl regression
      NFSv4: Fix problems with close in the presence of a delegation

Tyrel Datwyler (1):
      powerpc/pci: Reorder pci bus/bridge unregistration during PHB removal

Vidya Sagar (1):
      PCI: Configure ASPM when enabling device

Wanpeng Li (1):
      KVM: nVMX: fix "acknowledge interrupt on exit" when APICv is in use

Wolfram Sang (1):
      drivers/i2c/busses: use correct type for dma_map/unmap


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUClCUAAoJEDjbvchgkmk+H1wP/jgaYQdkkwpiCP1YDrAa1ybJ
+0HnzyipY5HDlzfu1Dh0GgAOrYy2qo3gQiYUYtr1RME5+od4KYDDt2gguUE9cOWZ
a2A7gz6wf8vRFtwjbmazqqHdfKbH/Q7O7uvuLFU46iirO8dBogJVNc4pOv04+kQf
yM3Jg6Zw9TDtyqUVjejMUvu0wtGN1nq5waelD7bVsSUqgJ0+8Z5/7ZQEEC4Ut5UJ
OWg96ebSJXY5cZDsyK2+6NzSvlxHXbmB7yIdL+l+3Q/kyVeiAYzLVXzoTHCDexzI
jDQe+eWuADePxTAsDnwTLZCk1WLZ4nI3xNGuAG/RKoizzy/YiV8DWL5t8cJk/m1x
JvXujmOKdiJFMRINx82r/ZrU/tgDqQwcWcP0eNhDWxf4qU+t1HAAJ9g/RUK3Xgk4
nCD94ywb99+PDYEhIhOz68g2VD4BxhwkvNAPwje2fzr9WeX2U3bdnKrYS4gINhhD
9pefHNbdSJUks/LsP6NHxjnUp6TuTj2r61mw2z2ncJ3+n4zbYXO0zQbDkCL849EE
i9shnKVcVtHjTZycv8zMCF+0u8d3gNtzn2R132JYmZIL4NgoASzkQ3r2vq3fxE+x
lNaBOpDL2ICtJUCL+o9S3YwYPvtQAxisTcfCmNBsIzoKKkQIZNheoUQJywdnSm7+
5GAnMY98bRK7ZkiLH0MO
=wXTo
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
