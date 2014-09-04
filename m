Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaIDJes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:34:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46747 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbaIDJeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:34:46 -0400
Date: Thu, 4 Sep 2014 10:34:42 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1409041025200.7902@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1633449997-1409823282=:7902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1633449997-1409823282=:7902
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

just i915 and vmwgfx fixes,

i915 contains a bunch of fixes for recent regressions in outputs,
vmwgfx fixes a possible loop for ever and a bad return code.

Dave.

The following changes since commit 59753a805499f1ffbca4ac0a24b3dff67bf00001:

  Merge tag 'backlight-fixes-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight (2014-08-28 10:47:10 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 3aacfda0ecd9040521fbfb4a2c53cd6bf77ae4ee:

  Merge tag 'drm-intel-fixes-2014-09-03' of git://anongit.freedesktop.org/drm-intel into drm-fixes (2014-09-04 11:20:00 +1000)

----------------------------------------------------------------

Dave Airlie (4):
      Merge tag 'drm-intel-fixes-2014-08-28' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      drm/i915: handle G45/GM45 pulse detection connected state.
      Merge branch 'vmwgfx-fixes-3.17' of git://people.freedesktop.org/~thomash/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2014-09-03' of git://anongit.freedesktop.org/drm-intel into drm-fixes

Mathias Krause (1):
      drm/i915: Remove bogus __init annotation from DMI callbacks

Paulo Zanoni (1):
      drm/i915: fix plane/cursor handling when runtime suspended

Scot Doyle (2):
      drm/i915: Ignore VBT backlight presence check on Acer C720 (4005U)
      drm/i915: don't warn if backlight unexpectedly enabled

Thomas Hellstrom (2):
      drm/vmwgfx: Fix an incorrect OOM return value
      drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle

Ville Syrjälä (2):
      drm/i915: Move intel_ddi_set_vc_payload_alloc(false) to haswell_crtc_disable()
      drm/i915: Fix lock dropping in intel_tv_detect()

 drivers/gpu/drm/i915/intel_bios.c       |  2 +-
 drivers/gpu/drm/i915/intel_crt.c        |  2 +-
 drivers/gpu/drm/i915/intel_display.c    | 34 +++++++++++++++++---
 drivers/gpu/drm/i915/intel_dp.c         | 55 ++++++++++++++++++++++-----------
 drivers/gpu/drm/i915/intel_lvds.c       |  2 +-
 drivers/gpu/drm/i915/intel_panel.c      |  8 ++---
 drivers/gpu/drm/i915/intel_tv.c         | 10 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 11 +++----
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c    |  3 +-
 9 files changed, 88 insertions(+), 39 deletions(-)
--29444707-1633449997-1409823282=:7902--
