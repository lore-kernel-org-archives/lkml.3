Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab3GSOAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:00:49 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55912 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760689Ab3GSN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:59:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 19/22] ARM: ux500: Remove '0x's from R8A7779 DTS file
Date: Fri, 19 Jul 2013 14:58:50 +0100
Message-Id: <1374242333-6852-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/r8a7779.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7779.dtsi b/arch/arm/boot/dts/r8a7779.dtsi
index 7f146c6..86bd487 100644
--- a/arch/arm/boot/dts/r8a7779.dtsi
+++ b/arch/arm/boot/dts/r8a7779.dtsi
@@ -65,7 +65,7 @@
 		sense-bitfield-width = <2>;
 	};
 
-	i2c0: i2c@0xffc70000 {
+	i2c0: i2c@ffc70000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		compatible = "renesas,rmobile-iic";
@@ -74,7 +74,7 @@
 		interrupts = <0 79 0x4>;
 	};
 
-	i2c1: i2c@0xffc71000 {
+	i2c1: i2c@ffc71000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		compatible = "renesas,rmobile-iic";
@@ -83,7 +83,7 @@
 		interrupts = <0 82 0x4>;
 	};
 
-	i2c2: i2c@0xffc72000 {
+	i2c2: i2c@ffc72000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		compatible = "renesas,rmobile-iic";
@@ -92,7 +92,7 @@
 		interrupts = <0 80 0x4>;
 	};
 
-	i2c3: i2c@0xffc73000 {
+	i2c3: i2c@ffc73000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		compatible = "renesas,rmobile-iic";
-- 
1.8.1.2

