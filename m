Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967976Ab3DSJfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:35:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19194 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3DSJfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:35:32 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/sama5d34ek.dts: remove not needed compatibility string
Date: Fri, 19 Apr 2013 11:35:29 +0200
Message-ID: <1366364129-15974-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"atmel,sama5ek" compatibility sting does not correspond to a
useful board configuration. This d35ek.dts is the only sama5d3
.dts file affected.

Reported-by: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d34ek.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d34ek.dts b/arch/arm/boot/dts/sama5d34ek.dts
index d2739f8..6bebfcd 100644
--- a/arch/arm/boot/dts/sama5d34ek.dts
+++ b/arch/arm/boot/dts/sama5d34ek.dts
@@ -12,7 +12,7 @@
 
 / {
 	model = "Atmel SAMA5D34-EK";
-	compatible = "atmel,sama5d34ek", "atmel,sama5ek", "atmel,sama5d3xmb", "atmel,sama5d3xcm", "atmel,sama5d3", "atmel,sama5";
+	compatible = "atmel,sama5d34ek", "atmel,sama5d3xmb", "atmel,sama5d3xcm", "atmel,sama5d3", "atmel,sama5";
 
 	ahb {
 		apb {
-- 
1.8.0

