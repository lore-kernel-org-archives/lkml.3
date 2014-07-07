Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaGGB6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 21:58:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaGGB6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 21:58:14 -0400
Date: Sun, 6 Jul 2014 19:02:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.97
Message-ID: <20140707020235.GA24807@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.97 kernel.

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
 arch/mips/kernel/irq-msc01.c                 |    2=20
 arch/powerpc/kernel/time.c                   |    2=20
 arch/powerpc/lib/sstep.c                     |    2=20
 arch/powerpc/platforms/pseries/eeh_pseries.c |    1=20
 arch/x86/include/asm/ptrace.h                |   16 +++++
 drivers/infiniband/core/user_mad.c           |   75 +++++++++++++++-------=
-----
 drivers/infiniband/hw/ipath/ipath_diag.c     |    4 +
 drivers/infiniband/hw/qib/qib_mad.c          |    2=20
 drivers/infiniband/ulp/srp/ib_srp.c          |    6 ++
 drivers/input/mouse/elantech.c               |   22 ++++++-
 drivers/pci/pci.c                            |    2=20
 drivers/pci/quirks.c                         |    1=20
 drivers/watchdog/sp805_wdt.c                 |    4 -
 fs/nfsd/nfs4state.c                          |    2=20
 fs/nfsd/nfs4xdr.c                            |    4 -
 fs/ubifs/shrinker.c                          |    1=20
 include/linux/ptrace.h                       |    3 +
 include/trace/syscall.h                      |   15 +++++
 kernel/fork.c                                |    2=20
 scripts/recordmcount.h                       |    4 -
 21 files changed, 122 insertions(+), 50 deletions(-)

Alex Smith (1):
      recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in=
 modules

Bart Van Assche (3):
      IB/srp: Fix a sporadic crash triggered by cable pulling
      IB/umad: Fix error handling
      IB/umad: Fix use-after-free on close

Bjorn Helgaas (1):
      PCI: Fix incorrect vgaarb conditional in WARN_ON()

Christoph Hellwig (1):
      nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Gavin Shan (1):
      powerpc/pseries: Fix overwritten PE state

Greg Kroah-Hartman (1):
      Linux 3.4.97

Hans de Goede (1):
      Input: elantech - deal with clickpads reporting right button events

J. Bruce Fields (1):
      nfsd4: fix FREE_STATEID lockowner leak

Markos Chandras (1):
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event

Oleg Nesterov (1):
      tracing: Fix syscall_*regfunc() vs copy_process() race

Paul Bolle (2):
      powerpc: fix typo 'CONFIG_PMAC'
      powerpc: fix typo 'CONFIG_PPC_CPU'

Tejun Heo (1):
      ptrace,x86: force IRET path after a ptrace_stop()

Thomas Jarosch (1):
      PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Viresh Kumar (1):
      watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()

hujianyang (1):
      UBIFS: Remove incorrect assertion in shrink_tnc()


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTuf+7AAoJEDjbvchgkmk+aNoP/ArLTcSeoqZwMWbJQoJAYLR4
+EyCpTJmH6kWdzEbOQkamYFaDLzXlwG55Kehy9dxY1ZmXdnGGxq+NidMhOggYXfv
x4Cjw4h7LTVee6f/EiCFT4UeKlsp1tNEcO6TdtMt3Qk7ivEr6jxBvWoxibj2nIPm
KatJbft2hprkL7KSs/KJ3AWZbvdAgwtE7wzlgAC8ixE2jahwE61I4/cdIVj7eAGQ
ndEoScK0zGRgTLRXyZoyEceb8WKzUguVQvkuFccO2OC70LGuaZ6vxxYa9JT3MlUx
uQM64NqeUBVwhCedxGUzLmoxE7ihPFesmbsR2HdXm7OB1CZbabAnaPgkx9UrXTq0
Iiw5o9Iik03DlBAOaPgblOmoqUiaotHx4NsCWGXqOJ+OzvkPcPXcIzV1c+WvsBSH
QaVsqx6XUA50XvD3Yy5YQ92nbTkofq41tPXiGzzjAbM/nUHqIVEm+OvmJwdy0SZR
jqydT3Otaufm+NLUc7+vW7UB97BrIWyaiuriDHh3R0uayR+xxyHXNQQX5Ld8OlrF
Tec3upRwkwiG6fAXtQhEdGyqtM3B7kPb6FjGbp1ydRbImwfxP4geD1hOQVEHz4Jk
R8anaOiljyM9qAkSQAS6GGMo4JB32Db8p66auq3c1KzCP/uEwkogl+hN/Exp5gWZ
ytSKFnh3LeKfWjMqIwgD
=phVw
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
