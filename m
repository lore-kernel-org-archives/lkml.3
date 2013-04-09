Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935210Ab3DIHD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:03:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53531 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762735Ab3DIHD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:03:28 -0400
Date: Tue, 9 Apr 2013 08:03:21 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm nouveau fix
Message-ID: <alpine.DEB.2.00.1304090802170.18231@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just a spare semicolon in nouveau that caused some issues.

Dave.

The following changes since commit f011a08c804d50eeff4abf2d308cdce492f015aa:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes (2013-04-08 16:10:43 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to c9cdee17653409dedeb65c0733a253f6fe3fc7d6:

  Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2013-04-09 09:28:55 +1000)

----------------------------------------------------------------

Calvin Owens (1):
      drm/nouveau: fix unconditional return waiting on memory

Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

 drivers/gpu/drm/nouveau/nv50_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
