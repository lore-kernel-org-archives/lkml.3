Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3CLGJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:09:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40009 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab3CLGJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:09:44 -0400
Date: Tue, 12 Mar 2013 06:09:42 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm nouveau fixes
Message-ID: <alpine.DEB.2.00.1303120608560.5819@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

this is just nouveau fixes from Ben, one fixes a nasty oops that some 
Fedora people have been seeing, so I'd like to get it out of the way.

Dave.

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to 8698080ee092bdbd6ee2cd5e7f707ceea2812bd8:

  Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next (2013-03-11 13:53:58 +1000)

----------------------------------------------------------------

Ben Skeggs (1):
      drm/nv50: encoder creation failure doesn't mean full init failure

Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next

Maarten Lankhorst (1):
      drm/nouveau: fix regression in vblanking

Marcin Slusarz (2):
      drm/nouveau: idle channel before releasing notify object
      drm/nv50: use correct tiling methods for m2mf buffer moves

 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c | 4 ++--
 drivers/gpu/drm/nouveau/nouveau_abi16.c         | 5 +++++
 drivers/gpu/drm/nouveau/nouveau_bo.c            | 4 ++--
 drivers/gpu/drm/nouveau/nv50_display.c          | 1 +
 4 files changed, 10 insertions(+), 4 deletions(-)
