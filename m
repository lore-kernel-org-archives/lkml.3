Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3LTFKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:10:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49276 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3LTFKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:10:45 -0500
X-AuditID: cbfee68e-b7f566d000002344-17-52b3d14c7db6
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH v12 4/4] ARM: dts: Exynos5420: Add device nodes for TMU blocks
Date: Fri, 20 Dec 2013 10:41:21 +0530
Message-id: <1387516281-10273-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
References: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSpetzcXOQQWsPp0XD1RCLjTPWs1q8
	PKRpMf/IOVaLNft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYLNbPeM3iwOOx
	c9Zddo/Fe14yefRtWcXocfzGdiaPz5vkAlijuGxSUnMyy1KL9O0SuDL6Fy1gKzgsVPHux3mm
	BsaJ/F2MnBwSAiYSp/7+Y4GwxSQu3FvP1sXIxSEksJRR4vztH4xdjBxgRTdfBEHEFzFKLFz0
	hBHC6WGSeLDkJRNIN5uAmcTBRavZQWwRARmJqVf2s4IUMQvMZ5I49GctWEJYwE/iaOM/sAYW
	AVWJvYuuga3mFXCVWDHlJRvEGYoS3c8mgNmcQPHfrw6B1QsJuEjs3vcDbKiEwD52iYunNkMN
	EpD4NvkQC8SpshKbDjBDzJGUOLjiBssERuEFjAyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3
	MQLj4vS/Z307GG8esD7EmAw0biKzlGhyPjCu8kriDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhI
	ID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo/rPviWfnQPz/b4mzbvj5CJTaDvngNd0s+6N84x6
	ylpnV6n2FD+fsPKp3CSZuYnxDelnlwf9Orr8Xub+xz8DD1bHFqV/8rziGXN5v3HWDQ2h1Il6
	Xz7eypiwsXMO6wdj331GR2pLikNX/BbnWyLNXakpe3mX1R9Oj7W/+VeZynIvrZ4Zw1gbrMRS
	nJFoqMVcVJwIAKm6kkuhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAV3vi5uDDHpW2Fg0XA2x2DhjPavF
	y0OaFvOPnGO1WLP/J5NF74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzWL9jNcsDjwe
	O2fdZfdYvOclk0ffllWMHsdvbGfy+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jRv+iBWwFh4Uq3v04z9TAOJG/i5GDQ0LAROLmi6AuRk4gU0ziwr31bF2MXBxC
	AosYJRYuesII4fQwSTxY8pIJpIpNwEzi4KLV7CC2iICMxNQr+1lBipgF5jNJHPqzFiwhLOAn
	cbTxH1gDi4CqxN5F11hAbF4BV4kVU16yQaxTlOh+NgHM5gSK/351CKxeSMBFYve+H6wTGHkX
	MDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOumfSOxhXNVgcYhTgYFTi4S3Q3xwkxJpY
	VlyZe4hRgoNZSYQ3/iBQiDclsbIqtSg/vqg0J7X4EGMy0FUTmaVEk/OBCSGvJN7Q2MTc1NjU
	0sTCxMySNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilgOEcXmr8zmB69a6eSx73lzELyGdW
	6jK06QddSrYQE7maPce9m02ywfOfJZObve1e8Tehr8Rm39jpqKittqHr55UDaawbkoM2cuz8
	90X0r8KNL2dtFY5eMNig4eWUwhLB9Z/jWG38iXaPV6vVFffrn2etPWA1YW/+bK61t1ceybY4
	7nzpAL/ZIiWW4oxEQy3mouJEAJHNq+b+AgAA
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
3. Fixed a coding style problem pointed by Tomasz

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
+	tmu_cpu0: tmu@10060000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10060000 0x100>;
+		interrupts = <0 65 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	tmu_cpu1: tmu@10064000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10064000 0x100>;
+		interrupts = <0 183 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	tmu_cpu2: tmu@10068000 {
+		compatible = "samsung,exynos5420-tmu-ext-triminfo";
+		reg = <0x10068000 0x100>, <0x1006c000 0x4>;
+		interrupts = <0 184 0>;
+		clocks = <&clock 318>, <&clock 318>;
+		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
+	};
+
+	tmu_cpu3: tmu@1006c000 {
+		compatible = "samsung,exynos5420-tmu-ext-triminfo";
+		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
+		interrupts = <0 185 0>;
+		clocks = <&clock 318>, <&clock 319>;
+		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
+	};
+
+	tmu_gpu: tmu@100a0000 {
+		compatible = "samsung,exynos5420-tmu-ext-triminfo";
+		reg = <0x100a0000 0x100>, <0x10068000 0x4>;
+		interrupts = <0 215 0>;
+		clocks = <&clock 319>, <&clock 318>;
+		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
+	};
 };
-- 
1.7.10.4

