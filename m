Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3JaGpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:45:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55565 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab3JaGo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:44:59 -0400
Date: Thu, 31 Oct 2013 06:44:55 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [drm pull] drm radeon fixes
Message-ID: <alpine.DEB.2.00.1310310644070.4275@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oops missed in my post ks sweep, just 3 small fixes for radeon.

Dave.

The following changes since commit 12aee278b50c4a94a93fa0b4d201ae35d792c696:

  Merge branch 'akpm' (fixes from Andrew Morton) (2013-10-30 14:27:10 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 74c85e1357e30f3f21944989bf9948038faef6ab:

  Merge branch 'drm-fixes-3.12' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2013-10-31 15:29:10 +1000)

----------------------------------------------------------------

Alex Deucher (3):
      drm/radeon: use sw CTS/N values for audio on DCE4+
      drm/radeon: disable bapm on KB
      drm/radeon/dpm: fix incompatible casting on big endian

Dave Airlie (1):
      Merge branch 'drm-fixes-3.12' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

 drivers/gpu/drm/radeon/evergreen_hdmi.c | 1 +
 drivers/gpu/drm/radeon/kv_dpm.c         | 2 +-
 drivers/gpu/drm/radeon/radeon.h         | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)
