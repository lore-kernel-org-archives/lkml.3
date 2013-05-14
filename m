Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab3ENPjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:39:10 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48319 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3ENPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:39:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: [PATCHv2 00/20] Cleanup irqchip_init calls
Date: Tue, 14 May 2013 17:38:33 +0200
Message-Id: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is a splitted up version of the patch I previously sent to
remove the explicit declaration of irqchip_init as the init_irq callback in
the machine descriptions.

Since it was a pretty tricky patch to merge, since it was touching a lot of
different platforms, I splitted it for each platforms, and rebased it on top
of 3.10-rc1.

The best way to merge it is probably that each one of us take into their tree
the patches that are relevant for our architecture and send them to arm-soc
later on.

Thanks,
Maxime

Changes from v1:
  - Removed the dead include of linux/irqchip.h
  - Splitted the shmobile changes into several patches

Maxime Ripard (20):
  ARM: sunxi: Remove init_irq declaration in machine description
  ARM: zynq: Remove init_irq declaration in machine description
  ARM: nomadik: Remove init_irq declaration in machine description
  ARM: picoxcell: Remove init_irq declaration in machine description
  ARM: shmobile: ape6evm: Remove init_irq declaration in machine
    description
  ARM: shmobile: kzm9g: Remove init_irq declaration in machine
    description
  ARM: shmobile: lager: Remove init_irq declaration in machine
    description
  ARM: shmobile: emev2: Remove init_irq declaration in machine
    description
  ARM: shmobile: r8a73a4: Remove init_irq declaration in machine
    description
  ARM: shmobile: r8a7790: Remove init_irq declaration in machine
    description
  ARM: shmobile: sh73a0: Remove init_irq declaration in machine
    description
  ARM: bcm281xx: Remove init_irq declaration in machine description
  ARM: spear: Remove init_irq declaration in machine description
  ARM: msm: Remove init_irq declaration in machine description
  ARM: mvebu: Remove init_irq declaration in machine description
  ARM: mxs: Remove init_irq declaration in machine description
  ARM: sirf: Remove init_irq declaration in machine description
  ARM: vexpress: Remove init_irq declaration in machine description
  ARM: virt: Remove init_irq declaration in machine description
  ARM: vt8500: Remove init_irq declaration in machine description

 arch/arm/mach-bcm/board_bcm.c                  | 2 --
 arch/arm/mach-msm/board-dt-8660.c              | 2 --
 arch/arm/mach-msm/board-dt-8960.c              | 2 --
 arch/arm/mach-mvebu/armada-370-xp.c            | 2 --
 arch/arm/mach-mxs/mach-mxs.c                   | 2 --
 arch/arm/mach-nomadik/cpu-8815.c               | 2 --
 arch/arm/mach-picoxcell/common.c               | 2 --
 arch/arm/mach-prima2/common.c                  | 4 ----
 arch/arm/mach-shmobile/board-ape6evm.c         | 2 --
 arch/arm/mach-shmobile/board-kzm9g-reference.c | 2 --
 arch/arm/mach-shmobile/board-lager.c           | 2 --
 arch/arm/mach-shmobile/setup-emev2.c           | 2 --
 arch/arm/mach-shmobile/setup-r8a73a4.c         | 2 --
 arch/arm/mach-shmobile/setup-r8a7790.c         | 2 --
 arch/arm/mach-shmobile/setup-sh73a0.c          | 2 --
 arch/arm/mach-spear/spear1310.c                | 2 --
 arch/arm/mach-spear/spear1340.c                | 2 --
 arch/arm/mach-spear/spear300.c                 | 2 --
 arch/arm/mach-spear/spear310.c                 | 2 --
 arch/arm/mach-spear/spear320.c                 | 2 --
 arch/arm/mach-spear/spear6xx.c                 | 2 --
 arch/arm/mach-sunxi/sunxi.c                    | 2 --
 arch/arm/mach-vexpress/v2m.c                   | 2 --
 arch/arm/mach-virt/virt.c                      | 2 --
 arch/arm/mach-vt8500/vt8500.c                  | 2 --
 arch/arm/mach-zynq/common.c                    | 2 --
 26 files changed, 54 deletions(-)

-- 
1.8.1.2

