Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab3HHIqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:46:31 -0400
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:49114 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934006Ab3HHIq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:46:27 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 0/6] ARM: at91: use new at91 clks for samad3 SoCs
Date: Thu,  8 Aug 2013 10:46:12 +0200
Message-Id: <1375951572-10829-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 6605654754223552691
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series was formerly part of the
"ARM: at91: move to common clk framework" patch series.

It moves sama5d3 SoCs and boards to the new at91 clks (clk implementation
using common clk framework).

This patch series depends on following patch series (they must be applied in
this order):
1) "ARM: at91/dt: split sama5d3 definition" (v1)
2) "ARM: at91/dt: make use of periph id macros" (v2, not submitted yet)
3) "ARM: at91: move to common clk framework" (v3)

I will answer to this mail and join this patch series' dependencies in
attachments.

Best Regards,

Boris

Boris BREZILLON (6):
  ARM: at91: prepare sama5 dt boards transition to common clk
  ARM: at91: prepare common clk transition for sama5d3 SoC
  ARM: at91/dt: define sama5d3 clocks
  ARM: at91/dt: define sama5d3xek's main clk frequency
  ARM: at91: move sama5d3 SoC to common clk
  ARM: at91/dt: remove old main clk definition from sama5d3xcm.dtsi

 arch/arm/boot/dts/sama5d3.dtsi      |  331 ++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/sama5d3_can.dtsi  |   19 ++
 arch/arm/boot/dts/sama5d3_emac.dtsi |   12 ++
 arch/arm/boot/dts/sama5d3_gmac.dtsi |   12 ++
 arch/arm/boot/dts/sama5d3_lcd.dtsi  |   17 ++
 arch/arm/boot/dts/sama5d3_mci2.dtsi |   11 ++
 arch/arm/boot/dts/sama5d3_tcb1.dtsi |   12 ++
 arch/arm/boot/dts/sama5d3_uart.dtsi |   19 ++
 arch/arm/boot/dts/sama5d3xcm.dtsi   |   17 +-
 arch/arm/mach-at91/Kconfig          |    1 -
 arch/arm/mach-at91/board-dt-sama5.c |   10 +-
 arch/arm/mach-at91/sama5d3.c        |    6 +-
 12 files changed, 451 insertions(+), 16 deletions(-)

-- 
1.7.9.5

