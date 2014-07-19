Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaGSVg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 17:36:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58391 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049AbaGSVg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 17:36:56 -0400
Date: Sat, 19 Jul 2014 22:36:53 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel fixes
Message-ID: <alpine.DEB.2.00.1407192233450.1576@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Intel fixes came in late, but since I debugged one of them I'll send them 
on,

two reverts, a quirk and one warn regression.

Dave.

The following changes since commit b579fcca32b7eaef7c346dff55adc953b56bb1a8:

  Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband (2014-07-18 20:39:34 -1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to e898c791e1a4c27fa1f221058b29b0ad06ddf8b0:

  Merge tag 'drm-intel-fixes-2014-07-18' of git://anongit.freedesktop.org/drm-intel (2014-07-19 16:48:38 +1000)

----------------------------------------------------------------

Daniel Vetter (2):
      Revert "drm/i915: Don't set the 8to6 dither flag when not scaling"
      drm/i915: Track the primary plane correctly when reassigning planes

Dave Airlie (2):
      Revert "drm/i915: reverse dp link param selection, prefer fast over wide again"
      Merge tag 'drm-intel-fixes-2014-07-18' of git://anongit.freedesktop.org/drm-intel

Scot Doyle (1):
      drm/i915: Ignore VBT backlight presence check on HP Chromebook 14

 drivers/gpu/drm/i915/intel_display.c | 4 ++++
 drivers/gpu/drm/i915/intel_dp.c      | 4 ++--
 drivers/gpu/drm/i915/intel_lvds.c    | 7 +++++++
 drivers/gpu/drm/i915/intel_panel.c   | 8 ++++----
 4 files changed, 17 insertions(+), 6 deletions(-)
