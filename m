Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3EVHM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:12:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57595 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab3EVHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:12:26 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, KV Sujith <sujithkv@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 10/11] ARM: davinci: da850: add GPIO DT entries
Date: Wed, 22 May 2013 12:40:33 +0530
Message-ID: <1369206634-6778-11-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

Add DT entries for Davinci GPIO.

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/boot/dts/da850.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 452bdc6..9014eba 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -126,6 +126,15 @@
 				>;
 			};
 		};
+		gpio: gpio@1e26000 {
+			compatible = "ti,da830-gpio";
+			reg = <0x226000 0x1000>;
+			interrupts = <42>;
+			ngpio = <144>;
+			intc_irq_num = <101>;
+			gpio_unbanked = <0>;
+			status = "disabled";
+		};
 		serial0: serial@1c42000 {
 			compatible = "ns16550a";
 			reg = <0x42000 0x100>;
-- 
1.7.9.5

