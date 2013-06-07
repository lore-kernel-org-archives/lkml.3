Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3FGLVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:21:46 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61426 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3FGLVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:21:40 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, patches@linaro.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/3] ARM: dts: exynos4210: Add LCD related pinctrl entries
Date: Fri,  7 Jun 2013 16:37:13 +0530
Message-Id: <1370603235-11193-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370603235-11193-1-git-send-email-tushar.behera@linaro.org>
References: <1370603235-11193-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Kamat <sachin.kamat@linaro.org>

Adds pinctrl entries required by FIMD.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi |   75 +++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-pinctrl.dtsi b/arch/arm/boot/dts/exynos4210-pinctrl.dtsi
index 55a2efb..d241726 100644
--- a/arch/arm/boot/dts/exynos4210-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos4210-pinctrl.dtsi
@@ -330,6 +330,81 @@
 			samsung,pin-pud = <3>;
 			samsung,pin-drv = <0>;
 		};
+
+		pwm0_out: pwm0-out {
+			samsung,pins = "gpd0-0";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		pwm1_out: pwm1-out {
+			samsung,pins = "gpd0-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		lcd_ctrl: lcd-ctrl {
+			samsung,pins = "gpd0-0", "gpd0-1";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		lcd_sync: lcd-sync {
+			samsung,pins = "gpf0-0", "gpf0-1";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		lcd_en: lcd-en {
+			samsung,pins = "gpe3-4";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		lcd_clk: lcd-clk {
+			samsung,pins = "gpf0-0", "gpf0-1", "gpf0-2", "gpf0-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		lcd_data16: lcd-data-width16 {
+			samsung,pins = "gpf0-7", "gpf1-0", "gpf1-1", "gpf1-2",
+					"gpf1-3", "gpf1-6", "gpf1-7", "gpf2-0",
+					"gpf2-1", "gpf2-2", "gpf2-3", "gpf2-7",
+					"gpf3-0", "gpf3-1", "gpf3-2", "gpf3-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		lcd_data18: lcd-data-width18 {
+			samsung,pins = "gpf0-6", "gpf0-7", "gpf1-0", "gpf1-1",
+					"gpf1-2", "gpf1-3", "gpf1-6", "gpf1-7",
+					"gpf2-0", "gpf2-1", "gpf2-2", "gpf2-3",
+					"gpf2-6", "gpf2-7", "gpf3-0", "gpf3-1",
+					"gpf3-2", "gpf3-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
+
+		lcd_data24: lcd-data-width24 {
+			samsung,pins = "gpf0-4", "gpf0-5", "gpf0-6", "gpf0-7",
+					"gpf1-0", "gpf1-1", "gpf1-2", "gpf1-3",
+					"gpf1-4", "gpf1-5", "gpf1-6", "gpf1-7",
+					"gpf2-0", "gpf2-1", "gpf2-2", "gpf2-3",
+					"gpf2-4", "gpf2-5", "gpf2-6", "gpf2-7",
+					"gpf3-0", "gpf3-1", "gpf3-2", "gpf3-3";
+			samsung,pin-function = <2>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	pinctrl@11000000 {
-- 
1.7.9.5

