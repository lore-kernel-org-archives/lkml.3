Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3CCWao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:30:44 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52770 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3CCWal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:30:41 -0500
Date: Mon, 4 Mar 2013 06:30:53 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.68
Message-ID: <20130303223053.GA15022@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.68 kernel.

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

 Documentation/kernel-parameters.txt          |    5 ++
 Makefile                                     |    2=20
 arch/s390/kvm/kvm-s390.c                     |    2=20
 arch/x86/kernel/amd_iommu_init.c             |   10 +++-
 arch/x86/kernel/apic/x2apic_phys.c           |   17 +++++--
 arch/x86/kernel/head.c                       |   53 ++++++++++++++--------
 arch/x86/mm/fault.c                          |    9 ++-
 drivers/block/xen-blkback/xenbus.c           |   49 ++++++++++-----------
 drivers/dca/dca-core.c                       |    2=20
 drivers/firewire/core-device.c               |    4 +
 drivers/media/rc/rc-main.c                   |    4 +
 drivers/staging/comedi/comedi_fops.c         |    8 +--
 drivers/staging/comedi/drivers/ni_labpc.c    |   35 ++++++++-------
 drivers/target/target_core_fabric_configfs.c |    8 +++
 drivers/vhost/vhost.c                        |    2=20
 fs/ext4/mballoc.c                            |    6 +-
 fs/ocfs2/suballoc.c                          |    7 +--
 fs/ocfs2/suballoc.h                          |    2=20
 include/linux/auto_fs.h                      |   25 +++-------
 include/linux/quota.h                        |    1=20
 include/linux/sched.h                        |   11 ++++
 kernel/cgroup.c                              |    8 +++
 kernel/cpuset.c                              |   12 ++++-
 kernel/posix-timers.c                        |    7 +++
 kernel/ptrace.c                              |   63 ++++++++++++++++++++++=
-----
 kernel/sched.c                               |    3 -
 kernel/signal.c                              |   17 +++----
 kernel/sysctl_binary.c                       |    3 -
 kernel/trace/ftrace.c                        |   46 +++++++++++++------
 lib/idr.c                                    |    9 +++
 net/sunrpc/svc_xprt.c                        |   15 ------
 31 files changed, 287 insertions(+), 158 deletions(-)

Dan Carpenter (1):
      media: rc: unlock on error in show_protocols()

Greg Kroah-Hartman (1):
      Linux 3.0.68

H. Peter Anvin (1):
      x86: Make sure we can boot in the case the BDA contains pure garbage

Helge Deller (1):
      unbreak automounter support on 64-bit kernel with 32-bit userspace (v=
2)

Ian Abbott (3):
      staging: comedi: ni_labpc: correct differential channel sequence for =
AI commands
      staging: comedi: ni_labpc: set up command4 register *after* command3
      staging: comedi: check s->async for poll(), read() and write()

J. Bruce Fields (1):
      svcrpc: make svc_age_temp_xprts enqueue under sv_lock

Jan Beulich (1):
      xen-blkback: do not leak mode property

Jiri Slaby (2):
      dca: check against empty dca_domains list before unregister provider =
fix
      s390/kvm: Fix store status for ACRS/FPRS fix

Joerg Roedel (1):
      iommu/amd: Initialize device table after dma_ops

Kees Cook (1):
      x86: Do not leak kernel page mapping locations

Konrad Rzeszutek Wilk (2):
      doc, xen: Mention 'earlyprintk=3Dxen' in the documentation.
      doc, kernel-parameters: Document 'console=3Dhvc<n>'

Li Zefan (2):
      cpuset: fix cpuset_print_task_mems_allowed() vs rename() race
      cgroup: fix exit() vs rmdir() race

Michael S. Tsirkin (1):
      vhost: fix length for cross region descriptor

Nicholas Bellinger (1):
      target: Add missing mapped_lun bounds checking during make_mappedlun =
setup

Niu Yawei (1):
      ext4: fix race in ext4_mb_add_n_trim()

Oleg Nesterov (3):
      ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
      ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
      wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACE=
D task

Steven Rostedt (Red Hat) (1):
      ftrace: Call ftrace cleanup module notifier after all other notifiers

Stoney Wang (1):
      x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server sys=
tems

Tejun Heo (3):
      posix-timer: Don't call idr_find() with out-of-range ID
      idr: fix a subtle bug in idr_get_next()
      firewire: add minor number range check to fw_device_init()

Theodore Ts'o (1):
      quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format

Xi Wang (1):
      sysctl: fix null checking in bin_dn_node_address()

Xiaowei.Hu (1):
      ocfs2: ac->ac_allow_chain_relink=3D0 won't disable group relink


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRM88dAAoJEDjbvchgkmk+ESoP/1QV40RFSha7/dpDRrxIo/lp
S+/zPb1SdVACc6/wDiLUwThhTD1caprmbeXuyL6b2mJQp9tE4+I+hu8viXUhXek/
SOtdimGpwHD/7OF2A/xdiFhOaPDsqW5vDFcXPF8Ol94MuKw93Kv+8JN5YdzzP0Bg
Cz/oDMrk4ZcYHRhuqYOppeQOBUNQtHK1zXF5s5CVwwGYAg3bWwoaZ7fvJpn2Mj+G
cvnIDmxnqY13s6aOkXpFGRMyLJ1o/6MAjtVbcNmKru6xlAaaNCo4xuWL+PHH4KhT
w3yeFztf1IwJ5Vg835xb28FmBtLTn/bp/YUanmQHbVQuZeTdZd1yv1GU1s1+NAnR
Lo3jrCI++GPeDGmJrfNryysoFsvvV3cruQlwYKt9YiXBHXwGX+dZNe4n0AY3pTjZ
rboXe4w8k5rL60uRol82pVfq7GyHOEumU20kL7XK9Yzj8LhTZenkqCD1QZRkOknQ
H1PlTW0Ccq6sRtD4gkFemjjTEp7Psvv1Q2yDRLU4TgOG17P7MYBoSM7yuyyA4h7l
mFPILfV0xjIEUiaCu95/Kb7yNGTghMl8x8XRqteRFVGXhflhRHqMUKzvI51XuOem
h9mzinF09KgQO1ZpI5cxhbXT/K5NBLCmQUeZzxUt203fbJf1CR52fV0KCtYPlNBf
clrQjIYxxhqrGRyPyk9Q
=he15
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
