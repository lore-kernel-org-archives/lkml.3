Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3LBKN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:13:29 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:46501 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3LBKNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:13:09 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <jiri.prchal@aksignal.cz>,
        <b.brezillon@overkiz.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: add usart3 alias to dtsi
Date: Mon, 2 Dec 2013 11:13:06 +0100
Message-ID: <1385979186-29447-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alias was missing for SoC of the at91sam9x5 familly that embed USART3.
Preripheral node and pinctrl declarations are already in the
at91sam9x5_usart3.dtsi file.

Reported-by: Jiri Prchal <jiri.prchal@aksignal.cz>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9g25.dtsi | 4 ++++
 arch/arm/boot/dts/at91sam9x25.dtsi | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g25.dtsi b/arch/arm/boot/dts/at91sam9g25.dtsi
index 17b879990914..d4650b4e9ebb 100644
--- a/arch/arm/boot/dts/at91sam9g25.dtsi
+++ b/arch/arm/boot/dts/at91sam9g25.dtsi
@@ -14,6 +14,10 @@
 	model = "Atmel AT91SAM9G25 SoC";
 	compatible = "atmel,at91sam9g25", "atmel,at91sam9x5";
 
+	aliases {
+		serial4 = &usart3;
+	};
+
 	ahb {
 		apb {
 			pinctrl@fffff400 {
diff --git a/arch/arm/boot/dts/at91sam9x25.dtsi b/arch/arm/boot/dts/at91sam9x25.dtsi
index c2554219f7a4..aceee86f60eb 100644
--- a/arch/arm/boot/dts/at91sam9x25.dtsi
+++ b/arch/arm/boot/dts/at91sam9x25.dtsi
@@ -15,6 +15,10 @@
 	model = "Atmel AT91SAM9X25 SoC";
 	compatible = "atmel,at91sam9x25", "atmel,at91sam9x5";
 
+	aliases {
+		serial4 = &usart3;
+	};
+
 	ahb {
 		apb {
 			pinctrl@fffff400 {
-- 
1.8.2.2

