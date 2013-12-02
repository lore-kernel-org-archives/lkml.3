Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3LBMxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:53:18 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:5477 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3LBMxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:53:15 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>, <jiri.prchal@aksignal.cz>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <b.brezillon@overkiz.com>
Subject: [PATCH v2] ARM: at91: add usart3 alias to dtsi
Date: Mon, 2 Dec 2013 13:53:13 +0100
Message-ID: <1385988793-1787-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1385979186-29447-1-git-send-email-nicolas.ferre@atmel.com>
References: <1385979186-29447-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alias was missing for SoC of the at91sam9x5 familly that embed USART3.

Reported-by: Jiri Prchal <jiri.prchal@aksignal.cz>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9x5_usart3.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
index 2347e9563cef..6801106fa1f8 100644
--- a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
@@ -11,6 +11,10 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 
 / {
+	aliases {
+		serial4 = &usart3;
+	};
+
 	ahb {
 		apb {
 			pinctrl@fffff400 {
-- 
1.8.2.2

