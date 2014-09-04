Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaIDXrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:47:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58429 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbaIDXrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:47:04 -0400
Date: Fri, 5 Sep 2014 00:46:58 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linuxfoundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes (resend + one patch)
Message-ID: <alpine.DEB.2.00.1409050045190.9851@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-2017059747-1409874418=:9851"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-2017059747-1409874418=:9851
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

send one yesterday, it bounced due to LF mail fail (linux-foundation.org),
hopefully this one makes it.

i915 fixes, a few display regressions
vmwgfx, possible loop forever fix
nouveau, one userspace interface fix.

Dave.

The following changes since commit 59753a805499f1ffbca4ac0a24b3dff67bf00001:

  Merge tag 'backlight-fixes-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight (2014-08-28 10:47:10 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 68c78bd67bd6f868474ac75d98ea7d6ebf28d2e7:

  Merge branch 'linux-3.17' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2014-09-05 09:27:33 +1000)

----------------------------------------------------------------

Ben Skeggs (1):
      drm/nouveau/core: don't leak oclass type bits to user

Dave Airlie (5):
      Merge tag 'drm-intel-fixes-2014-08-28' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      drm/i915: handle G45/GM45 pulse detection connected state.
      Merge branch 'vmwgfx-fixes-3.17' of git://people.freedesktop.org/~thomash/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2014-09-03' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'linux-3.17' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

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

 drivers/gpu/drm/i915/intel_bios.c          |  2 +-
 drivers/gpu/drm/i915/intel_crt.c           |  2 +-
 drivers/gpu/drm/i915/intel_display.c       | 34 +++++++++++++++---
 drivers/gpu/drm/i915/intel_dp.c            | 55 ++++++++++++++++++++----------
 drivers/gpu/drm/i915/intel_lvds.c          |  2 +-
 drivers/gpu/drm/i915/intel_panel.c         |  8 ++---
 drivers/gpu/drm/i915/intel_tv.c            | 10 ++++--
 drivers/gpu/drm/nouveau/core/core/parent.c |  4 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c    | 11 +++---
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c       |  3 +-
 10 files changed, 90 insertions(+), 41 deletions(-)
--29444707-2017059747-1409874418=:9851--
