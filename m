Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaKUU2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:28:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49640 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaKUU2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:28:21 -0500
Date: Fri, 21 Nov 2014 20:28:17 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1411212026350.31357@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just two radeon and two intel fixes, endian and regression fixes.

Dave.

The following changes since commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:

  Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to a0fc608178a9b38a5f782331909fcc208b742a7b:

  Merge branch 'drm-fixes-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2014-11-21 12:19:19 +1000)

----------------------------------------------------------------

Alex Deucher (2):
      drm/radeon: disable native backlight control on pre-r6xx asics (v2)
      drm/radeon: fix endian swapping in vbios fetch for tdp table

Daniel Vetter (2):
      drm/i915: drop WaSetupGtModeTdRowDispatch:snb
      drm/i915: Kick fbdev before vgacon

Dave Airlie (2):
      Merge tag 'drm-intel-fixes-2014-11-19' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

 drivers/gpu/drm/i915/i915_dma.c          | 10 ++++++----
 drivers/gpu/drm/i915/intel_pm.c          |  5 -----
 drivers/gpu/drm/radeon/r600_dpm.c        |  2 +-
 drivers/gpu/drm/radeon/radeon_encoders.c |  3 +++
 4 files changed, 10 insertions(+), 10 deletions(-)
