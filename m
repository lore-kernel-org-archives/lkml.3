Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaGGCAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 22:00:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaGGCA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 22:00:29 -0400
Date: Sun, 6 Jul 2014 19:04:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.47
Message-ID: <20140707020451.GA24502@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.47 kernel.

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

 Documentation/SubmittingPatches              |   22 ++++
 Makefile                                     |    2=20
 arch/mips/kernel/irq-msc01.c                 |    2=20
 arch/mips/kvm/kvm_mips.c                     |   13 --
 arch/powerpc/include/asm/systbl.h            |    2=20
 arch/powerpc/include/uapi/asm/cputable.h     |    1=20
 arch/powerpc/kernel/cputable.c               |    3=20
 arch/powerpc/kernel/time.c                   |    2=20
 arch/powerpc/lib/sstep.c                     |    2=20
 arch/powerpc/platforms/pseries/eeh_pseries.c |    1=20
 arch/x86/include/asm/ptrace.h                |   16 +++
 drivers/block/mtip32xx/mtip32xx.c            |  123 +++++++++++++++++++---=
-----
 drivers/extcon/extcon-max77693.c             |    4=20
 drivers/infiniband/core/user_mad.c           |   75 +++++++++-------
 drivers/infiniband/hw/ipath/ipath_diag.c     |    4=20
 drivers/infiniband/hw/qib/qib_mad.c          |    2=20
 drivers/infiniband/ulp/srp/ib_srp.c          |    6 +
 drivers/input/mouse/elantech.c               |   27 ++++-
 drivers/misc/mei/hw-me.c                     |   28 ++++--
 drivers/pci/pci.c                            |    2=20
 drivers/pci/quirks.c                         |    1=20
 drivers/target/iscsi/iscsi_target.c          |    2=20
 drivers/target/iscsi/iscsi_target_util.c     |    2=20
 drivers/target/target_core_device.c          |    1=20
 drivers/watchdog/ath79_wdt.c                 |   10 ++
 drivers/watchdog/sp805_wdt.c                 |    4=20
 fs/nfs/inode.c                               |   26 +++--
 fs/nfs/nfs4filelayout.c                      |    2=20
 fs/nfsd/nfs4state.c                          |    2=20
 fs/nfsd/nfs4xdr.c                            |    4=20
 fs/nfsd/nfscache.c                           |   53 ++---------
 fs/reiserfs/inode.c                          |    8 +
 fs/ubifs/file.c                              |    3=20
 fs/ubifs/shrinker.c                          |    1=20
 include/linux/ptrace.h                       |    3=20
 include/trace/syscall.h                      |   15 +++
 kernel/fork.c                                |    2=20
 kernel/trace/trace.c                         |   13 +-
 net/ipv4/netfilter/ipt_ULOG.c                |    7 -
 net/netfilter/ipvs/ip_vs_core.c              |   15 ++-
 net/sunrpc/svc_xprt.c                        |    2=20
 scripts/recordmcount.h                       |    4=20
 42 files changed, 338 insertions(+), 179 deletions(-)

Alex Smith (1):
      recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in=
 modules

Anton Blanchard (1):
      powerpc: 64bit sendfile is capped at 2GB

Asai Thambi S P (3):
      mtip32xx: Fix ERO and NoSnoop values in PCIe upstream on AMD systems
      mtip32xx: Increase timeout for STANDBY IMMEDIATE command
      mtip32xx: Remove dfs_parent after pci unregister

Bart Van Assche (3):
      IB/srp: Fix a sporadic crash triggered by cable pulling
      IB/umad: Fix error handling
      IB/umad: Fix use-after-free on close

Benjamin Herrenschmidt (1):
      powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support

Bjorn Helgaas (1):
      PCI: Fix incorrect vgaarb conditional in WARN_ON()

Christoph Hellwig (1):
      nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

Deng-Cheng Zhu (1):
      MIPS: KVM: Fix memory leak on VCPU

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Gabor Juhos (1):
      watchdog: ath79_wdt: avoid spurious restarts on AR934x

Gavin Shan (1):
      powerpc/pseries: Fix overwritten PE state

Greg Kroah-Hartman (1):
      Linux 3.10.47

Hans de Goede (2):
      Input: elantech - deal with clickpads reporting right button events
      Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk =
is set

J. Bruce Fields (1):
      nfsd4: fix FREE_STATEID lockowner leak

Jacob Keller (1):
      Documentation/SubmittingPatches: describe the Fixes: tag

James Hogan (1):
      MIPS: KVM: Remove redundant NULL checks before kfree()

Jeff Layton (2):
      nfsd: don't try to reuse an expired DRC entry off the list
      nfsd: don't halt scanning the DRC LRU list when there's an RC_INPROG =
entry

Jeff Mahoney (1):
      reiserfs: call truncate_setsize under tailpack mutex

Krzysztof Kozlowski (1):
      extcon: max77693: Fix two NULL pointer exceptions on missing pdata

Markos Chandras (1):
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Mathias Krause (1):
      netfilter: ipt_ULOG: fix info leaks

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event

Nicholas Bellinger (3):
      target: Fix left-over se_lun->lun_sep pointer OOPs
      iscsi-target: Avoid rejecting incorrect ITT for Data-Out
      iscsi-target: Explicily clear login response PDU in exception path

Oleg Nesterov (1):
      tracing: Fix syscall_*regfunc() vs copy_process() race

Paul Bolle (2):
      powerpc: fix typo 'CONFIG_PMAC'
      powerpc: fix typo 'CONFIG_PPC_CPU'

Peter Christensen (1):
      ipvs: Fix panic due to non-linear skb

Steven Rostedt (Red Hat) (1):
      tracing: Try again for saved cmdline if failed due to locking

Tejun Heo (1):
      ptrace,x86: force IRET path after a ptrace_stop()

Thomas Jarosch (1):
      PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Tomas Winkler (2):
      mei: me: read H_CSR after asserting reset
      mei: me: fix hw ready reset flow

Trond Myklebust (3):
      SUNRPC: Fix a module reference leak in svc_handle_xprt
      pNFS: Handle allocation errors correctly in filelayout_alloc_layout_h=
dr()
      NFS: Don't declare inode uptodate unless all attributes were checked

Viresh Kumar (1):
      watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()

hujianyang (2):
      UBIFS: fix an mmap and fsync race condition
      UBIFS: Remove incorrect assertion in shrink_tnc()


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTugBCAAoJEDjbvchgkmk+TQkQALJWR58RenbEvzWV8hdY/obm
kwmErN8dAoUzU7HWZswJcDfNM2hak2wLH+9mZDYpa3g4EWw3RWpPzl3izybxVkQX
i6rrHOFnJ/pwSpwKBs4ttd2xrV2vPW3nLchVIT2fezMPHLvLhl006xbM0KR+wWCm
4hj727GVQrIJRwwxd/5Ul+5gk0BNCDUbS0SFU9AkNAfY/iz3yaDgg87Ld7Q/Ar2h
m69jRcJJFV/eX0TRag4T3k/QFnBIhubXV8OPglFMilTc1lks4g629IgiCpNYIu6S
iEHV3627ZPP0CABlzxg21V7OpfBiOIj0EEDX+n09Hqotu9ornp4qRatxPJzgsskS
nfAHrUZgrHDVKUA/tOsEkEciFHn01wvB/icGTb53WpPN6fq177w25FUmNw+JYFwQ
Vo+nkBcx5OJIK89T1Zl71G2nMYKwyC4qNqfHkRY3fDXiuiwm3paPp6NR2yDhZc4D
x1lAsA2DpRZuV08BvkK5DlpR8omb6t5+TMcdRw1CmtVUX+9zkIsTo7j7vK2BKC22
ZOGILjAOnXsAmBqvtLORqeTkYqvRjfMai1X/tduVxjstnX4YmhS2IGUzIzDN1XM4
yyd0miB4W7VxrJA1O5ZV238kGa+zc5IpOLQV3KYXAEQx21uJ7+mY2MU/meUCot0z
sFDcQwiT6bojRm3L5fhY
=0K3U
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
