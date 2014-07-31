Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaGaW6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:58:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaGaW6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:58:43 -0400
Date: Thu, 31 Jul 2014 15:58:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.15.8
Message-ID: <20140731225815.GA4155@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.15.8 kernel.

All users of the 3.15 kernel series must upgrade.

The updated 3.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.15.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                  |    6 ++--
 arch/parisc/include/uapi/asm/signal.h     |    2 -
 arch/powerpc/platforms/pseries/dlpar.c    |    1=20
 arch/powerpc/platforms/pseries/reconfig.c |    1=20
 arch/s390/kernel/ptrace.c                 |   12 ++++++--
 arch/x86/kernel/entry_32.S                |    9 +++---
 arch/xtensa/mm/init.c                     |    2 -
 block/blk-cgroup.c                        |    7 ++++
 block/blk-tag.c                           |   33 ++++-------------------
 block/compat_ioctl.c                      |    1=20
 drivers/ata/ahci.c                        |    1=20
 drivers/ata/libata-core.c                 |   12 ++++++--
 drivers/base/platform.c                   |    9 ++++--
 drivers/block/zram/zram_drv.c             |   22 ++++++++++++---
 drivers/char/hw_random/core.c             |    6 ++++
 drivers/char/hw_random/virtio-rng.c       |   10 ++++++
 drivers/gpu/drm/radeon/cik.c              |    2 +
 drivers/gpu/drm/radeon/evergreen.c        |    1=20
 drivers/gpu/drm/radeon/r600.c             |    1=20
 drivers/gpu/drm/radeon/si.c               |    1=20
 drivers/hwmon/smsc47m192.c                |    4 ++
 drivers/input/input.c                     |    6 ++--
 drivers/input/mouse/synaptics.c           |    5 ++-
 drivers/media/dvb-frontends/tda10071.c    |    6 +++-
 drivers/media/usb/dvb-usb-v2/af9035.c     |   40 +++++++++++++++++++++++--=
--
 drivers/media/usb/hdpvr/hdpvr-video.c     |    6 ++--
 drivers/media/v4l2-core/v4l2-dv-timings.c |    4 +-
 drivers/parport/Kconfig                   |   12 ++++----
 drivers/pinctrl/pinctrl-st.c              |    2 -
 drivers/staging/media/omap4iss/Kconfig    |    2 -
 fs/coredump.c                             |    2 -
 fs/fuse/inode.c                           |    5 ---
 fs/namei.c                                |    3 +-
 fs/nfs/nfs3acl.c                          |   43 +++++++++++++++++++++++++=
+++++
 fs/nfs/nfs3proc.c                         |    4 +-
 include/linux/libata.h                    |    1=20
 include/uapi/linux/fuse.h                 |    3 ++
 kernel/trace/trace.c                      |    2 -
 kernel/trace/trace_clock.c                |    9 +++---
 mm/hugetlb.c                              |    1=20
 mm/memory.c                               |    2 -
 mm/slab_common.c                          |    2 -
 net/wireless/nl80211.c                    |   11 +++----
 43 files changed, 222 insertions(+), 92 deletions(-)

Amit Shah (1):
      hwrng: virtio - ensure reads happen after successful probe

Andrew Gallagher (1):
      fuse: add FUSE_NO_OPEN_SUPPORT flag to INIT

Antti Palosaari (2):
      media: af9035: override tuner id when bad value set into eeprom
      media: tda10071: force modulation to QPSK on DVB-S

Arnd Bergmann (1):
      media: staging: tighten omap4iss dependencies

Christian K=F6nig (1):
      drm/radeon: fix irq ring buffer overflow handling

Christoph Hellwig (2):
      nfs: only show Posix ACLs in listxattr if actually present
      block: don't assume last put of shared tags is for the host

Dmitry Torokhov (1):
      Input: fix defuzzing logic

Greg Kroah-Hartman (1):
      Linux 3.15.8

Guenter Roeck (2):
      hwmon: (smsc47m192) Fix temperature limit and vrm write operations
      platform_get_irq: Revert to platform_get_resource if of_irq_get fails

Hans Verkuil (1):
      media: hdpvr: fix two audio bugs

Hans de Goede (1):
      Input: synaptics - add min/max quirk for pnp-id LEN2002 (Edge E531)

Jerome Glisse (1):
      drm/radeon: fix cut and paste issue for hawaii.

Johannes Berg (1):
      nl80211: move set_qos_map command into split state

John David Anglin (1):
      parisc: Remove SA_RESTORER define

Kevin Hao (1):
      libata: support the ata host which implements a queue depth less than=
 32

Konstantin Khlebnikov (1):
      mm: do not call do_fault_around for non-linear fault

Linus Torvalds (1):
      Fix gcc-4.9.0 miscompilation of load_balance() in scheduler

Martin Schwidefsky (1):
      s390/ptrace: fix PSW mask check

Max Filippov (1):
      xtensa: fix sysmem reservation at the end of existing block

Maxime COQUELIN (1):
      pinctrl: st: Fix irqmux handler

Miklos Szeredi (1):
      fuse: s_time_gran fix

Mikulas Patocka (2):
      block: provide compat ioctl for BLKZEROOUT
      slab_common: fix the check for duplicate slab names

Minchan Kim (1):
      zram: avoid lockdep splat by revalidate_disk

Naoya Horiguchi (1):
      mm: hugetlb: fix copy_hugetlb_page_range()

Randy Dunlap (1):
      parport: fix menu breakage

Rickard Strandqvist (1):
      media: media: v4l2-core: v4l2-dv-timings.c: Cleaning up code wrong va=
lue used in aspect ratio

Romain Degez (1):
      ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

Silesh C V (1):
      coredump: fix the setting of PF_DUMPCORE

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

Tejun Heo (2):
      libata: introduce ata_host->n_tags to avoid oops on SAS controllers
      blkcg: don't call into policy draining if root_blkg is already gone

Tony Luck (1):
      tracing: Fix wraparound problems in "uptime" trace clock

Tyrel Datwyler (1):
      powerpc/pseries: dynamically added OF nodes need to call of_node_init

Vasily Averin (1):
      fs: umount on symlink leaks mnt count


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2soHAAoJEDjbvchgkmk+cv8P/i0gnQRRVS6N3xylhqfpv9z9
5iypRSIXZE+D4fRlb1KPCleSMh4XUkyjtWXDKgBCowr0553nDbtgmXdOh0KqoqNo
eQU2uYsPoNxAgWVTGVN4IrgGjMwPir88GwCXBrXE+Ag5giwvfg2MDJJ3xeX64a2f
cit+m5Y2xk1Vxl7Y/wYG/6/xbHncdGsyA8jbKoz+DsTEOoZGWqmcHYxDMzyr1u5o
UcZEhE+P7ER+r0a/MTKGps7RlmBA7EHUH7yBfQmDE7u+UaketNNNpFWIcubgmS5I
8RT9WrYLtM+ey2Orh4rJLBM9M4uJq09U86nPCyO4ExlZjrk3g5Xguz4Bm2fL8HHQ
BjWx4lADoHav3XPJZgaDuLQXcF5G2nb1rEEzCYHPzm5YifXPsib1AdSEzWF84IJH
/ZcPF4vQuTXQIkLMvxzMCQ+iZEsW2O+HsD78WuEPq89R+B4/AYSpYm3QsqQyViNL
HCvbt4N9EadS7UMfPKqFEMfzzHOGLSZSucdV8Ttkx6zSQIDEmy0p5NBB+JgBRdcL
+ZhJhab8SwNGLfQlh0aOLZxy6COa3iKO3Ufby1dn+c4yboZ/rOVqpFkewFP+WpYz
Xi1F96eLlok0lCYX758oUJNwezRjh/F1FZEkUVbWbDn39dFg2qoGqkKh07i/Eti4
qSWW3lVbFWNswGyxaO40
=/94V
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
