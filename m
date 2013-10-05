Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3JEPua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:50:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3JEPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:50:28 -0400
Date: Sat, 5 Oct 2013 08:49:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.4
Message-ID: <20131005154931.GA1357@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.11.4 kernel.

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

 Makefile                                 |    2 -
 arch/arm/crypto/aes-armv4.S              |    6 +--
 arch/x86/kernel/reboot.c                 |   16 ++++++++
 arch/x86/platform/efi/efi.c              |   11 +++--
 drivers/base/core.c                      |   14 +++----
 drivers/gpu/drm/i915/intel_display.c     |    4 ++
 drivers/gpu/drm/i915/intel_dp.c          |   13 ++++++
 drivers/gpu/drm/i915/intel_tv.c          |    8 ++++
 drivers/gpu/drm/radeon/cik.c             |   17 ++++----
 drivers/gpu/drm/radeon/r100.c            |    8 ++--
 drivers/gpu/drm/radeon/r600_hdmi.c       |   20 +++++++---
 drivers/gpu/drm/radeon/radeon_asic.c     |    2 +
 drivers/gpu/drm/radeon/radeon_cs.c       |    2 -
 drivers/gpu/drm/radeon/radeon_device.c   |   15 ++++++-
 drivers/gpu/drm/radeon/radeon_pm.c       |    8 ++--
 drivers/gpu/drm/radeon/radeon_ring.c     |    8 ++--
 drivers/hwmon/applesmc.c                 |   11 +++++
 drivers/md/bcache/bcache.h               |    7 +--
 drivers/md/bcache/bset.c                 |   39 ++++++++++++++------
 drivers/md/bcache/btree.c                |    2 -
 drivers/md/bcache/journal.c              |   33 ++++++++++-------
 drivers/md/bcache/request.c              |   15 ++++---
 drivers/md/bcache/sysfs.c                |    9 +++-
 drivers/md/bcache/util.c                 |   11 +++++
 drivers/md/bcache/util.h                 |   12 ++++--
 drivers/md/bcache/writeback.c            |   42 ++++++++++-----------
 drivers/md/dm-mpath.c                    |   11 +++++
 drivers/md/dm-snap-persistent.c          |    2 -
 drivers/md/dm-snap.c                     |    5 +-
 drivers/md/dm.c                          |   11 +++++
 drivers/misc/mei/amthif.c                |    1=20
 drivers/misc/mei/bus.c                   |    5 ++
 drivers/misc/mei/client.h                |    6 +++
 drivers/misc/mei/hbm.c                   |   10 +++--
 drivers/misc/mei/init.c                  |    3 +
 drivers/misc/mei/main.c                  |   11 ++---
 drivers/misc/mei/mei_dev.h               |    6 +--
 drivers/net/wireless/cw1200/cw1200_spi.c |   26 +++----------
 drivers/net/wireless/cw1200/fwio.c       |    2 -
 drivers/net/wireless/cw1200/hwbus.h      |    1=20
 drivers/net/wireless/cw1200/hwio.c       |   15 -------
 drivers/staging/vt6656/iwctl.c           |    3 +
 drivers/staging/vt6656/main_usb.c        |    3 +
 drivers/tty/serial/pch_uart.c            |    5 ++
 drivers/tty/serial/serial-tegra.c        |    4 +-
 drivers/tty/tty_ioctl.c                  |    3 +
 drivers/usb/core/devio.c                 |   16 ++++++++
 drivers/usb/dwc3/dwc3-pci.c              |    4 ++
 drivers/usb/gadget/f_fs.c                |   60 +++++++++++++-------------=
-----
 drivers/usb/host/ehci-fsl.c              |   12 +-----
 drivers/usb/host/ehci-pci.c              |    2 -
 drivers/usb/host/ohci-hcd.c              |   22 ++++++-----
 drivers/usb/host/ohci-q.c                |   26 +++++++++++--
 drivers/usb/host/uhci-pci.c              |    2 -
 drivers/usb/host/uhci-q.c                |   12 ++++--
 drivers/usb/host/xhci-hub.c              |    2 -
 drivers/usb/host/xhci-pci.c              |    2 -
 drivers/usb/host/xhci-ring.c             |   24 +++++++++++-
 drivers/usb/host/xhci.c                  |   25 ++----------
 drivers/usb/host/xhci.h                  |    1=20
 fs/bio.c                                 |    4 +-
 fs/sysv/super.c                          |    1=20
 include/linux/device-mapper.h            |    3 +
 kernel/Makefile                          |    2 -
 kernel/irq/Makefile                      |    6 ++-
 kernel/reboot.c                          |    9 ++++
 sound/core/compress_offload.c            |    3 +
 tools/lib/lk/debugfs.c                   |    1=20
 68 files changed, 444 insertions(+), 263 deletions(-)

Al Viro (1):
      USB: Fix breakage in ffs_fs_mount()

Alan Stern (3):
      USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd
      USB: OHCI: accept very late isochronous URBs
      USB: UHCI: accept very late isochronous URBs

Alex Deucher (6):
      drm/radeon/cik: fix overflow in vram fetch
      drm/radeon: avoid UVD corruption on AGP cards using GPU gart
      drm/radeon: don't set default clocks for SI when DPM is disabled
      drm/radeon: disable tests/benchmarks if accel is disabled
      drm/radeon: add missing hdmi callbacks for rv6xx
      drm/radeon: fix hdmi audio on DCE3.0/3.1 asics

Alex Ivanov (1):
      drm/radeon: Make r100_cp_ring_info() and radeon_ring_gfx() safe (v2)

Alexander Usyskin (1):
      mei: cancel stall timers in mei_reset

Ard Biesheuvel (1):
      ARM: 7837/3: fix Thumb-2 bug in AES assembler code

Ben Hutchings (1):
      irq: Always define devm_{request_threaded,free}_irq()

Benson Leung (1):
      driver core : Fix use after free of dev->parent in device_shutdown

Chuansheng Liu (1):
      kernel/reboot.c: re-enable the function of variable reboot_default

Daniel Vetter (2):
      drm/i915/tv: clear adjusted_mode.flags
      drm/i915: preserve pipe A quirk in i9xx_set_pipeconf

David Cohen (1):
      usb: dwc3: add support for Merrifield

Florian Wolter (1):
      xhci: Fix race between ep halt and URB cancellation

Gabriel de Perthuis (1):
      bcache: Strip endline when writing the label through sysfs

Greg Kroah-Hartman (1):
      Linux 3.11.4

Heikki Krogerus (1):
      usb: dwc3: pci: add support for BayTrail

Henrik Rydberg (1):
      hwmon: (applesmc) Check key count before proceeding

Jani Nikula (1):
      drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Johan Hovold (3):
      serial: tegra: fix tty-kref leak
      serial: pch_uart: fix tty-kref leak in rx-error path
      serial: pch_uart: fix tty-kref leak in dma-rx path

Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386

Kent Overstreet (9):
      block: Fix bio_copy_data()
      bcache: Fix a dumb journal discard bug
      bcache: Fix for when no journal entries are found
      bcache: Fix a writeback performance regression
      bcache: Fix a flush/fua performance bug
      bcache: Fix a dumb CPU spinning bug in writeback
      bcache: Fix a shrinker deadlock
      bcache: Fix for handling overlapping extents when reading in a btree =
node
      bcache: Fix flushes in writeback mode

Kurt Garloff (1):
      usb/core/devio.c: Don't reject control message to endpoint with wrong=
 direction bit

Liam Girdwood (1):
      ALSA: compress: Fix compress device unregister.

Lubomir Rintel (1):
      sysv: Add forgotten superblock lock init for v7 fs

Malcolm Priestley (2):
      staging: vt6656: [BUG] main_usb.c oops on device_close move flag earl=
ier.
      staging: vt6656: [BUG] iwctl_siwencodeext return if device not open

Masoud Sharbiani (1):
      x86/reboot: Add quirk to make Dell C6100 use reboot=3Dpci automatical=
ly

Mathias Nyman (2):
      xhci: Ensure a command structure points to the correct trb on the com=
mand ring
      xhci: Fix oops happening after address device timeout

Michel D=E4nzer (2):
      drm/radeon/cik: Fix printing of client name on VM protection fault
      drm/radeon/cik: Fix encoding of number of banks in tiling configurati=
on info

Mike Snitzer (1):
      dm mpath: disable WRITE SAME if it fails

Mikulas Patocka (2):
      dm snapshot: workaround for a false positive lockdep warning
      dm-snapshot: fix performance degradation due to small hash size

Peter Hurley (1):
      tty: Fix SIGTTOU not sent with tcflush()

Ramneek Mehresh (1):
      fsl/usb: Resolve PHY_CLK_VLD instability issue for ULPI phy

Solomon Peachy (2):
      Revert "cw1200: Don't perform SPI transfers in interrupt context"
      cw1200: Use a threaded oneshot irq handler for cw1200_spi

Tomas Winkler (2):
      mei: make me client counters less error prone
      mei: bus: stop wait for read during cl state transition

Vinson Lee (1):
      tools lib lk: Uninclude linux/magic.h in debugfs.c


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSUDULAAoJEDjbvchgkmk+KAsP/jjy/GVOJauz0n/zISVqQJ0A
/9DU/2vg5W3ZikLvdcRr8aQ0n9fKstEnrZaO6vr6iquYzHTimn0sYUeMOQVSpNbZ
zK5KLX3uYNmwge1O0Jct6tyPQyseZDEtcPWahRa1lw1f3JbPGUy3cOqxo4AWytFs
nC76fU/FIrBn+3Y+1baOwh0IK84onsIJaylqDVOvlZfVnqjiNk2lFSFqmSE3aYSh
L5uz2BMr5PK1Fplc7JQ051BoKxZA3MnmNLi09eVss6HQ389uHDiZOUg8jsjnoT/O
Kik+iBw/TEOrcLX2q/r9OzmKoHr4X1s0/7wRGI1FOIE8CYBLC0d3/ER8UWpJrDtC
BEZA0aaURnTCUwUaqc9HsSCQjFIkxfv4v8r6zNmgxIWSD+hAA3Mjeosi9CQRo0pD
BHBEC6UddIvT8POY/Wof5Wrq7EiHvzxBPQeseI0eK059g3wvH8j/Y7ZKWZ9oiHYV
4Z+UqY1s6LFR+JgqAaKJpGuK2WEHljFhuteLYNpuFH6+eWvzZO92950I1YzbU/Mh
iZru1qhd8b6N17xWBRwGs9wMOZc1Xwj9oscaRCDuDGV6V5jUBsqrDILfOwGjDsHm
R8p8y9ZImwUSqVRZ2TEU0XCRgGLsDEuOWnb/lGWs1I396SYikIDpc7klgQ5vc6Wi
1029KoZXf5Uig8qzpbUs
=cJ4o
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
