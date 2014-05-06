Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaEFXMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:12:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59726 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbaEFXMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:12:52 -0400
Date: Wed, 7 May 2014 00:12:51 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon mullins support.
Message-ID: <alpine.DEB.2.00.1405070011210.22006@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is support for the new AMD mullins APU, it pretty much just adds 
support to the driver in the all the right places, and is pretty low risk 
wrt other GPUs, however I'll leave it up to you if it fits with the 
current release cycle,

Dave.

The following changes since commit 2a1235e53bed8fa111e1c1ee2e7d8d91efa71ebc:

  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2014-05-07 09:06:21 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-radeon-mullins

for you to fetch changes up to 995c376e89992e756cf844b86209eb4ceb5ebe27:

  Merge branch 'mullins' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes (2014-05-07 09:10:28 +1000)

----------------------------------------------------------------

Alex Deucher (1):
      drm/radeon: dpm updates for KV/KB

Dave Airlie (1):
      Merge branch 'mullins' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes

Leo Liu (1):
      drm/radeon: add Mullins VCE support

Samuel Li (6):
      drm/radeon: add Mullins chip family
      drm/radeon: update cik init for Mullins.
      drm/radeon: add Mullins UVD support.
      drm/radeon: add Mullins dpm support.
      drm/radeon: modesetting updates for Mullins.
      drm/radeon: add pci ids for Mullins

 drivers/gpu/drm/radeon/atombios_crtc.c |   5 +-
 drivers/gpu/drm/radeon/cik.c           |  71 +++++++++++++++++
 drivers/gpu/drm/radeon/kv_dpm.c        | 135 ++++++++++++++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_asic.c   |   1 +
 drivers/gpu/drm/radeon/radeon_device.c |   1 +
 drivers/gpu/drm/radeon/radeon_family.h |   1 +
 drivers/gpu/drm/radeon/radeon_pm.c     |   1 +
 drivers/gpu/drm/radeon/radeon_ucode.h  |   1 +
 drivers/gpu/drm/radeon/radeon_uvd.c    |   1 +
 drivers/gpu/drm/radeon/radeon_vce.c    |   1 +
 include/drm/drm_pciids.h               |  16 ++++
 11 files changed, 203 insertions(+), 31 deletions(-)
