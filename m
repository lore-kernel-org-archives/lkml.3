Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3H2XI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:08:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41644 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab3H2XIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:08:25 -0400
Date: Fri, 30 Aug 2013 00:08:23 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1308300006570.10513@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since we are getting to the pointy end, one i915 black screen on some 
machines, and one vmwgfx stop userspace ability to nuke the VM,

there might be one or two ati or nouveau fixes trickle in before final, 
but I think this should pretty much be it.

Dave.


The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:

  Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)

are available in the git repository at:

  ssh://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 6e4dcff3adbf25acb87e74500a58e3c07bdec40f:

  drm/vmwgfx: Split GMR2_REMAP commands if they are to large (2013-08-30 09:03:39 +1000)

----------------------------------------------------------------
Dave Airlie (1):
      Merge tag 'drm-intel-fixes-2013-08-30' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large

 drivers/gpu/drm/i915/i915_reg.h     |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c | 58 +++++++++++++++++++++++++------------
 2 files changed, 40 insertions(+), 20 deletions(-)
