Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaBMWIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:08:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaBMWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:08:50 -0500
Date: Thu, 13 Feb 2014 14:10:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.80
Message-ID: <20140213221008.GA23260@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.80 kernel.

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

 Makefile                                         |    2=20
 drivers/acpi/bus.c                               |    9 +++
 drivers/gpu/drm/radeon/evergreen_cs.c            |    5 +-
 drivers/gpu/drm/radeon/r600.c                    |   13 +++--
 drivers/gpu/drm/radeon/r600_cs.c                 |    5 +-
 drivers/gpu/drm/radeon/r600d.h                   |    1=20
 drivers/gpu/drm/radeon/radeon_atombios.c         |    4 +
 drivers/gpu/drm/radeon/radeon_i2c.c              |    3 +
 drivers/gpu/drm/radeon/radeon_pm.c               |    6 +-
 drivers/infiniband/hw/qib/qib_ud.c               |    9 +++
 drivers/iommu/intel-iommu.c                      |    2=20
 drivers/md/dm-sysfs.c                            |   10 +++-
 drivers/md/dm.c                                  |   11 ++++
 drivers/md/dm.h                                  |    2=20
 drivers/md/persistent-data/dm-space-map-common.c |    6 ++
 drivers/mmc/host/atmel-mci.c                     |   13 +++++
 drivers/mtd/nand/mxc_nand.c                      |    1=20
 drivers/pci/pci.c                                |   14 +++---
 drivers/rtc/rtc-cmos.c                           |   52 ++++++++++++++++++=
++++-
 drivers/spi/spi.c                                |    4 +
 fs/exofs/ore.c                                   |   37 +++++++++++-----
 fs/hpfs/dir.c                                    |   10 ++--
 fs/nfs/nfs4proc.c                                |    4 -
 fs/nfs/nfs4xdr.c                                 |   47 +++++++++++++-----=
--
 include/linux/audit.h                            |    2=20
 include/linux/sched.h                            |    1=20
 include/scsi/osd_ore.h                           |    1=20
 kernel/sched/core.c                              |    3 -
 kernel/sched/fair.c                              |    7 ++-
 kernel/sched/rt.c                                |   35 ++++++++++++---
 kernel/sched/sched.h                             |    1=20
 kernel/time/timekeeping.c                        |   14 +++---
 mm/slub.c                                        |    8 +++
 net/sunrpc/clnt.c                                |    8 ++-
 security/selinux/ss/policydb.c                   |   14 +++++-
 tools/power/x86/turbostat/turbostat.c            |   11 ++--
 36 files changed, 288 insertions(+), 87 deletions(-)

AKASHI Takahiro (1):
      audit: correct a type mismatch in audit_syscall_exit()

Al Viro (1):
      hpfs: deadlock and race in directory lseek()

Alex Deucher (3):
      drm/radeon: warn users when hw_i2c is enabled (v2)
      drm/radeon: set the full cache bit for fences on r7xx+
      drm/radeon/DCE4+: clear bios scratch dpms bit (v2)

Alex Williamson (1):
      intel-iommu: fix off-by-one in pagetable freeing

Boaz Harrosh (1):
      ore: Fix wrong math in allocation of per device BIO

Borislav Petkov (1):
      rtc-cmos: Add an alarm disable quirk

Colin Cross (2):
      sched/rt: Fix SCHED_RR across cgroups
      3.4.y: timekeeping: fix 32-bit overflow in get_monotonic_boottime

Daniel Santos (1):
      spidev: fix hang when transfer_one_message fails

Greg Kroah-Hartman (1):
      Linux 3.4.80

Ira Weiny (1):
      IB/qib: Fix QP check when looping back to/from QP1

Joe Thornber (1):
      dm space map common: make sure new space is used during extend

John Stultz (1):
      timekeeping: Avoid possible deadlock from clock_was_set_delayed

Josh Triplett (1):
      turbostat: Use GCC's CPUID functions to support PIC

Li Zefan (1):
      slub: Fix calculation of cpu slabs

Ludovic Desroches (1):
      mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

Marek Ol=C5=A1=C3=A1k (1):
      drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to =
INVALID

Mark Brown (1):
      ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to r=
egulator API

Michael Grzeschik (1):
      mtd: mxc_nand: remove duplicated ecc_stats counting

Michel D=C3=A4nzer (1):
      radeon/pm: Guard access to rdev->pm.power_state array

Mike Galbraith (1):
      sched,rt: fix isolated CPUs leaving root_task_group indefinitely thro=
ttled

Mikulas Patocka (1):
      dm: wait until embedded kobject is released before destroying a device

Peter Boonstoppel (1):
      sched: Unthrottle rt runqueues in __disable_runtime()

Tetsuo Handa (1):
      SELinux: Fix memory leak upon loading policy

Trond Myklebust (1):
      NFSv4: OPEN must handle the NFS4ERR_IO return code correctly

Weston Andros Adamson (2):
      nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME
      sunrpc: Fix infinite loop in RPC state machine

Yijing Wang (1):
      PCI: Enable ARI if dev and upstream bridge support it; disable otherw=
ise

Ying Xue (1):
      sched/rt: Avoid updating RT entry timeout twice within one tick period


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/ULAAAoJEDjbvchgkmk+yccP/1hSz/aCXE4X9aSWmB6x38bP
BFfGdjqui0eBFAGr1LpI/H5QUKQUXKvECDY8vYl54Ea4OregbDRMFIlzOKml3KQS
Tn6GFD5cj5IgrpUsdBHawe2kkWLKd4WTRAR6wNow1558y9Vqjsc6IIXqIB9m/BTa
DIzIaZrwuaeVDtPDAnNNHjOn1BHXA3SeuKksiVxw1+tNBSctBVRYG9YSNjSNgl1I
OqO5XCeC9l6RuDepvb3UnYzCpR2hrNwBUH0dtXLHdB9IwDc9nbDZlD5C4ibJzeDf
zOloRRfx1/DlI5rnBVO9njmFcZYPyzSAs+egXiqTIa5yySmBCpeVpn9AeW0Gn+5a
ppzkfWJwDXPy3W28uUdIYpkb85vqD9CHpzHz8XUuALhD8HPTjwSld+aQ4XUF1z7l
OGuTyJrKaF285NumhDW02le1arVqgruJitJt8zy5KLDOLCeaOR2wgpz4TS01aDN0
JGs3KQ4koC7wKxx/EFUlLcp1b2OyaABpDuhxsODlrNYa95wwEmq8UgnSsuI/1+3f
GvRt2xGn5rW4TewLi3vlpEY3zKeA3jKGFh0tSTMzzTP74tQPDliqkclJZ+bMCwZ4
A+yZxfj0UYXvNdXjNlDafMeZjOwOULWT9UddliZ+SJOISCkHvcsZlMwq6WAasyNX
9k4tWCCK+SW2SIbb4sJ6
=GZdb
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
