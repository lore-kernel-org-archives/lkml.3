Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3IUNHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 09:07:09 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57583 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3IUNHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 09:07:08 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [PATCH 2/3] Add cpuconfig nodes in dts for smp configure.
Date: Sat, 21 Sep 2013 21:05:15 +0800
Message-Id: <1379768716-11672-3-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379768716-11672-1-git-send-email-cinifr@gmail.com>
References: <1379768716-11672-1-git-send-email-cinifr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fan Rong <cinifr@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 999ff45..f745e0b 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -20,13 +20,13 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		cpu@0 {
+		cpu0: cpu@0  {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
 			reg = <0>;
 		};
 
-		cpu@1 {
+		cpu1: cpu@1 {
 			compatible = "arm,cortex-a7";
 			device_type = "cpu";
 			reg = <1>;
@@ -167,6 +167,11 @@
 		#size-cells = <1>;
 		ranges;
 
+		cpuconfig: cpuconfig@01c25c00 {
+			compatible = "allwinner,sun7i-a20-cpuconfig";
+			reg = <0x01c25c00 0x400>;
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun7i-a20-pinctrl";
 			reg = <0x01c20800 0x400>;
-- 
1.8.1.2

