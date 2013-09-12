Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3ILGxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:53:32 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63378 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab3ILGx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:53:29 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [PATCH 4/4] Add arch count timer node in dts for Allwinner A20(sunxi 7i).
Date: Thu, 12 Sep 2013 14:51:27 +0800
Message-Id: <1378968687-8200-5-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fan Rong <cinifr@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index bfedcb2..ce138f7 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -312,5 +312,14 @@
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
 	};
 };
-- 
1.7.9.5

