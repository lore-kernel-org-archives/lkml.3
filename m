Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3LSGGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:06:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9383 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3LSGGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:06:17 -0500
X-AuditID: cbfee690-b7f206d000000aee-54-52b28cd83b19
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH v12 4/4] ARM: dts: Exynos5420: Add device nodes for TMU blocks
Date: Thu, 19 Dec 2013 11:37:02 +0530
Message-id: <1387433222-7893-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
References: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSrXujZ1OQQXePpEXD1RCLjTPWs1q8
	PKRpMf/IOVaLNft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYLNbPeM3iwOOx
	c9Zddo/Fe14yefRtWcXocfzGdiaPz5vkAlijuGxSUnMyy1KL9O0SuDKObV/HVtAtVDH36mGW
	BsYXfF2MnBwSAiYS+3p+M0HYYhIX7q1n62Lk4hASWMoosWPfcyaYoourPjBBJKYzSnyft5sR
	wulhkji44ToLSBWbgJnEwUWr2UFsEQEZialX9rOCFDELzGeSOPRnLVhCWMBP4mjjP7CxLAKq
	Evd/TweL8wq4SDw+0c4KsU5RovvZBDYQm1PAVeL3q0Ng9UJANbv3/QAbKiGwj13i04XFbBCD
	BCS+TT4EdAUHUEJWYtMBZog5khIHV9xgmcAovICRYRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+
	7iZGYGSc/vdswg7GewesDzEmA42byCwlmpwPjKy8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUF
	CQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDMyJD8z7pAeHqgna7Cilkdqw+Yl1jqnVpkyHv5
	z0/tsC3PbJxXPTMLvrFao+yk4GGxqF8Kz4v1NreLTLzy9+ip/hkcUr8nZ/+U9pzTt2n2u84T
	L5+cLuw5xe946u+UPV2O92afKvr3OE193VOh3dtusq17JHvS9MKrzphbdmlFfZ/SLEPDk+cy
	K7EUZyQaajEXFScCAH2LzgKiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jQd0bPZuCDC7/57douBpisXHGelaL
	l4c0LeYfOcdqsWb/TyaL3gVX2Swu75rDZvG59wijxYzz+5gsFm37z2zx5GEfm8X6Ga9ZHHg8
	ds66y+6xeM9LJo++LasYPY7f2M7k8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjGPb17EVdAtVzL16mKWB8QVfFyMnh4SAicTFVR+YIGwxiQv31rN1MXJxCAlM
	Z5T4Pm83I4TTwyRxcMN1FpAqNgEziYOLVrOD2CICMhJTr+xnBSliFpjPJHHoz1qwhLCAn8TR
	xn9gY1kEVCXu/54OFucVcJF4fKKdFWKdokT3swlsIDangKvE71eHwOqFgGp27/vBOoGRdwEj
	wypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Lh7Jr2DcVWDxSFGAQ5GJR7egOcbg4RYE8uK
	K3MPMUpwMCuJ8F5h2RQkxJuSWFmVWpQfX1Sak1p8iDEZ6KqJzFKiyfnAlJBXEm9obGJuamxq
	aWJhYmZJmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxBjx5zeDrlrmtILRSbvZVnzlOm
	ja3tdjJThbt7BKZG1H1w8sjbUeMgHFoZVifBknzx5stv715s2irrvvtMzue5f1ve3DJPU7Pk
	m1l6oujS8Z+a/pZs/QwcD5q0Niie7NAz2DWX7Xn+/TX9+XOOepgofewV/2iZ5BvXvVk3e3UC
	2/NJGdeZfJRYijMSDbWYi4oTAe3EMUP/AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5420 SoC has per core thermal management unit.
5 TMU channels 4 for CPUs and 5th for GPU.

This patch adds the device tree nodes to the DT device list.

Nodes carry the misplaced second base address and the second
clock to access the misplaced base address.

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes since v11:
  changed the secondary clock name to "tmu_triminfo_apbif"
from "tmu_apbif_triminfo"

Changes since previous version:
1. used lables instead of comment lines
2. pass the same clock as trimfo_apbif clock for TMU channel 2

 arch/arm/boot/dts/exynos5420.dtsi |   40 +++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index b1fa334..c62cde6 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -402,4 +402,44 @@
 		clock-names = "gscl";
 		samsung,power-domain = <&gsc_pd>;
 	};
+
+	tmu_cpu0:tmu@10060000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10060000 0x100>;
+		interrupts = <0 65 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	tmu_cpu1:tmu@10064000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10064000 0x100>;
+		interrupts = <0 183 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	tmu_cpu2:tmu@10068000 {
+		compatible = "samsung,exynos5420-tmu-ext-triminfo";
+		reg = <0x10068000 0x100>, <0x1006c000 0x4>;
+		interrupts = <0 184 0>;
+		clocks = <&clock 318>, <&clock 318>;
+		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
+	};
+
+	tmu_cpu3:tmu@1006c000 {
+		compatible = "samsung,exynos5420-tmu-ext-triminfo";
+		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
+		interrupts = <0 185 0>;
+		clocks = <&clock 318>, <&clock 319>;
+		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
+	};
+
+	tmu_gpu:tmu@100a0000 {
+		compatible = "samsung,exynos5420-tmu-ext-triminfo";
+		reg = <0x100a0000 0x100>, <0x10068000 0x4>;
+		interrupts = <0 215 0>;
+		clocks = <&clock 319>, <&clock 318>;
+		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
+	};
 };
-- 
1.7.10.4

