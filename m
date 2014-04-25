Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaDYXDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:03:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48402 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaDYXDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:03:20 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 00/10] ARM: OMAP: dts and HWMOD entries for crypto modules
Date: Fri, 25 Apr 2014 18:02:38 -0500
Message-ID: <1398466968-29506-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony, Benoit,

Here are some dts/hwmod  patches for crypto on OMAP4 and DRA7, couple of them
are resends and some are sent for first time now that clock nodes are available
in dts.

If there's no other feedback, I would like these queued for v3.16. Thanks.

Patches 1,2 and 3 are dts, the rest are hwmod entries. The patches are rebased
on v3.15-rc2. and can pulled from the Git repo below:
https://github.com/joelagnel/linux-kernel.git (branch v3.16/prep-dts)

Joel Fernandes (9):
  ARM: OMAP: hwmod: Add SYSC offsets for AES IP
  ARM: DRA7xx: hwmod: Add hwmod data for DES IP
  ARM: DRA7xx: hwmod: Add hwmod data for AES IP
  ARM: DRA7xx: Add hwmod entries for RNG module
  ARM: OMAP4: hwmod: Add hwmod data for AES IP
  ARM: OMAP4: hwmod: add hwmod data for DES IP
  ARM: dts: DRA7: Add DT node for DES IP
  ARM: dts: DRA7: Add DT node for AES IP
  ARM: dts: OMAP4: Add clock nodes for AES/DES nodes

Lokesh Vutla (1):
  ARM: dts: OMAP4: clk: Add clk node for DES IP

 arch/arm/boot/dts/dra7.dtsi                  |   22 +++++
 arch/arm/boot/dts/omap4.dtsi                 |    4 +
 arch/arm/boot/dts/omap44xx-clocks.dtsi       |    8 ++
 arch/arm/mach-omap2/omap_hwmod.h             |   11 +++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c   |   78 ++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c    |  113 ++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_common_data.c |   10 +++
 drivers/clk/ti/clk-44xx.c                    |    1 +
 8 files changed, 247 insertions(+)

-- 
1.7.9.5

