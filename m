Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab3FLHiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:38:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35381 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab3FLHiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:38:11 -0400
Date: Wed, 12 Jun 2013 08:38:21 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1306120837200.7689@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just some GMA500 memory leaks and i915 regression fix due to regression 
fix.

Dave.

The following changes since commit ab0296319a8cb970f4e42659472bb40fbfae3e56:

  Merge tag 'spi-v3.10-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi (2013-06-10 13:28:39 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to df63d3ecbca514bad99513b2401448d19a9bb92e:

  Merge tag 'drm-intel-fixes-2013-06-11' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-06-11 19:38:27 +1000)

----------------------------------------------------------------

Chris Wilson (2):
      drm/i915: Fix hotplug interrupt enabling for SDVOC
      drm/i915: Enable hotplug interrupts after querying hw capabilities.

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Dave Airlie (2):
      Merge branch 'gma500-fixes' of git://github.com/patjak/drm-gma500 into drm-fixes
      Merge tag 'drm-intel-fixes-2013-06-11' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Patrik Jakobsson (5):
      drm/gma500: Add fb gtt offset to fb base
      drm/gma500/psb: Unpin framebuffer on crtc disable
      drm/gma500/cdv: Unpin framebuffer on crtc disable
      drm/gma500/psb: Fix cursor gem obj referencing on psb
      drm/gma500/cdv: Fix cursor gem obj referencing on cdv

 drivers/gpu/drm/gma500/cdv_intel_display.c | 30 ++++++++++++++++++++++-----
 drivers/gpu/drm/gma500/framebuffer.c       |  4 ++--
 drivers/gpu/drm/gma500/psb_intel_display.c | 33 ++++++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_sdvo.c          | 24 +++++++++++++---------
 4 files changed, 68 insertions(+), 23 deletions(-)
