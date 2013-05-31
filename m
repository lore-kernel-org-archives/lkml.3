Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3EaDLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:11:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:3087 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3EaDLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:11:39 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <wim@iguana.be>, <linux@arm.linux.org.uk>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>,
        <richard.genoud@gmail.com>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>, <jm.lin@atmel.com>
Subject: [PATCH 1/2] ARM: dts: add the watchdog nodes for at91 SoC
Date: Fri, 31 May 2013 11:10:02 +0800
Message-ID: <1369969802-7840-2-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369969802-7840-1-git-send-email-wenyou.yang@atmel.com>
References: <1369969744-3428-1-git-send-email-wenyou.yang@atmel.com>
 <1369969802-7840-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9x5, at91sam9n12

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/boot/dts/at91sam9n12.dtsi |    6 ++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  |    6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 8d25f88..7f92f07 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -423,6 +423,12 @@
 				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
 			};
+
+			watchdog@fffffe40 {
+				compatible = "atmel,at91sam9260-wdt";
+				reg = <0xfffffe40 0x10>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 1145ac3..1d32064 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -648,6 +648,12 @@
 				interrupts = <1 4 7>;
 				status = "disabled";
 			};
+
+			watchdog@fffffe40 {
+				compatible = "atmel,at91sam9260-wdt";
+				reg = <0xfffffe40 0x10>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
-- 
1.7.9.5

