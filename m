Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaKJAJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 19:09:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59778 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaKJAJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 19:09:20 -0500
Date: Mon, 10 Nov 2014 00:09:15 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon and i915 fixes
Message-ID: <alpine.DEB.2.00.1411100007470.5288@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

I probably should have sent these earlier, but nothing too urgent in them,
i915, blackscreen and corruption fixes
radeon, oops, locking and stability.

Dave.

The following changes since commit ed78bb846e8bc1a8589fa6e0d9bf2b0f518893d5:

  Merge tag 'pci-v3.18-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci (2014-11-06 11:33:06 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 03dca708521d30153fc5c7e2ff136f780a7372c9:

  Merge tag 'drm-intel-fixes-2014-11-07' of git://anongit.freedesktop.org/drm-intel into drm-fixes (2014-11-10 10:05:37 +1000)

----------------------------------------------------------------

Alex Deucher (3):
      drm/radeon: make sure mode init is complete in bandwidth_update
      drm/radeon: use gart for DMA IB tests
      drm/radeon: add missing crtc unlock when setting up the MC

Dave Airlie (2):
      Merge branch 'drm-fixes-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2014-11-07' of git://anongit.freedesktop.org/drm-intel into drm-fixes

Imre Deak (1):
      drm/i915: vlv: fix gunit HW state corruption during S4 suspend

Jammy Zhou (1):
      drm/radeon: set correct CE ram size for CIK

Jani Nikula (1):
      drm/i915: safeguard against too high minimum brightness

Rodrigo Vivi (1):
      drm/i915: Disable caches for Global GTT.

 drivers/gpu/drm/i915/i915_drv.c     | 10 ++++++++++
 drivers/gpu/drm/i915/i915_gem_gtt.c | 16 ++++++++++++++++
 drivers/gpu/drm/i915/intel_panel.c  | 17 +++++++++++++++--
 drivers/gpu/drm/radeon/cik.c        |  7 +++++--
 drivers/gpu/drm/radeon/cik_sdma.c   | 21 ++++++++++++---------
 drivers/gpu/drm/radeon/evergreen.c  |  4 ++++
 drivers/gpu/drm/radeon/r100.c       |  3 +++
 drivers/gpu/drm/radeon/r600_dma.c   | 20 ++++++++++----------
 drivers/gpu/drm/radeon/rs600.c      |  3 +++
 drivers/gpu/drm/radeon/rs690.c      |  3 +++
 drivers/gpu/drm/radeon/rv515.c      |  3 +++
 drivers/gpu/drm/radeon/si.c         |  3 +++
 12 files changed, 87 insertions(+), 23 deletions(-)
