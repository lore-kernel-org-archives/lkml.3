Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623Ab3GSOEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:04:42 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61738 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3GSN7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:59:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/22] ARM: ux500: Remove '0x's from U300 DTS file
Date: Fri, 19 Jul 2013 14:58:34 +0100
Message-Id: <1374242333-6852-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ste-u300.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/ste-u300.dts b/arch/arm/boot/dts/ste-u300.dts
index 8a1032c..a9da480 100644
--- a/arch/arm/boot/dts/ste-u300.dts
+++ b/arch/arm/boot/dts/ste-u300.dts
@@ -307,7 +307,7 @@
 		clocks = <&i2c0_clk>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		ab3100: ab3100@0x48 {
+		ab3100: ab3100@48 {
 			compatible = "stericsson,ab3100";
 			reg = <0x48>;
 			interrupt-parent = <&vica>;
@@ -385,10 +385,10 @@
 		clocks = <&i2c1_clk>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		fwcam0: fwcam@0x10 {
+		fwcam0: fwcam@10 {
 			reg = <0x10>;
 		};
-		fwcam1: fwcam@0x5d {
+		fwcam1: fwcam@5d {
 			reg = <0x5d>;
 		};
 	};
-- 
1.8.1.2

