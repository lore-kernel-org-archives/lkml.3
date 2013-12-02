Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3LBQKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:10:10 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:25348 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab3LBQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:10:07 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>
CC: <linux-kernel@vger.kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: add uart aliases to sama5d3 dtsi
Date: Mon, 2 Dec 2013 17:10:04 +0100
Message-ID: <1386000604-20829-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3_uart.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3_uart.dtsi b/arch/arm/boot/dts/sama5d3_uart.dtsi
index 49d4d76ca6f4..a9fa75e41652 100644
--- a/arch/arm/boot/dts/sama5d3_uart.dtsi
+++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
@@ -12,6 +12,11 @@
 #include <dt-bindings/clk/at91.h>
 
 / {
+	aliases {
+		serial5 = &uart0;
+		serial6 = &uart1;
+	};
+
 	ahb {
 		apb {
 			pinctrl@fffff200 {
-- 
1.8.2.2

