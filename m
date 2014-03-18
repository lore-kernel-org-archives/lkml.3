Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbaCRXQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:16:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39354 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757255AbaCRXQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:16:39 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/3] ARM: at91/dt: at91sam9m10g45ek: add ADC and touchscreen support
Date: Wed, 19 Mar 2014 00:15:40 +0100
Message-Id: <1395184541-5787-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395184541-5787-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395184541-5787-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9m10g45ek.dts | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
index 7ff665a8c708..7800931a4b16 100644
--- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -130,6 +130,21 @@
 				status = "okay";
 			};
 
+			adc0: adc@fffb0000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <
+					&pinctrl_adc0_ad0
+					&pinctrl_adc0_ad1
+					&pinctrl_adc0_ad2
+					&pinctrl_adc0_ad3
+					&pinctrl_adc0_ad4
+					&pinctrl_adc0_ad5
+					&pinctrl_adc0_ad6
+					&pinctrl_adc0_ad7>;
+				atmel,adc-ts-wires = <4>;
+				status = "okay";
+			};
+
 			pwm0: pwm@fffb8000 {
 				status = "okay";
 
-- 
1.8.3.2

