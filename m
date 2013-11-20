Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3KTH7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:59:11 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38364 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3KTH7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:59:06 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, horms@verge.net.au,
        linux-sh@vger.kernel.org
Date: Wed, 20 Nov 2013 16:59:48 +0900
Message-Id: <20131120075948.23557.47715.sendpatchset@w520>
In-Reply-To: <20131120075921.23557.23231.sendpatchset@w520>
References: <20131120075921.23557.23231.sendpatchset@w520>
Subject: [PATCH 03/05] ARM: shmobile: Add r8a7791 thermal device node to DTS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Hook up the r8a7791 thermal sensor to the DTS.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/boot/dts/r8a7791.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

--- 0001/arch/arm/boot/dts/r8a7791.dtsi
+++ work/arch/arm/boot/dts/r8a7791.dtsi	2013-11-20 16:00:29.000000000 +0900
@@ -145,6 +145,13 @@
 		interrupt-controller;
 	};
 
+	thermal@e61f0000 {
+		compatible = "renesas,thermal-r8a7791", "renesas,rcar-thermal";
+		reg = <0 0xe61f0000 0 0x14>, <0 0xe61f0100 0 0x38>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 69 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
 	timer {
 		compatible = "arm,armv7-timer";
 		interrupts = <1 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
