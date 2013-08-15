Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294Ab3HOGIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:08:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab3HOGIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:08:41 -0400
Date: Wed, 14 Aug 2013 23:10:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.7
Message-ID: <20130815061014.GA16711@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.7 kernel.

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

 Makefile                                  |    2=20
 arch/mips/Kconfig                         |    2=20
 arch/mips/include/asm/io.h                |    5 +
 arch/powerpc/Kconfig                      |    2=20
 arch/powerpc/include/asm/processor.h      |    4=20
 arch/powerpc/include/asm/reg.h            |   31 ++++---
 arch/powerpc/include/asm/switch_to.h      |    9 ++
 arch/powerpc/kernel/asm-offsets.c         |    3=20
 arch/powerpc/kernel/entry_64.S            |   36 ++++++--
 arch/powerpc/kernel/exceptions-64s.S      |    5 -
 arch/powerpc/kernel/process.c             |   10 ++
 arch/powerpc/kernel/tm.S                  |   20 ++++
 arch/powerpc/kernel/traps.c               |   58 +++++++------
 drivers/acpi/proc.c                       |    8 +
 drivers/base/regmap/regcache.c            |    3=20
 drivers/char/virtio_console.c             |   70 +++++++++++-----
 drivers/cpufreq/cpufreq_conservative.c    |   20 ++--
 drivers/cpufreq/cpufreq_governor.c        |    8 -
 drivers/cpufreq/cpufreq_governor.h        |    4=20
 drivers/cpufreq/cpufreq_ondemand.c        |   20 ++--
 drivers/cpufreq/loongson2_cpufreq.c       |   11 +-
 drivers/gpu/drm/ast/ast_ttm.c             |    1=20
 drivers/gpu/drm/cirrus/cirrus_ttm.c       |    1=20
 drivers/gpu/drm/drm_irq.c                 |    5 -
 drivers/gpu/drm/i915/i915_dma.c           |    1=20
 drivers/gpu/drm/i915/intel_pm.c           |    2=20
 drivers/gpu/drm/mgag200/mgag200_ttm.c     |    1=20
 drivers/gpu/drm/radeon/evergreen.c        |    6 -
 drivers/gpu/drm/radeon/ni.c               |    6 -
 drivers/gpu/drm/radeon/r600.c             |   31 +++++--
 drivers/gpu/drm/radeon/r600_hdmi.c        |   12 ++
 drivers/gpu/drm/radeon/radeon.h           |    2=20
 drivers/gpu/drm/radeon/radeon_asic.h      |    2=20
 drivers/gpu/drm/radeon/radeon_fence.c     |    2=20
 drivers/gpu/drm/radeon/radeon_uvd.c       |   50 ++++++++---
 drivers/gpu/drm/radeon/rv770.c            |    7 +
 drivers/gpu/drm/radeon/si.c               |    9 +-
 drivers/hwmon/adt7470.c                   |    2=20
 drivers/i2c/busses/i2c-mxs.c              |    2=20
 drivers/media/usb/em28xx/em28xx-i2c.c     |    2=20
 drivers/mtd/nand/Kconfig                  |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c |   20 +++-
 drivers/scsi/nsp32.c                      |    2=20
 drivers/scsi/scsi.c                       |    3=20
 drivers/scsi/virtio_scsi.c                |    2=20
 drivers/staging/zcache/zcache-main.c      |    6 -
 drivers/staging/zram/zram_drv.c           |    2=20
 drivers/usb/core/hub.c                    |    5 -
 fs/btrfs/tree-log.c                       |    5 -
 fs/cifs/cifsencrypt.c                     |    2=20
 fs/cifs/cifsglob.h                        |    1=20
 fs/cifs/connect.c                         |    7 -
 fs/cifs/readdir.c                         |    8 +
 fs/cifs/sess.c                            |    6 -
 fs/debugfs/inode.c                        |   69 +++++-----------
 fs/ext4/extents.c                         |    2=20
 fs/ext4/ialloc.c                          |   10 +-
 fs/ext4/ioctl.c                           |    6 -
 fs/ext4/super.c                           |   20 ++++
 fs/lockd/clntlock.c                       |   13 ++-
 fs/lockd/clntproc.c                       |    5 -
 fs/reiserfs/procfs.c                      |   99 ++++-------------------
 fs/reiserfs/super.c                       |    3=20
 include/linux/ftrace_event.h              |   10 +-
 include/linux/regmap.h                    |    1=20
 include/linux/sunrpc/sched.h              |    1=20
 kernel/trace/trace.c                      |  128 +++++++++++++++++++------=
-----
 kernel/trace/trace_irqsoff.c              |    4=20
 net/sunrpc/clnt.c                         |    4=20
 net/sunrpc/netns.h                        |    1=20
 net/sunrpc/rpcb_clnt.c                    |   48 ++++++++---
 sound/usb/6fire/comm.c                    |   38 +++++++-
 sound/usb/6fire/comm.h                    |    2=20
 sound/usb/endpoint.c                      |   13 +--
 74 files changed, 633 insertions(+), 390 deletions(-)

Aaro Koskinen (1):
      cpufreq: loongson2: fix regression related to clock management

Al Viro (1):
      reiserfs: fix deadlock in umount

Alban Browaeys (1):
      media: em28xx: fix assignment of the eeprom data

Alex Deucher (2):
      drm/radeon: select audio dto based on encoder id for DCE3
      drm/radeon: always program the MC on startup

Alexander Z Lam (2):
      tracing: Make TRACE_ITER_STOP_ON_FREE stop the correct buffer
      tracing: Fix reset of time stamps during trace_clock changes

Amit Shah (5):
      virtio: console: fix race with port unplug and open/close
      virtio: console: fix race in port_fops_open() and port unplug
      virtio: console: clean up port data immediately at time of unplug
      virtio: console: fix raising SIGIO after port unplug
      virtio: console: return -ENODEV on all read operations after unplug

Andrew Vagin (1):
      tracing: Fix fields of struct trace_iterator that are zeroed by mista=
ke

Anton Blanchard (1):
      powerpc: On POWERNV enable PPC_DENORMALISATION by default

Arnd Bergmann (2):
      SCSI: nsp32: use mdelay instead of large udelay constants
      mtd: omap2: allow bulding as a module

Asias He (1):
      virtio-scsi: Fix virtqueue affinity setup

Chen Gang (1):
      cifs: extend the buffer length enought for sprintf() using

Christian K=F6nig (3):
      drm/radeon: stop sending invalid UVD destroy msg
      drm/radeon: fix halting UVD
      drm/radeon: only save UVD bo when we have open handles

Clemens Ladisch (1):
      ALSA: usb-audio: do not trust too-big wMaxPacketSize values

Curt Brune (1):
      hwmon: (adt7470) Fix incorrect return code check

Dave Airlie (1):
      drm/ast: invalidate page tables when pinning a BO

Egbert Eich (1):
      drm/mgag200: Invalidate page tables when pinning a BO

Eric Sandeen (1):
      ext4: destroy ext4_es_cachep on module unload

Fabio Estevam (1):
      i2c: i2c-mxs: Use DMA mode even for small transfers

Greg Kroah-Hartman (1):
      Linux 3.10.7

Jani Nikula (1):
      drm/i915: initialize gt_lock early with other spin locks

Jeff Layton (1):
      cifs: don't instantiate new dentries in readdir for inodes that need =
to be revalidated immediately

Josef Bacik (1):
      Btrfs: release both paths before logging dir/changed extents

Julius Werner (1):
      usb: core: don't try to reset_device() a port that got just disconnec=
ted

Jussi Kivilinna (1):
      ALSA: 6fire: fix DMA issues with URB transfer_buffer usage

Lars-Peter Clausen (1):
      regmap: cache: Make sure to sync the last register in a block

Markos Chandras (1):
      MIPS: Expose missing pci_io{map,unmap} declarations

Martin K. Petersen (1):
      SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_page=
s is set

Mateusz Krawczuk (1):
      regmap: Add missing header for !CONFIG_REGMAP stubs

Michael Neuling (5):
      powerpc: Fix hypervisor facility unavaliable vector number
      powerpc: Rework setting up H/FSCR bit definitions
      powerpc: Fix context switch DSCR on POWER8
      powerpc: Save the TAR register earlier
      powerpc/tm: Fix context switching TAR, PPR and DSCR SPRs

Michal Srb (1):
      drm/cirrus: Invalidate page tables when pinning a BO

Michel D=E4nzer (1):
      drm: Don't pass negative delta to ktime_sub_ns()

Oleg Nesterov (1):
      debugfs: debugfs_remove_recursive() must not rely on list_empty(d_sub=
dirs)

Piotr Sarna (2):
      staging: zcache: fix "zcache=3D" kernel parameter
      ext4: fix mount/remount error messages for incompatible mount options

Rafael J. Wysocki (1):
      ACPI / PM: Walk physical_node_list under physical_node_lock

Sergey Senozhatsky (1):
      zram: allow request end to coincide with disksize

Steven Rostedt (Red Hat) (1):
      tracing: Use flag buffer_disabled for irqsoff tracer

Sumit.Saxena@lsi.com (1):
      SCSI: megaraid_sas: megaraid_sas driver init fails in kdump kernel

Theodore Ts'o (4):
      ext4: make sure group number is bumped after a inode allocation race
      ext4: fix retry handling in ext4_ext_truncate()
      ext4: allow the mount options nodelalloc and data=3Djournal
      ext4: flush the extent status cache during EXT4_IOC_SWAP_BOOT

Trond Myklebust (3):
      LOCKD: Don't call utsname()->nodename from nlmclnt_setlockargs
      SUNRPC: Don't auto-disconnect from the local rpcbind socket
      SUNRPC: If the rpcbind channel is disconnected, fail the call to unre=
gister

Viresh Kumar (1):
      cpufreq: rename ignore_nice as ignore_nice_load

Yoshihiro YUNOMAE (2):
      virtio/console: Quit from splice_write if pipe->nrbufs is 0
      virtio/console: Add pipe_lock/unlock for splice_write


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDHDGAAoJEDjbvchgkmk+OTkP/itRxVspX4Ii3l+s/aomXFVG
gJEmISnh8nFgOYhVfvL1xkGZi5iKf3GM3zeiqGUtHmjvzU+AJwhgkrCK+L5TwHNb
2SkWuSocJ+IrinqVru5tdOzVfa/ldaM7rcQE4jdYcRDQJSu40QyiKjoJ0oOSAecv
r4s9cspSCnmDwcgMhrMmL/M72xMgZl1Q0eQVqhgLHavF/rk6WaQ/1C5apRQKtsyb
m99E41wY8nPzA2Nhn6SYy6k7Tz1J2tDik/ca7QGmjw3LGMIYVolSKUhKuVHzLV4x
B4GbT8MSR8glDpBiBom5h+0rQlMAwoa0c/5SWoBveQFLK75jN40V20zPCoQ0begI
67LQrYa7t+N+8a4WSjbldKRgAMafouBDLbSZHQtFIc6MBmipZnVCpny8bfmK4ulG
T6qTot/iEiKnvCt5LEX7d4NnXLQmjPWerPcEI3NHWhogx1jNMp5bXCsvUIqvpm7F
ihNz/Dtoo2BFkhfZwBt6DibTIb8SmChA6BdGmIZkbRd2J5nEGoQqfsmjPrd3f3Tv
p31LtCKhteuulpknaEp/2CrIqutuDnomHZD2RehdGofg3yvjM571RQFtJD5yVljW
JsvQ94pTHy0TxA7Ue9oLC5482QCSVu2m9+JcxyEMvCi1a3pgRUyX/ekjHEBcs8VW
1x1kAXFCQcG1hosqMmD6
=VinT
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
