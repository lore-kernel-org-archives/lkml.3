Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab3KOKyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:54:04 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60335 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab3KOKx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:53:59 -0500
Date: Fri, 15 Nov 2013 10:53:56 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm regression fix
Message-ID: <alpine.DEB.2.00.1311151053090.22802@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Forgot this one liner was necessary to fix module reload issues introduced 
earlier in the pull

Thanks,
Dave.

The following changes since commit 0846c728e20a0cd1e43fb75a3015f3b176a26466:

  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next (2013-11-15 12:24:40 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to a3483353ca4e6dbeef2ed62ebed01af109b5b27a:

  drm: check for !kdev in drm_unplug_minor() (2013-11-15 20:49:02 +1000)

----------------------------------------------------------------
David Herrmann (1):
      drm: check for !kdev in drm_unplug_minor()

 drivers/gpu/drm/drm_stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
