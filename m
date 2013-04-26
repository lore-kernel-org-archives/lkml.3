Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3DZE13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 00:27:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46893 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3DZE10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 00:27:26 -0400
Date: Thu, 25 Apr 2013 21:27:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.9
Message-ID: <20130426042722.GA24693@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.9 kernel.

All users of the 3.8 kernel series must upgrade.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/arm/kernel/perf_event.c                         |    5 +
 arch/arm/mach-imx/clk-imx35.c                        |    2=20
 arch/arm/mm/cache-feroceon-l2.c                      |    1=20
 arch/arm/mm/proc-arm920.S                            |    2=20
 arch/arm/mm/proc-arm926.S                            |    2=20
 arch/arm/mm/proc-mohawk.S                            |    2=20
 arch/arm/mm/proc-sa1100.S                            |    2=20
 arch/arm/mm/proc-v6.S                                |    2=20
 arch/arm/mm/proc-xsc3.S                              |    2=20
 arch/arm/mm/proc-xscale.S                            |    2=20
 arch/mips/include/asm/page.h                         |    2=20
 arch/powerpc/kernel/entry_64.S                       |    2=20
 arch/powerpc/kvm/e500mc.c                            |    7 ++
 arch/s390/include/asm/io.h                           |    4 -
 arch/s390/include/asm/pgtable.h                      |    4 +
 arch/x86/include/asm/kvm_host.h                      |    4 -
 arch/x86/kernel/cpu/perf_event_intel.c               |   20 +++++--
 arch/x86/kvm/lapic.c                                 |    2=20
 arch/x86/kvm/x86.c                                   |   51 ++++++++------=
----
 crypto/algif_hash.c                                  |    2=20
 crypto/algif_skcipher.c                              |    1=20
 drivers/char/hpet.c                                  |   14 -----
 drivers/md/raid1.c                                   |    7 ++
 drivers/md/raid10.c                                  |    9 ++-
 drivers/mtd/mtdchar.c                                |   32 -----------
 drivers/net/can/mcp251x.c                            |   10 ++-
 drivers/net/can/sja1000/sja1000_of_platform.c        |   31 +++++------
 drivers/net/ethernet/broadcom/tg3.c                  |   18 ++++++
 drivers/net/ethernet/broadcom/tg3.h                  |    2=20
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h |    2=20
 drivers/net/wireless/ath/ath9k/htc_drv_init.c        |    2=20
 drivers/net/wireless/b43/phy_n.c                     |    3 -
 drivers/ssb/driver_chipcommon_pmu.c                  |   29 ++++++++++
 drivers/video/fbmem.c                                |   39 +++++---------
 fs/binfmt_elf.c                                      |    1=20
 fs/btrfs/tree-log.c                                  |   48 ++++++++++++++=
+--
 fs/hfsplus/extents.c                                 |    2=20
 fs/hugetlbfs/inode.c                                 |    2=20
 fs/proc/array.c                                      |    1=20
 include/linux/kvm_host.h                             |    2=20
 include/linux/kvm_types.h                            |    1=20
 include/linux/mm.h                                   |    2=20
 include/linux/sched.h                                |    5 +
 include/linux/ssb/ssb_driver_chipcommon.h            |    2=20
 include/trace/events/sched.h                         |    2=20
 kernel/events/core.c                                 |    2=20
 kernel/hrtimer.c                                     |    3 -
 kernel/kthread.c                                     |   52 ++++++++++----=
-----
 kernel/sched/core.c                                  |    8 +-
 kernel/signal.c                                      |    2=20
 kernel/user_namespace.c                              |   22 ++++----
 mm/hugetlb.c                                         |   12 ++++
 mm/memory.c                                          |   47 ++++++++++++++=
+++
 net/mac80211/mlme.c                                  |   24 +++++++-
 sound/core/pcm_native.c                              |   12 ----
 virt/kvm/ioapic.c                                    |    7 +-
 virt/kvm/kvm_main.c                                  |   47 +++++++++++++-=
---
 58 files changed, 405 insertions(+), 222 deletions(-)

Andrew Honig (1):
      KVM: Allow cross page reads and writes from cached translations.

Andy Honig (3):
      KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME =
(CVE-2013-1796)
      KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache functio=
ns (CVE-2013-1797)
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-=
1798)

Andy Lutomirski (2):
      userns: Check uid_map's opener's fsuid, not the current fsuid
      userns: Changing any namespace id mappings should require privileges

Christoph Fritz (1):
      can: sja1000: fix handling on dt properties on little endian systems

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

Eric W. Biederman (1):
      userns: Don't let unprivileged users trick privileged users into sett=
ing the id_map

Felix Fietkau (2):
      ath9k_htc: accept 1.x firmware newer than 1.3
      ath9k_hw: change AR9580 initvals to fix a stability issue

Greg Kroah-Hartman (1):
      Linux 3.8.9

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon

Joe Lawrence (1):
      md: raid1,10: Handle REQ_WRITE_SAME flag in write bios

Johannes Berg (1):
      mac80211: fix cfg80211 interaction on auth/assoc request

Josef Bacik (1):
      Btrfs: make sure nbytes are right after log replay

Kevin Hao (1):
      powerpc: add a missing label in resume_kernel

Linus Torvalds (6):
      vm: add vm_iomap_memory() helper function
      vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
      vm: convert fb_mmap to vm_iomap_memory() helper
      vm: convert HPET mmap to vm_iomap_memory() helper
      vm: convert mtdchar mmap to vm_iomap_memory() helper
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h

Marc Kleine-Budde (1):
      can: mcp251x: add missing IRQF_ONESHOT to request_threaded_irq

Markus Pargmann (1):
      ARM: clk-imx35: Bugfix iomux clock

Mathias Krause (1):
      crypto: algif - suppress sending source address information in recvmsg

Matt Carlson (1):
      tg3: Add 57766 device support.

Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP

Naoya Horiguchi (3):
      hugetlbfs: stop setting VM_DONTDUMP in initializing vma(VM_HUGETLB)
      hugetlbfs: add swap entry check in follow_hugetlb_page()
      fs/binfmt_elf.c: fix hugetlb memory check in vma_dump_size()

Rafa=C5=82 Mi=C5=82ecki (1):
      ssb: implement spurious tone avoidance

Ralf Baechle (1):
      Revert "MIPS: page.h: Provide more readable definition for PAGE_MASK."

Russell King (1):
      ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend support=
) properly

Sascha Hauer (1):
      ARM: i.MX35: enable MAX clock

Scott Wood (1):
      kvm/powerpc/e500mc: fix tlb invalidation on cpu migration

Stephane Eranian (1):
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

Thomas Gleixner (1):
      kthread: Prevent unpark race which puts threads on the wrong cpu

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()

Will Deacon (1):
      ARM: 7698/1: perf: fix group validation when using enable_on_exec

libin (1):
      sched/debug: Fix sd->*_idx limit range avoiding overflow


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRegIqAAoJEDjbvchgkmk+y4IQANPIdUr3EiMthp4KnOyl/a1G
xWFczY5T0HKjBGGNh6xAjFY2oSLwkLkDrqvvCg71buPUPV/ESVuzegbRWL2puU9j
wKI5Xk3ilIPBrFOTlMY0sjwjCDZlPV9DhUGY3zwhG56PF2T0Oe47nFMRvM3+06Ww
bAS2XFHm9J7ZF96zqEaQC7ygdgLQPEyjdggvuuowa3pqaQK6+StD4ycpY0PrFJDf
iTRaeeUh3naNXx/feIdVg5T0c8+4BHuIaPSjmsuPsMeia3Xp+mS85pEw+iLjyZOJ
kw6qn+yc1coK4FdKRWaz6QZMolYNyLLW6sqnjHzDGgiNJDeMVG2Hr4U/q7+4PEME
vO+Yw7C9k20263aje8fTdOhDVxVMlfo+lnAJL2vg28YCipSbXNGtMIMDFCMZyeBY
PmD9wrYv8oJ2rxDy+vSUNlajpMMELMT0I5UD40zygZKZFewtqRbeho/spUOoEy1g
8rcWUZksWgMwJGcJMcDIG/2xhfAgN+ikvvdDtrvoWc0lWWoohjXZbvxmhHFEBz+r
jSPS4TBBSQejmvo5DsFUkIvNyk4WigwS/HFDD0iKZfueCx5zJjrAI6wZAXdR3MiB
h7JYMKNzt3GLrjb4ZiMqF/M7CB4ogt4GMhpsST4wnmPkJs+vGV3yH2hCOV616s+6
NpzS2W+oYsghXRAj4/CD
=hcZs
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
