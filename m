Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3KLGg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:36:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:28049 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3KLGgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:36:18 -0500
X-AuditID: cbfee68f-b7f836d000001b39-0c-5281cc610f98
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH 4/4 v3] ARM: dts: Exynos5420: Add device nodes for TMU blocks
Date: Tue, 12 Nov 2013 12:07:48 +0530
Message-id: <1384238268-24671-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
References: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSp5t4pjHIoOOSgUXD1RCLjTPWs1q8
	PKRpMf/IOVaLNft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYLNbPeM3iwOOx
	c9Zddo/Fe14yefRtWcXocfzGdiaPz5vkAlijuGxSUnMyy1KL9O0SuDL2/Dcv+CFc0bz5GmsD
	43/+LkZODgkBE4muXS+YIGwxiQv31rOB2EICSxklXt1zhan5dvMdUA0XUHw6o8T3W43MEE4P
	k8SjlxfAOtgEzCQOLlrNDmKLCMhITL2ynxWkiFlgPpPEoT9rwRLCAr4SjZNamUFsFgFViZ83
	WlhAbF4BV4nz3Y1QZyhKdD+bADaUEyj++9UhJoiTXCR27/sBNlRCYB+7xKb5l9ghBglIfJt8
	CGgQB1BCVmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmBU
	nP73rH8H490D1ocYk4HGTWSWEk3OB0ZVXkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeW
	pGanphakFsUXleakFh9iZOLglGpgjFtw/L/lq/lcn5v6XTS37U/pjF+iUB03P1fC63635YqD
	Cz1YPj+sCpeZlBOdum7P80CT3C2CkybUzZqwtHh+wOXgzxvn7/Z3Wy1TNEUjy3XDsQyHB+xL
	N/+9fJRrpQPPowXBO3PrQp/t/zQnirF26WoBtQ6Hc/eqj60+N79YvfXSNx8JwXy2e0osxRmJ
	hlrMRcWJAPPCcoWgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQd3EM41BBqv+q1s0XA2x2DhjPavF
	y0OaFvOPnGO1WLP/J5NF74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzWL9jNcsDjwe
	O2fdZfdYvOclk0ffllWMHsdvbGfy+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxp7/5gU/hCuaN19jbWD8z9/FyMkhIWAi8e3mOyYIW0ziwr31bF2MXBxCAtMZ
	Jb7famSGcHqYJB69vMAGUsUmYCZxcNFqdhBbREBGYuqV/awgRcwC85kkDv1ZC5YQFvCVaJzU
	ygxiswioSvy80cICYvMKuEqc726EWqco0f1sAthQTqD471eHwOJCAi4Su/f9YJ3AyLuAkWEV
	o2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnDUPZPawbiyweIQowAHoxIP7w6uxiAh1sSy4src
	Q4wSHMxKIrzhi4FCvCmJlVWpRfnxRaU5qcWHGJOBrprILCWanA9MCHkl8YbGJuamxqaWJhYm
	ZpakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLgr63qPbXeZWA7/lvMb4ryLue6/t532
	b0bigqk/Twe17j/Bdmei4fcpk9//+WD7wWO+ov3xzpmveZzW9PXFmen/YdrNuWz1YsXAiW5d
	B1znbX70xrzugtOOxSr32MMZdoetrVGxb1kc+tjt4e9/T49onX+rPdtiUbrf9lYe9dkzG9JN
	dnz23flJiaU4I9FQi7moOBEA3lO7uP4CAAA=
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
Changes since v2:
3. uses the new compatible strings introduced along with adding
   support for Exynso5420.

Changes since v1:
1. Nodes carry the misplaced second base address and the second
   clock to access the misplaced base address.
2. Correct the clock number for the TMU4

 arch/arm/boot/dts/exynos5420.dtsi |   48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 6ffefd1..d736b40 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -369,4 +369,52 @@
 		clock-names = "gscl";
 		samsung,power-domain = <&gsc_pd>;
 	};
+
+	/* tmu for CPU0 */
+	tmu@10060000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10060000 0x100>;
+		interrupts = <0 65 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	/* tmu for CPU1 */
+	tmu@10064000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10064000 0x100>;
+		interrupts = <0 183 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	/* tmu for CPU2 */
+	tmu@10068000 {
+		compatible = "samsung,exynos5420-tmu-triminfo";
+		/* 2nd reg is for the misplaced TRIMINFO register */
+		reg = <0x10068000 0x100>, <0x1006c000 0x4>;
+		interrupts = <0 184 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	/* tmu for CPU3 */
+	tmu@1006c000 {
+		compatible = "samsung,exynos5420-tmu-triminfo-clk";
+		/* 2nd reg is for the misplaced TRIMINFO register */
+		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
+		interrupts = <0 185 0>;
+		clocks = <&clock 318>, <&clock 319>;
+		clock-names = "tmu_apbif", "tmu_apbif_triminfo";
+	};
+
+	/* tmu for GPU */
+	tmu@100a0000 {
+		compatible = "samsung,exynos5420-tmu-triminfo-clk";
+		/* 2nd reg is for the misplaced TRIMINFO register */
+		reg = <0x100a0000 0x100>, <0x10068000 0x4>;
+		interrupts = <0 215 0>;
+		clocks = <&clock 319>, <&clock 318>;
+		clock-names = "tmu_apbif", "tmu_apbif_triminfo";
+	};
 };
-- 
1.7.10.4

