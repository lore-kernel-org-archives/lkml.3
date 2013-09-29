Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3I2Tk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:40:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab3I2T3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/71] 3.11.3-stable review
Date: Sun, 29 Sep 2013 12:27:12 -0700
Message-Id: <20130929192643.539596256@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.11.3 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Oct  1 19:26:27 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.11.3-rc1

Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
    netfilter: ipset: Fix serious failure in CIDR tracking

Solomon Peachy <pizza@shaftnet.org>
    cw1200: Don't perform SPI transfers in interrupt context

Solomon Peachy <pizza@shaftnet.org>
    cw1200: Prevent a lock-related hang in the cw1200_spi driver

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

Khalid Aziz <khalid.aziz@oracle.com>
    mm: fix aio performance regression for database caused by THP

Konstantin Khlebnikov <khlebnikov@openvz.org>
    audit: fix endless wait in audit_log_start()

Jan Kara <jack@suse.cz>
    udf: Refuse RW mount of the filesystem instead of making it RO

Jan Kara <jack@suse.cz>
    udf: Standardize return values in mount sequence

Mikulas Patocka <mpatocka@redhat.com>
    skge: fix broken driver

Christian König <christian.koenig@amd.com>
    drm/radeon: avoid UVD corruptions on AGP cards

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix panel scaling with eDP and LVDS bridges

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm/rs780: don't enable sclk scaling if not required

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: fix fallback for empty UVD clocks

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: handle bapm on trinity

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/r6xx: add a stubbed out set_uvd_clocks callback

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add some additional berlin pci ids

Nithin Sujir <nsujir@broadcom.com>
    tg3: Expand led off fix to include 5720

Nithin Sujir <nsujir@broadcom.com>
    tg3: Don't turn off led on 5719 serdes port 0

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: make sure dc performance level limits are valid (BTC-SI) (v2)

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
    drm/radeon: add berlin pci ids

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/cik: update gpu_init for an additional berlin gpu

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix init ordering for r600+

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: update line buffer allocation for dce8

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fill in gpu_init for berlin GPU cores

Christian König <christian.koenig@amd.com>
    drm/radeon: enable UVD interrupts on CIK

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix endian bugs in hw i2c atom routines

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: add reclocking quirk for ASUS K70AF

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix LCD record parsing

Emil Velikov <emil.l.velikov@gmail.com>
    drm/nv50/disp: prevent false output detection on the original nv50

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    radeon kms: fix uninitialised hotplug work usage in r100_irq_process()

Ben Skeggs <bskeggs@redhat.com>
    drm/ttm: fix the tt_populated check in ttm_tt_destroy()

Dave Airlie <airlied@redhat.com>
    drm/ast: fix the ast open key function

David Herrmann <dh.herrmann@gmail.com>
    drm: fix DRM_IOCTL_MODE_GETFB handle-leak

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't enable the cursor on a disable pipe

Jani Nikula <jani.nikula@intel.com>
    drm/i915: do not update cursor in crtc mode set

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fix wait_for_pending_flips vs gpu hang deadlock

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fix gpu hang vs. flip stall deadlocks

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fix hpd work vs. flush_work in the pageflip code deadlock

Jani Nikula <jani.nikula@intel.com>
    drm/i915: try not to lose backlight CBLV precision

Alan Stern <stern@rowland.harvard.edu>
    usb: gadget: fix a bug and a WARN_ON in dummy-hcd

Kees Cook <keescook@chromium.org>
    HID: logitech-dj: validate output report details

Kees Cook <keescook@chromium.org>
    HID: lenovo-tpkbd: validate output report details

Kees Cook <keescook@chromium.org>
    HID: sony: validate HID output report details

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

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800: change initialization sequence to fix system freeze

Rafał Miłecki <zajec5@gmail.com>
    bgmac: fix internal switch initialization

Miklos Szeredi <mszeredi@suse.cz>
    cifs: fix filp leak in cifs_atomic_open()

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: cdc_ether: Use wwan interface for Telit modules

Tony Lindgren <tony@atomide.com>
    ARM: OMAP4: Fix clock_get error for GPMC during boot

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-omap2/cclock44xx_data.c              |   2 +-
 block/cfq-iosched.c                                |   2 +-
 drivers/gpu/drm/ast/ast_drv.h                      |   2 +-
 drivers/gpu/drm/drm_crtc.c                         |  18 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   7 +
 drivers/gpu/drm/i915/i915_irq.c                    |  85 ++++-
 drivers/gpu/drm/i915/intel_display.c               |  15 +-
 drivers/gpu/drm/i915/intel_opregion.c              |   2 +-
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |  15 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |   6 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   8 +-
 drivers/gpu/drm/radeon/atombios_i2c.c              |   4 +-
 drivers/gpu/drm/radeon/btc_dpm.c                   |   6 +
 drivers/gpu/drm/radeon/cik.c                       |  84 ++++-
 drivers/gpu/drm/radeon/cikd.h                      |   4 +
 drivers/gpu/drm/radeon/evergreen.c                 |  34 +-
 drivers/gpu/drm/radeon/evergreend.h                |   4 +
 drivers/gpu/drm/radeon/ni.c                        |   9 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |   6 +
 drivers/gpu/drm/radeon/ppsmc.h                     |   2 +
 drivers/gpu/drm/radeon/r600.c                      |  14 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   2 +
 drivers/gpu/drm/radeon/radeon_asic.h               |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |  13 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  34 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   8 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |  10 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   3 +
 drivers/gpu/drm/radeon/rs400.c                     |   9 +-
 drivers/gpu/drm/radeon/rs780_dpm.c                 |  13 +-
 drivers/gpu/drm/radeon/rv770.c                     |   9 +-
 drivers/gpu/drm/radeon/rv770_dpm.c                 |  20 +-
 drivers/gpu/drm/radeon/si.c                        | 138 +++++----
 drivers/gpu/drm/radeon/si_dpm.c                    |   6 +
 drivers/gpu/drm/radeon/sid.h                       |   4 +
 drivers/gpu/drm/radeon/trinity_dpm.c               |   2 +
 drivers/gpu/drm/radeon/trinity_dpm.h               |   1 +
 drivers/gpu/drm/radeon/trinity_smc.c               |   8 +
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
 drivers/hid/hid-sony.c                             |   4 +
 drivers/hid/hid-steelseries.c                      |   5 +
 drivers/hid/hid-zpff.c                             |  18 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   2 +-
 drivers/net/ethernet/broadcom/bgmac.h              |   2 +-
 drivers/net/ethernet/broadcom/tg3.c                |  19 +-
 drivers/net/ethernet/marvell/skge.c                |   5 +-
 drivers/net/usb/cdc_ether.c                        |   5 +
 drivers/net/wireless/cw1200/cw1200_spi.c           |  28 +-
 drivers/net/wireless/cw1200/fwio.c                 |   2 +-
 drivers/net/wireless/cw1200/hwbus.h                |   1 +
 drivers/net/wireless/cw1200/hwio.c                 |  15 +
 drivers/net/wireless/rt2x00/rt2800lib.c            |  18 +-
 drivers/pci/pci-acpi.c                             |   6 +-
 drivers/usb/gadget/dummy_hcd.c                     |   7 +-
 fs/bio-integrity.c                                 |   2 +-
 fs/cifs/dir.c                                      |   1 +
 fs/udf/super.c                                     | 342 +++++++++++++--------
 include/drm/drm_pciids.h                           |  21 ++
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
 81 files changed, 1071 insertions(+), 509 deletions(-)


