Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaCBXLE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:11:04 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57036 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbaCBXLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:11:03 -0500
Date: Sun, 2 Mar 2014 23:11:00 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1403022309530.12835@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-46800098-1393801860=:12835"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-46800098-1393801860=:12835
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Not a huge amount happening, some MAINTAINERS updates, radeon, vmwgfx and 
tegra fixes,

Dave.

The following changes since commit 75936c65dda54a08d9124f24f8725f86a4adc286:

  Merge tag 'ttm-fixes-3.14-2014-02-18' of git://people.freedesktop.org/~thomash/linux into drm-fixes (2014-02-19 08:21:26 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to d668ca1cc6b9b6d2f1ce2f7b158cbe919cc782dc:

  Merge branch 'drm-fixes-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2014-03-03 09:04:41 +1000)

----------------------------------------------------------------

Alex Deucher (7):
      MAINTAINERS: add entry for drm radeon driver
      MAINTAINERS: update drm git tree entry
      drm/radeon: print the supported atpx function mask
      drm/radeon: disable pll sharing for DP on DCE4.1
      drm/radeon: fix audio disable on dce6+
      drm/radeon: change audio enable logic
      drm/radeon: enable speaker allocation setup on dce3.2

Alexey Khoroshilov (1):
      drm/vmwgfx: avoid null pointer dereference at failure paths

Christian König (1):
      drm/radeon: fix missing bo reservation

Dave Airlie (3):
      Merge tag 'drm/for-3.14-rc3' of git://anongit.freedesktop.org/tegra/linux into drm-fixes
      Merge tag 'vmwgfx-fixes-3.14-2014-03-02' of git://people.freedesktop.org/~thomash/linux into drm-fixes
      Merge branch 'drm-fixes-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Dmitry Osipenko (1):
      drm/tegra: Add guard to avoid double disable/enable of RGB outputs

Erik Faye-Lund (1):
      gpu: host1x: do not check previously handled gathers

Jerome Glisse (1):
      drm/radeon: free uvd ring on unload

Paul Bolle (1):
      drm/tegra: fix typo 'CONFIG_TEGRA_DRM_FBDEV'

Thomas Hellstrom (2):
      drm/vmwgfx: Remove some unused surface formats
      drm/vmwgfx: Make sure backing mobs are cleared when allocated. Update driver date.

 MAINTAINERS                                  | 12 +++++++++-
 drivers/gpu/drm/radeon/atombios_crtc.c       | 16 ++++++++++++-
 drivers/gpu/drm/radeon/dce6_afmt.c           | 15 +++++++-----
 drivers/gpu/drm/radeon/evergreen.c           |  2 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c      | 26 ++++++++++++---------
 drivers/gpu/drm/radeon/r600_audio.c          | 14 ++++++-----
 drivers/gpu/drm/radeon/r600_hdmi.c           | 15 ++++++------
 drivers/gpu/drm/radeon/radeon.h              |  6 +++++
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |  3 ++-
 drivers/gpu/drm/radeon/radeon_kms.c          |  6 +++++
 drivers/gpu/drm/radeon/radeon_uvd.c          |  2 ++
 drivers/gpu/drm/radeon/rv770.c               |  2 +-
 drivers/gpu/drm/tegra/drm.c                  |  2 +-
 drivers/gpu/drm/tegra/rgb.c                  | 11 +++++++++
 drivers/gpu/drm/vmwgfx/svga3d_reg.h          |  7 +-----
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h          |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c          | 35 +++++++++++++++-------------
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c     |  3 +--
 drivers/gpu/host1x/job.c                     |  2 +-
 19 files changed, 118 insertions(+), 63 deletions(-)
--29444707-46800098-1393801860=:12835--
