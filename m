Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaCGAii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:38:38 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44884 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbaCGAih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:38:37 -0500
Date: Fri, 7 Mar 2014 00:38:34 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1403070036170.25778@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1493505853-1394152714=:25778"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1493505853-1394152714=:25778
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

mostly intel and radeon fixes, one tda998x, one kconfig dep fix and two 
more MAINTAINERS updates,

All pretty run of the mill for this stage,

Dave.

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 45db98e54242f3ae94bdcfbfe754e743252eb168:

  Merge branch 'drm-fixes-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2014-03-07 09:27:22 +1000)

----------------------------------------------------------------

Akash Goel (1):
      drm/i915: Resolving the memory region conflict for Stolen area

Alex Deucher (4):
      drm/radeon: resume old pm late
      drm/radeon/cik: fix typo in documentation
      drm/radeon/dpm: fix typo in EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters
      drm/radeon/atom: select the proper number of lanes in transmitter setup

Dave Airlie (5):
      MAINTAINERS: update AGP tree to point at drm tree
      Merge tag 'drm-intel-fixes-2014-03-04' of ssh://git.freedesktop.org/git/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'drm-armada-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-fixes
      Merge branch 'drm-fixes-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Gerd Hoffmann (1):
      drm: fix bochs kconfig dependencies

Imre Deak (2):
      drm/i915: fix pch pci device enumeration
      drm/i915: vlv: reserve GT power context early

Jani Nikula (1):
      drm/i915: use backlight legacy combination mode also for i915gm/i945gm

Lauri Kasanen (1):
      drm/radeon: TTM must be init with cpu-visible VRAM, v2

Paul Bolle (1):
      drm/radeon: silence GCC warning on 32 bit

Paulo Zanoni (1):
      drm/i915: fix assert_cursor on BDW

Russell King (2):
      DRM: armada: fix use of kfifo_put()
      MAINTAINERS: add maintainer entry for TDA998x driver

Ville Syrjälä (1):
      drm/i915: Reject >165MHz modes w/ DVI monitors

 MAINTAINERS                                |  8 +++++++-
 drivers/gpu/drm/armada/armada_drv.c        | 10 +---------
 drivers/gpu/drm/bochs/Kconfig              |  1 +
 drivers/gpu/drm/i915/i915_drv.c            | 23 +++++++++--------------
 drivers/gpu/drm/i915/i915_gem_stolen.c     | 19 ++++++++++++++++---
 drivers/gpu/drm/i915/intel_display.c       |  8 ++++----
 drivers/gpu/drm/i915/intel_hdmi.c          |  6 +++---
 drivers/gpu/drm/i915/intel_panel.c         |  4 ++--
 drivers/gpu/drm/i915/intel_pm.c            |  6 ++++--
 drivers/gpu/drm/radeon/atombios_encoders.c |  2 +-
 drivers/gpu/drm/radeon/cik.c               |  5 +++--
 drivers/gpu/drm/radeon/evergreen.c         |  3 ++-
 drivers/gpu/drm/radeon/evergreen_smc.h     |  2 +-
 drivers/gpu/drm/radeon/ni.c                |  3 ++-
 drivers/gpu/drm/radeon/r100.c              |  2 --
 drivers/gpu/drm/radeon/r300.c              |  2 --
 drivers/gpu/drm/radeon/r420.c              |  2 --
 drivers/gpu/drm/radeon/r520.c              |  2 --
 drivers/gpu/drm/radeon/r600.c              |  3 ++-
 drivers/gpu/drm/radeon/radeon_device.c     |  5 ++++-
 drivers/gpu/drm/radeon/radeon_ttm.c        |  5 ++++-
 drivers/gpu/drm/radeon/rs400.c             |  2 --
 drivers/gpu/drm/radeon/rs600.c             |  2 --
 drivers/gpu/drm/radeon/rs690.c             |  2 --
 drivers/gpu/drm/radeon/rv515.c             |  2 --
 drivers/gpu/drm/radeon/rv770.c             |  3 ++-
 drivers/gpu/drm/radeon/si.c                |  3 ++-
 27 files changed, 70 insertions(+), 65 deletions(-)
--29444707-1493505853-1394152714=:25778--
