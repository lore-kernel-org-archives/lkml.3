Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3JaGuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:50:46 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41700 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3JaGuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:50:23 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, lee.jones@linaro.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH 4/4] ARM: dts: Add S5M8767 clock nodes on Arndale board
Date: Thu, 31 Oct 2013 12:18:44 +0530
Message-Id: <1383202124-1775-5-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
References: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/boot/dts/exynos5250-arndale.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index b77a37e..34b305d 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -70,6 +70,13 @@
 			s5m8767,pmic-buck-ds-gpios = <&gpx2 3 0>,
 							<&gpx2 4 0>,
 							<&gpx2 5 0>;
+
+			s5m8767_osc: clocks {
+				#clock-cells = <1>;
+				clock-output-names = "s5m8767_ap",
+						"s5m8767_cp", "s5m8767_bt";
+			};
+
 			regulators {
 				ldo1_reg: LDO1 {
 					regulator-name = "VDD_ALIVE_1.0V";
-- 
1.7.9.5

