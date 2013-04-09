Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838Ab3DIXt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:49:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42741 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab3DIXt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:49:57 -0400
Date: Wed, 10 Apr 2013 00:49:55 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm nouveau fix
In-Reply-To: <alpine.DEB.2.00.1304090802170.18231@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1304100049270.15182@skynet.skynet.ie>
References: <alpine.DEB.2.00.1304090802170.18231@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Linus,
> 
> just a spare semicolon in nouveau that caused some issues.

Okay an mgag200 fix I missed is also in there now.

The following changes since commit f011a08c804d50eeff4abf2d308cdce492f015aa:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes (2013-04-08 16:10:43 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 1812a3db0874be1d1524086da9e84397b800f546:

  drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not decimal. (2013-04-10 09:48:24 +1000)

----------------------------------------------------------------
Calvin Owens (1):
      drm/nouveau: fix unconditional return waiting on memory

Christopher Harvey (1):
      drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not decimal.

Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

 drivers/gpu/drm/mgag200/mgag200_mode.c | 13 +++----------
 drivers/gpu/drm/nouveau/nv50_display.c |  2 +-
 2 files changed, 4 insertions(+), 11 deletions(-)
