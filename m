Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656AbaLKCyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:54:45 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:58387 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933176AbaLKCyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:54:44 -0500
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] ARM: at91/dt: sama5d4: fix the timer reg length
Date: Thu, 11 Dec 2014 10:54:33 +0800
Message-ID: <1418266473-30187-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second property of reg is the length, so correct it for timer.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 arch/arm/boot/dts/sama5d4.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index 2cc3cfe..0901706 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -940,7 +940,7 @@
 
 			pit: timer@fc068630 {
 				compatible = "atmel,at91sam9260-pit";
-				reg = <0xfc068630 0xf>;
+				reg = <0xfc068630 0x10>;
 				interrupts = <3 IRQ_TYPE_LEVEL_HIGH 5>;
 				clocks = <&h32ck>;
 			};
-- 
2.1.0.24.g4109c28

