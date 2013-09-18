Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3IRMPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:15:03 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:58975 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3IRMOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:14:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/41] ARM: ux500: Add PRCMU clock node to DBx500 Device Tree
Date: Wed, 18 Sep 2013 13:14:01 +0100
Message-Id: <1379506478-16625-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index a152945..2c64c85 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -10,6 +10,7 @@
  */
 
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/mfd/dbx500-prcmu.h>
 #include "skeleton.dtsi"
 
 / {
@@ -42,6 +43,14 @@
 			interrupts = <0 7 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		clocks {
+			compatible = "stericsson,u8500-clks";
+
+			prcmu_clk: prcmu-clock {
+				#clock-cells = <1>;
+			};
+		};
+
 		timer@a0410600 {
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xa0410600 0x20>;
-- 
1.8.1.2

