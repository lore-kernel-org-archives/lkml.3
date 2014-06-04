Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaFDDef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 23:34:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41429 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbaFDDee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 23:34:34 -0400
Date: Wed, 4 Jun 2014 04:34:30 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1406040432030.1541@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1651591784-1401852871=:1541"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1651591784-1401852871=:1541
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

all fairly small, radeon stability and a panic path fix.

Mostly radeon fixes, suspend/resume fix,
stability on the CIK chipsets, 
along with a locking check avoidance patch for panic times regression.

Dave.

The following changes since commit 18ee37a485653aa635cfab9a3710e9bcf5fbca01:

  drm/radeon: Resume fbcon last (2014-05-31 09:19:51 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 0a4ae727d6aa459247b027387edb6ff99f657792:

  Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes (2014-06-04 13:29:13 +1000)

----------------------------------------------------------------

Alex Deucher (1):
      drm/radeon/dpm: resume fixes for some systems

Christian König (3):
      drm/radeon: fix vm buffer size estimation
      drm/radeon: sync page table updates
      drm/radeon: use the CP DMA on CIK

Dave Airlie (1):
      Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes

Sergei Antonov (1):
      drm/crtc-helper: skip locking checks in panicking path

 drivers/gpu/drm/drm_crtc_helper.c      | 17 +++++++++++++++--
 drivers/gpu/drm/radeon/atombios_crtc.c |  6 ++----
 drivers/gpu/drm/radeon/radeon_asic.c   |  4 ++--
 drivers/gpu/drm/radeon/radeon_device.c |  4 ++++
 drivers/gpu/drm/radeon/radeon_pm.c     |  1 -
 drivers/gpu/drm/radeon/radeon_vm.c     | 11 ++++++++---
 6 files changed, 31 insertions(+), 12 deletions(-)
--29444707-1651591784-1401852871=:1541--
