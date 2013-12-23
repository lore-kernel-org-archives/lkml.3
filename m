Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab3LWCOC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 21:14:02 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34620 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715Ab3LWCOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 21:14:00 -0500
Date: Mon, 23 Dec 2013 02:13:57 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1312230212510.26973@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Xmas fixes pull, all small nothing major, intel, radeon, one ttm 
regression, and one build fix.

Dave.

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 418cb50bd6f977249b38f8888359e0adca6fc8ea:

  Merge tag 'drm-intel-fixes-2013-12-18' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-12-23 10:35:57 +1000)

----------------------------------------------------------------

Alex Deucher (4):
      drm/radeon/dce6: set correct number of audio pins
      drm/radeon/dpm: disable ss on Cayman
      drm/radeon: check for 0 count in speaker allocation and SAD code
      drm/radeon: fix asic gfx values for scrapper asics

Chris Wilson (3):
      drm/i915: Prevent double unref following alloc failure during execbuffer
      drm/i915: Fix erroneous dereference of batch_obj inside reset_status
      drm/i915: Use the correct GMCH_CTRL register for Sandybridge+

Dave Airlie (2):
      Merge branch 'drm-fixes-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2013-12-18' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Paulo Zanoni (2):
      drm/i915: change CRTC assertion on LCPLL disable
      drm/i915: get a PC8 reference when enabling the power well

Randy Dunlap (1):
      gpu: fix qxl missing crc32_le

Thomas Hellstrom (1):
      drm/ttm: Fix swapin regression

 drivers/gpu/drm/i915/i915_gem.c            | 34 +++++++++++++++++++++---------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 28 +++++++++++++++++-------
 drivers/gpu/drm/i915/intel_display.c       |  7 +++---
 drivers/gpu/drm/i915/intel_pm.c            | 14 ++++++++++--
 drivers/gpu/drm/qxl/Kconfig                |  1 +
 drivers/gpu/drm/qxl/qxl_display.c          |  2 +-
 drivers/gpu/drm/radeon/dce6_afmt.c         |  8 ++++---
 drivers/gpu/drm/radeon/evergreen_hdmi.c    |  4 ++--
 drivers/gpu/drm/radeon/ni.c                | 20 ++++++++++++++----
 drivers/gpu/drm/radeon/rv770_dpm.c         |  6 ++++++
 drivers/gpu/drm/ttm/ttm_bo_util.c          |  3 ++-
 11 files changed, 93 insertions(+), 34 deletions(-)
