Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaILEZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:25:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42274 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaILEZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:25:28 -0400
Date: Fri, 12 Sep 2014 05:25:25 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linuxfoundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1409120520260.28141@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1615061047-1410495925=:28141"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1615061047-1410495925=:28141
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

ast, i915, radeon and msm fixes, all over the place, all fixing build 
issues, regressions, oopses or failure to detect cards.

Dave.

The following changes since commit 7ec62d421bdf29cb31101ae2689f7f3a9906289a:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs (2014-09-10 14:04:17 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 83502a5d34386f7c6973bc70e1c423f55f5a2e3a:

  drm/ast: AST2000 cannot be detected correctly (2014-09-12 13:41:39 +1000)

----------------------------------------------------------------
Alex Deucher (3):
      drm/radeon: only use me/pfp sync on evergreen+
      drm/radeon: add connector quirk for fujitsu board
      drm/radeon/dpm: set the thermal type properly for special configs

Andy Shevchenko (1):
      drm/radeon: reduce memory footprint for debugging

Chris Wilson (2):
      drm/i915: Prevent recursive deadlock on releasing a busy userptr
      drm/i915: Evict CS TLBs between batches

Christian König (1):
      drm/radeon: fix semaphore value init

Daniel Vetter (2):
      drm/i915: Fix EIO/wedged handling in gem fault handler
      drm/i915: Fix irq enable tracking in driver load

Dave Airlie (3):
      Merge branch 'drm-fixes-3.17' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2014-09-10' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'msm-fixes-3.17-rc4' of git://people.freedesktop.org/~robclark/linux into drm-fixes

Mark Charlebois (1):
      drm/msm: Change nested function to static function

Rob Clark (2):
      drm/msm/hdmi: fix build break on non-CCF platforms
      drm/msm: don't crash if no msm.vram param

Ville Syrjälä (1):
      drm/i915: Wait for vblank before enabling the TV encoder

Y.C. Chen (2):
      drm/ast: open key before detect chips
      drm/ast: AST2000 cannot be detected correctly

 drivers/gpu/drm/ast/ast_main.c            |   3 +-
 drivers/gpu/drm/i915/i915_dma.c           |   9 +-
 drivers/gpu/drm/i915/i915_drv.h           |  10 +-
 drivers/gpu/drm/i915/i915_gem.c           |  11 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c   | 409 +++++++++++++++++-------------
 drivers/gpu/drm/i915/i915_reg.h           |  12 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c   |  66 +++--
 drivers/gpu/drm/i915/intel_tv.c           |   4 +
 drivers/gpu/drm/msm/hdmi/hdmi.c           |  46 ++--
 drivers/gpu/drm/msm/hdmi/hdmi_phy_8960.c  |  15 +-
 drivers/gpu/drm/msm/msm_drv.c             |   2 +-
 drivers/gpu/drm/radeon/atombios_dp.c      |   7 +-
 drivers/gpu/drm/radeon/r600.c             |   4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c  |  33 ++-
 drivers/gpu/drm/radeon/radeon_semaphore.c |   2 +-
 15 files changed, 371 insertions(+), 262 deletions(-)
--29444707-1615061047-1410495925=:28141--
