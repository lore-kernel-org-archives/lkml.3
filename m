Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3IVMZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 08:25:21 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39466 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3IVMZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 08:25:20 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [PATCH V3: Add Smp support for Allwinner A20. 3/3] add arch count timer node in dts for Allwinner A20(sunxi 7i).
Date: Sun, 22 Sep 2013 20:21:28 +0800
Message-Id: <1379852488-32147-4-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fan Rong <cinifr@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index f745e0b..76b8c3f 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -312,5 +312,15 @@
 			#interrupt-cells = <3>;
 			interrupts = <1 9 0xf04>;
 		};
+
+		timer {
+			compatible ="arm,armv7-timer";
+			interrupts = <1 13 0x308>,
+				     <1 14 0x308>,
+				     <1 11 0x308>,
+				     <1 10 0x308>;
+			clock-frequency = <24000000>;
+		};
+
 	};
 };
-- 
1.8.1.2

