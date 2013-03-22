Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab3CVOmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:42:19 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:1629 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511Ab3CVOmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:42:17 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/at91sam9x5: add RTC node
Date: Fri, 22 Mar 2013 15:42:14 +0100
Message-ID: <1363963334-21870-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index d18aff5..7a32a3f 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -559,6 +559,13 @@
 					trigger-value = <0x6>;
 				};
 			};
+
+			rtc@fffffeb0 {
+				compatible = "atmel,at91rm9200-rtc";
+				reg = <0xfffffeb0 0x40>;
+				interrupts = <1 4 7>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
-- 
1.8.0

