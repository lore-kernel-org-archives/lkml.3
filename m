Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3FFFO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:14:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44402 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab3FFFOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:14:24 -0400
Date: Thu, 6 Jun 2013 06:14:33 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1306060610001.27833@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-648499285-1370495673=:27833"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-648499285-1370495673=:27833
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

regression fixers for the big 3:
nouveau: hdmi audio, dac load detect, s/r regressions fixed
radeon: long standing system hang fixed, hdmi audio and rs780 fast fb 
fixes
intel: one old regression, a WARN removal, and a stop X dying fix

otherwise one mgag200 fix, a couple of arm build fixes, and a core use 
after free fix.

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
--29444707-648499285-1370495673=:27833--
