Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaKPXVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 18:21:07 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44863 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaKPXVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 18:21:06 -0500
Date: Sun, 16 Nov 2014 15:21:06 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.18-rc5 (or rc6)
Message-ID: <20141116232106.GA16402@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I'm guessing you're about to cut -rc5 right as I type this. I'm sick
this weekend and didn't get around to it yesterday.

Anyway, none of these are crucial enough that they can't wait another
week for -rc6, if timing didn't work out.


Thanks,

-Olof

The following changes since commit 92c9e0c780e61f821ab8a08f0d4d4fd33ba1197c:

  ARM: dts: zynq: Enable PL clocks for Parallella (2014-11-08 16:57:44 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/armsoc-for-rc5

for you to fetch changes up to e899dbaf4898efdaf6d1a02ed4ac205d35f54df8:

  ARM: at91/dt: Fix sama5d3x typos (2014-11-16 15:12:04 -0800)

----------------------------------------------------------------
ARM: SoC fixes for 3.18-rc5

Another small set of fixes:

- Some DT compatible typo fixes
- irq setup fix dealing with irq storms on orion
- i2c quirk generalization for mvebu
- A handful of smaller fixes for OMAP
- A couple of added file patterns for OMAP entries in MAINTAINERS

----------------------------------------------------------------
Andrew Lunn (1):
      ARM: mvebu: armada xp: Generalize use of i2c quirk

Evgeniy Dushistov (1):
      ARM: orion: Fix for certain sequence of request_irq can cause irq storm

Felipe Balbi (1):
      MAINTAINERS: add more files under OMAP SUPPORT

Keerthy (3):
      ARM: dts: AM43x-EPOS-EVM: Fix DCDC3 voltage
      ARM: dts: AM437x-GP-EVM: Fix DCDC3 voltage
      ARM: dts: AM437x-SK-EVM: Fix DCDC3 voltage

Nishanth Menon (1):
      MAINTAINERS: Update entry for omap related .dts files to cover new SoCs

Olof Johansson (2):
      Merge tag 'mvebu-fixes-3.18' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'omap-fixes-against-v3.18-rc4' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Peter Rosin (1):
      ARM: at91/dt: Fix sama5d3x typos

Roger Quadros (2):
      ARM: dts: am335x-evm: Fix 5th NAND partition's name
      pinctrl: dra: dt-bindings: Fix output pull up/down

 MAINTAINERS                          | 20 ++++++++++++++++++++
 arch/arm/boot/dts/am335x-evm.dts     |  2 +-
 arch/arm/boot/dts/am437x-gp-evm.dts  |  4 ++--
 arch/arm/boot/dts/am437x-sk-evm.dts  |  4 ++--
 arch/arm/boot/dts/am43x-epos-evm.dts |  4 ++--
 arch/arm/boot/dts/sama5d31.dtsi      |  2 +-
 arch/arm/boot/dts/sama5d33.dtsi      |  2 +-
 arch/arm/boot/dts/sama5d34.dtsi      |  2 +-
 arch/arm/boot/dts/sama5d35.dtsi      |  2 +-
 arch/arm/boot/dts/sama5d36.dtsi      |  2 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi    |  2 +-
 arch/arm/mach-mvebu/board-v7.c       |  2 +-
 arch/arm/plat-orion/gpio.c           | 36 ++++++++++++++++++++++++++++++++----
 include/dt-bindings/pinctrl/dra.h    |  4 ++--
 14 files changed, 68 insertions(+), 20 deletions(-)
