Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaFPVSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:18:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaFPVR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:17:58 -0400
Date: Mon, 16 Jun 2014 14:17:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.44
Message-ID: <20140616211748.GA1884@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.44 kernel.

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

 Makefile                                         |    2=20
 arch/arm/boot/dts/armada-xp-gp.dts               |    2=20
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |    2=20
 drivers/ata/ahci.c                               |    4 +
 drivers/infiniband/ulp/isert/ib_isert.c          |    8 +++
 drivers/misc/mei/hw-me.c                         |    4 -
 drivers/net/ethernet/mellanox/mlx4/en_cq.c       |    1=20
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c   |    6 --
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h     |    1=20
 drivers/scsi/megaraid/megaraid_sas.h             |    1=20
 drivers/scsi/megaraid/megaraid_sas_base.c        |    5 +-
 drivers/target/iscsi/iscsi_target.c              |    1=20
 drivers/target/iscsi/iscsi_target_core.h         |    1=20
 drivers/target/iscsi/iscsi_target_login.c        |   51 +++++++++++-------=
--
 drivers/target/iscsi/iscsi_target_tpg.c          |    9 ++-
 drivers/target/target_core_alua.c                |    9 +++
 drivers/target/target_core_configfs.c            |    5 ++
 fs/attr.c                                        |    8 +--
 fs/inode.c                                       |   10 ++--
 fs/namei.c                                       |   11 ++--
 include/linux/capability.h                       |    2=20
 kernel/auditsc.c                                 |   27 +++++++---
 kernel/capability.c                              |   18 ++-----
 mm/compaction.c                                  |   57 ++++++++++++++----=
-----
 net/ipv4/netfilter/nf_defrag_ipv4.c              |    5 +-
 25 files changed, 151 insertions(+), 99 deletions(-)

Andreas Schr=E4gle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Andy Lutomirski (2):
      fs,userns: Change inode_capable to capable_wrt_inode_uidgid
      auditsc: audit_krule mask accesses need bounds checking

Ben Collins (1):
      SCSI: megaraid: Use resource_size_t for PCI resources, not long

Chris Mason (1):
      mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Florian Westphal (1):
      netfilter: ipv4: defrag: set local_df flag on defragmented skb

Greg Kroah-Hartman (1):
      Linux 3.10.44

J=E9r=F4me Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

Nicholas Bellinger (3):
      iser-target: Fix multi network portal shutdown regression
      target: Allow READ_CAPACITY opcode in ALUA Standby access state
      target: Fix alua_access_state attribute OOPs for un-configured devices

Roland Dreier (1):
      iscsi-target: Fix wrong buffer / buffer overrun in iscsi_change_param=
_value()

Sagi Grimberg (1):
      Target/iscsi,iser: Avoid accepting transport connections during stop =
stage

Thomas Petazzoni (2):
      ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree

Tomas Winkler (1):
      mei: me: drop harmful wait optimization

Vlastimil Babka (3):
      mm: compaction: reset cached scanner pfn's before reading them
      mm: compaction: detect when scanners meet in isolate_freepages
      mm/compaction: make isolate_freepages start at pageblock boundary


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTn178AAoJEDjbvchgkmk+C4oQAL7JHyNrRG7N/Sn9TkdVV24o
7LzWel/sr/sgP9nh82s91E9pnogAwOtcapirp/uLAlIqe5k8bHiP/pFu6PDelPNa
mdxvqYUZZ4WKtEeBNvY5hvlZnlhNtZGhazA5GiArRkCZ+iOgpaFTEqMsnEsYi5qY
GVPTu/JjqArVcvSQ/aXWYES+UoyAzebtVonz5lyCSEzy6x0gHDh/lkA2c97pZx2M
a08968Ptkjz9oUA8/twNAfVNacnN1YMt1A29GRDlof4Xltktj6/wH+lSET9/rytY
3hn9j84bBbuZp2+H89Ag0+hPNFcWBqbKwaMSTHciVFQYnGAcq/3G2BTGvi3lwrW5
NIM49XOgos0t0t6O43JtVa9jKwsHvK43wpoFh6gYFGXiMUoVObKUDGBtP80Jt7om
JgD0oXm0mjT+kuZiXLhPH0BD7lgNCqwduOIyaPQY0zGCbgQT+n8Z3sUHEaHgb+5Y
x9w3asydAv/UA7lrxUmN6ROFy1ag/zorqMun8wiCG6pw6aR9aBVpojIvyo8Wzvis
pSEf5GSIEa7vWZK7ul68rB4YhYw3B/x8ZOvrOOwgYnWxr9RpDMvaM3i/QZkIzYjP
6gIavnAzzVETjzK2LWa5rgo6LzbS+pl2lZmlAVPFkE6wgrb4eIODQBpPWxwQxJmO
7ySTpcVFDiyiw1nSfBYK
=Elkt
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
