Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbaD1QSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:18:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50052 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932118AbaD1QSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:18:16 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-pwm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 3/7] ARM: sun4i: dt: add pinmux configuration for the PWM
Date: Mon, 28 Apr 2014 18:17:10 +0200
Message-Id: <1398701834-3719-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398701834-3719-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398701834-3719-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the pinctrl descriptions for both PWM channels of the Allwinner A10.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 9174724571e2..109e796e4a69 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -477,6 +477,20 @@
 			#size-cells = <0>;
 			#gpio-cells = <3>;
 
+			pwm0_pins_a: pwm0@0 {
+				allwinner,pins = "PB2";
+				allwinner,function = "pwm";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			pwm1_pins_a: pwm1@0 {
+				allwinner,pins = "PI3";
+				allwinner,function = "pwm";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
 			uart0_pins_a: uart0@0 {
 				allwinner,pins = "PB22", "PB23";
 				allwinner,function = "uart0";
-- 
1.9.1

