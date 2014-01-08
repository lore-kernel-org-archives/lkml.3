Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaAHIOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:14:00 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42280 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbaAHINx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:13:53 -0500
Date: Wed, 8 Jan 2014 08:13:49 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1401080812070.31762@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

LCA fixes tree,

i915 and nouveau fixes, a revert for i915 gm45 backlight, and a 
MAINTAINERS update for the i915 driver, as it now has a co-maintainer.

Dave.

The following changes since commit ef350bb7c5e0748f7d17f1d70c6b0eec5f64f446:

  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2014-01-07 08:22:42 +0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to ceb3b0212dfc843a6abe8a6f3b4e28c1f2059e64:

  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/nouveau/linux-2.6 into drm-fixes (2014-01-08 17:57:45 +1000)

----------------------------------------------------------------

Alexander van Heukelum (1):
      Revert "drm/i915: assume all GM45 Acer laptops use inverted backlight PWM"

Ben Skeggs (1):
      drm/nouveau: populate master subdev pointer only when fully constructed

Ben Widawsky (1):
      drm/i915/bdw: Flush system agent on gen8 also

Bob Gleitsmann (1):
      drm/nouveau: return offset of allocated notifier

Christian Engelmayer (1):
      drm/nouveau/nouveau: fix memory leak in nouveau_crtc_page_flip()

Daniel Vetter (1):
      MAINTAINERS: Updates for drm/i915

Dave Airlie (2):
      Merge tag 'drm-intel-fixes-2014-01-08' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/nouveau/linux-2.6 into drm-fixes

Ilia Mirkin (2):
      drm/nouveau/bios: make jump conditional
      drm/nouveau/bios: fix offset calculation for BMPv1 bioses

Kelly Doran (1):
      drm/nvc0/gr: fix mthd data submission

Sid Boyce (1):
      drm/nvce/mc: fix msi rearm on GF114

 MAINTAINERS                                       |  2 ++
 drivers/gpu/drm/i915/i915_gem_gtt.c               |  2 --
 drivers/gpu/drm/i915/intel_display.c              | 19 ++++++++++++++-----
 drivers/gpu/drm/nouveau/core/core/subdev.c        |  3 ---
 drivers/gpu/drm/nouveau/core/engine/device/base.c |  2 ++
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c |  2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c  |  2 +-
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h  |  5 +++++
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c   | 14 +++++++++-----
 drivers/gpu/drm/nouveau/nouveau_abi16.c           |  2 ++
 drivers/gpu/drm/nouveau/nouveau_display.c         |  2 +-
 11 files changed, 37 insertions(+), 18 deletions(-)
