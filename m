Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3BCLSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:18:39 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:33686 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3BCLSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:18:37 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sunxi: dts: Report the pinctrl nodes as gpio-controllers
Date: Sun,  3 Feb 2013 12:18:30 +0100
Message-Id: <1359890311-10110-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359889813-10029-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359889813-10029-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |    4 +++-
 arch/arm/boot/dts/sun5i-a13.dtsi |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index f99f60d..03d2b53 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -18,11 +18,13 @@
 	};
 
 	soc {
-		pinctrl@01c20800 {
+		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun4i-a10-pinctrl";
 			reg = <0x01c20800 0x400>;
+			gpio-controller;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			#gpio-cells = <3>;
 
 			uart0_pins_a: uart0@0 {
 				allwinner,pins = "PB22", "PB23";
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index e112189..945bfac 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -19,11 +19,13 @@
 	};
 
 	soc {
-		pinctrl@01c20800 {
+		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun5i-a13-pinctrl";
 			reg = <0x01c20800 0x400>;
+			gpio-controller;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			#gpio-cells = <3>;
 
 			uart1_pins_a: uart1@0 {
 				allwinner,pins = "PE10", "PE11";
-- 
1.7.10.4

