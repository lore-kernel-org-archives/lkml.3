Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab3BHDnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:43:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43520 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab3BHDnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:43:21 -0500
Date: Fri, 8 Feb 2013 03:43:11 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm regression fix
Message-ID: <alpine.DEB.2.00.1302080342200.3999@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

this one fixes a sleep while locked regression that was introduced earlier 
in 3.8.

Dave.

The following changes since commit 6bacaa9ddacb71c691d32c678d37bc59ffc71fac:

  Merge tag 'sound-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2013-02-07 08:43:30 +1100)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to ff7c60c580d9722f820d85c9c58ca55ecc1ee7c4:

  drm/ttm: fix fence locking in ttm_buffer_object_transfer, 2nd try (2013-02-08 10:44:31 +1000)

----------------------------------------------------------------
Daniel Vetter (1):
      drm/ttm: fix fence locking in ttm_buffer_object_transfer, 2nd try

 drivers/gpu/drm/ttm/ttm_bo_util.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)
