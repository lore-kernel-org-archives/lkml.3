Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965905Ab3FTTbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:31:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965895Ab3FTTbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:31:01 -0400
Date: Thu, 20 Jun 2013 12:31:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.7
Message-ID: <20130620193100.GA1239@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.9.7 kernel.

All users of the 3.9 kernel series must upgrade.

The updated 3.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.9.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/arm/mach-kirkwood/mpp.c                         |    5=20
 arch/powerpc/include/asm/exception-64s.h             |    2=20
 arch/powerpc/kernel/exceptions-64s.S                 |    2=20
 arch/powerpc/kernel/irq.c                            |    2=20
 arch/powerpc/kernel/process.c                        |    4=20
 arch/powerpc/kernel/traps.c                          |   10 +
 arch/x86/boot/compressed/eboot.c                     |   47 ----
 arch/x86/include/asm/efi.h                           |    7=20
 arch/x86/include/uapi/asm/bootparam.h                |    1=20
 arch/x86/kernel/relocate_kernel_64.S                 |    2=20
 arch/x86/mm/init.c                                   |    6=20
 arch/x86/platform/efi/efi.c                          |  188 ++++++--------=
-----
 drivers/acpi/scan.c                                  |    5=20
 drivers/acpi/video.c                                 |    3=20
 drivers/block/cciss.c                                |   32 +--
 drivers/block/rbd.c                                  |   10 -
 drivers/gpu/drm/gma500/cdv_intel_display.c           |   14 +
 drivers/gpu/drm/gma500/psb_intel_display.c           |   14 +
 drivers/gpu/drm/i915/intel_sdvo.c                    |   10 -
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c   |    4=20
 drivers/gpu/drm/nouveau/core/include/core/class.h    |    2=20
 drivers/gpu/drm/nouveau/nv50_display.c               |    4=20
 drivers/md/raid1.c                                   |   38 ++-
 drivers/md/raid10.c                                  |   29 +-
 drivers/md/raid5.c                                   |    4=20
 drivers/net/ethernet/broadcom/tg3.c                  |   10 +
 drivers/net/wireless/ath/ath9k/Kconfig               |   10 -
 drivers/net/wireless/ath/ath9k/Makefile              |    2=20
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |   10 -
 drivers/net/wireless/ath/ath9k/init.c                |    7=20
 drivers/net/wireless/ath/ath9k/rc.h                  |    2=20
 drivers/net/wireless/b43/main.c                      |    2=20
 drivers/net/wireless/ti/wl12xx/wl12xx.h              |    2=20
 drivers/rtc/rtc-twl.c                                |    1=20
 drivers/usb/chipidea/core.c                          |    3=20
 drivers/usb/serial/f81232.c                          |    8=20
 drivers/usb/serial/pl2303.c                          |   10 -
 drivers/usb/serial/spcp8x5.c                         |   10 -
 fs/ceph/locks.c                                      |   73 ++++---
 fs/ceph/mds_client.c                                 |   90 ++++-----
 fs/ceph/super.h                                      |    9=20
 fs/proc/kmsg.c                                       |   10 -
 include/linux/ceph/auth.h                            |   18 +
 include/linux/cpu.h                                  |    4=20
 include/linux/swapops.h                              |    3=20
 include/linux/syslog.h                               |    4=20
 include/net/bluetooth/hci_core.h                     |    1=20
 include/net/bluetooth/mgmt.h                         |    1=20
 kernel/audit.c                                       |    2=20
 kernel/cpu.c                                         |   55 ++---
 kernel/printk.c                                      |   91 +++++----
 kernel/sys.c                                         |   29 ++
 mm/hugetlb.c                                         |    2=20
 mm/memcontrol.c                                      |    2=20
 mm/migrate.c                                         |   23 +-
 mm/page_alloc.c                                      |    6=20
 mm/swap_state.c                                      |   18 +
 net/bluetooth/hci_core.c                             |    6=20
 net/bluetooth/l2cap_core.c                           |   70 +++++--
 net/bluetooth/mgmt.c                                 |   21 ++
 net/ceph/auth.c                                      |  117 ++++++++++-
 net/ceph/auth_x.c                                    |   24 ++
 net/ceph/auth_x.h                                    |    1=20
 net/ceph/messenger.c                                 |    3=20
 net/ceph/mon_client.c                                |    7=20
 net/ceph/osd_client.c                                |   29 +-
 67 files changed, 738 insertions(+), 505 deletions(-)

Alex Elder (2):
      libceph: must hold mutex for reset_changed_osds()
      rbd: don't destroy ceph_opts in rbd_add()

Alex Lyakas (1):
      md/raid1: consider WRITE as successful only if at least one non-Fault=
y and non-rebuilding drive completed it.

Alexander Shishkin (1):
      usb: chipidea: fix id change handling

Andrey Vagin (1):
      memcg: don't initialize kmem-cache destroying work for root caches

Ben Skeggs (2):
      drm/nv50/disp: force dac power state during load detect
      drm/nv50/kms: use dac loadval from vbios, where it's available

Benjamin Herrenschmidt (1):
      powerpc: Fix missing/delayed calls to irq_work

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Felix Fietkau (1):
      Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"

Greg Kroah-Hartman (1):
      Linux 3.9.7

H. Peter Anvin (1):
      md/raid1,5,10: Disable WRITE SAME until a recovery strategy is in pla=
ce

Jim Schutt (2):
      ceph: add cpu_to_le32() calls when encoding a reconnect capability
      ceph: ceph_pagelist_append might sleep while atomic

Johan Hedberg (2):
      Bluetooth: Fix missing length checks for L2CAP signalling PDUs
      Bluetooth: Fix mgmt handling of power on failures

Johan Hovold (3):
      USB: pl2303: fix device initialisation at open
      USB: f81232: fix device initialisation at open
      USB: spcp8x5: fix device initialisation at open

Kees Cook (3):
      b43: stop format string leaking into error msgs
      kmsg: honor dmesg_restrict sysctl on /dev/kmsg
      x86: Fix typo in kexec register clearing

Luciano Coelho (1):
      wl12xx: fix minimum required firmware version for wl127x multirole

Matthew Garrett (1):
      Modify UEFI anti-bricking code

Michael Ellerman (1):
      powerpc: Fix stack overflow crash in resume_kernel when ftracing

Naoya Horiguchi (1):
      mm: migration: add migrate_entry_wait_huge()

NeilBrown (1):
      md/raid1,raid10: use freeze_array in place of raise_barrier in variou=
s places.

Nicolas Schichan (1):
      ARM: Kirkwood: handle mv88f6282 cpu in __kirkwood_variant().

Nithin Sujir (1):
      tg3: Wait for boot code to finish after power on

Oleg Nesterov (1):
      audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE

Patrik Jakobsson (2):
      drm/gma500/psb: Unpin framebuffer on crtc disable
      drm/gma500/cdv: Unpin framebuffer on crtc disable

Paul Mackerras (1):
      powerpc: Fix emulation of illegal instructions on PowerNV platform

Rafael Aquini (1):
      swap: avoid read_swap_cache_async() race to deadlock while waiting on=
 discard I/O completion

Rafael J. Wysocki (1):
      ACPI / video: Do not bind to device objects with a scan handler

Robin Holt (1):
      reboot: rigrate shutdown/reboot to boot cpu

Sage Weil (5):
      libceph: clear messenger auth_retry flag when we authenticate
      libceph: fix authorizer invalidation
      libceph: add update_authorizer auth method
      libceph: wrap auth ops in wrapper functions
      libceph: wrap auth methods in a mutex

Srivatsa S. Bhat (1):
      CPU hotplug: provide a generic helper to disable/enable CPU hotplug

Stephen M. Cameron (1):
      cciss: fix broken mutex usage in ioctl

Sujith Manoharan (2):
      ath9k: Disable PowerSave by default
      ath9k: Use minstrel rate control by default

Tomasz Stanislawski (1):
      mm/page_alloc.c: fix watermark check in __zone_watermark_ok()

Tony Lindgren (1):
      drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted w=
ith device tree

Yinghai Lu (1):
      x86: Fix adjust_range_size_mask calling position


--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRw1h0AAoJEDjbvchgkmk+1Z8QAJVMtDyKPdsKjOPiwtwDp7Kt
iGsgdgtjaG7joPtw3uu2asQG7ZNWYWkyH6KnSHmfcBG3Nzf12MyihDeWly4Zcx7X
I0R7CQ4zsYR7YI+ENR2SkM7vSN+SKjMuyKT2pnQLQfNKVSnla63IDpCqxFRLGiaH
7rFI3mRCBFnMgXMUjS4q9pmzbDzSl5yH4dJgrFnemtx2BMZEoMHVH7n+YKEK1FJL
mpgQ7aBU7yE6W1cdx1Cc7xQXzfZJLA2nlUgTOyP2Ghh/Xw9nSJcJIRzEwTiu8XmK
GpbFYDzblR8ovZA2ZyX/eYdneurl03GWFJduL5opvz8hqU9p7MULWqPpRPLCADL/
iTC1+s9b3gxly2cPbdFmYXtGJs6fJDLvAw5/S35JphBm7J/MuqHBQaV7Vpi1RIbt
7/6UgMDgUPlebIp5uf3dwaDgkgCwOfQ9DX3QPEgITCy9UXHf4s32Z5CWtx4lXsLg
+TxLv57U49kkC0/Vrmv5Evw/0XmApVoC2xmf+jpbM8s6aOyeAI2ZyXZJJ739dq5r
i1VRo6IkwXOImkWu8Wfmq97YRqp6CpY9bXEjsZtGfAUbfNeubUZLDJ+Y04tZU902
EfrR85a2Q5TodMhEM0SH5M6Iz4mdisAbWGHBM0trT5PjImaUikJjKdORMD3spCt5
gWwigSjXh3U7QWtMAV1I
=WuS2
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
