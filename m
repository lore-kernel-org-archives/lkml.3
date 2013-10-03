Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3JCW3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:29:35 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:36011 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab3JCW2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:28:38 -0400
From: Sean Paul <seanpaul@chromium.org>
To: kgene.kim@samsung.com, dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        inki.dae@samsung.com
Cc: airlied@linux.ie, Sean Paul <seanpaul@chromium.org>
Subject: [PATCH v2 2/5] ARM: dts: Add dp-controller node to exynos5250-snow
Date: Thu,  3 Oct 2013 18:28:20 -0400
Message-Id: <1380839303-4834-3-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
 <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dp-controller node to the exynos5250-snow board dts
file.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---

v2: Added dp-controller address to node (rebased on linux-next)

 arch/arm/boot/dts/exynos5250-snow.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 2a0f0de..f1cf68e 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -186,6 +186,18 @@
 		samsung,vbus-gpio = <&gpx1 1 0>;
 	};
 
+	dp-controller@145B0000 {
+		samsung,color-space = <0>;
+		samsung,dynamic-range = <0>;
+		samsung,ycbcr-coeff = <0>;
+		samsung,color-depth = <1>;
+		samsung,link-rate = <0x0a>;
+		samsung,lane-count = <2>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&dp_hpd>;
+	};
+
 	fimd: fimd@14400000 {
 		display-timings {
 			native-mode = <&lcd_timing>;
-- 
1.8.4

