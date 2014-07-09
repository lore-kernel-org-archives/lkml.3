Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaGITcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:32:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbaGITc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:32:28 -0400
Date: Wed, 9 Jul 2014 12:36:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.48
Message-ID: <20140709193653.GA16367@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.48 kernel.

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

 Makefile                                   |    2=20
 arch/arm/mach-omap2/mux.c                  |    6 +-
 arch/arm64/kernel/entry.S                  |    1=20
 arch/unicore32/mm/alignment.c              |    1=20
 arch/x86/include/asm/kvm_host.h            |    4 -
 drivers/block/rbd.c                        |   19 +++++++
 drivers/gpu/drm/radeon/atombios_crtc.c     |   48 ++++++++++--------
 drivers/gpu/drm/radeon/atombios_dp.c       |   17 +++++-
 drivers/gpu/drm/radeon/atombios_encoders.c |    5 +
 drivers/gpu/drm/radeon/radeon_connectors.c |    2=20
 drivers/gpu/drm/radeon/radeon_cs.c         |    6 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c         |    1=20
 drivers/hwmon/ina2xx.c                     |    7 +-
 drivers/iio/inkern.c                       |    6 +-
 drivers/irqchip/spear-shirq.c              |    2=20
 drivers/md/dm-thin.c                       |    3 -
 drivers/md/md.c                            |   13 +++++
 drivers/mmc/host/rtsx_pci_sdmmc.c          |    3 +
 drivers/mtd/nand/fsl_elbc_nand.c           |   14 +++++
 drivers/mtd/nand/omap2.c                   |    2=20
 drivers/net/wireless/b43/xmit.c            |   10 ++-
 drivers/net/wireless/iwlwifi/pcie/trans.c  |   26 ++++++----
 drivers/net/wireless/rt2x00/rt2500pci.c    |    7 ++
 drivers/net/wireless/rt2x00/rt2x00.h       |    1=20
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   24 ++++++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    2=20
 drivers/scsi/ibmvscsi/ibmvscsi.c           |   13 ++++-
 drivers/scsi/sym53c8xx_2/sym_hipd.c        |    4 +
 drivers/scsi/virtio_scsi.c                 |   26 +++++++++-
 drivers/tty/serial/8250/8250_dw.c          |   74 ++++++++++++++++++++++--=
-----
 drivers/usb/gadget/f_fs.c                  |   12 ++--
 drivers/usb/host/xhci-ring.c               |    2=20
 drivers/usb/host/xhci.c                    |   10 ++-
 drivers/usb/serial/ftdi_sio.c              |    7 +-
 drivers/usb/serial/option.c                |   26 +++++++---
 drivers/video/fb-puv3.c                    |    2=20
 fs/cifs/cifs_unicode.c                     |    7 +-
 fs/ext4/indirect.c                         |   20 ++++++-
 fs/nfsd/nfs4proc.c                         |    9 ---
 fs/nfsd/nfs4xdr.c                          |   13 ++++-
 kernel/trace/trace.c                       |    2=20
 mm/hugetlb.c                               |   71 ++++++++++++++++--------=
---
 mm/mempolicy.c                             |   46 +++++++-----------
 net/bluetooth/hci_conn.c                   |    2=20
 net/bluetooth/hci_event.c                  |    7 +-
 net/bluetooth/mgmt.c                       |    7 ++
 net/mac80211/debugfs_netdev.c              |    6 --
 net/mac80211/sta_info.c                    |    1=20
 sound/usb/pcm.c                            |    3 -
 tools/usb/ffs-test.c                       |    4 -
 50 files changed, 429 insertions(+), 177 deletions(-)

Adam Thomson (1):
      iio: of_iio_channel_get_by_name() returns non-null pointers for error=
 legs

Alex Deucher (4):
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
      drm/radeon/atom: fix dithering on certain panels

Alex Elder (1):
      rbd: use reference counts for image requests

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

Bj=C3=B8rn Mork (1):
      usb: option: add/modify Olivetti Olicard modems

Brian King (2):
      ibmvscsi: Abort init sequence during error recovery
      ibmvscsi: Add memory barriers for send / receive

Chen Gang (1):
      arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid compi=
ling error

ChiaHao (1):
      arm64: Bug fix in stack alignment exception

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code

Emmanuel Grumbach (1):
      iwlwifi: pcie: try to get ownership several times

Fabio Baltieri (1):
      hwmon: (ina2xx) Cast to s16 on shunt and current regs

Felix Fietkau (1):
      mac80211: fix a memory leak on sta rate selection table

Greg Kroah-Hartman (1):
      Linux 3.10.48

Hugh Dickins (1):
      mm: fix crashes from mbind() merging vmas

Ilya Dryomov (1):
      rbd: handle parent_overlap on writes correctly

J. Bruce Fields (1):
      nfsd: fix rare symlink decoding bug

James Hogan (1):
      serial: 8250_dw: Fix LCR workaround regression

Jan Kara (2):
      ext4: Fix buffer double free in ext4_alloc_branch()
      ext4: Fix hole punching for files with indirect blocks

Johan Hedberg (3):
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix locking of hdev when calling into SMP code

Johan Hovold (1):
      USB: ftdi_sio: fix null deref at port probe

Lukas Czerner (1):
      dm thin: update discard_granularity to reflect the thin-pool blocksize

Marek Ol=C5=A1=C3=A1k (1):
      drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission

Mathias Nyman (1):
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Michal Nazarewicz (2):
      usb: gadget: f_fs: fix NULL pointer dereference when there are no str=
ings
      tools: ffs-test: fix header values endianess

Micky Ching (1):
      mmc: rtsx: add R1-no-CRC mmc command type handle

Mikulas Patocka (1):
      sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10

Naoya Horiguchi (1):
      hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned=
 entry

NeilBrown (1):
      md: flush writes before starting a recovery.

Oliver Neukum (1):
      USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Paolo Bonzini (3):
      virtio-scsi: avoid cancelling uninitialized work items
      virtio-scsi: fix various bad behavior on aborted requests
      KVM: x86: preserve the high 32-bits of the PAT register

Pekon Gupta (1):
      mtd: eLBC NAND: fix subpage write support

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware

Sander Eikelenboom (1):
      ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log=
 while DEBUG not defined

Stanislaw Gruszka (2):
      rt2x00: disable TKIP on USB
      rt2x00: fix rfkill regression on rt2500pci

Steve French (1):
      CIFS: fix mount failure with broken pathnames when smb3 mount with ma=
pchars option

Steven Rostedt (Red Hat) (1):
      tracing: Remove ftrace_stop/start() from reading the trace file

Thomas Gleixner (1):
      irqchip: spear_shirq: Fix interrupt offset

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:

Tim Gardner (1):
      ALSA: usb-audio: Suppress repetitive debug messages from retire_playb=
ack_urb()

Tim Kryger (2):
      serial: 8250_dw: Report CTS asserted for auto flow
      serial: 8250_dw: Improve unwritable LCR workaround

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.

Zhichuang SUN (1):
      drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mm=
ap

pekon gupta (1):
      mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in=
 erased-page


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvZnVAAoJEDjbvchgkmk+DycQANahXO+a9CQto0smE5H9Jcyy
jvuerJosQdImBOyTofI7o0a5fS0SbraLjsk8OTePYsebRLFHgaV1ipvdyndgGbYF
TnQp0IUPzIq3ao5V0iEp6eakgOc0wL5TQZQjcEmNMpivjHG00nmc+/SMzikLBJdB
WgTvExtX3BfUQTa3nWO/g4iTjrV1C+PcIJgTzHfhDHlsjYewa2oQ9ZHyyEi066Ki
QgJ8a0w6brPVOTa9mIqigc3byDTUZoSNOLHi3J9Re9qspXDVsZeSuDTQI5piL0NH
lMWYl5hcHDajLnlIuZf+RAi8G4avjDUKsIQKvSfQsnK4mtT5FmJNV3C4inat0pkQ
5yfzyWGn3gf5Q4siw0SbGMLzvlvdZu68wl7A6COp2xBzwaS8h7bFBGpFeqklCblL
1POQg9bBVEOEG54RQWvT919xKliTrWdFwD3Ww/QDJRoVyJ3YB9kTHF91PdkKrbwy
CYMN4b+HV+kQsYLGCeSXFoFjmcU6a51P5eAR/hQgcpa/TyxQwPmlxcA2Gq078dH9
G73IKStMEe/9U0d0QXjziprse8vRYee/csP3GXx0Mxtq6dDBhVrgIfT7eWmfh4kx
q45ron1x3LcQ4Nq/n/LKe+9bTaCnUw6KoshAn60uOrQhFkBlQAFtv7R2TyZutaLv
EkwMUqpFPFb3LgJOlWCi
=nFdE
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
