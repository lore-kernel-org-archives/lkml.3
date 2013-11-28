Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab3K1WuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 17:50:15 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33252 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3K1WuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 17:50:11 -0500
Date: Thu, 28 Nov 2013 22:50:09 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm qxl leak fix
Message-ID: <alpine.DEB.2.00.1311282249170.29599@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As usual 5 mins after I send a trivial pull fix I find a real bug!

This fixes a memory leak and I'd like to get it into stable queue asap.

Dave.

The following changes since commit eec99016e38b740662509f097effb90abc7a1376:

  drm/nouveau/hwmon: fix compilation without CONFIG_HWMON (2013-11-28 14:38:09 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 1b28c3e628315ac0d9ef2d3fac0403f05ae692db:

  drm/qxl: fix memory leak in release list handling (2013-11-29 08:36:15 +1000)

----------------------------------------------------------------
Dave Airlie (1):
      drm/qxl: fix memory leak in release list handling

 drivers/gpu/drm/qxl/qxl_release.c | 1 +
 1 file changed, 1 insertion(+)
