Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab3FRQRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:17:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab3FRQRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:36 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/48] 3.9.7-stable review
Date: Tue, 18 Jun 2013 09:17:26 -0700
Message-Id: <20130618161725.912524266@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 3.9.7 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 20 16:15:42 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.9.7-rc1

Nicolas Schichan <nschichan@freebox.fr>
    ARM: Kirkwood: handle mv88f6282 cpu in __kirkwood_variant().

Nithin Sujir <nsujir@broadcom.com>
    tg3: Wait for boot code to finish after power on

Johan Hovold <jhovold@gmail.com>
    USB: spcp8x5: fix device initialisation at open

Johan Hovold <jhovold@gmail.com>
    USB: f81232: fix device initialisation at open

Johan Hovold <jhovold@gmail.com>
    USB: pl2303: fix device initialisation at open

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    usb: chipidea: fix id change handling

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Fix missing/delayed calls to irq_work

Paul Mackerras <paulus@samba.org>
    powerpc: Fix emulation of illegal instructions on PowerNV platform

Michael Ellerman <michael@ellerman.id.au>
    powerpc: Fix stack overflow crash in resume_kernel when ftracing

Matthew Garrett <matthew.garrett@nebula.com>
    Modify UEFI anti-bricking code

Sage Weil <sage@inktank.com>
    libceph: wrap auth methods in a mutex

Sage Weil <sage@inktank.com>
    libceph: wrap auth ops in wrapper functions

Sage Weil <sage@inktank.com>
    libceph: add update_authorizer auth method

Sage Weil <sage@inktank.com>
    libceph: fix authorizer invalidation

Sage Weil <sage@inktank.com>
    libceph: clear messenger auth_retry flag when we authenticate

Ben Skeggs <bskeggs@redhat.com>
    drm/nv50/kms: use dac loadval from vbios, where it's available

Ben Skeggs <bskeggs@redhat.com>
    drm/nv50/disp: force dac power state during load detect

Kees Cook <keescook@chromium.org>
    x86: Fix typo in kexec register clearing

Yinghai Lu <yinghai@kernel.org>
    x86: Fix adjust_range_size_mask calling position

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: migration: add migrate_entry_wait_huge()

Tomasz Stanislawski <t.stanislaws@samsung.com>
    mm/page_alloc.c: fix watermark check in __zone_watermark_ok()

NeilBrown <neilb@suse.de>
    md/raid1,raid10: use freeze_array in place of raise_barrier in various places.

H. Peter Anvin <hpa@zytor.com>
    md/raid1,5,10: Disable WRITE SAME until a recovery strategy is in place

Alex Lyakas <alex@zadarastorage.com>
    md/raid1: consider WRITE as successful only if at least one non-Faulty and non-rebuilding drive completed it.

Rafael Aquini <aquini@redhat.com>
    swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Luciano Coelho <coelho@ti.com>
    wl12xx: fix minimum required firmware version for wl127x multirole

Andrey Vagin <avagin@openvz.org>
    memcg: don't initialize kmem-cache destroying work for root caches

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    cciss: fix broken mutex usage in ioctl

Kees Cook <keescook@chromium.org>
    kmsg: honor dmesg_restrict sysctl on /dev/kmsg

Robin Holt <holt@sgi.com>
    reboot: rigrate shutdown/reboot to boot cpu

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    CPU hotplug: provide a generic helper to disable/enable CPU hotplug

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Use minstrel rate control by default

Felix Fietkau <nbd@openwrt.org>
    Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Disable PowerSave by default

Ben Hutchings <ben@decadent.org.uk>
    s390/pci: Implement IRQ functions if !PCI

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix mgmt handling of power on failures

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix missing length checks for L2CAP signalling PDUs

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500/cdv: Unpin framebuffer on crtc disable

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500/psb: Unpin framebuffer on crtc disable

Tony Lindgren <tony@atomide.com>
    drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree

Alex Elder <elder@inktank.com>
    rbd: don't destroy ceph_opts in rbd_add()

Jim Schutt <jaschut@sandia.gov>
    ceph: ceph_pagelist_append might sleep while atomic

Jim Schutt <jaschut@sandia.gov>
    ceph: add cpu_to_le32() calls when encoding a reconnect capability

Alex Elder <elder@inktank.com>
    libceph: must hold mutex for reset_changed_osds()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / video: Do not bind to device objects with a scan handler

Kees Cook <keescook@chromium.org>
    b43: stop format string leaking into error msgs

Oleg Nesterov <oleg@redhat.com>
    audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-kirkwood/mpp.c                       |   5 +-
 arch/powerpc/include/asm/exception-64s.h           |   2 +-
 arch/powerpc/kernel/exceptions-64s.S               |   2 +-
 arch/powerpc/kernel/irq.c                          |   2 +-
 arch/powerpc/kernel/process.c                      |   4 +-
 arch/powerpc/kernel/traps.c                        |  10 ++
 arch/s390/kernel/irq.c                             |  64 +++++++
 arch/s390/pci/pci.c                                |  33 ----
 arch/x86/boot/compressed/eboot.c                   |  47 ------
 arch/x86/include/asm/efi.h                         |   7 -
 arch/x86/include/uapi/asm/bootparam.h              |   1 -
 arch/x86/kernel/relocate_kernel_64.S               |   2 +-
 arch/x86/mm/init.c                                 |   6 +-
 arch/x86/platform/efi/efi.c                        | 188 +++++++--------------
 drivers/acpi/scan.c                                |   5 +-
 drivers/acpi/video.c                               |   3 +
 drivers/block/cciss.c                              |  32 ++--
 drivers/block/rbd.c                                |  10 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |  14 ++
 drivers/gpu/drm/gma500/psb_intel_display.c         |  14 ++
 drivers/gpu/drm/i915/intel_sdvo.c                  |  10 +-
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |   4 +
 drivers/gpu/drm/nouveau/core/include/core/class.h  |   2 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |   4 +-
 drivers/md/raid1.c                                 |  38 +++--
 drivers/md/raid10.c                                |  29 ++--
 drivers/md/raid5.c                                 |   4 +-
 drivers/net/ethernet/broadcom/tg3.c                |  10 ++
 drivers/net/wireless/ath/ath9k/Kconfig             |  10 +-
 drivers/net/wireless/ath/ath9k/Makefile            |   2 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  10 +-
 drivers/net/wireless/ath/ath9k/init.c              |   7 +-
 drivers/net/wireless/ath/ath9k/rc.h                |   2 +-
 drivers/net/wireless/b43/main.c                    |   2 +-
 drivers/net/wireless/ti/wl12xx/wl12xx.h            |   2 +-
 drivers/rtc/rtc-twl.c                              |   1 +
 drivers/usb/chipidea/core.c                        |   3 +-
 drivers/usb/serial/f81232.c                        |   8 +-
 drivers/usb/serial/pl2303.c                        |  10 +-
 drivers/usb/serial/spcp8x5.c                       |  10 +-
 fs/ceph/locks.c                                    |  73 +++++---
 fs/ceph/mds_client.c                               |  90 +++++-----
 fs/ceph/super.h                                    |   9 +-
 fs/proc/kmsg.c                                     |  10 +-
 include/linux/ceph/auth.h                          |  18 ++
 include/linux/cpu.h                                |   4 +
 include/linux/swapops.h                            |   3 +
 include/linux/syslog.h                             |   4 +-
 include/net/bluetooth/hci_core.h                   |   1 +
 include/net/bluetooth/mgmt.h                       |   1 +
 kernel/audit.c                                     |   2 +-
 kernel/cpu.c                                       |  55 +++---
 kernel/printk.c                                    |  91 +++++-----
 kernel/sys.c                                       |  29 +++-
 mm/hugetlb.c                                       |   2 +-
 mm/memcontrol.c                                    |   2 -
 mm/migrate.c                                       |  23 ++-
 mm/page_alloc.c                                    |   6 +-
 mm/swap_state.c                                    |  18 +-
 net/bluetooth/hci_core.c                           |   6 +-
 net/bluetooth/l2cap_core.c                         |  70 ++++++--
 net/bluetooth/mgmt.c                               |  21 +++
 net/ceph/auth.c                                    | 117 +++++++++++--
 net/ceph/auth_x.c                                  |  24 ++-
 net/ceph/auth_x.h                                  |   1 +
 net/ceph/messenger.c                               |   3 +-
 net/ceph/mon_client.c                              |   7 +-
 net/ceph/osd_client.c                              |  29 ++--
 69 files changed, 803 insertions(+), 539 deletions(-)


