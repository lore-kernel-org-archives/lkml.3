Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3HDBId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 21:08:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58224 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab3HDBIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 21:08:32 -0400
Date: Sun, 4 Aug 2013 02:08:29 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm build fix
Message-ID: <alpine.DEB.2.00.1308040207490.5329@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just a quick fix that a few people have reported, be nice to have in asap.

Dave.

The following changes since commit 72a67a94bcba71a5fddd6b3596a20604d2b5dcd6:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-08-03 15:00:23 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to adfb8e51332153016857194b85309150ac560286:

  drm/radeon: fix 64 bit divide in SI spm code (2013-08-04 11:03:14 +1000)

----------------------------------------------------------------
Alex Deucher (1):
      drm/radeon: fix 64 bit divide in SI spm code

 drivers/gpu/drm/radeon/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
