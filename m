Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaIFAIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:08:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaIFAIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:08:18 -0400
Date: Fri, 5 Sep 2014 17:08:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.54
Message-ID: <20140906000816.GA12458@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.54 kernel.

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

 Documentation/sound/alsa/ALSA-Configuration.txt |    4 -
 Documentation/stable_kernel_rules.txt           |    3 +
 Makefile                                        |    2=20
 arch/arm/mach-omap2/control.c                   |    3 -
 arch/arm/mach-omap2/omap_hwmod.c                |    4 +
 arch/x86/Kconfig                                |    1=20
 arch/x86/include/asm/kvm_host.h                 |    2=20
 arch/x86/kernel/resource.c                      |    8 ++-
 arch/x86/kernel/vsyscall_64.c                   |    8 +--
 arch/x86/kvm/emulate.c                          |    4 +
 arch/x86/kvm/irq.c                              |    2=20
 arch/x86/kvm/lapic.c                            |   52 ++++++++++++++++++-=
-----
 arch/x86/pci/i386.c                             |    4 +
 drivers/crypto/ux500/cryp/cryp_core.c           |   25 +++++------
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c        |    6 +-
 drivers/gpu/drm/omapdrm/omap_gem.c              |   10 ++--
 drivers/gpu/drm/omapdrm/omap_plane.c            |    4 -
 drivers/hid/hid-cherry.c                        |    2=20
 drivers/hid/hid-kye.c                           |    2=20
 drivers/hid/hid-lg.c                            |    4 -
 drivers/hid/hid-logitech-dj.c                   |   13 ++----
 drivers/hid/hid-monterey.c                      |    2=20
 drivers/hid/hid-petalynx.c                      |    2=20
 drivers/hid/hid-sunplus.c                       |    2=20
 drivers/hwmon/ads1015.c                         |    4 +
 drivers/hwmon/dme1737.c                         |   33 ++++++++-------
 drivers/hwmon/gpio-fan.c                        |    2=20
 drivers/hwmon/lm78.c                            |    2=20
 drivers/hwmon/lm85.c                            |    9 ++--
 drivers/hwmon/sis5595.c                         |    2=20
 drivers/i2c/busses/i2c-at91.c                   |    4 -
 drivers/misc/mei/client.c                       |    2=20
 drivers/misc/mei/nfc.c                          |   11 ++---
 drivers/scsi/hpsa.c                             |    2=20
 drivers/staging/speakup/selection.c             |   10 +++-
 drivers/tty/serial/serial_core.c                |    3 +
 drivers/usb/core/hub.c                          |   49 +++++++++++++++++++=
+++
 drivers/usb/host/ehci-pci.c                     |   25 +++++++++++
 drivers/usb/host/ohci-q.c                       |   46 +++++++++++++------=
--
 drivers/usb/host/xhci-pci.c                     |    4 +
 drivers/usb/host/xhci-ring.c                    |    3 -
 drivers/usb/serial/ftdi_sio.c                   |    5 ++
 drivers/usb/serial/ftdi_sio_ids.h               |   20 ++++++---
 drivers/usb/serial/whiteheat.c                  |    7 ++-
 fs/btrfs/file-item.c                            |    2=20
 fs/ext4/mballoc.c                               |   26 +++++++++++-
 fs/isofs/inode.c                                |   15 +++---
 fs/isofs/isofs.h                                |   23 ++++++++--
 fs/isofs/rock.c                                 |   39 ++++++++++++------
 fs/jbd2/recovery.c                              |    7 ++-
 fs/nfs/nfs3acl.c                                |    5 +-
 fs/nfs/nfs4proc.c                               |   17 +++++--
 fs/nfsd/nfs4callback.c                          |    3 -
 fs/nfsd/nfssvc.c                                |    5 +-
 include/drm/drm_pciids.h                        |    4 +
 include/linux/sunrpc/svc_xprt.h                 |    1=20
 net/sunrpc/svcsock.c                            |    2=20
 net/sunrpc/xprt.c                               |    2=20
 net/sunrpc/xprtrdma/svc_rdma_transport.c        |    1=20
 sound/pci/Kconfig                               |    4 -
 sound/pci/hda/patch_ca0132.c                    |    7 ++-
 sound/pci/hda/patch_realtek.c                   |   17 +++++--
 sound/pci/hda/patch_sigmatel.c                  |   12 +++++
 sound/pci/oxygen/virtuoso.c                     |    1=20
 sound/pci/oxygen/xonar_pcm179x.c                |   12 ++++-
 virt/kvm/ioapic.c                               |    7 +--
 virt/kvm/iommu.c                                |   19 ++++----
 67 files changed, 465 insertions(+), 178 deletions(-)

Alan Stern (1):
      USB: OHCI: don't lose track of EDs when a controller dies

Alex Deucher (1):
      drm/radeon: add additional SI pci ids

Alexander Usyskin (3):
      mei: start disconnect request timer consistently
      mei: reset client state on queued connect request
      mei: nfc: fix memory leak in error path

Andy Lutomirski (1):
      x86_64/vsyscall: Fix warn_bad_vsyscall log output

Arnd Bergmann (1):
      crypto: ux500 - make interrupt mode plausible

Axel Lin (5):
      hwmon: (sis5595) Prevent overflow problem when writing large limits
      hwmon: (gpio-fan) Prevent overflow problem when writing large limits
      hwmon: (ads1015) Fix off-by-one for valid channel index checking
      hwmon: (ads1015) Fix out-of-bounds array access
      hwmon: (dme1737) Prevent overflow problem when writing large limits

Ben Hutchings (1):
      Staging: speakup: Update __speakup_paste_selection() tty (ab)usage to=
 match vt

Bryan O'Donoghue (1):
      USB: ehci-pci: USB host controller support for Intel Quark X1000

Christoph Schulz (1):
      x86: don't exclude low BIOS area when allocating address space for no=
n-PCI cards

Chuck Lever (1):
      svcrdma: Select NFSv4.1 backchannel transport based on forward channel

Clemens Ladisch (1):
      ALSA: virtuoso: add Xonar Essence STX II support

Darrick J. Wong (1):
      jbd2: fix infinite loop when recovering corrupt journal blocks

Dave Chiluk (1):
      stable_kernel_rules: Add pointer to netdev-FAQ for network patches

Filipe Manana (1):
      Btrfs: fix csum tree corruption, duplicate and outdated checksums

Greg Kroah-Hartman (2):
      USB: fix build error with CONFIG_PM_RUNTIME disabled
      Linux 3.10.54

Guenter Roeck (2):
      hwmon: (lm78) Fix overflow problems seen when writing large temperatu=
re limits
      hwmon: (lm85) Fix various errors on attribute writes

Hans de Goede (1):
      xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_S=
TOP_INVAL

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk

Hui Wang (1):
      ALSA: hda - fix an external mic jack problem on a HP machine

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response

Jan Kara (1):
      isofs: Fix unbounded recursion when processing relocated directories

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

Matt Fleming (1):
      x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub

Michael S. Tsirkin (1):
      kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-=
3601)

Nadav Amit (1):
      KVM: x86: Inter-privilege level ret emulation is not implemeneted

Paolo Bonzini (2):
      KVM: x86: always exit on EOIs for interrupts listed in the IOAPIC red=
ir table
      Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"

Patrick Riphagen (2):
      USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
      USB: serial: ftdi_sio: Add support for new Xsens devices

Peter Hurley (1):
      serial: core: Preserve termios c_cflag for console resume

Pratyush Anand (1):
      USB: Fix persist resume of some SS USB devices

Roger Quadros (1):
      usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1

Russell King (1):
      drm: omapdrm: fix compiler errors

Stephen M. Cameron (1):
      hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl

Takashi Iwai (2):
      ALSA: hda/ca0132 - Don't try loading firmware at resume when already =
failed
      ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co

Theodore Ts'o (2):
      ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa=
 struct
      ext4: fix BUG_ON in mb_free_blocks()

Tony Lindgren (1):
      ARM: OMAP2+: hwmod: Rearm wake-up interrupts for DT when MUSB is idled

Trond Myklebust (2):
      NFSv3: Fix another acl regression
      NFSv4: Fix problems with close in the presence of a delegation

Wanpeng Li (1):
      KVM: nVMX: fix "acknowledge interrupt on exit" when APICv is in use

Wolfram Sang (1):
      drivers/i2c/busses: use correct type for dma_map/unmap


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUClBwAAoJEDjbvchgkmk+IRsP/AqHXPQi6459in4HVqrM8+1N
UjjQZCRmZg5zukzlLpTk4WPEbdvdxj+L6SPUlWbWAs3gkc7FvTLkVht75L+CECIa
bLpZTXeDJKhgxEkPNQ5V6/YFnOHoO1ftwERgu3UCwfTiUf/cK6HsL99NRsuAfSMZ
7tn3SPhQPXaVIgemwJ7efGMxSkUQZAzwiyDyPD+3xAmJxLAp/N80S8N647WpCD7i
GRYfId5yEEehEaD+/nJcW/nVxQDQfLDaZnJGQa+f5uJOAyAdoobkG3cd0d/Jc+G3
fIpQGTSbQ0Oo4BDLoXlHQghMstmAjH5yXK6/dMwE2KWMTYABmYUVWqFEQ9rfI4R7
PclRUJc4bgMOGZNygAgI2XsHWgPloz7RDmDSNewudwvANljOXHeKEW43QNyumUh0
KhM0pLMpzxl47lkeSmFZ2vSZ36mEUNmHUPigruJLePyN0lIZx6PBavUB6Ox9hLbr
Q9/SOh2cqomv10My+8oimS9Om5jOS3B5IkFBoYyPMOMC2md21AtvzLgaxL0Cb0C8
Li41RGUYIj4oL9W/75VElOTnxV8nmfyzSAJkep71LkqwCxEB9OtIr+5zKFTlKYvl
M5GDxRXYwzYUMmr9eZYxVZMeXC+DVgF200JcJL8SUdxyFO8NNHwMIpXv8/fpHHHJ
im9G45x4eXluR3laZJzX
=GoEB
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
