Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab3GVK5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:57:13 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:40296 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab3GVKxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:53:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 11/22] ARM: dts: Remove '0x's from Exynos5440 DTS file
Date: Mon, 22 Jul 2013 11:52:30 +0100
Message-Id: <1374490361-25769-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/exynos5440.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index ff7f5d8..0cedba4 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -20,7 +20,7 @@
 		spi0 = &spi_0;
 	};
 
-	clock: clock-controller@0x160000 {
+	clock: clock-controller@160000 {
 		compatible = "samsung,exynos5440-clock";
 		reg = <0x160000 0x1000>;
 		#clock-cells = <1>;
-- 
1.8.1.2

