Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaGBWHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:07:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43909 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbaGBWHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:07:31 -0400
Date: Wed, 2 Jul 2014 23:07:28 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes
Message-ID: <alpine.DEB.2.00.1407022305230.16811@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-727255830-1404338848=:16811"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-727255830-1404338848=:16811
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

holiday fixes dump and run, all radeon fixes for mostly power management 
stuff, though a few other regrsesion fixes also,

and one permission changed sneaked past me, so I changed it back.

I'm off for a few days now, but I'll be online for a small while each day.

Dave.


The following changes since commit d92a333a65a17b8638a0980df4bedf8a262b12f3:

  Merge tag 'fbdev-fixes-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux (2014-07-01 09:30:38 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to e55a379827ed02c4982250fc815fed47def53a45:

  Merge branch 'drm-fixes-3.16' of git://people.freedesktop.org/~agd5f/linux (2014-07-03 07:55:32 +1000)

----------------------------------------------------------------

Alex Deucher (8):
      drm/radeon: adjust default dispclk on DCE6 (v2)
      drm/radeon: only apply bapm changes for AC power on ARUBA
      drm/radeon: enable bapm by default on KV/KB
      drm/radeon: enable bapm by default on desktop TN/RL boards
      drm/radeon: add a module parameter to control deep color support
      drm/radeon/dpm: fix typo in vddci setup for eg/btc
      drm/radeon/dpm: fix vddci setup typo on cayman
      drm/radeon/cik: fix typo in EOP packet

Christian König (1):
      drm/radeon: page table BOs are kernel allocations

Dave Airlie (2):
      drm: fix permissions on drm_drv.c
      Merge branch 'drm-fixes-3.16' of git://people.freedesktop.org/~agd5f/linux

Michel Dänzer (1):
      drm/radeon: Track the status of a page flip more explicitly

Stefan Brüns (2):
      drm/radeon: Use only one line for whole DPCD debug output
      drm/radeon: use RADEON_MAX_CRTCS, RADEON_MAX_AFMT_BLOCKS (v2)

 drivers/gpu/drm/drm_drv.c                  |  0
 drivers/gpu/drm/radeon/atombios_dp.c       | 12 +++++++-----
 drivers/gpu/drm/radeon/cikd.h              |  2 +-
 drivers/gpu/drm/radeon/cypress_dpm.c       |  2 +-
 drivers/gpu/drm/radeon/kv_dpm.c            |  2 +-
 drivers/gpu/drm/radeon/ni_dpm.c            |  2 +-
 drivers/gpu/drm/radeon/radeon.h            |  5 +----
 drivers/gpu/drm/radeon/radeon_atombios.c   | 10 +++++++++-
 drivers/gpu/drm/radeon/radeon_connectors.c |  3 +++
 drivers/gpu/drm/radeon/radeon_display.c    | 19 ++++++++++++++-----
 drivers/gpu/drm/radeon/radeon_drv.c        |  4 ++++
 drivers/gpu/drm/radeon/radeon_mode.h       | 15 +++++++++++++--
 drivers/gpu/drm/radeon/radeon_pm.c         |  6 ++++--
 drivers/gpu/drm/radeon/radeon_vm.c         |  4 ++--
 drivers/gpu/drm/radeon/trinity_dpm.c       | 10 +++++++++-
 15 files changed, 70 insertions(+), 26 deletions(-)
 mode change 100755 => 100644 drivers/gpu/drm/drm_drv.c
--29444707-727255830-1404338848=:16811--
