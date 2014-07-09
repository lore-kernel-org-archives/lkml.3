Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbaGITcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:32:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaGITcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:32:01 -0400
Date: Wed, 9 Jul 2014 12:36:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.98
Message-ID: <20140709193626.GA16284@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.98 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                   |    2=20
 arch/arm/mach-omap2/mux.c                  |    6 +-
 arch/powerpc/kernel/exceptions-64s.S       |    2=20
 arch/powerpc/kernel/lparcfg.c              |   24 ++++-----
 arch/powerpc/kernel/setup_64.c             |    2=20
 arch/powerpc/kernel/sysfs.c                |   18 ++++++-
 arch/powerpc/kernel/time.c                 |    4 -
 arch/powerpc/kernel/traps.c                |   10 ++++
 arch/powerpc/lib/checksum_64.S             |   54 ++++++++++++++++------
 arch/x86/include/asm/kvm_host.h            |    4 -
 drivers/acpi/video.c                       |   16 ++++++
 drivers/acpi/video_detect.c                |   45 ++++++++++++++++++
 drivers/gpu/drm/radeon/atombios_crtc.c     |   48 ++++++++++---------
 drivers/gpu/drm/radeon/atombios_encoders.c |    5 +-
 drivers/gpu/drm/radeon/radeon_connectors.c |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c         |    1=20
 drivers/md/md.c                            |   13 +++++
 drivers/mtd/nand/pxa3xx_nand.c             |    4 -
 drivers/net/wireless/b43/xmit.c            |   10 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c    |    7 ++
 drivers/net/wireless/rt2x00/rt2x00.h       |    1=20
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   24 ++++++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    2=20
 drivers/scsi/ibmvscsi/ibmvscsi.c           |    3 -
 drivers/scsi/sym53c8xx_2/sym_hipd.c        |    4 +
 drivers/staging/bcm/InterfaceInit.c        |    4 +
 drivers/staging/bcm/InterfaceInit.h        |    5 +-
 drivers/staging/comedi/comedi_fops.c       |   25 ++++++----
 drivers/staging/comedi/drivers/das08.c     |    2=20
 drivers/staging/wlags49_h2/wl_priv.c       |    9 ++-
 drivers/usb/gadget/f_fs.c                  |   12 ++--
 drivers/usb/host/xhci-ring.c               |    2=20
 drivers/usb/host/xhci.c                    |   10 ++--
 drivers/usb/serial/ftdi_sio.c              |    7 ++
 drivers/usb/serial/option.c                |   26 ++++++++--
 fs/cifs/cifs_unicode.c                     |    7 +-
 fs/nfsd/nfs4proc.c                         |    9 ---
 fs/nfsd/nfs4xdr.c                          |   13 ++++-
 include/linux/usb.h                        |   16 ++++++
 include/net/bluetooth/hci_core.h           |    1=20
 mm/hugetlb.c                               |   71 +++++++++++++++++-------=
-----
 mm/mempolicy.c                             |   53 +++++++++------------
 net/bluetooth/hci_conn.c                   |   16 ------
 net/bluetooth/hci_event.c                  |    7 ++
 net/mac80211/debugfs_netdev.c              |    6 --
 tools/usb/ffs-test.c                       |    4 -
 46 files changed, 413 insertions(+), 203 deletions(-)

Alex Deucher (3):
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/atom: fix dithering on certain panels

Alex Hung (1):
      ACPI video: ignore BIOS initial backlight value for HP 1000

Anton Blanchard (1):
      powerpc/pseries: Duplicate dtl entries sometimes sent to userspace

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Benjamin Herrenschmidt (1):
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hype=
rvisor

Bj=C3=B8rn Mork (2):
      USB: add USB_DEVICE_INTERFACE_CLASS macro
      usb: option: add/modify Olivetti Olicard modems

Brian King (1):
      ibmvscsi: Abort init sequence during error recovery

Chen Gang (2):
      powerpc/smp: Section mismatch from smp_release_cpus to __initdata spi=
nning_secondaries
      powerpc/pseries/lparcfg: Fix possible overflow are more than 1026

Corentin Chary (1):
      acpi/video_detect: blacklist samsung x360

Dan Carpenter (1):
      staging: wlags49_h2: buffer overflow setting station name

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code

Greg Kroah-Hartman (1):
      Linux 3.4.98

Gustavo Maciel Dias Vieira (1):
      ACPI video: ignore BIOS backlight value for HP dm4

Hugh Dickins (1):
      mm: fix crashes from mbind() merging vmas

Ian Abbott (2):
      staging: comedi: das08: Correct AI encoding for das08jr-16-ao
      staging: comedi: fix a race between do_cmd_ioctl() and read/write

J. Bruce Fields (1):
      nfsd: fix rare symlink decoding bug

Johan Hedberg (1):
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM

Johan Hovold (1):
      USB: ftdi_sio: fix null deref at port probe

Kevin McKinney (2):
      Staging: bcm: Create and initialize new device id in InterfaceInit
      Staging: bcm: Add two products and remove an existing product.

Lan Tianyu (1):
      ACPI / video: Add "Asus UL30VT" to ACPI video detect blacklist

Madhavan Srinivasan (1):
      powerpc/sysfs: Disable writing to PURR in guest mode

Mathias Nyman (1):
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Michal Nazarewicz (2):
      usb: gadget: f_fs: fix NULL pointer dereference when there are no str=
ings
      tools: ffs-test: fix header values endianess

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

Paolo Bonzini (1):
      KVM: x86: preserve the high 32-bits of the PAT register

Paul E. McKenney (1):
      powerpc: Restore registers on error exit from csum_partial_copy_gener=
ic()

Paul Mackerras (1):
      powerpc: Fix emulation of illegal instructions on PowerNV platform

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware

Stanislaw Gruszka (2):
      rt2x00: disable TKIP on USB
      rt2x00: fix rfkill regression on rt2500pci

Steve French (1):
      CIFS: fix mount failure with broken pathnames when smb3 mount with ma=
pchars option

Syam Sidhardhan (1):
      Bluetooth: Remove unused hci_le_ltk_reply()

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:

Thomas Petazzoni (1):
      mtd: pxa3xx_nand: make the driver work on big-endian systems

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvZm6AAoJEDjbvchgkmk+Id8QANIQS/q1tSfvHAoKBS/vfayx
XFULMQWEyJikj5WDBJza7XEv2HCg4mCkYhgF56hf3xeYMmZkdv4299wbcsIJp77W
0dkMAUsOjZ6PIBlxg1oQv6rk0fglf3gzBBdS2iQR3l2OEKvQpHZ4NpZ1WDxEKmGf
HY7QBfWHk4bxvXVQ6fGW2I6GE6TGv8m73HKu0qoajU72Abmo6th1i9cIlqD4pifK
u88dgfRZIAJ0GfAQUl2di9wYxmexE0CrR7Z5E9ZAQWSKzhg3CfTuaLVMatjRMkfO
7haGpWuk/J4SmQe/L6jN4ggnjhKpyb2wCPUtlvjcIoyqInAmNLDXLSLe+tgUXCMB
LI3kh7rSRi1ercArpAKPn9SJX41R/FwXo2c8bI6mNRQtLfDJIwcuh5l7UInLQMhQ
mxxQn8MT1HV9te3UAHvNGWWUFw57ecU0ehuS/SfunD60v4VLTAZ/4YJ3mwkUUkTL
AsZwqs91ZdoTkhIOqMngJNEDredxtk1EGZV/S2nRh8btIN878CjGRe7ok8T+UufX
kB4Ux3I0dqm0pycHApRuhc/3XOG5hr1Nb5dgM6kBrDI8E5iguMU62dG6BeblFX6e
00DefnZAMALmiGzWblGYRUToLKyqZkAOnRjyVcxzk1FJBPt7CgmJP+yrYqhgGE1R
EXMDPvT1A+Orm6jjEMf+
=2j0u
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
