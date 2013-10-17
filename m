Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3JQQjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:39:32 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54791 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3JQQja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:39:30 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [Add SMP support for Allwinner A20: PATCH V5 2/3] Add cpuconfig nodes in dts for smp configure.
Date: Fri, 18 Oct 2013 00:37:06 +0800
Message-Id: <1382027827-10080-3-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382027827-10080-1-git-send-email-cinifr@gmail.com>
References: <1382027827-10080-1-git-send-email-cinifr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpu Configure regiser can be used for reset and boot smp cpus in allwiner's A20.

Signed-off-by: Fan Rong <cinifr@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index e46cfed..6543b3f 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -270,6 +270,11 @@
 			reg = <0x01c23800 0x200>;
 		};
 
+		cpuconfig: cpuconfig@01c25c00 {
+			compatible = "allwinner,sun7i-a20-cpuconfig";
+			reg = <0x01c25c00 0x400>;
+		};
+
 		uart0: serial@01c28000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28000 0x400>;
-- 
1.8.1.2

