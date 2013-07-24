Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab3GXDo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:44:56 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36203 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3GXDoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:44:55 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: koba@kmckk.co.jp, Magnus Damm <magnus.damm@gmail.com>, horms@verge.net.au,
        linux-sh@vger.kernel.org
Date: Wed, 24 Jul 2013 12:45:03 +0900
Message-Id: <20130724034503.30609.21892.sendpatchset@w520>
Subject: [PATCH] ARM: shmobile: sh73a0: add PMU information to sh73a0.dtsi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add PMU information to sh73a0.dtsi. With this
included KZM9G DT reference may use the PMU.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/boot/dts/sh73a0.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

--- 0001/arch/arm/boot/dts/sh73a0.dtsi
+++ work/arch/arm/boot/dts/sh73a0.dtsi	2013-07-24 04:12:57.000000000 +0900
@@ -38,6 +38,12 @@
 		      <0xf0000100 0x100>;
 	};
 
+	pmu {
+		compatible = "arm,cortex-a9-pmu";
+		interrupts = <0 55 4>,
+			     <0 56 4>;
+	};
+
 	irqpin0: irqpin@e6900000 {
 		compatible = "renesas,intc-irqpin";
 		#interrupt-cells = <2>;
