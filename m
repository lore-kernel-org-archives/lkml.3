Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab3ETXxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:53:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50399 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab3ETXxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:53:17 -0400
Date: Tue, 21 May 2013 00:53:24 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm new AMD radeon hw
Message-ID: <alpine.DEB.2.00.1305210051210.15866@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Since I know its outside the merge window, but since this is new hw I 
thought I'd try and provoke the new hw exception, it just fills in the 
blanks in the driver for the new AMD sun and hainan chipsets. The pull is 
based on the previous one with the changelog just for the new pieces.

Dave.

The following changes since commit a3f6902672c9fa3868722ef6ab8a7dd9141def6a:

  Merge branch 'drm-fixes-3.10' of git://people.freedesktop.org/~agd5f/linux into drm-next (2013-05-21 09:41:33 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux.git drm-radeon-sun-hainan

for you to fetch changes up to cc3e06a57d4314ca0582fcf7d6b56dea5ca11f77:

  Merge branch 'drm-fixes-3.10-sun' of git://people.freedesktop.org/~agd5f/linux into drm-next (2013-05-21 09:42:55 +1000)

----------------------------------------------------------------

Alex Deucher (9):
      drm/radeon: add chip family for Hainan
      drm/radeon: fill in GPU init for Hainan (v2)
      drm/radeon: don't touch DCE or VGA regs on Hainan (v3)
      drm/radeon: fill in ucode loading support for Hainan
      drm/radeon: radeon-asic updates for Hainan
      drm/radeon: track which asics have UVD
      drm/radeon: sun/hainan chips do not have UVD (v2)
      drm/radeon: add golden register settings for Hainan (v2)
      drm/radeon: add Hainan pci ids

Dave Airlie (1):
      Merge branch 'drm-fixes-3.10-sun' of git://people.freedesktop.org/~agd5f/linux into drm-next

 drivers/gpu/drm/radeon/evergreen.c     |  27 ++-
 drivers/gpu/drm/radeon/radeon.h        |   2 +
 drivers/gpu/drm/radeon/radeon_asic.c   |  22 +-
 drivers/gpu/drm/radeon/radeon_bios.c   |  28 +--
 drivers/gpu/drm/radeon/radeon_device.c |   1 +
 drivers/gpu/drm/radeon/radeon_family.h |   1 +
 drivers/gpu/drm/radeon/si.c            | 366 ++++++++++++++++++++++++++-------
 drivers/gpu/drm/radeon/sid.h           |   1 +
 include/drm/drm_pciids.h               |   6 +
 9 files changed, 362 insertions(+), 92 deletions(-)
