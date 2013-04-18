Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab3DRNBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:01:35 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:4386 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab3DRNBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:01:32 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <dgilbert@interlog.com>, <robertcnelson@gmail.com>,
        <tanzilli@acmesystems.it>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/5] ARM: at91/at91sam9x5.dtsi: add UART0/1 nodes
Date: Thu, 18 Apr 2013 15:01:11 +0200
Message-ID: <0209fb2e06ac4a81f614c8c3b8d7b154c52e8419.1366289869.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1366289869.git.nicolas.ferre@atmel.com>
References: <cover.1366289869.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 58747f3..2cc33fb 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -522,6 +522,24 @@
 				status = "disabled";
 			};
 
+			uart0: serial@f8040000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf8040000 0x200>;
+				interrupts = <15 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_uart0>;
+				status = "disabled";
+			};
+
+			uart1: serial@f8044000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf8044000 0x200>;
+				interrupts = <16 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_uart1>;
+				status = "disabled";
+			};
+
 			adc0: adc@f804c000 {
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xf804c000 0x100>;
-- 
1.8.0

