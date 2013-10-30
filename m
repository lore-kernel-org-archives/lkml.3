Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3J3K6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:58:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38124 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab3J3K6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:58:53 -0400
Date: Wed, 30 Oct 2013 10:58:48 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel fixes
Message-ID: <alpine.DEB.2.00.1310301057350.26235@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1793410717-1383130728=:26235"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1793410717-1383130728=:26235
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

mainly Intel regression fixes and quirks, along with a simple one liner to 
fix rendernodes ioctl access (off by default, but testers want to test 
it).

Dave.

The following changes since commit 7314e613d5ff9f0934f7a0f74ed7973b903315d1:

  Fix a few incorrectly checked [io_]remap_pfn_range() calls (2013-10-29 10:21:34 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 3d3b78c06c827bfc072a11056d7eb70aeb90e449:

  drm: allow DRM_IOCTL_VERSION on render-nodes (2013-10-30 14:41:56 +1000)

----------------------------------------------------------------
Daniel Vetter (1):
      drm/i915: Fix the PPT fdi lane bifurcate state handling on ivb

Dave Airlie (1):
      Merge tag 'drm-intel-fixes-2013-10-29' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

David Herrmann (1):
      drm: allow DRM_IOCTL_VERSION on render-nodes

Jani Nikula (1):
      drm/i915/dp: workaround BIOS eDP bpp clamping issue

Rob Pearce (1):
      drm/i915: No LVDS hardware on Intel D410PT and D425KT

Ville Syrjälä (2):
      drm/i915: Add support for pipe_bpp readout
      drm/i915: Add HSW CRT output readout support

 drivers/gpu/drm/drm_drv.c            |   2 +-
 drivers/gpu/drm/i915/intel_crt.c     |  30 ++++++--
 drivers/gpu/drm/i915/intel_ddi.c     |  21 +++++-
 drivers/gpu/drm/i915/intel_display.c | 131 ++++++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_dp.c      |  20 ++++++
 drivers/gpu/drm/i915/intel_drv.h     |   2 +
 drivers/gpu/drm/i915/intel_lvds.c    |  16 +++++
 7 files changed, 168 insertions(+), 54 deletions(-)
--29444707-1793410717-1383130728=:26235--
