Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaBTT3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:29:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaBTT3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:29:53 -0500
Date: Thu, 20 Feb 2014 11:31:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.81
Message-ID: <20140220193119.GA9107@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.81 kernel.

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

 Makefile                                  |    2=20
 drivers/block/virtio_blk.c                |    9 --
 drivers/gpu/drm/i915/i915_dma.c           |   37 ++++++++-
 drivers/infiniband/hw/qib/qib_user_sdma.c |    6 -
 drivers/input/mouse/synaptics.c           |   23 ++++++
 drivers/md/Kconfig                        |    4 +
 drivers/md/Makefile                       |    1=20
 drivers/md/dm-builtin.c                   |   50 +++++++++++++
 drivers/md/dm-sysfs.c                     |    5 -
 drivers/md/dm.c                           |   26 +-----
 drivers/md/dm.h                           |   17 ++++
 drivers/target/target_core_file.c         |   81 +++++++++------------
 drivers/target/target_core_file.h         |    2=20
 fs/buffer.c                               |    6 +
 fs/ext4/ialloc.c                          |    4 -
 fs/nfs/write.c                            |   10 ++
 include/linux/sched.h                     |    1=20
 kernel/power/swap.c                       |   62 ++++++++++------
 kernel/printk.c                           |    1=20
 kernel/sched/core.c                       |   86 +++++++++++++++++++----
 kernel/sched/fair.c                       |    2=20
 kernel/sched/sched.h                      |    2=20
 kernel/time/tick-sched.c                  |    1=20
 kernel/trace/ftrace.c                     |  112 ++++++++++++++++++++++++-=
-----
 lib/Makefile                              |    1=20
 lib/vsprintf.c                            |    3=20
 mm/internal.h                             |    2=20
 mm/page-writeback.c                       |    5 -
 mm/page_alloc.c                           |   33 ++++----
 mm/sparse.c                               |    3=20
 security/selinux/ss/services.c            |    4 +
 virt/kvm/irq_comm.c                       |    1=20
 32 files changed, 425 insertions(+), 177 deletions(-)

Andrew Morton (1):
      mm/page_alloc.c: remove pageblock_default_order()

Asias He (1):
      virtio-blk: Use block layer provided spinlock

Avi Kivity (1):
      KVM: Fix buffer overflow in kvm_set_irq()

Bojan Smojver (1):
      PM / Hibernate: Hibernate/thaw fixes/improvements

Dan Rosenberg (1):
      lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq show-all-timers(=
Q)

Daniel Vetter (1):
      drm/i915: kick any firmware framebuffers before claiming the gtt

Greg Kroah-Hartman (1):
      Linux 3.4.81

Jan Kara (1):
      IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()

Jeff Layton (1):
      nfs: tear down caches in nfs_init_writepagecache when allocation fails

KOSAKI Motohiro (2):
      mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of =
spin_lock_irq()
      mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

Mikulas Patocka (1):
      dm sysfs: fix a module unload race

Nicholas Bellinger (2):
      target/file: Use O_DSYNC by default for FILEIO backends
      target/file: Re-enable optional fd_buffered_io=3D1 operation

Paul E. McKenney (1):
      printk: Fix scheduling-while-atomic problem in console_cpu_notify()

Peter Oberparleiter (1):
      x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=3Dy

Peter Zijlstra (2):
      sched/nohz: Fix rq->cpu_load[] calculations
      sched/nohz: Fix rq->cpu_load calculations some more

Seth Forshee (1):
      Input: synaptics - handle out of bounds values from the hardware

Stephen Smalley (1):
      SELinux: Fix kernel BUG on empty security contexts.

Steven Rostedt (3):
      ftrace: Synchronize setting function_trace_op with ftrace_trace_funct=
ion
      ftrace: Fix synchronization location disabling and freeing ftrace_ops
      ftrace: Have function graph only trace based on global_ops filters

Tao Ma (1):
      ext4: protect group inode free counting with group lock

Xishi Qiu (1):
      mm: setup pageblock_order before it's used by sparsemem


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBlgHAAoJEDjbvchgkmk+PSEP/2sFelzLatj/SM72cf38wjOw
mAJIwhiXYeJZaqAB3XeWNKXqZQUs5+ZcW6R+Iv/LG3nEZrBvpA1h+aeA1cS+wFXh
pWhL9xsqkbS+xUDwbt3ESpBSCboTywfqu4xhgfOapGTEyZR8kBGYZkbr1BqxwD/i
J7Q1IHRRBtAOydsBCP+pW8crBhQD466Xgpd5+2IdhWIwZkaCoVFCtCNqOmCWekqe
eROuACx2AQlT/S9HJXfrulow0ZTK3isC/H6ZE6Kv6aUir4VtVhLMC7IsEP1iI/mK
lRWtAtC6tsS8ueJJhYD4ja8Rg+j3RYhXLygiBsThQAcrXjzkr2suxKkXtoBuyeb6
jTW+6yTwJ7QB5ohzY20ib4eIzvefaKI2O746LBPCpbd5QFkZecO7SmGUuSDQ6y8S
4sl5J87NGpnHZiCPDy/zejeTU+Zf6L0hCBmxcyT6Po9sv6z0EV6+yk/nQyQlIsrK
NvUN/2SsgY4tKRQgRzAV8HJug5Gduwr0W/Cmh9WsnLHehMYFW/jsonYCAfycJBFO
L9c8PfT4Pe6SteOOodPXDV751R2w7S68wmuwJCGUj1ZeRI4Kt/LCDpaBBP3+3mZn
Ov/o61Qozx1FaLjYq5P/q+w88+J4rHDlhHhpg/BKgzVS1ntL0QBpqyHUxQ0SruRY
8k403XzO5siItYOABhbn
=OV7X
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
