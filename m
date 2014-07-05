Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaGEWNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 18:13:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58807 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaGEWNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 18:13:32 -0400
Date: Sat, 5 Jul 2014 23:13:27 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1407052310460.24632@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1137296181-1404598407=:24632"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1137296181-1404598407=:24632
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

i915, tda998x and vmwgfx fixes, the main one is i915 fix for missing VGA 
connectors, along with some fixes for the tda998x from Russell fixing some 
modesetting problems.

(still on holidays, but got a spare moment to find these).

Dave.

The following changes since commit e1a08b855f56d6528e7f85aae9ca8123f4c3ae04:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2014-07-05 10:12:52 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to dfd7aecfd6d227831d77719379d4c7137f444fee:

  Merge tag 'drm-intel-fixes-2014-07-03' of git://anongit.freedesktop.org/drm-intel (2014-07-06 07:49:59 +1000)

----------------------------------------------------------------

Dave Airlie (3):
      Merge branch 'tda998x-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox
      Merge branch 'vmwgfx-fixes-3.16' of git://people.freedesktop.org/~thomash/linux
      Merge tag 'drm-intel-fixes-2014-07-03' of git://anongit.freedesktop.org/drm-intel

Deepak S (1):
      drm/i915: Drop early VLV WA to fix Voltage not getting dropped to Vmin

Guido Martínez (1):
      drm/i2c: tda998x: move drm_i2c_encoder_destroy call

Jesse Barnes (1):
      drm/i915: only apply crt_present check on VLV

Russell King (2):
      drm/i2c: tda998x: faster polling for edid
      drm/i2c: tda998x: add some basic mode validation

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:

Ville Syrjälä (1):
      drm/i915: Wait for vblank after enabling the primary plane on BDW

 drivers/gpu/drm/i2c/tda998x_drv.c    | 12 +++++++++---
 drivers/gpu/drm/i915/intel_display.c | 27 ++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/intel_pm.c      |  8 ++++++++
 drivers/gpu/drm/i915/intel_sprite.c  |  8 ++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c   |  1 -
 5 files changed, 51 insertions(+), 5 deletions(-)
--29444707-1137296181-1404598407=:24632--
