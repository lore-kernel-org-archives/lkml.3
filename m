Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3LVRRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 12:17:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37669 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab3LVRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 12:17:48 -0500
Date: Sun, 22 Dec 2013 09:15:39 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] ARM: Fixes for 3.13-rc
Message-ID: <20131222171539.GA8271@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

arm-soc fixes pull request, Christmas edition 2013. No glögg included, sorry!

God Jul,


-Olof

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 95fcfa70f3bc4b3b82bf582fa5b24a39bdbd23ae:

  Merge tag 'renesas-fixes-for-v3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into fixes (2013-12-20 11:28:30 -0800)

----------------------------------------------------------------

ARM: SoC fixes for 3.13-rc

Much smaller batch of fixes this week.

Biggest one is a revert of an OMAP display change that removed some non-DT
pinmux code that was still needed for 3.13 to get DSI displays to work.

There's also a fix that resolves some misdescribed GPIO controller
resources on shmobile. The rest are mostly smaller fixes, a couple of
MAINTAINERS updates, etc.

----------------------------------------------------------------
Kevin Hilman (3):
      Merge tag 'keystone/maintainer-file' of git://git.kernel.org/.../ssantosh/linux-keystone into fixes
      Merge tag 'omap-for-v3.13/display-fix' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'renesas-fixes-for-v3.13' of git://git.kernel.org/.../horms/renesas into fixes

Laurent Pinchart (1):
      irqchip: renesas-intc-irqpin: Fix register bitfield shift calculation

Magnus Damm (1):
      ARM: shmobile: r8a7790: Fix GPIO resources in DTS

Santosh Shilimkar (2):
      MAINTAINERS: Add keystone git tree information
      MAINTAINERS: Add keystone clock drivers

Simon Horman (1):
      ARM: shmobile: lager: phy fixup needs CONFIG_PHYLIB

Tomasz Figa (1):
      ARM: s3c64xx: dt: Fix boot failure due to double clock initialization

Tomi Valkeinen (1):
      Revert "ARM: OMAP2+: Remove legacy mux code for display.c"

 MAINTAINERS                               |  2 ++
 arch/arm/boot/dts/r8a7790.dtsi            | 24 +++++++++----------
 arch/arm/mach-omap2/display.c             | 38 +++++++++++++++++++++++++++++++
 arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c   | 11 +--------
 arch/arm/mach-shmobile/board-lager.c      |  4 +++-
 drivers/irqchip/irq-renesas-intc-irqpin.c |  8 ++++---
 6 files changed, 61 insertions(+), 26 deletions(-)
