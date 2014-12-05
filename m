Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaLEG1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:27:24 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40736 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaLEG1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:27:22 -0500
Date: Fri, 5 Dec 2014 06:27:19 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel fixes
Message-ID: <alpine.DEB.2.00.1412050626130.17905@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

two intel stable fixes, that should be it from me for this round.

Dave.

The following changes since commit ebea76f5b95caddb59f49a3e288da26358e6ab1f:

  Merge tag 'media/v3.18-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2014-12-04 16:06:02 -0800)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 3e3282c0a23d8eb9438dcf4ac908a5eb48c7038b:

  Merge tag 'drm-intel-fixes-2014-12-04' of git://anongit.freedesktop.org/drm-intel into drm-fixes (2014-12-05 11:12:29 +1000)

----------------------------------------------------------------

Daniel Vetter (2):
      drm/i915: More cautious with pch fifo underruns
      drm/i915: Unlock panel even when LVDS is disabled

Dave Airlie (1):
      Merge tag 'drm-intel-fixes-2014-12-04' of git://anongit.freedesktop.org/drm-intel into drm-fixes

 drivers/gpu/drm/i915/intel_display.c |  2 --
 drivers/gpu/drm/i915/intel_lvds.c    | 22 +++++++++++-----------
 2 files changed, 11 insertions(+), 13 deletions(-)
