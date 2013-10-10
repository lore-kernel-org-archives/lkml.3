Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3JJW0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:26:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41473 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab3JJW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:26:37 -0400
From: Sean Paul <seanpaul@chromium.org>
To: kgene.kim@samsung.com, dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        inki.dae@samsung.com
Cc: airlied@linux.ie, Sean Paul <seanpaul@chromium.org>
Subject: [PATCH v3 2/5] ARM: dts: Add dp-controller node to exynos5250-snow
Date: Thu, 10 Oct 2013 18:26:15 -0400
Message-Id: <1381443978-5654-3-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381443978-5654-1-git-send-email-seanpaul@chromium.org>
References: <1380839303-4834-1-git-send-email-seanpaul@chromium.org>
 <1381443978-5654-1-git-send-email-seanpaul@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dp-controller node to the exynos5250-snow board dts
file.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---

v2: Added dp-controller address to node (rebased on linux-next)
v3: Added status = "okay"

 arch/arm/boot/dts/exynos5250-snow.dts | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 28eea9b..f813644 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -186,6 +186,19 @@
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
+		status = "okay";
+	};
+
 	fimd: fimd@14400000 {
 		status = "okay";
 		display-timings {
-- 
1.8.4

