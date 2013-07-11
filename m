Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab3GKDeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 23:34:05 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:31162 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab3GKDeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 23:34:00 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v2 3/3] arm: atmel: at91sam9n12: correct pin number of gpio-key
Date: Thu, 11 Jul 2013 11:30:46 +0800
Message-Id: <1373513446-18215-4-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373513446-18215-1-git-send-email-voice.shen@atmel.com>
References: <1373513446-18215-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

correct pin number of gpio-key for at91sam9n12ek board
the pioB4 is connect to LED, the pioB3 use as gpio-key

Signed-off-by: Bo Shen <voice.shen@atmel.com>

---
Changes in v2: None

 arch/arm/boot/dts/at91sam9n12ek.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index 7a95a28..3e86b05 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -137,7 +137,7 @@
 
 		enter {
 			label = "Enter";
-			gpios = <&pioB 4 GPIO_ACTIVE_LOW>;
+			gpios = <&pioB 3 GPIO_ACTIVE_LOW>;
 			linux,code = <28>;
 			gpio-key,wakeup;
 		};
-- 
1.7.9.5

