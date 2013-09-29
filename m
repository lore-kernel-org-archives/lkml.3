Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3I2T6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:58:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab3I2T1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/49] 3.10.14-stable review
Date: Sun, 29 Sep 2013 12:26:34 -0700
Message-Id: <20130929191603.008825488@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.14 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Oct  1 19:15:49 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.14-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.14-rc1

Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
    netfilter: ipset: Fix serious failure in CIDR tracking

J. Bruce Fields <bfields@redhat.com>
    rpc: let xdr layer allocate gssproxy receieve pages

J. Bruce Fields <bfields@redhat.com>
    rpc: fix huge kmalloc's in gss-proxy

J. Bruce Fields <bfields@redhat.com>
    rpc: comment on linux_cred encoding, treat all as unsigned

J. Bruce Fields <bfields@redhat.com>
    rpc: clean up decoding of gssproxy linux creds

Anatol Pomozov <anatol.pomozov@gmail.com>
    cfq: explicitly use 64bit divide operation for 64bit arguments

Bjorn Helgaas <bhelgaas@google.com>
    bio-integrity: Fix use of bs->bio_integrity_pool after free

Andi Kleen <ak@linux.intel.com>
    perf tools: Handle JITed code in shared memory

Khalid Aziz <khalid.aziz@oracle.com>
    mm: fix aio performance regression for database caused by THP

Konstantin Khlebnikov <khlebnikov@openvz.org>
    audit: fix endless wait in audit_log_start()

Jan Kara <jack@suse.cz>
    udf: Refuse RW mount of the filesystem instead of making it RO

Jan Kara <jack@suse.cz>
    udf: Standardize return values in mount sequence

Mauro Carvalho Chehab <mchehab@redhat.com>
    Properly handle tristate dependencies on USB/PCI menus

Randy Dunlap <rdunlap@infradead.org>
    media: media/usb: fix kconfig dependencies

Christian König <christian.koenig@amd.com>
    drm/radeon: avoid UVD corruptions on AGP cards

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix panel scaling with eDP and LVDS bridges

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (v2)

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800: change initialization sequence to fix system freeze

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix handling of variable sized arrays for router objects

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix resume on some rs4xx boards (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: update line buffer allocation for dce6

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: update line buffer allocation for dce4.1/5

Tom Stellard <thomas.stellard@amd.com>
    drm/radeon/si: Add support for CP DMA to CS checker for compute v2

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix endian bugs in hw i2c atom routines

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix LCD record parsing

Emil Velikov <emil.l.velikov@gmail.com>
    drm/nv50/disp: prevent false output detection on the original nv50

Ben Skeggs <bskeggs@redhat.com>
    drm/ttm: fix the tt_populated check in ttm_tt_destroy()

Dave Airlie <airlied@redhat.com>
    drm/ast: fix the ast open key function

David Herrmann <dh.herrmann@gmail.com>
    drm: fix DRM_IOCTL_MODE_GETFB handle-leak

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fix wait_for_pending_flips vs gpu hang deadlock

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fix gpu hang vs. flip stall deadlocks

Alan Stern <stern@rowland.harvard.edu>
    usb: gadget: fix a bug and a WARN_ON in dummy-hcd

Kees Cook <keescook@chromium.org>
    HID: logitech-dj: validate output report details

Kees Cook <keescook@chromium.org>
    HID: lenovo-tpkbd: validate output report details

Kees Cook <keescook@chromium.org>
    HID: steelseries: validate output report details

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: lenovo-tpkbd: fix leak if tpkbd_probe_tp fails

Kees Cook <keescook@chromium.org>
    HID: zeroplus: validate output report details

Kees Cook <keescook@chromium.org>
    HID: LG: validate HID output report details

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: multitouch: validate indexes details

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: validate feature and input report details

Kees Cook <keescook@chromium.org>
    HID: provide a helper for validating hid reports

Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
    sched/fair: Fix small race where child->se.parent,cfs_rq might point to invalid ones

Stanislaw Gruszka <sgruszka@redhat.com>
    sched/cputime: Do not scale when utime == 0

John Stultz <john.stultz@linaro.org>
    timekeeping: Fix HRTICK related deadlock from ntp lock changes

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800: fix wrong TX power compensation

Rafał Miłecki <zajec5@gmail.com>
    bgmac: fix internal switch initialization

Miklos Szeredi <mszeredi@suse.cz>
    cifs: fix filp leak in cifs_atomic_open()

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: cdc_ether: Use wwan interface for Telit modules

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup


-------------

Diffstat:

 Makefile                                           |   4 +-
 block/cfq-iosched.c                                |   2 +-
 drivers/gpu/drm/ast/ast_drv.h                      |   2 +-
 drivers/gpu/drm/drm_crtc.c                         |  18 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  76 ++++-
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |  15 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |   6 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   8 +-
 drivers/gpu/drm/radeon/atombios_i2c.c              |   4 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  25 +-
 drivers/gpu/drm/radeon/evergreend.h                |   4 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |  13 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  34 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   8 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   3 +
 drivers/gpu/drm/radeon/rs400.c                     |   9 +-
 drivers/gpu/drm/radeon/si.c                        | 129 +++++---
 drivers/gpu/drm/radeon/sid.h                       |   4 +
 drivers/gpu/drm/ttm/ttm_tt.c                       |   2 +-
 drivers/hid/hid-core.c                             |  74 ++++-
 drivers/hid/hid-input.c                            |  11 +-
 drivers/hid/hid-lenovo-tpkbd.c                     |  25 +-
 drivers/hid/hid-lg2ff.c                            |  19 +-
 drivers/hid/hid-lg3ff.c                            |  29 +-
 drivers/hid/hid-lg4ff.c                            |  20 +-
 drivers/hid/hid-lgff.c                             |  17 +-
 drivers/hid/hid-logitech-dj.c                      |  10 +-
 drivers/hid/hid-multitouch.c                       |  26 +-
 drivers/hid/hid-steelseries.c                      |   5 +
 drivers/hid/hid-zpff.c                             |  18 +-
 drivers/media/pci/Kconfig                          |   4 +-
 drivers/media/usb/Kconfig                          |   4 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   2 +-
 drivers/net/ethernet/broadcom/bgmac.h              |   2 +-
 drivers/net/usb/cdc_ether.c                        |   5 +
 drivers/net/wireless/rt2x00/rt2800lib.c            |  22 +-
 drivers/pci/pci-acpi.c                             |   6 +-
 drivers/usb/gadget/dummy_hcd.c                     |   7 +-
 fs/bio-integrity.c                                 |   2 +-
 fs/cifs/dir.c                                      |   1 +
 fs/udf/super.c                                     | 342 +++++++++++++--------
 include/linux/hid.h                                |   4 +
 include/linux/timex.h                              |   1 +
 include/uapi/drm/radeon_drm.h                      |   2 +
 kernel/audit.c                                     |   5 +-
 kernel/sched/cputime.c                             |  19 +-
 kernel/sched/fair.c                                |  14 +-
 kernel/time/ntp.c                                  |   6 +-
 kernel/time/timekeeping.c                          |   2 +
 mm/swap.c                                          |  77 +++--
 net/netfilter/ipset/ip_set_hash_gen.h              |  28 +-
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |  26 ++
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |  41 ++-
 net/sunrpc/auth_gss/gss_rpc_xdr.h                  |   5 +-
 tools/perf/util/map.c                              |   1 +
 55 files changed, 800 insertions(+), 448 deletions(-)


