Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3IJNBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:01:21 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40464 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3IJMtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:49:49 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/38] ARM: ux500: Remove PrimeCell IDs from Nomadik I2C DT nodes
Date: Tue, 10 Sep 2013 13:49:02 +0100
Message-Id: <1378817379-8238-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out that they're actually not required and the driver probes just
fine without them. The ID is incorrect at the moment anyway. They actually
currently specify the stn8815.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ste-dbx5x0.dtsi | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/ste-dbx5x0.dtsi b/arch/arm/boot/dts/ste-dbx5x0.dtsi
index 1c1091e..0c1338e 100644
--- a/arch/arm/boot/dts/ste-dbx5x0.dtsi
+++ b/arch/arm/boot/dts/ste-dbx5x0.dtsi
@@ -559,7 +559,6 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80004000 0x1000>;
 			interrupts = <0 21 IRQ_TYPE_LEVEL_HIGH>;
-			arm,primecell-periphid = <0x180024>;
 
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -572,7 +571,6 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80122000 0x1000>;
 			interrupts = <0 22 IRQ_TYPE_LEVEL_HIGH>;
-			arm,primecell-periphid = <0x180024>;
 
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -585,7 +583,6 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80128000 0x1000>;
 			interrupts = <0 55 IRQ_TYPE_LEVEL_HIGH>;
-			arm,primecell-periphid = <0x180024>;
 
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -598,7 +595,6 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80110000 0x1000>;
 			interrupts = <0 12 IRQ_TYPE_LEVEL_HIGH>;
-			arm,primecell-periphid = <0x180024>;
 
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -611,7 +607,6 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x8012a000 0x1000>;
 			interrupts = <0 51 IRQ_TYPE_LEVEL_HIGH>;
-			arm,primecell-periphid = <0x180024>;
 
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
1.8.1.2

