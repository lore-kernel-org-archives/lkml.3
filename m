Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaFPVTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:19:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaFPVTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:19:05 -0400
Date: Mon, 16 Jun 2014 14:18:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.8
Message-ID: <20140616211855.GA1991@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.8 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 arch/mips/include/asm/thread_info.h       |    3 ++-
 drivers/ata/ahci.c                        |    4 ++++
 drivers/infiniband/ulp/isert/ib_isert.c   |    8 ++++++++
 drivers/media/dvb-core/dvb-usb-ids.h      |    3 +++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c   |   15 ++++++++++++++-
 drivers/misc/mei/hw-me.c                  |   25 +++++++++++++++++++------
 drivers/pci/msi.c                         |    2 +-
 drivers/target/iscsi/iscsi_target.c       |    1 +
 drivers/target/iscsi/iscsi_target_core.h  |    1 +
 drivers/target/iscsi/iscsi_target_login.c |    1 +
 drivers/target/iscsi/iscsi_target_tpg.c   |    2 ++
 drivers/target/target_core_alua.c         |    9 +++++++++
 fs/attr.c                                 |    8 ++++----
 fs/inode.c                                |   10 +++++++---
 fs/namei.c                                |   11 ++++++-----
 fs/xfs/xfs_ioctl.c                        |    2 +-
 include/linux/capability.h                |    2 +-
 kernel/auditsc.c                          |   27 ++++++++++++++++++-------=
--
 kernel/capability.c                       |   20 ++++++++------------
 net/ipv4/netfilter/nf_defrag_ipv4.c       |    5 +++--
 21 files changed, 114 insertions(+), 47 deletions(-)

Alessandro Miceli (2):
      rtl28xxu: add [1b80:d39d] Sveon STV20
      rtl28xxu: add [1b80:d3af] Sveon STV27

Alexei Starovoitov (1):
      PCI/MSI: Fix memory leak in free_msi_irqs()

Andreas Schr=E4gle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Andy Lutomirski (2):
      fs,userns: Change inode_capable to capable_wrt_inode_uidgid
      auditsc: audit_krule mask accesses need bounds checking

Brian Healy (1):
      rtl28xxu: add 1b80:d395 Peak DVB-T USB

Florian Westphal (1):
      netfilter: ipv4: defrag: set local_df flag on defragmented skb

Greg Kroah-Hartman (1):
      Linux 3.14.8

Jan Vcelak (2):
      rtl28xxu: add USB ID for Genius TVGo DVB-T03
      rtl28xxu: add chipset version comments into device list

J=E9r=F4me Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

Markos Chandras (1):
      MIPS: asm: thread_info: Add _TIF_SECCOMP flag

Nicholas Bellinger (2):
      iser-target: Fix multi network portal shutdown regression
      target: Allow READ_CAPACITY opcode in ALUA Standby access state

Sagi Grimberg (1):
      Target/iscsi,iser: Avoid accepting transport connections during stop =
stage

Till D=F6rges (1):
      rtl28xxu: add ID [0ccd:00b4] TerraTec NOXON DAB Stick (rev 3)

Tomas Winkler (3):
      mei: me: fix hw ready reset flow
      mei: me: drop harmful wait optimization
      mei: me: read H_CSR after asserting reset


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTn18/AAoJEDjbvchgkmk+SAYP/0CTDO53ayK6Qn6ohPCKKLwW
zJzEN9+9lw/9ScMaF5e5ROhc04upMaPVMZrzE5f5dKZAr8h0nr+jzJPQFEnuO+ZP
DzID1JghGScIepf1djhGP/fKXnmyZ8jjlMMbONXff12KZyx9ryOQkdbhtXDkbkW7
+wNGzNLrKa8MaEwPQTv4z+bH4LflU8S16FfK5INWBxrzOel/M1I4qvFCrLl4mykC
05I+7OUEqRGZ7kXyQZ+rfblNk/iQOxV91IJEQTQohsdiGEbHZo7COXSiCwAnt9Bp
VTnt+KhviTTGLJTUp6ubad8T2sbY0QgZMPViz1r998p9UU00qkEKYcBBZIO8h0TV
Icj0pwCGdGHtEHXXFRuXGpo5kOjEInBoM4cfp0wS3MaU4/y+VmFwhFi7s9Nz5hHA
k/FjYEeIqrp/y2MtVVyAB41oZ9p7mC5LUCOshtzvhoO408+29h74wPQsgAxdNy/f
oZ+SzjFYPqmjPXCrMmzcCLXl9xuZeVnpiLfG5aSvuK6eTRrWbT51mHPACtCFSe7R
Z4eyx11TBWK6GYpLpot+llXu9wc4lNs3Kb6oNOzYeqrF3CMzqNOavjILzwf/91tL
oEx3gymLYGAT9Nwhd6A5oYIGOKNFTOhfwZ6X1arAZR4pZYb6eqV1TmtI34gzDf45
DlJn2mQtaZnTBKhPmFoP
=2njS
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
