Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaAAK44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 05:56:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43143 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbaAAK4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 05:56:54 -0500
Date: Wed, 1 Jan 2014 10:56:50 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes
Message-ID: <alpine.DEB.2.00.1401011053510.8355@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-2107497560-1388573810=:8355"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-2107497560-1388573810=:8355
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

just piping a bunch of fixes from pre-xmas from Alex for radeon, all 
either fix bad hw setup issues or regressions.

Dave.

The following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda:

  Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 61ef8be7fa4302180c163fb56a259610fd84ee13:

  Merge branch 'drm-fixes-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2014-01-01 20:32:19 +1000)

----------------------------------------------------------------

Alex Deucher (2):
      drm/radeon: 0x9649 is SUMO2 not SUMO
      drm/radeon: Bump version for CIK DCE tiling fix

Christian König (1):
      drm/radeon: fix UVD 256MB check

Dave Airlie (1):
      Merge branch 'drm-fixes-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Marek Ol¨ák (4):
      drm/radeon: fix render backend setup for SI and CIK
      drm/radeon: expose render backend mask to the userspace
      drm/radeon: set correct pipe config for Hawaii in DCE
      drm/radeon: set correct number of banks for CIK chips in DCE

 drivers/gpu/drm/radeon/atombios_crtc.c | 83 ++++++++++++++++++++--------------
 drivers/gpu/drm/radeon/cik.c           | 12 +++--
 drivers/gpu/drm/radeon/radeon.h        |  4 +-
 drivers/gpu/drm/radeon/radeon_drv.c    |  3 +-
 drivers/gpu/drm/radeon/radeon_kms.c    |  9 ++++
 drivers/gpu/drm/radeon/radeon_uvd.c    |  2 +-
 drivers/gpu/drm/radeon/si.c            | 12 +++--
 include/drm/drm_pciids.h               |  2 +-
 include/uapi/drm/radeon_drm.h          |  2 +
 9 files changed, 80 insertions(+), 49 deletions(-)
--29444707-2107497560-1388573810=:8355--
