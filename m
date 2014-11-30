Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaK3Ubj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:31:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57028 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaK3Ubh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:31:37 -0500
Date: Sun, 30 Nov 2014 20:31:35 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1411302029490.25810@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1577939450-1417379495=:25810"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1577939450-1417379495=:25810
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

two i915 regressions, one dual-gpu laptop radeon fix.

Dave.

The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:

  Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 21124e5c52ecf87c3fdcb03855ec852563ce93cf:

  Merge tag 'drm-intel-fixes-2014-11-27' of git://anongit.freedesktop.org/drm-intel into drm-fixes (2014-11-28 13:56:31 +1000)

----------------------------------------------------------------

Alex Deucher (1):
      drm/radeon: report disconnected for LVDS/eDP with PX if ddc fails

Dave Airlie (2):
      Merge branch 'drm-fixes-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2014-11-27' of git://anongit.freedesktop.org/drm-intel into drm-fixes

Ville Syrjälä (2):
      drm/i915: Ignore SURFLIVE and flip counter when the GPU gets reset
      drm/i915: Cancel vdd off work before suspend

 drivers/gpu/drm/i915/intel_display.c       |  4 ++++
 drivers/gpu/drm/i915/intel_dp.c            |  1 +
 drivers/gpu/drm/radeon/radeon_connectors.c | 19 ++++++++++++++++++-
 3 files changed, 23 insertions(+), 1 deletion(-)
--29444707-1577939450-1417379495=:25810--
