Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3BEBZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:25:58 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44026 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3BEBZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:25:56 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: Add USBPHY device node for Exynos4412
Date: Tue,  5 Feb 2013 10:25:22 +0900
Message-Id: <1360027522-18196-2-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360027522-18196-1-git-send-email-tobetter@gmail.com>
References: <1360027522-18196-1-git-send-email-tobetter@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds USBPHY device node for Samsung's Exynos4412 SoC to
arch/arm/boot/dts/exynos4412.dtsi.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/boot/dts/exynos4412.dtsi |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
index 387aa27..c01d841 100644
--- a/arch/arm/boot/dts/exynos4412.dtsi
+++ b/arch/arm/boot/dts/exynos4412.dtsi
@@ -33,4 +33,17 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 	};
+
+	usbphy@125B0000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "samsung,exynos4412-usbphy";
+		reg = <0x125B0000 0x100>;
+		status = "disabled";
+		ranges;
+
+		usbphy-sys {
+			reg = <0x10020704 0xc>;
+		};
+	};
 };
-- 
1.7.10.4

