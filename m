Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaCND5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 23:57:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59471 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbaCND5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 23:57:33 -0400
Date: Fri, 14 Mar 2014 03:57:31 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1403140356090.7219@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

pretty minor set of fixes for radeon, ttm and vmwgfx,
ttm ones are a regression and an oops seen on server chipsets.

Dave.

The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to f042cc4a607d675452134884c26e8d0d395dd979:

  Merge tag 'ttm-fixes-3.14-2014-03-12' of git://people.freedesktop.org/~thomash/linux into drm-fixes (2014-03-13 17:31:24 +1000)

----------------------------------------------------------------

Alex Deucher (4):
      drm/radeon: fix runpm disabling on non-PX harder
      drm/radeon/cik: properly set sdma ring status on disable
      drm/radeon/cik: stop the sdma engines in the enable() function
      drm/radeon/cik: properly set compute ring status on disable

Dave Airlie (3):
      Merge tag 'vmwgfx-fixes-3.14-2014-03-13' of git://people.freedesktop.org/~thomash/linux into drm-fixes
      Merge branch 'drm-fixes-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'ttm-fixes-3.14-2014-03-12' of git://people.freedesktop.org/~thomash/linux into drm-fixes

Rob Clark (1):
      drm/ttm: don't oops if no invalidate_caches()

Thomas Hellstrom (2):
      drm/ttm: Work around performance regression with VM_PFNMAP
      drm/vmwgfx: Fix a surface reference corner-case in legacy emulation mode

 drivers/gpu/drm/radeon/cik.c            |  5 ++++-
 drivers/gpu/drm/radeon/cik_sdma.c       | 14 +++++++-------
 drivers/gpu/drm/radeon/radeon_kms.c     | 10 +++++++++-
 drivers/gpu/drm/ttm/ttm_bo.c            |  8 +++++---
 drivers/gpu/drm/ttm/ttm_bo_vm.c         | 12 +++++++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c | 18 ++++++++++++++++++
 6 files changed, 50 insertions(+), 17 deletions(-)
