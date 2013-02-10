Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3BJXpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 18:45:19 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57263 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab3BJXpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 18:45:17 -0500
Date: Sun, 10 Feb 2013 23:45:15 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm nouveau fixes.
Message-ID: <alpine.DEB.2.00.1302102344160.28198@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just 3 nouveau fixes, all user visible issues, I have one radeon 
regression fix I'm hoping to send tomorrow once I'm happy with it.

Dave.

The following changes since commit ff7c60c580d9722f820d85c9c58ca55ecc1ee7c4:

  drm/ttm: fix fence locking in ttm_buffer_object_transfer, 2nd try (2013-02-08 10:44:31 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to e28f639eeaa97b6029b0db8890b2a4ce99e642c6:

  Merge branch 'drm-nouveau-fixes-3.8' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next (2013-02-11 09:40:14 +1000)

----------------------------------------------------------------

Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes-3.8' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next

Maarten Lankhorst (1):
      drm/nouveau: use different register to wait for secret scrubber

Marcin Slusarz (1):
      drm/nouveau: add lockdep annotations

Roy Spliet (1):
      drm/nv50/fb: Fix nullptr-deref on IGPs

 drivers/gpu/drm/nouveau/core/core/falcon.c         | 7 +++++--
 drivers/gpu/drm/nouveau/core/core/subdev.c         | 2 +-
 drivers/gpu/drm/nouveau/core/include/core/object.h | 7 +++++--
 drivers/gpu/drm/nouveau/core/subdev/fb/base.c      | 4 ++--
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      | 5 +++--
 drivers/gpu/drm/nouveau/nouveau_drm.c              | 3 +++
 6 files changed, 19 insertions(+), 9 deletions(-)
