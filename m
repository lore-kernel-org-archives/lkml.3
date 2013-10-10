Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3JJW1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:27:51 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58387 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3JJW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:26:36 -0400
From: Sean Paul <seanpaul@chromium.org>
To: kgene.kim@samsung.com, dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        inki.dae@samsung.com
Cc: airlied@linux.ie, Sean Paul <seanpaul@chromium.org>
Subject: [PATCH v3 1/5] ARM: dts: Add fimd display-timings for exynos5250-snow
Date: Thu, 10 Oct 2013 18:26:14 -0400
Message-Id: <1381443978-5654-2-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381443978-5654-1-git-send-email-seanpaul@chromium.org>
References: <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
 <1381443978-5654-1-git-send-email-seanpaul@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the internal panel timings to the exynos5250-snow board
dts file.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---

v2: No difference
v3: Added status = "okay"

 arch/arm/boot/dts/exynos5250-snow.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index fd711e2..28eea9b 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -186,6 +186,24 @@
 		samsung,vbus-gpio = <&gpx1 1 0>;
 	};
 
+	fimd: fimd@14400000 {
+		status = "okay";
+		display-timings {
+			native-mode = <&lcd_timing>;
+			lcd_timing: 1366x768 {
+				clock-frequency = <70589280>;
+				hactive = <1366>;
+				vactive = <768>;
+				hfront-porch = <40>;
+				hback-porch = <40>;
+				hsync-len = <32>;
+				vback-porch = <10>;
+				vfront-porch = <12>;
+				vsync-len = <6>;
+			};
+		};
+	};
+
 	fixed-rate-clocks {
 		xxti {
 			compatible = "samsung,clock-xxti";
-- 
1.8.4

