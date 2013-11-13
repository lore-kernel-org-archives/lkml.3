Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab3KMDJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:09:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3KMDJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:09:19 -0500
Date: Wed, 13 Nov 2013 12:12:09 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.69
Message-ID: <20131113031209.GA7862@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.69 kernel.

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

 Makefile                                     |    2=20
 arch/parisc/kernel/head.S                    |    4=20
 arch/um/kernel/exitcode.c                    |    4=20
 arch/xtensa/kernel/signal.c                  |    2=20
 drivers/ata/libata-eh.c                      |    6=20
 drivers/gpu/drm/drm_drv.c                    |    9 +
 drivers/gpu/drm/radeon/atombios_encoders.c   |    2=20
 drivers/md/raid1.c                           |    1=20
 drivers/md/raid10.c                          |    1=20
 drivers/net/can/flexcan.c                    |   10 +
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    3=20
 drivers/scsi/aacraid/linit.c                 |    2=20
 drivers/staging/bcm/Bcmchar.c                |    1=20
 drivers/staging/ozwpan/ozcdev.c              |    3=20
 drivers/usb/core/quirks.c                    |    6=20
 drivers/usb/serial/ftdi_sio.c                |    1=20
 drivers/usb/serial/ftdi_sio_ids.h            |    6=20
 drivers/usb/serial/option.c                  |  216 ++++++++++++++++++++++=
+++++
 fs/jfs/jfs_inode.c                           |    3=20
 kernel/time/clockevents.c                    |   65 ++++++--
 lib/scatterlist.c                            |    3=20
 mm/swap.c                                    |   31 +++
 net/mac80211/ieee80211_i.h                   |    3=20
 net/mac80211/scan.c                          |   19 ++
 net/mac80211/status.c                        |    3=20
 sound/core/pcm.c                             |    4=20
 sound/pci/hda/patch_realtek.c                |    1=20
 sound/soc/codecs/wm_hubs.c                   |    1=20
 sound/soc/soc-dapm.c                         |    2=20
 29 files changed, 382 insertions(+), 32 deletions(-)

Alex Deucher (1):
      drm/radeon/atom: workaround vbios bug in transmitter table on rs780

Baruch Siach (1):
      xtensa: don't use alternate signal stack on threads

Chris Wilson (1):
      drm: Prevent overwriting from userspace underallocating core ioctl st=
ructs

Dan Carpenter (4):
      staging: ozwpan: prevent overflow in oz_cdev_write()
      Staging: bcm: info leak in ioctl
      uml: check length in exitcode_proc_write()
      aacraid: missing capable() check in compat ioctl

Dave Kleikamp (1):
      jfs: fix error path in ialloc

Emmanuel Grumbach (1):
      mac80211: correctly close cancelled scans

Fangxiaozhi (Franko) (1):
      USB: support new huawei devices in option.c

Felix Fietkau (1):
      mac80211: update sta->last_rx on acked tx frames

Greg Kroah-Hartman (1):
      Linux 3.4.69

Gwendal Grignou (1):
      libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures

Helge Deller (1):
      parisc: Do not crash 64bit SMP kernels on machines with >=3D 4GB RAM

Khalid Aziz (1):
      mm: fix aio performance regression for database caused by THP

Lukasz Dorau (1):
      md: Fix skipping recovery for read-only arrays.

Marc Kleine-Budde (1):
      can: flexcan: flexcan_chip_start: fix regression, mark one MB for TX =
and abort pending TX

Mark Cave-Ayland (1):
      rtlwifi: rtl8192cu: Fix error in pointer arithmetic

Ming Lei (1):
      lib/scatterlist.c: don't flush_kernel_dcache_page on slab page

Oliver Neukum (2):
      USB: quirks.c: add one device that cannot deal with suspension
      USB: quirks: add touchscreen that is dazzeled by remote wakeup

Russell King (1):
      ALSA: fix oops in snd_pcm_info() caused by ASoC DPCM

Takashi Iwai (3):
      ALSA: hda - Add a fixup for ASUS N76VZ
      ASoC: wm_hubs: Add missing break in hp_supply_event()
      ASoC: dapm: Fix source list debugfs outputs

Thomas Gleixner (1):
      clockevents: Sanitize ticks to nsec conversion

=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 =D0=9A=D1=80=D0=B0=D0=BC=D0=B0=
=D1=80=D0=B5=D0=BD=D0=BA=D0=BE (1):
      USB: serial: ftdi_sio: add id for Z3X Box device


--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSgu4JAAoJEDjbvchgkmk+2qsP+gJ7mYHWmbhIU9k7AJT/jzoj
5DgufkxmBM6TwBhX1xPPMIwIix4L6XpWV8EPPQrMgP2UQ/WGzoxvFzARX32u/IA4
8h3VkOeJ8GBgR161JDysf9VS03vIW9kbLe8tHHSo/+IBsNh98kP9noPYtxpDafBg
ymihjYtlOH61tG8+m3hVbfPXUQsY+DMk70xlwP/ZghSKStPydoUI5vC2yn8TD0sZ
mcbCr4N4fFhRY1bwcgQ3F3/g6/cRWmNxFVhHzn/jRfWwJEtIa55vxY/lIIinWwu0
DWouiylqqrLi6G5n5YOb9oWXk9ktje6qKAAiH5GhgNFtuQzE3QNanSP+wSRGTNY3
nBkLI2Fm0IIb+E8ycqbNCm1hyHKCsk7AZU2m0H4UCxAZQ8fTFmNHTrlXyauU/nmB
hUi+p9caBjmy1Iozkc/75KuIt0WDMYgyIz97IUj2lM4WVF/owGjpoeWuVvn89iJU
frxBh4BtabyTORUoBB1e04QibdiyINlfZ+3Dl19WCKntVLmp3nU4GFhCkZ7fUnZq
m1xWOo+Rg/bh4sbrLJe826QgDoGUqZVeYOcOmpHiX4AfmNxLmt9EWQU+PRM/2YTK
8EigkF2noOMXPFbKR8agVpVGj4X3fKTUb+dMXnyY98Rswm82vLLadMDFZmdB3uep
lTRPU5xQ0sdXcEbTh+r3
=NgMv
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
