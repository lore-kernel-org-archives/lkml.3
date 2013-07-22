Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3GVKxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:53:09 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:60761 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab3GVKxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:53:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 07/22] ARM: exynos: Remove '0x's from Exynos4110 DTSI file
Date: Mon, 22 Jul 2013 11:52:26 +0100
Message-Id: <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
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
 arch/arm/boot/dts/exynos4210.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index b7f358a..53e2527 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -72,7 +72,7 @@
 		};
 	};
 
-	clock: clock-controller@0x10030000 {
+	clock: clock-controller@10030000 {
 		compatible = "samsung,exynos4210-clock";
 		reg = <0x10030000 0x20000>;
 		#clock-cells = <1>;
-- 
1.8.1.2

