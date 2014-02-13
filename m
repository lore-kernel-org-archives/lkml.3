Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaBMWKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:10:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaBMWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:10:09 -0500
Date: Thu, 13 Feb 2014 14:11:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.30
Message-ID: <20140213221127.GA17470@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.30 kernel.

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

 Documentation/filesystems/proc.txt                 |    4=20
 Documentation/i2c/busses/i2c-i801                  |    1=20
 Makefile                                           |    2=20
 arch/sh/kernel/kgdb.c                              |    1=20
 arch/tile/include/asm/compat.h                     |    1=20
 arch/xtensa/platforms/xtfpga/setup.c               |   12 -
 drivers/acpi/bus.c                                 |    9 +
 drivers/cpufreq/intel_pstate.c                     |   48 +++--
 drivers/eisa/eisa-bus.c                            |   26 +--
 drivers/gpu/drm/cirrus/cirrus_mode.c               |    4=20
 drivers/gpu/drm/i915/i915_dma.c                    |    1=20
 drivers/gpu/drm/i915/i915_gem_stolen.c             |    2=20
 drivers/gpu/drm/i915/i915_reg.h                    |   10 -
 drivers/gpu/drm/i915/intel_dp.c                    |   40 +++-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   12 -
 drivers/gpu/drm/mgag200/mgag200_mode.c             |    4=20
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   33 ----
 drivers/gpu/drm/radeon/atombios_crtc.c             |    5=20
 drivers/gpu/drm/radeon/evergreen.c                 |    4=20
 drivers/gpu/drm/radeon/evergreen_cs.c              |    5=20
 drivers/gpu/drm/radeon/ni.c                        |   16 -
 drivers/gpu/drm/radeon/nid.h                       |    1=20
 drivers/gpu/drm/radeon/r600.c                      |   13 -
 drivers/gpu/drm/radeon/r600_cs.c                   |    5=20
 drivers/gpu/drm/radeon/r600d.h                     |    1=20
 drivers/gpu/drm/radeon/radeon_atombios.c           |    4=20
 drivers/gpu/drm/radeon/radeon_i2c.c                |    3=20
 drivers/gpu/drm/radeon/radeon_pm.c                 |    6=20
 drivers/gpu/drm/radeon/si.c                        |    2=20
 drivers/gpu/drm/radeon/sid.h                       |    2=20
 drivers/i2c/busses/Kconfig                         |    1=20
 drivers/i2c/busses/i2c-i801.c                      |    3=20
 drivers/infiniband/hw/qib/qib_ud.c                 |    9 -
 drivers/iommu/intel-iommu.c                        |    2=20
 drivers/md/Kconfig                                 |    4=20
 drivers/md/Makefile                                |    1=20
 drivers/md/dm-builtin.c                            |   48 +++++
 drivers/md/dm-sysfs.c                              |    5=20
 drivers/md/dm-thin-metadata.c                      |   20 ++
 drivers/md/dm-thin-metadata.h                      |    2=20
 drivers/md/dm-thin.c                               |   31 ++-
 drivers/md/dm.c                                    |   15 -
 drivers/md/dm.h                                    |   17 ++
 drivers/md/persistent-data/dm-space-map-common.c   |    6=20
 drivers/md/persistent-data/dm-space-map-metadata.c |   28 ++-
 drivers/media/dvb-frontends/dib8000.c              |   42 +++--
 drivers/media/dvb-frontends/m88rs2000.c            |  117 ++++++++++----
 drivers/media/dvb-frontends/m88rs2000.h            |    2=20
 drivers/media/dvb-frontends/nxt200x.c              |    2=20
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   28 ---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    9 -
 drivers/media/usb/dvb-usb-v2/anysee.c              |    3=20
 drivers/mfd/lpc_ich.c                              |   17 ++
 drivers/mmc/card/block.c                           |    7=20
 drivers/mmc/host/atmel-mci.c                       |   13 +
 drivers/mtd/nand/mxc_nand.c                        |    1=20
 drivers/rtc/rtc-cmos.c                             |   52 ++++++
 drivers/spi/spi-bcm63xx.c                          |    2=20
 drivers/spi/spi.c                                  |    4=20
 fs/dcookies.c                                      |    2=20
 fs/exofs/ore.c                                     |   37 +++-
 fs/fuse/dev.c                                      |   22 --
 fs/nfs/nfs4client.c                                |   18 +-
 fs/nfs/nfs4proc.c                                  |   38 +++-
 fs/nfs/nfs4xdr.c                                   |   47 +++--
 fs/notify/fanotify/fanotify_user.c                 |    4=20
 fs/read_write.c                                    |   16 -
 fs/splice.c                                        |   18 ++
 include/linux/audit.h                              |    2=20
 include/linux/compat.h                             |   18 +-
 include/linux/pipe_fs_i.h                          |    2=20
 include/linux/vmstat.h                             |    3=20
 include/scsi/osd_ore.h                             |    1=20
 kernel/audit.c                                     |    5=20
 kernel/time/timekeeping.c                          |   33 ++--
 kernel/trace/ftrace.c                              |  171 ++++++++++++++++=
++---
 kernel/trace/trace.c                               |    8=20
 mm/memory-failure.c                                |   21 +-
 mm/oom_kill.c                                      |    2=20
 mm/page-writeback.c                                |   57 +++----
 mm/slub.c                                          |    8=20
 mm/vmscan.c                                        |   49 +-----
 net/core/skbuff.c                                  |   32 ---
 net/sunrpc/clnt.c                                  |    8=20
 security/selinux/ss/policydb.c                     |   14 +
 tools/power/x86/turbostat/Makefile                 |    2=20
 tools/power/x86/turbostat/turbostat.c              |   13 -
 87 files changed, 954 insertions(+), 465 deletions(-)

AKASHI Takahiro (1):
      audit: correct a type mismatch in audit_syscall_exit()

Akash Goel (1):
      drm/i915: Fix the offset issue for the stolen GEM objects

Alex Deucher (6):
      drm/radeon: warn users when hw_i2c is enabled (v2)
      drm/radeon: disable ss on DP for DCE3.x
      drm/radeon: fix surface sync in fence on cayman (v2)
      drm/radeon: set the full cache bit for fences on r7xx+
      drm/radeon: fix DAC interrupt handling on DCE5+
      drm/radeon/DCE4+: clear bios scratch dpms bit (v2)

Alex Williamson (1):
      intel-iommu: fix off-by-one in pagetable freeing

Antti Palosaari (1):
      media: anysee: fix non-working E30 Combo Plus DVB-T

Bjorn Helgaas (1):
      Revert "EISA: Initialize device before its resources"

Boaz Harrosh (2):
      ore: Fix wrong math in allocation of per device BIO
      pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done

Borislav Petkov (1):
      rtc-cmos: Add an alarm disable quirk

Brennan Shacklett (1):
      intel_pstate: Improve accuracy by not truncating until final result

Chris Wilson (1):
      drm/i915: Flush outstanding requests before allocating new seqno

Daniel Santos (1):
      spidev: fix hang when transfer_one_message fails

Dave Airlie (1):
      drm/mgag200: fix typo causing bw limits to be ignored on some chips

David Rientjes (1):
      mm, oom: base root bonus on current usage

Dirk Brandewie (1):
      intel_pstate: Correct calculation of min pstate value

Greg Kroah-Hartman (1):
      Linux 3.10.30

Heiko Carstens (4):
      compat: fix sys_fanotify_mark
      fs/compat: fix parameter handling for compat readv/writev syscalls
      fs/compat: fix lookup_dcookie() parameter handling
      tile: remove compat_sys_lookup_dcookie declaration to fix compile err=
or

Ira Weiny (1):
      IB/qib: Fix QP check when looping back to/from QP1

James Ralston (1):
      mfd: lpc_ich: Add support for Intel Avoton SoC

Joe Thornber (4):
      dm thin: fix discard support to a previously shared block
      dm space map common: make sure new space is used during extend
      dm space map metadata: fix extending the space map
      dm space map metadata: fix bug in resizing of thin metadata

Johannes Weiner (2):
      mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirty=
able memory
      mm/page-writeback.c: do not count anon pages as dirtyable memory

John Stultz (4):
      timekeeping: Fix lost updates to tai adjustment
      timekeeping: Fix CLOCK_TAI timer/nanosleep delays
      timekeeping: Fix missing timekeeping_update in suspend path
      timekeeping: Avoid possible deadlock from clock_was_set_delayed

Jonas Gorski (1):
      spi/bcm63xx: don't substract prepend length from total length

Josh Triplett (2):
      turbostat: Don't put unprocessed uapi headers in the include path
      turbostat: Use GCC's CPUID functions to support PIC

Li Zefan (1):
      slub: Fix calculation of cpu slabs

Ludovic Desroches (1):
      mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

Maarten Lankhorst (1):
      drm/nouveau: fix m2mf copy to tiled gart

Malcolm Priestley (2):
      m88rs2000: add m88rs2000_set_carrieroffset
      m88rs2000: set symbol rate accurately

Marek Ol=C5=A1=C3=A1k (1):
      drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to =
INVALID

Marek Szyprowski (1):
      media: s5p_mfc: remove s5p_mfc_get_node_type() function

Mark Brown (1):
      ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to r=
egulator API

Mauro Carvalho Chehab (2):
      dib8000: make 32 bits read atomic
      nxt200x: increase write buffer size

Max Filippov (1):
      xtensa: xtfpga: fix definitions of platform devices

Michael Grzeschik (1):
      mtd: mxc_nand: remove duplicated ecc_stats counting

Michel D=C3=A4nzer (1):
      radeon/pm: Guard access to rdev->pm.power_state array

Mike Snitzer (1):
      dm thin: initialize dm_thin_new_mapping returned by get_next_mapping

Miklos Szeredi (1):
      fuse: fix pipe_buf_operations

Mikulas Patocka (2):
      dm: wait until embedded kobject is released before destroying a device
      dm sysfs: fix a module unload race

Naoya Horiguchi (1):
      mm/memory-failure.c: shift page lock from head page to tail page afte=
r thp split

Nell Hardcastle (1):
      intel_pstate: Add Haswell CPU models

Olivier Grenie (1):
      dib8000: fix regression with dib807x

Ray Jui (1):
      mmc: fix host release issue after discard operation

Richard Guy Briggs (1):
      audit: reset audit backlog wait time after error recovery

Seth Heasley (2):
      mfd: lpc_ich: iTCO_wdt patch for Intel Coleto Creek DeviceIDs
      i2c: i801: SMBus patch for Intel Coleto Creek DeviceIDs

Srinivas Pandruvada (1):
      intel_pstate: fix no_turbo

Stanislaw Gruszka (1):
      i915: remove pm_qos request on error

Steven Rostedt (3):
      ftrace: Synchronize setting function_trace_op with ftrace_trace_funct=
ion
      ftrace: Fix synchronization location disabling and freeing ftrace_ops
      ftrace: Have function graph only trace based on global_ops filters

Steven Rostedt (Red Hat) (2):
      tracing: Have trace buffer point back to trace_array
      tracing: Check if tracing is enabled in trace_puts()

Takashi Iwai (1):
      drm/cirrus: correct register values for 16bpp

Tetsuo Handa (1):
      SELinux: Fix memory leak upon loading policy

Todd Previte (1):
      drm/i915: VLV2 - Fix hotplug detect bits

Trond Myklebust (2):
      NFSv4: OPEN must handle the NFS4ERR_IO return code correctly
      NFSv4.1: Handle errors correctly in nfs41_walk_client_list

Wanlong Gao (1):
      arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>

Weston Andros Adamson (3):
      nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME
      nfs4: fix discover_server_trunking use after free
      sunrpc: Fix infinite loop in RPC state machine


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/UMPAAoJEDjbvchgkmk+oQ8QANVJnDAFLVDrCfl/uITuZRjD
BphJMngapTpPWVnmlxMa3uYAA9mIaktKBm3bVRV40h5RCMMknmybJimemuKvtFDw
md2/yQb7EKuY1xO4vMDBs5nkTx4qayQrQFZS8tviRZeVgwjxmTUizjxEas/HnJf0
ikWUQrRsjFdFDEFkxG3J5jAII526FV8m5/wGKqRImngYxtUJhoNh5g7dbpbQKvb3
LHdF7LZKdFaySwdyf8u2qqkSR+xKvWFlTcC1hFyzNfwf8a8B/xDLdQtk5MlnYAHg
1ZEp1Y45oA9Ib4h+rXYY0tm8k3tn4luU0amvHsoHNG/4Awp1UTe863BGVeJ2uyts
YqTBEvIb0dmMOaFupdoapDzDmct/VT9BII3cd4/NQExf+9v7sNNxSs7hzHLlFxYw
XatDu6VqYZ1xgrss/auu9v+S/tZ76D39miNKvi9ZfTlt9W+aGgOAL0VNZhVkUKQD
nTQ5Yw+ukwro1FPPLGHOf89QjN2Q9NyFsLFypOpPTI0UqNvCe+EtresJvAUg566h
q0wFYrWvkdG75eaDJhUSDu402OHh5QKoOjSajpeRGIDVjpHCHwHQ0lVD8heHsTJa
vjDBHXvNS9JrQiDSQ1o26I5CEoGOKXBsygy8KlwfjWsyHeSD9RSkQd/6IsdeHINr
/nz2IK6/yWIFlvCqcRDc
=WmCu
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
