Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3FGT5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:57:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3FGT5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:57:50 -0400
Date: Fri, 7 Jun 2013 12:57:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.48
Message-ID: <20130607195749.GA28426@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.48 kernel.

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

 Makefile                                       |    2=20
 arch/arm/mach-kirkwood/ts219-setup.c           |    2=20
 arch/arm/plat-orion/common.c                   |   12 +--
 arch/avr32/kernel/module.c                     |    2=20
 arch/m68k/kernel/head.S                        |   29 +++++----
 arch/x86/um/sys_call_table_32.c                |    4 -
 drivers/ata/ata_piix.c                         |   15 ++++
 drivers/ata/libata-core.c                      |    6 +
 drivers/block/brd.c                            |    4 -
 drivers/gpu/drm/radeon/radeon_device.c         |   19 ++---
 drivers/iommu/amd_iommu.c                      |   31 ++++++++-
 drivers/iommu/amd_iommu_types.h                |    1=20
 drivers/leds/leds-ot200.c                      |   14 ++--
 drivers/net/xen-netback/netback.c              |    5 -
 drivers/platform/x86/thinkpad_acpi.c           |    7 ++
 drivers/staging/vt6656/hostap.c                |    2=20
 drivers/target/iscsi/iscsi_target_parameters.c |    8 --
 drivers/target/iscsi/iscsi_target_parameters.h |    4 -
 drivers/tty/n_tty.c                            |    8 ++
 drivers/usb/atm/cxacru.c                       |    3=20
 drivers/usb/core/quirks.c                      |    3=20
 drivers/usb/host/uhci-hub.c                    |    3=20
 drivers/usb/host/xhci-mem.c                    |   17 ++---
 drivers/usb/serial/ftdi_sio.c                  |    2=20
 drivers/usb/serial/ftdi_sio_ids.h              |    2=20
 drivers/usb/serial/io_ti.c                     |    3=20
 drivers/usb/serial/option.c                    |   13 ++--
 drivers/xen/events.c                           |   19 ++++-
 fs/cifs/cifs_dfs_ref.c                         |    4 -
 fs/cifs/inode.c                                |    3=20
 fs/fat/inode.c                                 |   15 ++++
 fs/jfs/inode.c                                 |    2=20
 fs/jfs/jfs_logmgr.c                            |    3=20
 fs/nfs/nfs4proc.c                              |    2=20
 fs/nilfs2/inode.c                              |   27 +++++++-
 fs/ocfs2/extent_map.c                          |    2=20
 fs/xfs/xfs_iops.c                              |   47 ++++++++++----
 include/linux/wait.h                           |   16 +++--
 lib/klist.c                                    |    2=20
 mm/huge_memory.c                               |    7 +-
 mm/migrate.c                                   |    2=20
 mm/mmu_notifier.c                              |   80 ++++++++++++--------=
-----
 mm/pagewalk.c                                  |   70 +++++++++++----------
 net/mac80211/iface.c                           |    9 ++
 tools/perf/scripts/python/net_dropmonitor.py   |    8 +-
 45 files changed, 354 insertions(+), 185 deletions(-)

Alan Stern (2):
      USB: xHCI: override bogus bulk wMaxPacketSize values
      USB: UHCI: fix for suspend of virtual HP controller

Alex Deucher (1):
      drm/radeon: fix card_posted check for newer asics

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Ben Hutchings (2):
      perf: net_dropmonitor: Fix trace parameter order
      perf: net_dropmonitor: Fix symbol-relative addresses

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race

Chew, Chiau Ee (1):
      ata_piix: add PCI IDs for Intel BayTail

Christian Gmeiner (1):
      drivers/leds/leds-ot200.c: fix error caused by shifted mask

Cliff Wickman (1):
      mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

Dan Carpenter (1):
      USB: cxacru: potential underflow in cxacru_cm_get_array()

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Dave Chinner (1):
      xfs: kill suid/sgid through the truncate path.

Dave Kleikamp (1):
      jfs: fix a couple races

Finn Thain (1):
      m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers

Greg Kroah-Hartman (1):
      Linux 3.4.48

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

Joerg Roedel (1):
      iommu/amd: Workaround for ERBT1312

Johannes Berg (1):
      mac80211: close AP_VLAN interfaces before unregistering all

Joseph Qi (1):
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs=
2_fiemap()

Kees Cook (1):
      iscsi-target: fix heap buffer overflow on error

Keir Fraser (1):
      xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code

Manoj Iyer (1):
      thinkpad-acpi: recognize latest V-Series using DMI_BIOS_VENDOR

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Martin Pelikan (1):
      x86, um: Correct syscall table type attributes breaking gcc 4.8

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface

Suravee Suthikulpanit (1):
      iommu/amd: Re-enable IOMMU event log interrupt after handling.

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G

Trond Myklebust (1):
      NFSv4: Fix a thinko in nfs4_try_open_cached

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR

Wang YanQing (1):
      TTY: Fix tty miss restart after we turn off flow-control

Wei Liu (1):
      xen-netback: remove skb in xen_netbk_alloc_page

Wolfgang Frisch (1):
      USB: io_ti: Fix NULL dereference in chase_port()

Xiao Guangrong (1):
      mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

wang, biao (1):
      klist: del waiter from klist_remove_waiters before wakeup waitting pr=
ocess


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRsjs9AAoJEDjbvchgkmk+aMMP/Rx5OfeHwz6H5b7ITiK8mg1b
D2E+c8EGqi3amo/AXrwIPRdjIA8/Q1IIJ8ZrdinCzgsd+/KRXreoNhhxJ4wYOeXn
pk4Swgja+KmZrL3zPUA94/Zsio2+Q03HX37oLK1k0KqI/JTlr5XSl1TDs9iK8lwC
vlMF5NCvGkYRdcof+vg/bEboWuIq8hP85eot44epgNumO3ge44q+EgMvbKOm40uB
UC5aX120Hf72WqhLszeg5JJ/w4yATC4QjG/OSKsdcOuvMCIkDZQu6q+VHZcdU8LM
kIxJwgwXstaNkVkaEH3X1kpIx5hpPyNz8SJmNPyl0S58RibV2KvmCpg0q5ZahFNg
jk0r7JFVf9NxdeZrKYaTVeVPRefOX0EvYYadUpf5rvNxvA8xZfiQgWTCrPnNBdUS
gjWHyfc7Pi8mLuc/OP9MTaUyAdRPnZpFWHWFUdbrCnX04b104o1nyg7TnI6dTO0x
Zr3SI0SyEYKhFzEXlzkdk1qG2t71vrwIZQokCkxlelBCFiKVBLl6BE96anor0zrT
/TWUl8YJrLDQgumd62YB3qeDRGKsdCgSh3DJreTeh2Zy8dR1BXz7Dt7ljCobDlzp
O9KQZzWe6j+cqXtsXxM35GinS40XI+A4K+PCI6wSVOvnwRvyz/CTkGEbBVnvf0uG
14AmsydXuBJOOPVhvaOh
=LqK+
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
