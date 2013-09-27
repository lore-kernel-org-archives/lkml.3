Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3I0AZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 20:25:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3I0AZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 20:25:48 -0400
Date: Thu, 26 Sep 2013 17:25:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.63
Message-ID: <20130927002547.GA8340@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.63 kernel.

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

 Makefile                                      |    2=20
 arch/arm/mach-versatile/pci.c                 |    6 +-
 arch/mips/ath79/clock.c                       |    2=20
 arch/powerpc/kernel/align.c                   |   10 +++
 crypto/api.c                                  |    7 ++
 drivers/gpu/drm/drm_edid.c                    |    3 +
 drivers/hid/hid-core.c                        |   17 ++++--
 drivers/hid/hid-ids.h                         |    1=20
 drivers/hid/hid-input.c                       |   12 +++-
 drivers/hid/hid-ntrig.c                       |    3 -
 drivers/hid/hid-pl.c                          |   10 ++-
 drivers/hid/hid-speedlink.c                   |   11 ++-
 drivers/hid/usbhid/hid-quirks.c               |    2=20
 drivers/iommu/intel-iommu.c                   |   72 ++++++++++++---------=
-----
 drivers/mmc/host/tmio_mmc_dma.c               |    4 -
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |    4 +
 drivers/net/wireless/ath/ath9k/ath9k.h        |    5 -
 drivers/net/wireless/ath/ath9k/recv.c         |   17 ++++--
 drivers/net/wireless/ath/ath9k/xmit.c         |    1=20
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |   15 +++--
 drivers/of/base.c                             |    1=20
 drivers/scsi/sd.c                             |   11 +--
 drivers/staging/comedi/drivers/dt282x.c       |    3 -
 drivers/usb/class/cdc-wdm.c                   |   13 +++-
 drivers/usb/core/config.c                     |    3 -
 drivers/usb/host/ehci-mxc.c                   |    2=20
 drivers/usb/host/xhci-plat.c                  |    2=20
 drivers/usb/host/xhci.c                       |   29 ++++++++++
 drivers/usb/host/xhci.h                       |    1=20
 drivers/usb/serial/mos7720.c                  |    6 +-
 drivers/xen/grant-table.c                     |   13 +++-
 fs/cifs/connect.c                             |    2=20
 fs/fuse/dir.c                                 |    4 +
 fs/fuse/file.c                                |    3 -
 fs/isofs/inode.c                              |   16 +----
 fs/ocfs2/extent_map.c                         |    1=20
 include/linux/hid.h                           |    4 +
 include/linux/rculist.h                       |    5 +
 include/media/v4l2-ctrls.h                    |    1=20
 mm/huge_memory.c                              |    2=20
 mm/memcontrol.c                               |    8 ++
 sound/pci/hda/hda_intel.c                     |    1=20
 sound/soc/codecs/wm8960.c                     |    6 +-
 43 files changed, 230 insertions(+), 111 deletions(-)

Alan Stern (1):
      SCSI: sd: Fix potential out-of-bounds access

Alex Deucher (1):
      drm/edid: add quirk for Medion MD30217PG

Alex Williamson (1):
      intel-iommu: Fix leaks in pagetable freeing

Anand Avati (1):
      fuse: invalidate inode attributes on xattr modification

Andrzej Hajda (1):
      media: v4l2: added missing mutex.h include to v4l2-ctrls.h

Anton Blanchard (1):
      powerpc: Handle unaligned ldbrx/stdbrx

Dan Carpenter (2):
      staging: comedi: dt282x: dt282x_ai_insn_read() always fails
      USB: mos7720: use GFP_ATOMIC under spinlock

Daniel Mack (1):
      usb: ehci-mxc: check for pdata before dereferencing

Felix Fietkau (4):
      ath9k: always clear ps filter bit on new assoc
      ath9k: fix rx descriptor related race condition
      ath9k: avoid accessing MRC registers on single-chain devices
      MIPS: ath79: Fix ar933x watchdog clock

Grant Likely (1):
      of: Fix missing memory initialization on FDT unflattening

Greg Kroah-Hartman (1):
      Linux 3.4.63

Greg Thelen (1):
      memcg: fix multiple large threshold notifications

Hans de Goede (1):
      usb: config->desc.bLength may not exceed amount of data returned by t=
he device

Herbert Xu (1):
      crypto: api - Fix race condition in larval lookup

Jan Kara (1):
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

Kees Cook (4):
      HID: pantherlord: validate output report details
      HID: validate HID report id size
      HID: ntrig: validate feature report details
      HID: check for NULL field when setting values

Libin (1):
      mm/huge_memory.c: fix potential NULL pointer dereference

Maxim Patlasov (1):
      fuse: postpone end_page_writeback() in fuse_writepage_locked()

Mike Dyer (1):
      ASoC: wm8960: Fix PLL register writes

Oliver Neukum (1):
      USB: cdc-wdm: fix race between interrupt handler and tasklet

Peter Maydell (1):
      ARM: PCI: versatile: Fix SMAP register offsets

Roger Pau Monne (1):
      xen-gnt: prevent adding duplicate gnt callbacks

Sarah Sharp (1):
      xhci-plat: Don't enable legacy PCI interrupts.

Sergei Shtylyov (1):
      mmc: tmio_mmc_dma: fix PIO fallback on SDHI

Shawn Nematbakhsh (1):
      usb: xhci: Disable runtime PM suspend for quirky controllers

Stefan Kriwanek (1):
      HID: Fix Speedlink VAD Cezanne support for some devices

Takashi Iwai (1):
      ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist

Tejun Heo (1):
      rculist: list_first_or_null_rcu() should use list_entry_rcu()

Vasily Titskiy (1):
      HID: usbhid: quirk for N-Trig DuoSense Touch Screen


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSRNCLAAoJEDjbvchgkmk+31kP/3NRSLDfbOR8SNz0aOBbIQns
dwIhx/gZIuuknGNwpBPAhHpsQhQQGoJDwJt5s+PBTKNzGzXftVMDadTrKBMi3ncE
5nuXDNdHdfRSzwlD4yJ3zWtuRHMROPPqIymp8F0jYS9XLN/JJmaGVpwDg4Ny4Z23
D+ByKSuEaEt8JzYp6SxOrF2U457/pt/YqmNLcy22WSHjupjRVYrYEHba9EgFxl3P
upLz7aJs/NR4C/nrYJI60KguvtZPphJIyBr7kutGHluju2rUbqKkcyyobRuAqqO8
wnG7ZULiU3wWCDV7gLOgXPQdOz7txB8btSab42YlFSRRKMmRDQSnfnObGFDXFg5W
CdipgTbd8rhyLKNX4AodwuOaJRgAyOuupKQalCeXFQUjEbVkiTt0BCY7FLGyPWb0
lt5tgkMEoCscmx9Zn87EblliBQO7zeG0C4jfaiZLn3WFVIL3J5nYtv016Zitts68
XrxrEAMgAueIApKNsu7TGdY6KgBipEFCLP6uWsUpeO6gY1WIqNrFf4oaKL1Br2wZ
nJ0akawEFtrxpTKFyswXsl6X3g1SQjsa1Owc0pi466jBZLhbJW9hlnWIV2n9Biij
80AlZuah0ACEhVpLncWGlYJMpv3vvclmKnKH+iPcgKaxCp90/O2Y2GJwBm/5nIRf
7VCjI6Jm2erEQ+kyQzTn
=fCdi
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
