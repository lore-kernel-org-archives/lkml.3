Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbaDWPaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:30:12 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59415 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbaDWP3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:29:49 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, stern@rowland.harvard.edu, balbi@ti.com,
        jg1.han@samsung.com, av.tikhomirov@samsung.com
Subject: [PATCH 3/3] dts: exynos5420-smdk5420: Add required VDD regulator supplies for usb
Date: Wed, 23 Apr 2014 20:59:29 +0530
Message-Id: <1398266969-26000-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398266969-26000-1-git-send-email-gautam.vivek@samsung.com>
References: <1398266969-26000-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add required VDD 3.3V and VDD 1.0V regulator supplies to usb nodes.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5420-smdk5420.dts |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-smdk5420.dts b/arch/arm/boot/dts/exynos5420-smdk5420.dts
index 96d99e1..323ce00 100644
--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
@@ -185,10 +185,30 @@
 		enable-active-high;
 	};
 
+	usb@12000000 {
+		vdd33-supply = <&ldo9_reg>;
+		vdd10-supply = <&ldo11_reg>;
+	};
+
 	phy@12100000 {
 		vbus-supply = <&usb300_vbus_reg>;
 	};
 
+	usb@12110000 {
+		vdd33-supply = <&ldo9_reg>;
+		vdd10-supply = <&ldo11_reg>;
+	};
+
+	usb@12120000 {
+		vdd33-supply = <&ldo9_reg>;
+		vdd10-supply = <&ldo11_reg>;
+	};
+
+	usb@12400000 {
+		vdd33-supply = <&ldo9_reg>;
+		vdd10-supply = <&ldo11_reg>;
+	};
+
 	phy@12500000 {
 		vbus-supply = <&usb301_vbus_reg>;
 	};
-- 
1.7.10.4

