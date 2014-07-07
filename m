Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaGGCEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 22:04:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaGGCEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 22:04:48 -0400
Date: Sun, 6 Jul 2014 19:09:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.11
Message-ID: <20140707020909.GA11910@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.11 kernel.

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

 Documentation/SubmittingPatches              |   22 ++++
 Makefile                                     |    2=20
 arch/arm/boot/dts/exynos5420.dtsi            |    7 +
 arch/mips/kernel/irq-msc01.c                 |    2=20
 arch/mips/kvm/kvm_mips.c                     |   13 --
 arch/powerpc/include/asm/switch_to.h         |    2=20
 arch/powerpc/include/asm/systbl.h            |    2=20
 arch/powerpc/include/uapi/asm/cputable.h     |    1=20
 arch/powerpc/kernel/cputable.c               |    3=20
 arch/powerpc/kernel/legacy_serial.c          |   15 +--
 arch/powerpc/kernel/setup-common.c           |   10 +-
 arch/powerpc/kernel/time.c                   |    2=20
 arch/powerpc/lib/sstep.c                     |    2=20
 arch/powerpc/mm/hash_utils_64.c              |   31 ++++--
 arch/powerpc/platforms/pseries/eeh_pseries.c |    1=20
 arch/x86/include/asm/ptrace.h                |   16 +++
 drivers/block/mtip32xx/mtip32xx.c            |  123 +++++++++++++++++++---=
-----
 drivers/infiniband/core/user_mad.c           |   75 +++++++++-------
 drivers/infiniband/hw/ipath/ipath_diag.c     |    4=20
 drivers/infiniband/hw/mlx5/cq.c              |   13 ++
 drivers/infiniband/hw/mlx5/srq.c             |   14 ++-
 drivers/infiniband/hw/mlx5/user.h            |    2=20
 drivers/infiniband/hw/qib/qib_mad.c          |    2=20
 drivers/infiniband/ulp/srp/ib_srp.c          |    6 +
 drivers/input/mouse/elantech.c               |   27 ++++-
 drivers/input/mouse/synaptics.c              |   19 ++--
 drivers/pci/pci.c                            |    2=20
 drivers/pci/quirks.c                         |    1=20
 drivers/target/iscsi/iscsi_target.c          |    2=20
 drivers/target/iscsi/iscsi_target_login.c    |   13 +-
 drivers/target/iscsi/iscsi_target_util.c     |    2=20
 drivers/target/target_core_device.c          |    1=20
 drivers/watchdog/ath79_wdt.c                 |   10 ++
 drivers/watchdog/kempld_wdt.c                |    2=20
 drivers/watchdog/sp805_wdt.c                 |    4=20
 fs/nfs/inode.c                               |   26 +++--
 fs/nfs/nfs4filelayout.c                      |    2=20
 fs/nfs/nfs4state.c                           |    6 -
 fs/nfs/super.c                               |    1=20
 fs/nfs/write.c                               |    4=20
 fs/nfsd/nfs4state.c                          |    2=20
 fs/nfsd/nfs4xdr.c                            |    4=20
 fs/reiserfs/inode.c                          |    8 +
 fs/ubifs/file.c                              |    3=20
 fs/ubifs/shrinker.c                          |    1=20
 fs/xfs/xfs_mount.c                           |   23 +++--
 include/linux/ptrace.h                       |    3=20
 include/trace/syscall.h                      |   15 +++
 kernel/fork.c                                |    2=20
 kernel/trace/trace.c                         |   13 +-
 kernel/watchdog.c                            |    2=20
 lib/lz4/lz4_decompress.c                     |    6 +
 net/netfilter/ipvs/ip_vs_core.c              |   15 ++-
 net/sunrpc/svc_xprt.c                        |    2=20
 scripts/recordmcount.h                       |    4=20
 sound/pci/hda/patch_hdmi.c                   |    2=20
 sound/usb/card.c                             |   13 ++
 sound/usb/endpoint.c                         |   17 +++
 sound/usb/endpoint.h                         |    1=20
 59 files changed, 450 insertions(+), 178 deletions(-)

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

Benjamin Herrenschmidt (2):
      powerpc/serial: Use saner flags when creating legacy ports
      powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support

Benjamin Tissoires (1):
      Input: synaptics - fix resolution for manually provided min/max

Bjorn Helgaas (1):
      PCI: Fix incorrect vgaarb conditional in WARN_ON()

Christoph Hellwig (1):
      nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

Dave Chinner (1):
      xfs: xfs_readsb needs to check for magic numbers

Deng-Cheng Zhu (1):
      MIPS: KVM: Fix memory leak on VCPU

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Don Zickus (1):
      kernel/watchdog.c: remove preemption restrictions when restarting loc=
kup detector

Gabor Juhos (1):
      watchdog: ath79_wdt: avoid spurious restarts on AR934x

Gavin Shan (1):
      powerpc/pseries: Fix overwritten PE state

Greg Kroah-Hartman (2):
      lz4: add overrun checks to lz4_uncompress_unknownoutputsize()
      Linux 3.14.11

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

Jeff Mahoney (1):
      reiserfs: call truncate_setsize under tailpack mutex

Markos Chandras (1):
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Mateusz Guzik (1):
      NFS: populate ->net in mount data when remounting

Michael Ellerman (2):
      powerpc/mm: Check paca psize is up to date for huge mappings
      powerpc/perf: Ensure all EBB register state is cleared on fork()

Michael Neuling (1):
      powerpc: Don't setup CPUs with bad status

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event

Mikulas Patocka (1):
      iscsi-target: fix iscsit_del_np deadlock on unload

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

Pierre Ossman (1):
      ALSA: hda - hdmi: call overridden init on resume

Scott Mayhew (1):
      nfs: Fix cache_validity check in nfs_write_pageuptodate()

Scott Wood (1):
      powerpc: Don't skip ePAPR spin-table CPUs

Seungwon Jeon (1):
      ARM: dts: disable MDMA1 node for exynos5420

Steven Rostedt (Red Hat) (1):
      tracing: Try again for saved cmdline if failed due to locking

Takashi Iwai (1):
      ALSA: usb-audio: Fix races at disconnection and PCM closing

Tejun Heo (1):
      ptrace,x86: force IRET path after a ptrace_stop()

Thomas Jarosch (1):
      PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Trond Myklebust (4):
      SUNRPC: Fix a module reference leak in svc_handle_xprt
      pNFS: Handle allocation errors correctly in filelayout_alloc_layout_h=
dr()
      NFS: Don't declare inode uptodate unless all attributes were checked
      NFS: Use raw_write_seqcount_begin/end int nfs4_reclaim_open_state

Viresh Kumar (1):
      watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()

Yann Droneaud (2):
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_cq
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_srq

gundberg (1):
      watchdog: kempld-wdt: Use the correct value when configuring the pres=
caler with the watchdog

hujianyang (2):
      UBIFS: fix an mmap and fsync race condition
      UBIFS: Remove incorrect assertion in shrink_tnc()


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTugFFAAoJEDjbvchgkmk+qtcQAJDYifvxB8tclkGDAKn/zavN
gcBUYLlBzbgCwiUjuV3HjfXPOWyisguk5PijD9nd1JYyo5ss4V2LHBKFo4GnkmCE
HLrzonZawZcNGRLEy5PNw9racSwk58gD3oV8r/H6IsP3aXGTjiVPHsZ/rdCJ28Oj
bdOA/w4YMAbEBHn1l8aCjka4pUrX1xBv/oMKQ7x1wqkMpeGWneZYwZASBvQbhN67
jN5QlP1Yw83JAP/YZGm2eD0iyx5JgiDwFuc7uiByUVmZNtZ1ZylEYH//zURtKZ65
g0xUJXVpgmsn36Ne5HkZjOo2MAaFocSFPw8YW1g3MfgoUinYSH61qgnefZVkfTyh
6UxvqOhB3rr0xUDUeMU/4R4BZSXF/u2glAaYOSiMii/SwtmQ3nPcJvIoSWh91c7X
eW+GLLIyQfB4p44B2NPA0k8bzAL8PM7UezPS4NtslFr1pGIF++f5Q4pIPINRgo5W
RNvnfIBUQCVJkFcUM2pJC+rCQKLhOGHug8XejfsGWWTERdSCIjXnVSXhgkYf5j/j
RnGKyr1eKg9Ax+XXPjY9FW++wMYWgLEpEEQHbiPZ8lnUv4g3R4Tr9lpIITZ2+TVT
2ApwSAQSTKqeKXcjKuGZ0RKYSyNz0gZq7bNbLdNmuToIhjHQeJZvhed0DvTGQmFf
WltsiZhpd+AQiUHtGjfz
=Kya6
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
