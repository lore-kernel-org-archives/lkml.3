Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3FOR2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 13:28:40 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45564 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3FOR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 13:28:38 -0400
Date: Sat, 15 Jun 2013 10:28:43 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.10-rc
Message-ID: <20130615172843.GA14339@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are a little later than I planned on since I got caught up with handling
merges for 3.11 most of the week. Details below.


Thanks,

-Olof

The following changes since commit 090878aa951628143f40a1acc19ec074a5ae9200:

  Merge tag 'mxs-fixes-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes (2013-06-07 18:19:40 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 323226bbb3d865af12644d66df2b7f161adf51c7:

  Merge tag 'fixes-3.10-4' of git://git.infradead.org/users/jcooper/linux into fixes (2013-06-11 17:05:56 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.10-rc

Another week, another batch of fixes for arm-soc platforms.

Again, nothing controversial. A few more than would be ideal, but all
are valid fixes. In particular the prima2 panic patch is critical since
it fixes a problem where multiplatform kernels panic on all but prima2
hardware.

----------------------------------------------------------------
Haojian Zhuang (1):
      ARM: prima2: fix incorrect panic usage

Jean-Philippe Francois (1):
      ARM: omap3: clock: fix wrong container_of in clock36xx.c

Kevin Hilman (1):
      ARM: dts: omap4-panda|sdp: Fix mux for twl6030 IRQ pin and msecure line

Lars Poeschel (1):
      ARM: dts: AM33xx: Fix properties on gpmc node

Nicolas Schichan (1):
      ARM: Kirkwood: handle mv88f6282 cpu in __kirkwood_variant().

Olof Johansson (2):
      Merge tag 'omap-for-v3.10/fixes-v3.10-rc4' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'fixes-3.10-4' of git://git.infradead.org/users/jcooper/linux into fixes

Suman Anna (1):
      ARM: dts: OMAP5: Fix missing PWM capability to timer nodes

Thomas Petazzoni (2):
      arm: omap2: fix AM33xx hwmod infos for UART2
      arm: mvebu: armada-xp-{gp,openblocks-ax3-4}: specify PCIe range

Tomasz Figa (1):
      ARM: SAMSUNG: pm: Adjust for pinctrl- and DT-enabled platforms

Tony Lindgren (3):
      ARM: OMAP3: Fix iva2_pwrdm settings for 3703
      Merge branch 'dts-fixes-for-3.10' of git://git.kernel.org/.../bcousson/linux-omap-dt into omap-for-v3.10/fixes
      Merge tag 'omap-fixes-b-for-3.10-rc' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.10/fixes

 arch/arm/boot/dts/am33xx.dtsi                    |  4 ++--
 arch/arm/boot/dts/armada-xp-gp.dts               |  5 +++--
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  5 +++--
 arch/arm/boot/dts/omap4-panda-common.dtsi        | 20 ++++++++++++++++++++
 arch/arm/boot/dts/omap4-sdp.dts                  | 20 ++++++++++++++++++++
 arch/arm/boot/dts/omap5.dtsi                     |  3 +++
 arch/arm/mach-kirkwood/mpp.c                     |  5 +++--
 arch/arm/mach-omap2/clock36xx.c                  | 18 +++++++++---------
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c       |  9 ++++++++-
 arch/arm/mach-omap2/pm34xx.c                     |  6 ++++--
 arch/arm/mach-prima2/pm.c                        |  6 ++++--
 arch/arm/mach-prima2/rstc.c                      |  6 ++++--
 arch/arm/plat-samsung/pm.c                       | 18 +++++++++++++-----
 13 files changed, 96 insertions(+), 29 deletions(-)
