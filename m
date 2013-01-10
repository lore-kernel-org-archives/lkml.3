Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3AJV4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 16:56:42 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58240 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab3AJV4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 16:56:40 -0500
Date: Thu, 10 Jan 2013 21:56:30 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel fixes
Message-ID: <alpine.DEB.2.00.1301102155250.6541@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Just intel fixes, including getting the Ironlake systems back to the state 
they were in for 3.6.

Dave.

The following changes since commit ecf02a607bd801e742d7bb35c6e40f7ca15edf03:

  Merge branch 'for_linus' of git://cavan.codon.org.uk/platform-drivers-x86 (2013-01-10 09:09:41 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 82ba789f48de669fd0bbc84c326f07571d078572:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel (2013-01-11 07:52:48 +1000)

----------------------------------------------------------------

Chris Wilson (6):
      drm/i915; Only increment the user-pin-count after successfully pinning the bo
      drm/i915: Treat crtc->mode.clock == 0 as disabled
      drm: Only evict the blocks required to create the requested hole
      drm/i915: The sprite scaler on Ironlake also support YUV planes
      drm/i915: Add DEBUG messages to all intel_create_user_framebuffer error paths
      drm/i915: Use pixel size for computing linear offsets into a sprite

Daniel Vetter (2):
      Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"
      drm/i915: Revert shrinker changes from "Track unbound pages"

Dave Airlie (1):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel

 drivers/gpu/drm/drm_mm.c             | 45 ++++++++++++++----------------------
 drivers/gpu/drm/i915/i915_gem.c      | 25 ++++++++++++++------
 drivers/gpu/drm/i915/intel_display.c | 33 +++++++++++++++++++-------
 drivers/gpu/drm/i915/intel_lvds.c    |  8 -------
 drivers/gpu/drm/i915/intel_pm.c      | 25 ++++++++++++--------
 drivers/gpu/drm/i915/intel_sprite.c  | 10 ++++----
 include/drm/drm_mm.h                 |  2 +-
 7 files changed, 81 insertions(+), 67 deletions(-)
