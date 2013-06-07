Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab3FGT5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:57:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3FGT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:57:21 -0400
Date: Fri, 7 Jun 2013 12:57:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.81
Message-ID: <20130607195720.GA28377@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.81 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                               |    2=20
 arch/arm/mach-kirkwood/ts219-setup.c   |    2=20
 arch/arm/plat-orion/common.c           |   12 ++--
 arch/avr32/kernel/module.c             |    2=20
 arch/um/include/asm/pgtable.h          |    2=20
 drivers/ata/libata-core.c              |    6 ++
 drivers/block/brd.c                    |    4 -
 drivers/gpu/drm/radeon/radeon_device.c |   19 +++----
 drivers/platform/x86/thinkpad_acpi.c   |    7 ++
 drivers/staging/vt6656/hostap.c        |    2=20
 drivers/tty/n_tty.c                    |    8 +++
 drivers/usb/atm/cxacru.c               |    3 -
 drivers/usb/core/quirks.c              |    3 +
 drivers/usb/host/uhci-hub.c            |    3 -
 drivers/usb/serial/ftdi_sio.c          |    2=20
 drivers/usb/serial/ftdi_sio_ids.h      |    2=20
 drivers/usb/serial/io_ti.c             |    3 +
 drivers/usb/serial/option.c            |   13 +++--
 drivers/xen/events.c                   |   19 ++++++-
 fs/cifs/cifs_dfs_ref.c                 |    4 +
 fs/cifs/inode.c                        |    3 -
 fs/fat/inode.c                         |   15 +++++-
 fs/jfs/inode.c                         |    2=20
 fs/jfs/jfs_logmgr.c                    |    3 -
 fs/nilfs2/inode.c                      |   27 +++++++++--
 fs/ocfs2/extent_map.c                  |    2=20
 include/linux/wait.h                   |   16 ++++--
 lib/klist.c                            |    2=20
 mm/huge_memory.c                       |    7 ++
 mm/migrate.c                           |    2=20
 mm/mmu_notifier.c                      |   80 ++++++++++++++++------------=
-----
 net/mac80211/iface.c                   |    9 +++
 sound/usb/card.h                       |    1=20
 sound/usb/format.c                     |    6 ++
 sound/usb/quirks.c                     |    6 ++
 35 files changed, 207 insertions(+), 92 deletions(-)

Alan Stern (1):
      USB: UHCI: fix for suspend of virtual HP controller

Alex Deucher (1):
      drm/radeon: fix card_posted check for newer asics

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race

Dan Carpenter (1):
      USB: cxacru: potential underflow in cxacru_cm_get_array()

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Dave Kleikamp (1):
      jfs: fix a couple races

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers

Greg Kroah-Hartman (1):
      Linux 3.0.81

Gregory CLEMENT (1):
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11

Hans-Christian Egtvedt (1):
      avr32: fix relocation check for signed 18-bit offset

Hema Prathaban (1):
      staging: vt6656: use free_netdev instead of kfree

Imre Deak (1):
      wait: fix false timeouts when using wait_event_timeout()

Jeff Layton (2):
      cifs: only set ops for inodes in I_NEW state
      cifs: fix potential buffer overrun when composing a new options string

Johannes Berg (1):
      mac80211: close AP_VLAN interfaces before unregistering all

Joseph Qi (1):
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs=
2_fiemap()

Keir Fraser (1):
      xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code

Manoj Iyer (1):
      thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub

Richard Weinberger (1):
      um: Serve io_remap_pfn_range()

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR

Wang YanQing (1):
      TTY: Fix tty miss restart after we turn off flow-control

Wolfgang Frisch (1):
      USB: io_ti: Fix NULL dereference in chase_port()

Xi Wang (2):
      ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_=
rate_range()
      ALSA: usb-audio: avoid integer overflow in create_fixed_stream_quirk()

Xiao Guangrong (1):
      mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

wang, biao (1):
      klist: del waiter from klist_remove_waiters before wakeup waitting pr=
ocess


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRsjsgAAoJEDjbvchgkmk+BAsP/03Zq7O9bw/j+85cXGpL9eny
7LsCULYS+QB8jY+PwM1ptCEl/I1zTYMPfZob28wrNzrrq0ZcTOM5tdB2UtwKf6fY
cZLD6LTt2mnRZ18uDff8ZjQmvjhDUQCAv1ushsGOi/9pTEjLQQpSz6tQCyFrk1fr
AKixQGcnqsCsZ+DFby1ubqe4FsRGrbyeEYTtxPHOf/HNVAgE8Zw9kiE7vc8f1Ik7
Kt3snwZsrLS1VPgvob7l3Ktt5mbMjz9BaMxn/pCbgC7oxVMTAcHjco1K1dykTV8X
0JbpCEZPsIWrW31FH5/JCTGxqBy8pr+6lyTyf0vS1e9WxCZrv3JpabLIohuAcSbB
25Y5NYAz3+8+rROXulrf0z/2ohnNIlvkPWsij0e15pv1xbKim5qH/gcwEE4KPwZ+
oT8iXYnKZnRePvPwUQZkCvDGvuwrrk78o7MJWo1uhrdzSqWQpC8Witw8K2YrJS6u
BaHJmH/gblOvLFxPdPxqlo1CNcEb+zOc/+wf0fkpr2H1+ohG9J/mhQ7rBn3nuU2A
lCoxbZHKdmtP4nSo0WlY6QjsXrexi4pO5v1LkhP9rboe/skG+rbgmb+R9bkVQRM2
uGg7DmCKqKAwS2MxyW5DAAwmNud5b4XLlMyFETVrjKbOqFOVEKuh6uDi9/BKyJIW
PSWfT8bmRqrQAxiG0OvI
=HPiB
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
