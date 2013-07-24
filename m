Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3GXD7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:59:04 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60068 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3GXD7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:59:01 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, horms@verge.net.au,
        kuninori.morimoto.gx@renesas.com, linux-sh@vger.kernel.org
Date: Wed, 24 Jul 2013 12:59:09 +0900
Message-Id: <20130724035909.30648.64982.sendpatchset@w520>
Subject: [PATCH] ARM: shmobile: r8a7740: add PMU information to r8a7740.dtsi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add PMU information to r8a7740.dtsi. With this
included Armadillo800eva DT reference may use the PMU.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Dry coded based on data sheet, not runtime tested.

 arch/arm/boot/dts/r8a7740.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

--- 0001/arch/arm/boot/dts/r8a7740.dtsi
+++ work/arch/arm/boot/dts/r8a7740.dtsi	2013-07-24 04:20:42.000000000 +0900
@@ -32,6 +32,11 @@
 		      <0xc2000000 0x1000>;
 	};
 
+	pmu {
+		compatible = "arm,cortex-a9-pmu";
+		interrupts = <0 83 4>;
+	};
+
 	/* irqpin0: IRQ0 - IRQ7 */
 	irqpin0: irqpin@e6900000 {
 		compatible = "renesas,intc-irqpin";
