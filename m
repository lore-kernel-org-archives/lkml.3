Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3EaC7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 22:59:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58482 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab3EaC7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 22:59:35 -0400
Date: Fri, 31 May 2013 03:59:42 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1305310358200.9016@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-470587977-1369969182=:9016"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-470587977-1369969182=:9016
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

one qxl 32-bit warning fix, the rest is a bunch of radeon fixes from Alex 
for some issues we've been seeing.

Dave.

The following changes since commit c89b65e7fffef745bdd36c372aa0dea778fecbab:

  qxl: fix Kconfig deps - select FB_DEFERRED_IO (2013-05-28 17:03:37 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 970fa986fadb1165cf38b45b70e98302a3bee497:

  drm/qxl: fix build warnings on 32-bit (2013-05-31 12:45:09 +1000)

----------------------------------------------------------------
Alex Deucher (4):
      drm/radeon: fix typo in cu_per_sh on verde
      drm/radeon: fix card_posted check for newer asics
      drm/radeon: don't check crtcs in card_posted() on cards without DCE
      drm/radeon: narrow scope of Apple re-POST hack

Christian König (1):
      drm/radeon: UVD block on SUMO2 is the same as on SUMO

Dave Airlie (2):
      Merge branch 'drm-fixes-3.10' of git://people.freedesktop.org/~agd5f/linux into drm-next
      drm/qxl: fix build warnings on 32-bit

Kleber Sacilotto de Souza (1):
      radeon: use max_bus_speed to activate gen2 speeds

 drivers/gpu/drm/qxl/qxl_ioctl.c        |  4 ++--
 drivers/gpu/drm/qxl/qxl_kms.c          |  9 +++++----
 drivers/gpu/drm/radeon/evergreen.c     | 10 +++-------
 drivers/gpu/drm/radeon/r600.c          |  9 ++-------
 drivers/gpu/drm/radeon/radeon_device.c | 27 ++++++++++++++++-----------
 drivers/gpu/drm/radeon/rv770.c         | 13 +++----------
 drivers/gpu/drm/radeon/si.c            |  2 +-
 7 files changed, 32 insertions(+), 42 deletions(-)
--29444707-470587977-1369969182=:9016--
