Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3ILGxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:53:02 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63847 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab3ILGwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:52:51 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [PATCH 2/4] Add cpuconfig nodes in dts for smp configure.
Date: Thu, 12 Sep 2013 14:51:25 +0800
Message-Id: <1378968687-8200-3-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fan Rong <cinifr@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 999ff45..bfedcb2 100644
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
 
+		cc: cpuconfig@01c25c00 {
+			compatible = "allwinner,sun7i-cc";
+			reg = <0x01c25c00 0x400>;
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun7i-a20-pinctrl";
 			reg = <0x01c20800 0x400>;
-- 
1.7.9.5

