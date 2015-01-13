Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbbAMSOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:14:22 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36634 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751954AbbAMSMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:12:39 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Bo Shen <voice.shen@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v3 1/6] ARM: at91/dt: at91sam9n12: Add RTC node
Date: Tue, 13 Jan 2015 19:12:21 +0100
Message-Id: <1421172746-18727-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421172746-18727-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421172746-18727-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add node for the RTC available on the at91sam9n12.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9n12.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 68eb9aded164..1d69db2e9e28 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -893,6 +893,13 @@
 				status = "disabled";
 			};
 
+			rtc@fffffeb0 {
+				compatible = "atmel,at91rm9200-rtc";
+				reg = <0xfffffeb0 0x40>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				status = "disabled";
+			};
+
 			pwm0: pwm@f8034000 {
 				compatible = "atmel,at91sam9rl-pwm";
 				reg = <0xf8034000 0x300>;
-- 
2.1.0

