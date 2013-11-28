Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab3K1Exc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:53:32 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41474 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab3K1Exa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:53:30 -0500
Date: Thu, 28 Nov 2013 04:53:28 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm minor fixes
Message-ID: <alpine.DEB.2.00.1311280452450.22390@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just two minor fixes as people keep resending since they are so low 
hanging.

Dave.

The following changes since commit 8ae516aa8b8161254d3e402b3348b2a9b8d1efd0:

  Merge tag 'trace-fixes-v3.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace (2013-11-26 18:04:21 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to eec99016e38b740662509f097effb90abc7a1376:

  drm/nouveau/hwmon: fix compilation without CONFIG_HWMON (2013-11-28 14:38:09 +1000)

----------------------------------------------------------------
David Herrmann (1):
      drm/sysfs: fix OOM verification

Ilia Mirkin (1):
      drm/nouveau/hwmon: fix compilation without CONFIG_HWMON

 drivers/gpu/drm/drm_sysfs.c             | 2 +-
 drivers/gpu/drm/nouveau/nouveau_hwmon.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)
