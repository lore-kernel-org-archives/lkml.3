Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3FZXk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:40:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34587 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab3FZXk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:40:58 -0400
Date: Thu, 27 Jun 2013 00:41:11 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel final fixes
Message-ID: <alpine.DEB.2.00.1306270036320.3643@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

should be last two fixes for i915, one is for a fence leak killing X on 
some older GPUs, and one is a late regression partial revert for an 
swiotlb/xen/i915 interaction, Konrad has promised to figure out the proper 
answer, and this patch is the best thing to do at this stage to avoid 
regressing.

Dave.


The following changes since commit acdb37c361dc87e165889a504e291c1e82ae133c:

  fs: fix new splice.c kernel-doc warning (2013-06-23 16:19:56 -1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 426729dcc713b3d1ae802e314030e5556a62da53:

  drm/i915: make compact dma scatter lists creation work with SWIOTLB backend. (2013-06-25 10:39:57 +1000)

----------------------------------------------------------------
Chris Wilson (1):
      drm/i915: Restore fences after resume and GPU resets

Dave Airlie (1):
      Merge tag 'drm-intel-fixes-2013-06-24' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Konrad Rzeszutek Wilk (1):
      drm/i915: make compact dma scatter lists creation work with SWIOTLB backend.

 drivers/gpu/drm/i915/i915_drv.h     |  2 ++
 drivers/gpu/drm/i915/i915_gem.c     | 37 +++++++++++++++++--------------------
 drivers/gpu/drm/i915/i915_suspend.c |  1 +
 3 files changed, 20 insertions(+), 20 deletions(-)
