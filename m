Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbaGORC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:02:58 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61029 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbaGORCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:17 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arun Kumar K <arun.kk@samsung.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 62/94] ARM: dts: Add clock property for mfc_pd in exynos5420
Date: Tue, 15 Jul 2014 20:01:17 +0300
Message-Id: <1405443709-15288-62-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Kumar K <arun.kk@samsung.com>

Adding the optional clock property for the mfc_pd for
handling the re-parenting while pd on/off.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 79e9119..1595722 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -260,6 +260,9 @@
 	mfc_pd: power-domain@10044060 {
 		compatible = "samsung,exynos4210-pd";
 		reg = <0x10044060 0x20>;
+		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MOUT_SW_ACLK333>,
+			<&clock CLK_MOUT_USER_ACLK333>;
+		clock-names = "oscclk", "pclk0", "clk0";
 	};
 
 	disp_pd: power-domain@100440C0 {
-- 
1.7.10.4

