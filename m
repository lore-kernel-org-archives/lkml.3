Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaHVOGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:06:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33569 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbaHVOG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:06:26 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/6] ARM: dts: OMAP5+: Fixes for pinctrl support 
Date: Fri, 22 Aug 2014 09:03:49 -0500
Message-ID: <1408716235-26164-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series add the missing dts changes needed for pinctrl to
finally work on OMAP5/DRA7.

This is part 6/6 series which eventually enables framework for
suspend-to-ram and cpuidle for OMAP5 and DRA7.

Depends on previous series for pinctrl and PRM fixes for
functionality, but is capable of continuing to provide older
functionality with older zImage

NOTE: Various hwmod and dts fixes for various other IP blocks are
still pending for complete suspend functionality.

Each of series is based on v3.17-rc1 and this specific series is available:
weblink: https://github.com/nmenon/linux-2.6-playground/commits/push/v3.17/dts-fixes

git repo: https://github.com/nmenon/linux-2.6-playground.git push/v3.17/dts-fixes

An complete integrated branch is available here: https://github.com/nmenon/linux-2.6-playground/commits/testing/v3.17/cpu-idle-suspend-dra7-omap5-framework

Nishanth Menon (6):
  ARM: dts: OMAP3+: Add PRM interrupt
  ARM: dts: OMAP5: switch to compatible pinctrl
  ARM: dts: DRA7: switch to compatible pinctrl
  ARM: dts: AM437x: switch to compatible pinctrl
  ARM: dts: OMAP5/DRA7: switch over to interrupts-extended property for
    UART
  ARM: dts: dra7-evm: Mark uart1 rxd as wakeup capable

 arch/arm/boot/dts/am4372.dtsi  |    4 +++-
 arch/arm/boot/dts/dra7-evm.dts |    2 ++
 arch/arm/boot/dts/dra7.dtsi    |   25 ++++++++++++++-----------
 arch/arm/boot/dts/omap3.dtsi   |    1 +
 arch/arm/boot/dts/omap4.dtsi   |    1 +
 arch/arm/boot/dts/omap5.dtsi   |   21 +++++++++++++--------
 6 files changed, 34 insertions(+), 20 deletions(-)

-- 
1.7.9.5

