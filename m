Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaIFAJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:09:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaIFAJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:09:31 -0400
Date: Fri, 5 Sep 2014 17:09:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.16.2
Message-ID: <20140906000930.GA12599@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.2 kernel.

All users of the 3.16 kernel series must upgrade.

The updated 3.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.16.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/sound/alsa/ALSA-Configuration.txt    |    4=20
 Documentation/stable_kernel_rules.txt              |    3=20
 Documentation/virtual/kvm/api.txt                  |    3=20
 Makefile                                           |    2=20
 arch/arm/boot/dts/am4372.dtsi                      |    3=20
 arch/arm/include/asm/unistd.h                      |   10=20
 arch/arm/include/uapi/asm/unistd.h                 |   11=20
 arch/arm/mach-omap2/control.c                      |    3=20
 arch/arm/mach-omap2/omap_hwmod.c                   |    4=20
 arch/arm64/include/asm/cacheflush.h                |   11=20
 arch/arm64/include/asm/pgtable.h                   |   13=20
 arch/arm64/include/asm/tlbflush.h                  |    5=20
 arch/arm64/kernel/debug-monitors.c                 |   22 -
 arch/arm64/kernel/efi.c                            |    2=20
 arch/mips/math-emu/cp1emu.c                        |    2=20
 arch/powerpc/include/uapi/asm/kvm.h                |    1=20
 arch/powerpc/kernel/eeh_pe.c                       |   46 ---
 arch/powerpc/kvm/book3s_hv.c                       |   13=20
 arch/powerpc/kvm/book3s_pr.c                       |    2=20
 arch/powerpc/platforms/powernv/pci-ioda.c          |    1=20
 arch/powerpc/platforms/pseries/pci_dlpar.c         |    4=20
 arch/s390/mm/pgtable.c                             |    5=20
 arch/x86/Kconfig                                   |    1=20
 arch/x86/include/asm/kvm_host.h                    |    2=20
 arch/x86/include/asm/pgtable.h                     |    9=20
 arch/x86/kernel/cpu/mcheck/mce_intel.c             |   18 -
 arch/x86/kernel/resource.c                         |    8=20
 arch/x86/kernel/vsyscall_64.c                      |    8=20
 arch/x86/kvm/emulate.c                             |    4=20
 arch/x86/kvm/irq.c                                 |    2=20
 arch/x86/kvm/lapic.c                               |   52 ++-
 arch/x86/pci/i386.c                                |    4=20
 arch/x86/xen/grant-table.c                         |   10=20
 arch/x86/xen/time.c                                |    2=20
 drivers/char/tpm/tpm_i2c_stm_st33.c                |    1=20
 drivers/crypto/ux500/cryp/cryp_core.c              |   25 -
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c           |    6=20
 drivers/gpu/drm/omapdrm/omap_gem.c                 |   10=20
 drivers/gpu/drm/omapdrm/omap_plane.c               |    4=20
 drivers/gpu/drm/radeon/cik.c                       |    1=20
 drivers/hid/hid-cherry.c                           |    2=20
 drivers/hid/hid-kye.c                              |    2=20
 drivers/hid/hid-lg.c                               |    4=20
 drivers/hid/hid-logitech-dj.c                      |   15 -
 drivers/hid/hid-monterey.c                         |    2=20
 drivers/hid/hid-petalynx.c                         |    2=20
 drivers/hid/hid-sunplus.c                          |    2=20
 drivers/hwmon/ads1015.c                            |    4=20
 drivers/hwmon/amc6821.c                            |   17 -
 drivers/hwmon/dme1737.c                            |   33 +-
 drivers/hwmon/gpio-fan.c                           |    2=20
 drivers/hwmon/lm78.c                               |    2=20
 drivers/hwmon/lm85.c                               |    9=20
 drivers/hwmon/lm92.c                               |   13=20
 drivers/hwmon/sis5595.c                            |    2=20
 drivers/i2c/busses/i2c-at91.c                      |    4=20
 drivers/i2c/busses/i2c-rk3x.c                      |    2=20
 drivers/misc/mei/client.c                          |   18 -
 drivers/misc/mei/nfc.c                             |   11=20
 drivers/misc/mei/pci-me.c                          |    2=20
 drivers/misc/mei/pci-txe.c                         |    2=20
 drivers/mmc/host/mmci.c                            |   33 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |    2=20
 drivers/pci/pci-label.c                            |   18 -
 drivers/pci/pci.c                                  |   12=20
 drivers/pci/setup-res.c                            |    7=20
 drivers/scsi/hpsa.c                                |    6=20
 drivers/staging/et131x/et131x.c                    |   68 ++---
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    2=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |    2=20
 drivers/tty/serial/serial_core.c                   |    3=20
 drivers/usb/core/devio.c                           |    2=20
 drivers/usb/core/hub.c                             |   58 ++++
 drivers/usb/host/ehci-hub.c                        |    2=20
 drivers/usb/host/ehci-pci.c                        |   25 +
 drivers/usb/host/ohci-dbg.c                        |    9=20
 drivers/usb/host/ohci-hcd.c                        |   10=20
 drivers/usb/host/ohci-q.c                          |   46 ++-
 drivers/usb/host/xhci-pci.c                        |   13=20
 drivers/usb/host/xhci-ring.c                       |  104 +++----
 drivers/usb/host/xhci.c                            |    6=20
 drivers/usb/host/xhci.h                            |    2=20
 drivers/usb/serial/ftdi_sio.c                      |    5=20
 drivers/usb/serial/ftdi_sio_ids.h                  |   20 +
 drivers/usb/serial/whiteheat.c                     |    7=20
 drivers/usb/storage/uas.c                          |    2=20
 drivers/xen/events/events_fifo.c                   |    5=20
 fs/btrfs/async-thread.c                            |   44 ++-
 fs/btrfs/async-thread.h                            |   28 ++
 fs/btrfs/backref.c                                 |   14 -
 fs/btrfs/btrfs_inode.h                             |    6=20
 fs/btrfs/delayed-inode.c                           |    4=20
 fs/btrfs/disk-io.c                                 |   85 ++----
 fs/btrfs/extent-tree.c                             |    7=20
 fs/btrfs/extent_io.c                               |    1=20
 fs/btrfs/file-item.c                               |    2=20
 fs/btrfs/file.c                                    |   22 -
 fs/btrfs/inode.c                                   |   94 ++-----
 fs/btrfs/ordered-data.c                            |  124 ---------
 fs/btrfs/ordered-data.h                            |    5=20
 fs/btrfs/qgroup.c                                  |    1=20
 fs/btrfs/raid56.c                                  |    9=20
 fs/btrfs/reada.c                                   |    3=20
 fs/btrfs/scrub.c                                   |   14 -
 fs/btrfs/transaction.c                             |   33 --
 fs/btrfs/transaction.h                             |    1=20
 fs/btrfs/ulist.h                                   |   15 +
 fs/btrfs/volumes.c                                 |    3=20
 fs/debugfs/inode.c                                 |   33 +-
 fs/ext4/ext4.h                                     |   20 +
 fs/ext4/extents.c                                  |   88 +++---
 fs/ext4/indirect.c                                 |  281 +++++++++++++++-=
-----
 fs/ext4/inode.c                                    |   46 +--
 fs/ext4/mballoc.c                                  |   26 +
 fs/ext4/namei.c                                    |   21 +
 fs/ext4/super.c                                    |    5=20
 fs/isofs/inode.c                                   |   15 -
 fs/isofs/isofs.h                                   |   23 +
 fs/isofs/rock.c                                    |   39 ++
 fs/jbd2/commit.c                                   |   21 -
 fs/jbd2/journal.c                                  |   56 ++--
 fs/jbd2/recovery.c                                 |   33 +-
 fs/jbd2/revoke.c                                   |    6=20
 fs/nfs/nfs3acl.c                                   |    7=20
 fs/nfs/nfs4proc.c                                  |   26 +
 fs/nfs/super.c                                     |    9=20
 fs/nfsd/nfs4callback.c                             |    3=20
 fs/nfsd/nfssvc.c                                   |    5=20
 include/drm/drm_pciids.h                           |    7=20
 include/linux/jbd2.h                               |   30 +-
 include/linux/sunrpc/svc_xprt.h                    |    1=20
 kernel/sched/core.c                                |    5=20
 mm/memory.c                                        |    7=20
 mm/util.c                                          |    9=20
 net/sunrpc/svcsock.c                               |    2=20
 net/sunrpc/xprt.c                                  |    2=20
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |    1=20
 sound/pci/Kconfig                                  |    4=20
 sound/pci/hda/patch_ca0132.c                       |    7=20
 sound/pci/hda/patch_realtek.c                      |   28 +-
 sound/pci/hda/patch_sigmatel.c                     |   12=20
 sound/pci/oxygen/virtuoso.c                        |    1=20
 sound/pci/oxygen/xonar_pcm179x.c                   |   12=20
 sound/usb/quirks-table.h                           |   29 ++
 sound/usb/quirks.c                                 |    2=20
 virt/kvm/ioapic.c                                  |    7=20
 virt/kvm/iommu.c                                   |   19 -
 147 files changed, 1403 insertions(+), 1016 deletions(-)

Alan Stern (2):
      USB: OHCI: fix bugs in debug routines
      USB: OHCI: don't lose track of EDs when a controller dies

Alex Deucher (3):
      drm/radeon: add new KV pci id
      drm/radeon: add new bonaire pci ids
      drm/radeon: add additional SI pci ids

Alexander Usyskin (6):
      mei: reset client connection state on timeout
      mei: start disconnect request timer consistently
      mei: don't schedule suspend in pm idle
      mei: fix return value on disconnect timeout
      mei: reset client state on queued connect request
      mei: nfc: fix memory leak in error path

Alexey Kardashevskiy (1):
      KVM: PPC: Book3S: Fix LPCR one_reg interface

Andrey Utkin (1):
      nfs3_list_one_acl(): check get_acl() result with IS_ERR_OR_NULL

Andy Lutomirski (1):
      x86_64/vsyscall: Fix warn_bad_vsyscall log output

Arnd Bergmann (2):
      crypto: ux500 - make interrupt mode plausible
      hpsa: fix non-x86 builds

Axel Lin (7):
      hwmon: (sis5595) Prevent overflow problem when writing large limits
      hwmon: (amc6821) Fix possible race condition bug
      hwmon: (gpio-fan) Prevent overflow problem when writing large limits
      hwmon: (ads1015) Fix off-by-one for valid channel index checking
      hwmon: (ads1015) Fix out-of-bounds array access
      hwmon: (dme1737) Prevent overflow problem when writing large limits
      hwmon: (lm92) Prevent overflow problem when writing large limits

Baruch Siach (1):
      ARM: 8097/1: unistd.h: relocate comments back to place

Brian W Hart (1):
      powerpc/powernv: Update dev->dma_mask in pci_set_dma_mask() path

Bryan O'Donoghue (1):
      USB: ehci-pci: USB host controller support for Intel Quark X1000

Catalin Marinas (1):
      arm64: Fix barriers used for page table modifications

Chris Mason (2):
      btrfs: disable strict file flushes for renames and truncates
      Btrfs: fix filemap_flush call in btrfs_file_release

Christian Borntraeger (1):
      KVM: s390/mm: Fix page table locking vs. split pmd lock

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

Darrick J. Wong (3):
      ext4: fix same-dir rename when inline data directory overflows
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

Dmitry Monakhov (4):
      ext4: move i_size,i_disksize update routines to helper function
      ext4: fix incorect journal credits reservation in ext4_zero_range
      ext4: fix transaction issues for ext4_fallocate and ext_zero_range
      ext4: update i_disksize coherently with block allocation on error path

Filipe Manana (2):
      Btrfs: fix csum tree corruption, duplicate and outdated checksums
      Btrfs: read lock extent buffer while walking backrefs

Greg Kroah-Hartman (2):
      USB: fix build error with CONFIG_PM_RUNTIME disabled
      Linux 3.16.2

Guenter Roeck (2):
      hwmon: (lm78) Fix overflow problems seen when writing large temperatu=
re limits
      hwmon: (lm85) Fix various errors on attribute writes

Guo Chao (1):
      PCI: Keep original resource if we fail to expand it

Hans de Goede (4):
      uas: Limit qdepth to 32 when connected over usb-2
      xhci: Blacklist using streams on the Etron EJ168 controller
      xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_S=
TOP_INVAL
      xhci: Disable streams on Via XHCI with device-id 0x3432

Holger Paradies (1):
      staging/rtl8188eu: add 0df6:0076 Sitecom Europe B.V.

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk

Hugh Dickins (1):
      x86,mm: fix pte_special versus pte_numa

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

Jiri Kosina (3):
      HID: logitech: fix bounds checking on LED report size
      HID: logitech: perform bounds checking on device_id early enough
      HID: fix a couple of off-by-ones

Johan Hovold (1):
      USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID

Kinglong Mee (1):
      NFSD: Decrease nfsd_users in nfsd_startup_generic fail

Larry Finger (1):
      staging: r8188eu: Add new USB ID

Liu Bo (3):
      Btrfs: fix compressed write corruption on enospc
      Btrfs: fix crash on endio of reading corrupted block
      Btrfs: fix task hang under heavy compressed write

Lukas Czerner (1):
      ext4: fix punch hole on files with indirect mapping

Mark Einon (1):
      staging: et131x: Fix errors caused by phydev->addr accesses before in=
itialisation

Mathias Nyman (1):
      xhci: rework cycle bit checking for new dequeue pointers

Matt Fleming (1):
      x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub

Michael S. Tsirkin (1):
      kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-=
3601)

Mike Qiu (1):
      powerpc/eeh: Wrong place to call pci_get_slot()

Myron Stowe (1):
      PCI: pciehp: Clear Data Link Layer State Changed during init

Nadav Amit (1):
      KVM: x86: Inter-privilege level ret emulation is not implemeneted

Oleg Nesterov (1):
      vm_is_stack: use for_each_thread() rather then buggy while_each_threa=
d()

Oliver Neukum (2):
      usbcore: don't log on consecutive debounce failures of the same port
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

Pranith Kumar (1):
      staging: lustre: Remove circular dependency on header

Pratyush Anand (1):
      USB: Fix persist resume of some SS USB devices

Rob Kendrick (1):
      MIPS: math-emu: Fix instruction decoding.

Roger Quadros (1):
      usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1

Russell King (1):
      drm: omapdrm: fix compiler errors

Scott Mayhew (1):
      nfs: reject changes to resvport and sharecache during remount

Semen Protsenko (1):
      efi/arm64: Store Runtime Services revision

Simone Gotti (1):
      ACPI / PCI: Fix sysfs acpi_index and label errors

Stephen M. Cameron (1):
      hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl

Steven Rostedt (1):
      debugfs: Fix corrupted loop in debugfs_remove_recursive

Suman Anna (1):
      ARM: dts: AM4372: Correct mailbox node data

Takashi Iwai (4):
      ALSA: hda/ca0132 - Don't try loading firmware at resume when already =
failed
      ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co
      Btrfs: Fix memory corruption by ulist_add_merge() on 32bit arch
      usbcore: Fix wrong device in an error message in hub_port_connect()

Theodore Ts'o (2):
      ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa=
 struct
      ext4: fix BUG_ON in mb_free_blocks()

Thomas Gleixner (1):
      x86: MCE: Add raw_lock conversion again

Tony Lindgren (1):
      ARM: OMAP2+: hwmod: Rearm wake-up interrupts for DT when MUSB is idled

Trond Myklebust (3):
      NFSv3: Fix another acl regression
      NFSv4: Don't clear the open state when we just did an OPEN_DOWNGRADE
      NFSv4: Fix problems with close in the presence of a delegation

Tyrel Datwyler (1):
      powerpc/pci: Reorder pci bus/bridge unregistration during PHB removal

Ulf Hansson (2):
      mmc: mmci: Remove redundant check of status for DATA irq
      mmc: mmci: Move all CMD irq handling to mmci_cmd_irq()

Vidya Sagar (1):
      PCI: Configure ASPM when enabling device

Wanpeng Li (1):
      KVM: nVMX: fix "acknowledge interrupt on exit" when APICv is in use

Will Deacon (1):
      arm64: don't call break hooks for BRK exceptions from EL0

Wolfram Sang (1):
      drivers/i2c/busses: use correct type for dma_map/unmap

addy ke (1):
      i2c: rk3x: fix interrupt handling issue


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUClC6AAoJEDjbvchgkmk+988P/1paROT8Qx/kmcblSxHjcJUK
LK3NWycqCl064CrGAvOl2xan/wCmph2ph+bZ0/MILB1YSdWhlRqmOZaA0TcdLFLV
dyePFxaOWujVVTn1Lb0vlYHUQa/bgAFUO7C0uESJLnzyG/av/y0pDoCsy4TXRqbL
pnnty9uhyyWeXNvBLaoorqmEBVUK7TymyJj10hmV8dvfdlTX/RbTkNGO8Xx7sR7t
ANmtfw2N793X834BlKsSoQBxFdmJASEepIaJ3dSvzA590phTRaZvm/QEX0RdPbJX
L6MmU/p85L/piiOaImeg79XgwEKTHMJk8lBK7uDtNIecHc5Z+CdW9i2cHYr7m8l6
J0l9psgWJOlkyKalczN3NYGAcqNzqZQC1vjl/iJu6R9KHvCrZqJzV1hrNUrKiOa1
+xtz2oNyp38P6I1xsOLTOBYL+sIkv4b8e03kFpYu/B2jRoYIJQUks7HVyFYHRwQb
P3UYOebzRW9EbTVvia+oa3UTfGC6dd/gYscQ012DHEDDN6gJzjYVTWPiL8lMkG5k
WqjOKVRkhNF4eDZeylYP/vB22zUBk1XUf3EkP8ef6Va+Zwp0/wh89KWTzbeVd8n0
4cVCJOpZUMicmKyzoHhsjpDLylOKDgAK/F3nZOlv95Mo5oIZ+PllO//Fi496pAmy
AyH9XZigwo28+A309xJd
=8SmB
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
