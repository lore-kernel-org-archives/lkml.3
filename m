Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab3LIIdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:33:11 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54196 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab3LIIdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:33:07 -0500
Date: Mon, 9 Dec 2013 08:33:01 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1312090830370.31658@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1895160980-1386577981=:31658"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1895160980-1386577981=:31658
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

this is probably a bit big, but just because I fell behind last week and 
didn't get to doing any pulls, so stuff backed up behind me, I actually 
should have sent this for -rc3 but failed to even manage that,

So this has radeon, intel, nouveau, vmware, exynos and tegra fixes in it,
and the line count isn't all the bad in the end.

Dave.

The following changes since commit 8ecffd7914484b728799dd31968f1339fae91593:

  Merge tag 'gpio-v3.13-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio (2013-12-04 08:59:33 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 9255ce80f88ba885c38c0bbd235db7c24392e22e:

  Merge branch 'drm-fixes-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2013-12-05 12:18:35 +1000)

----------------------------------------------------------------

Alex Deucher (6):
      drm/radeon: fix typo in fetching mpll params
      drm/radeon: program DCE2 audio dto just like DCE3
      drm/radeon/dpm: simplify state adjust logic for NI
      drm/radeon: fixup bad vram size on SI
      drm/radeon: fix null pointer dereference in dce6+ audio code
      drm/radeon/atom: fix bus probes when hw_i2c is set (v2)

Alexandre Demers (1):
      drm/radeon: Fix a typo in Cayman and Evergreen registers

Ben Skeggs (3):
      drm/nv04-nv30/clk: provide an empty domain list
      drm/nouveau: unreference fence after syncing
      drm/nouveau/sw: fix oops if gpu has its display block disabled

Chris Wilson (3):
      drm/i915: Prefer setting PTE cache age to 3
      drm/i915: Pin relocations for the duration of constructing the execbuffer
      drm/i915: Pin pages whilst allocating for dma-buf vmap()

Christian König (2):
      drm/radeon: add VMID allocation trace point
      drm/radeon: add radeon_vm_bo_update trace point

Dan Carpenter (2):
      drm/tegra: return -EFAULT if copy_from_user() fails
      drm/nv50/disp: min/max are reversed in nv50_crtc_gamma_set()

Dave Airlie (7):
      drm/radeon: fix VGT_GS_INSTANCE_CNT register
      Merge branch 'vmwgfx-fixes-3.13' of git://people.freedesktop.org/~thomash/linux into drm-fixes
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge tag 'drm/for-3.13-rc3' of git://anongit.freedesktop.org/tegra/linux into drm-fixes
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-fixes
      Merge tag 'drm-intel-fixes-2013-12-02' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Guenter Roeck (1):
      drm/radeon/dpm: Convert to use devm_hwmon_register_with_groups

Ilia Mirkin (3):
      drm/nv10/plane: fix format computation
      drm/nv10/plane: add downscaling restrictions
      drm/nv10/plane: some chipsets don't support NV12

Inki Dae (1):
      drm/exynos: release unhandled page flip events at postclose.

Jani Nikula (1):
      drm/i915/ddi: set sink to power down mode on dp disable

Jesse Barnes (2):
      drm/i915: take mode config lock around crtc disable at suspend
      drm/i915: use crtc_htotal in watermark calculations to match fastboot v2

Maarten Lankhorst (1):
      drm/nouveau/kms: send timestamp data for correct head in flip completion events

Olof Johansson (1):
      gpu: host1x: Silence a few warnings with LPAE=y

Paulo Zanoni (1):
      drm/i915: use the correct force_wake function at the PC8 code

Rob Clark (1):
      udl: fix issue with imported prime buffers

Roy Spliet (2):
      drm/nouveau/fifo: Hook up pause and resume for NV50 and NV84+
      drm/nouveau/clk: Add support for NVAA/NVAC

Sachin Kamat (1):
      drm/exynos: Fix trivial typo in exynos_drm_fimd.c

Thierry Reding (6):
      drm/tegra: Make CRTC upcasting safer
      drm/tegra: Tightly bind RGB output to DC
      drm/tegra: Fix address space mismatches
      drm/tegra: Make tegra_drm_driver static
      drm/tegra: Force cast to __iomem to make sparse happy
      gpu: host1x: Fix a few sparse warnings

Thomas Hellstrom (4):
      drm/vmwgfx: Correctly set the enabled state on crtcs
      drm/vmwgfx: Fix up and comment the dumb buffer implementation
      drm/vmwgfx: Fix dma buffer memory size accounting
      drm/vmwgfx: Add our connectors to sysfs

Thomas Wood (2):
      drm/edid: fix length check when adding extra 3D modes
      drm: fix the addition of the side-by-side (half) flag for extra 3D modes

Ville Syrjälä (5):
      drm/i915: Check VBT for eDP ports on VLV
      drm/i915: Simplify DP vs. eDP detection
      drm/i915: Fix pipe CSC post offset calculation
      drm/i915: Make the DERRMR SRM target global GTT
      drm/i915: MI_PREDICATE_RESULT_2 is HSW only

 drivers/gpu/drm/drm_edid.c                         |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |  35 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |   2 +-
 drivers/gpu/drm/i915/i915_drv.c                    |   2 +
 drivers/gpu/drm/i915/i915_gem.c                    |   7 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |  13 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |  60 +--
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   6 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   1 +
 drivers/gpu/drm/i915/intel_ddi.c                   |   5 +-
 drivers/gpu/drm/i915/intel_display.c               |  14 +-
 drivers/gpu/drm/i915/intel_dp.c                    |  34 +-
 drivers/gpu/drm/i915/intel_drv.h                   |   2 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  15 +-
 drivers/gpu/drm/nouveau/Makefile                   |   1 +
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |   4 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c    |   3 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nv84.c    |   3 +
 .../gpu/drm/nouveau/core/engine/software/nv50.c    |   2 +-
 .../gpu/drm/nouveau/core/include/subdev/clock.h    |   4 +
 drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c   |   7 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c   | 445 +++++++++++++++++++++
 drivers/gpu/drm/nouveau/dispnv04/overlay.c         |  42 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   3 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |   2 +-
 drivers/gpu/drm/radeon/atombios_i2c.c              |  15 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |  12 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |  28 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |   8 +-
 drivers/gpu/drm/radeon/radeon.h                    |   8 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |   2 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   4 +-
 drivers/gpu/drm/radeon/radeon_drv.h                |   3 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |  16 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  49 +--
 drivers/gpu/drm/radeon/radeon_trace.h              |  33 ++
 drivers/gpu/drm/radeon/reg_srcs/cayman             |   4 +-
 drivers/gpu/drm/radeon/reg_srcs/evergreen          |   4 +-
 drivers/gpu/drm/radeon/si.c                        |  11 +-
 drivers/gpu/drm/tegra/drm.c                        |  34 +-
 drivers/gpu/drm/tegra/drm.h                        |   2 +-
 drivers/gpu/drm/tegra/fb.c                         |   2 +-
 drivers/gpu/drm/tegra/rgb.c                        |  11 +-
 drivers/gpu/drm/udl/udl_gem.c                      |   6 +
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c             |   2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |   4 +
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           | 118 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |   5 +
 drivers/gpu/host1x/bus.c                           |   5 +-
 drivers/gpu/host1x/hw/cdma_hw.c                    |   4 +-
 drivers/gpu/host1x/hw/debug_hw.c                   |   4 +-
 53 files changed, 847 insertions(+), 265 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c
--29444707-1895160980-1386577981=:31658--
