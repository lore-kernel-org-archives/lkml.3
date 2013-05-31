Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3EaTqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:46:32 -0400
Received: from 9.mo4.mail-out.ovh.net ([46.105.40.176]:46955 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757276Ab3EaTqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:46:18 -0400
Date: Fri, 31 May 2013 21:42:09 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PULL] FBDEV: some small fixes for 3.10-rc4
Message-ID: <20130531194209.GS19468@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 18304317737628969786
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

	This contain some small fixes for Atmel LCDC, ps3fb and OMAPDSS

please pull
The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/plagnioj/linux-fbdev.git tags/fbdev-for-3.10-rc4

for you to fetch changes up to 56c21b53ab071feb3ce93375a563ead745fa7105:

  atmel_lcdfb: blank the backlight on remove (2013-06-01 03:18:55 +0800)

----------------------------------------------------------------
fbdev: fixes for 3.10-rc4

This contains some small fixes

Atmel LCDC: fix blank the backlight on remove
ps3fb: fix compile warning
OMAPDSS: Fix crash with DT boot

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (1):
      Merge branch 'fbdev-3.10-fixes' of git://gitorious.org/linux-omap-dss2/linux into linux-fbdev/for-3.10-fixes

Richard Genoud (2):
      trivial: atmel_lcdfb: add missing error message
      atmel_lcdfb: blank the backlight on remove

Tomi Valkeinen (2):
      fbdev/ps3fb: fix compile warning
      OMAPDSS: Fix crash with DT boot

 drivers/gpu/drm/omapdrm/omap_drv.c       |    3 +++
 drivers/media/platform/omap/omap_vout.c  |    3 +++
 drivers/video/atmel_lcdfb.c              |   15 ++++++++++++---
 drivers/video/omap2/dss/core.c           |   20 +++++++++++++++++++-
 drivers/video/omap2/omapfb/omapfb-main.c |    3 +++
 drivers/video/ps3fb.c                    |    2 +-
 include/video/omapdss.h                  |    1 +
 7 files changed, 42 insertions(+), 5 deletions(-)

Brest Regards,
J.
