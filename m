Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaAOFRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:17:34 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49647 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaAOFRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:17:32 -0500
Date: Wed, 15 Jan 2014 05:17:31 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm last fixes
Message-ID: <alpine.DEB.2.00.1401150516090.3314@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-691175057-1389763051=:3314"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-691175057-1389763051=:3314
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

One nouveau regression fix on older cards, i915 black screen fixes, and a 
revert for a strange G33 intel problem.

Dave.

The following changes since commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6:

  Linux 3.13-rc8 (2014-01-12 17:04:18 +0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 703a8c2dfa5aa69b9b0a6684dc78ea28a2c7fe3e:

  Merge branch 'drm-nouveau-next' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2014-01-15 15:01:11 +1000)

----------------------------------------------------------------

Ben Skeggs (1):
      drm/nouveau: fix null ptr dereferences on some boards

Dave Airlie (3):
      Merge tag 'drm-intel-fixes-2014-01-13' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Revert "drm: copy mode type in drm_mode_connector_list_update()"
      Merge branch 'drm-nouveau-next' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Jesse Barnes (1):
      drm/i915/bdw: make sure south port interrupts are enabled properly v2

Paulo Zanoni (1):
      drm/i915: fix DDI PLLs HW state readout code

Ville Syrjälä (1):
      drm/i915: Don't grab crtc mutexes in intel_modeset_gem_init()

 drivers/gpu/drm/drm_modes.c                           |  2 +-
 drivers/gpu/drm/i915/i915_irq.c                       |  2 ++
 drivers/gpu/drm/i915/intel_ddi.c                      |  8 +++++++-
 drivers/gpu/drm/i915/intel_display.c                  |  4 ++--
 drivers/gpu/drm/nouveau/core/include/subdev/i2c.h     |  2 +-
 drivers/gpu/drm/nouveau/core/include/subdev/instmem.h |  7 +++++++
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c        |  4 ++--
 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c        | 10 +++++-----
 drivers/gpu/drm/nouveau/dispnv04/dfp.c                |  2 +-
 drivers/gpu/drm/nouveau/dispnv04/tvnv04.c             |  2 +-
 10 files changed, 29 insertions(+), 14 deletions(-)
--29444707-691175057-1389763051=:3314--
