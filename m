Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaDVBgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:36:16 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42290 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaDVBgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:36:10 -0400
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: xuwei5@hisilicon.com, linus.walleij@linaro.org, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        baruch@tkos.co.il
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH 2/2] ARM: dts: add gpio alias in hi3620 dts file
Date: Tue, 22 Apr 2014 09:35:43 +0800
Message-Id: <1398130543-19454-2-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
References: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio alias to identify the index of gpio chip. Then we can keep the
same gpio number as schematics. Otherwise, gpio number is countered from
bottom to top.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
---
 arch/arm/boot/dts/hi3620.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/hi3620.dtsi b/arch/arm/boot/dts/hi3620.dtsi
index 6836795..2aaae09 100644
--- a/arch/arm/boot/dts/hi3620.dtsi
+++ b/arch/arm/boot/dts/hi3620.dtsi
@@ -21,6 +21,28 @@
 		serial2 = &uart2;
 		serial3 = &uart3;
 		serial4 = &uart4;
+		gpio0 = &gpio0;
+		gpio1 = &gpio1;
+		gpio2 = &gpio2;
+		gpio3 = &gpio3;
+		gpio4 = &gpio4;
+		gpio5 = &gpio5;
+		gpio6 = &gpio6;
+		gpio7 = &gpio7;
+		gpio8 = &gpio8;
+		gpio9 = &gpio9;
+		gpio10 = &gpio10;
+		gpio11 = &gpio11;
+		gpio12 = &gpio12;
+		gpio13 = &gpio13;
+		gpio14 = &gpio14;
+		gpio15 = &gpio15;
+		gpio16 = &gpio16;
+		gpio17 = &gpio17;
+		gpio18 = &gpio18;
+		gpio19 = &gpio19;
+		gpio20 = &gpio20;
+		gpio21 = &gpio21;
 	};
 
 	pclk: clk {
-- 
1.9.1

