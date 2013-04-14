Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3DNIsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 04:48:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44299 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab3DNIsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 04:48:18 -0400
Date: Sun, 14 Apr 2013 09:48:18 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1304140946460.18231@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus

one fix for a hotplug locking regressions, and one fix for an oops if you 
unplug the monitor at an inopportune moment on the udl device.

Dave.

The following changes since commit cfb63bafdb87bbcdc5d6dbbca623d3f69475f118:

  Merge branch 'fixes' of git://git.infradead.org/users/vkoul/slave-dma (2013-04-11 20:35:11 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 89ced125472b8551c65526934b7f6c733a6864fa:

  drm/fb-helper: Fix locking in drm_fb_helper_hotplug_event (2013-04-12 14:21:12 +1000)

----------------------------------------------------------------
Daniel Vetter (1):
      drm/fb-helper: Fix locking in drm_fb_helper_hotplug_event

Dave Airlie (1):
      udl: handle EDID failure properly.

 drivers/gpu/drm/drm_fb_helper.c     | 8 +++++---
 drivers/gpu/drm/udl/udl_connector.c | 4 ++++
 2 files changed, 9 insertions(+), 3 deletions(-)
