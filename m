Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab3GEQWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:22:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab3GEQWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:22:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Imre Kaloz <kaloz@openwrt.org>, Jason Cooper <jason@lakedaemon.net>,
        Krzysztof Halasa <khc@pm.waw.pl>, Kukjin Kim <kgene.kim@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 0/8] ARM: SoC specific bug fixes
Date: Fri,  5 Jul 2013 18:23:29 +0200
Message-Id: <1373041417-217728-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.1
X-Provags-ID: V02:K0:t45GXn5UK597zAXiwMWDe1ti3oH0sVj0IRT+oQUV0mX
 5bulCAh6izRXCWo3sJzYV8vrMnHPtS5IFtdsydA2Brps3j3K+J
 A44oaPdulRCuvozFLHR97lBxjLKhsERbA8Td4EjbJQ3Hy+NsB5
 jolHLe3yc02uE/pjGCPs4l1P0Ll+JtwFpTd63X1fXQUloAY6bK
 aoVKPZKG7m2SQMdjM4UTwHJp7Gao4OXq92rRSvW0kX9bgBx1vL
 uEi+Oxky6B1CwSL0zG8TaLm9JWNVM7PbEyaxoM82Y04mvmZ+p/
 cOnETMq1tnEpDWY46oDXF7Xb8uQTwl+4Pal70ERPGW9u9TrMET
 flshM6WbPhgDNawrRk7FwrhPLC6B3jOFjj7YapagM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is a set of bug fixes that came up during build testing.

I have applied them to the fixes branch for now and will send
them to Linus next week unless there are objections.

	Arnd

Arnd Bergmann (8):
  clocksource: armada-xp: always register local_timer_ops
  ARM: omap5: omap5 has SCU and TWD
  ARM: zynq: use DT_MACHINE_START
  ARM: OMAP: build mach-omap code only if needed
  ARM: sti: move DEBUG_STI_UART into alphabetical order
  ARM: OMAP: omap_common_late_init may be unused
  ARM: ixp4xx: avoid circular header dependency
  ARM: exynos: select PM_GENERIC_DOMAINS only when used

 arch/arm/Kconfig.debug                    |  20 ++--
 arch/arm/configs/omap2plus_defconfig      |   4 +
 arch/arm/mach-exynos/Kconfig              |   2 +-
 arch/arm/mach-ixp4xx/include/mach/timex.h |   2 +-
 arch/arm/mach-omap2/Kconfig               | 150 +++++++++++++++---------------
 arch/arm/mach-omap2/io.c                  |   2 +-
 arch/arm/mach-zynq/common.c               |   2 +-
 drivers/clocksource/time-armada-370-xp.c  |   2 -
 8 files changed, 94 insertions(+), 90 deletions(-)

Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Tony Lindgren <tony@atomide.com>

-- 
1.8.3.1

