Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818Ab3HSEVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:21:22 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58887 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3HSEVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:21:19 -0400
Date: Mon, 19 Aug 2013 05:21:17 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1308190519490.15659@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1232310002-1376886077=:15659"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1232310002-1376886077=:15659
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

bit late with these, was under the weather for a a few days, nothing 
too crazy, some radeon regression fixes, one intel regression fix, and 
one fix to avoid a warn with i915 when used with dma-buf.

Dave.

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 3387ed83943daf6cb1bb4195ae369067b9cd80ce:

  Merge tag 'drm-intel-fixes-2013-08-15' of git://people.freedesktop.org/~danvet/drm-intel (2013-08-19 13:49:20 +1000)

----------------------------------------------------------------

Alex Deucher (1):
      drm/radeon/r7xx: fix copy paste typo in golden register setup

Chris Wilson (1):
      drm/i915: Don't deref pipe->cpu_transcoder in the hangcheck code

Christian König (1):
      drm/radeon: fix UVD message buffer validation

Daniel Vetter (1):
      drm/i915: unpin backing storage in dmabuf_unmap

Dave Airlie (2):
      Merge branch 'drm-fixes-3.11' of git://people.freedesktop.org/~agd5f/linux
      Merge tag 'drm-intel-fixes-2013-08-15' of git://people.freedesktop.org/~danvet/drm-intel

Rafa³ Mi³ecki (1):
      drm/radeon: fix WREG32_OR macro setting bits in a register

 drivers/gpu/drm/i915/i915_gem_dmabuf.c |  8 ++++
 drivers/gpu/drm/i915/intel_display.c   | 86 ++++++++++++++++++++++------------
 drivers/gpu/drm/radeon/radeon.h        |  2 +-
 drivers/gpu/drm/radeon/radeon_uvd.c    |  8 ++++
 drivers/gpu/drm/radeon/rv770.c         | 12 ++---
 5 files changed, 80 insertions(+), 36 deletions(-)
--29444707-1232310002-1376886077=:15659--
