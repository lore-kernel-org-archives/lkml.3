Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbaGIPdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:33:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48330 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932306AbaGIPH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:28 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 19/34] ARM: at91/dt: evk-pro3: define slow crytal frequency
Date: Wed,  9 Jul 2014 17:06:47 +0200
Message-Id: <1404918422-7562-20-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define Telit EVK-PRO3 slow crystal frequency

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/evk-pro3.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/evk-pro3.dts b/arch/arm/boot/dts/evk-pro3.dts
index 4d829685fdfb..f72969efe6d7 100644
--- a/arch/arm/boot/dts/evk-pro3.dts
+++ b/arch/arm/boot/dts/evk-pro3.dts
@@ -15,6 +15,12 @@
 	model = "Telit EVK-PRO3 for Telit GE863-PRO3";
 	compatible = "telit,evk-pro3", "atmel,at91sam9260", "atmel,at91sam9";
 
+	clocks {
+		slow_xtal {
+			clock-frequency = <32768>;
+		};
+	};
+
 	ahb {
 		apb {
 			macb0: ethernet@fffc4000 {
-- 
1.9.1

