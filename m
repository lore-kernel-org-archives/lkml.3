Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaIXVJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:09:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49332 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaIXVJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:09:24 -0400
Date: Wed, 24 Sep 2014 22:09:21 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1409242208020.8863@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-345451779-1411592961=:8863"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-345451779-1411592961=:8863
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Some final radeon and i915 fixes, black screens mostly

Dave.

The following changes since commit 0f33be009b89d2268e94194dc4fd01a7851b6d51:

  Linux 3.17-rc6 (2014-09-21 15:43:02 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 67f33f30fc3cb7896cbdbd25c70395d38bfa9520:

  Merge branch 'drm-fixes-3.17' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2014-09-25 06:49:26 +1000)

----------------------------------------------------------------

Alex Deucher (4):
      drm/radeon: add a module parameter for backlight control (v2)
      drm/radeon: add a backlight quirk for Amilo Xi 2550
      drm/radeon: add PX quirk for asus K53TK
      drm/radeon/cik: use a separate counter for CP init timeout

Brad Volkin (1):
      drm/i915: Don't leak command parser tables on suspend/resume

Dave Airlie (2):
      Merge tag 'drm-intel-fixes-2014-09-24' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.17' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Jani Nikula (1):
      drm/i915/hdmi: fix hdmi audio state readout

Michel Dänzer (3):
      drm/radeon: Clear RB_OVERFLOW bit earlier
      drm/radeon: Make IH ring overflow debugging output more useful
      drm/radeon: Update IH_RB_RPTR register after each processed interrupt

 drivers/gpu/drm/i915/i915_cmd_parser.c   | 12 +++++----
 drivers/gpu/drm/i915/intel_hdmi.c        |  2 +-
 drivers/gpu/drm/radeon/cik.c             | 12 ++++-----
 drivers/gpu/drm/radeon/evergreen.c       |  8 +++---
 drivers/gpu/drm/radeon/r600.c            |  8 +++---
 drivers/gpu/drm/radeon/radeon.h          |  1 +
 drivers/gpu/drm/radeon/radeon_device.c   |  4 +++
 drivers/gpu/drm/radeon/radeon_drv.c      |  4 +++
 drivers/gpu/drm/radeon/radeon_encoders.c | 44 ++++++++++++++++++++++++++------
 drivers/gpu/drm/radeon/si.c              |  8 +++---
 10 files changed, 71 insertions(+), 32 deletions(-)
--29444707-345451779-1411592961=:8863--
