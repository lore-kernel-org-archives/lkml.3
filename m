Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3LJGmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:42:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46760 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3LJGmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:42:07 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-ef-52a6b7be8c4b
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH v11 4/4] ARM: dts: Exynos5420: Add device nodes for TMU blocks
Date: Tue, 10 Dec 2013 12:13:07 +0530
Message-id: <1386657787-21654-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
References: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSpbtv+7Igg3v/9SwaroZYbJyxntXi
	5SFNi/lHzrFarNn/k8mid8FVNovLu+awWXzuPcJoMeP8PiaLRdv+M1s8edjHZrF+xmsWBx6P
	nbPusnss3vOSyaNvyypGj+M3tjN5fN4kF8AaxWWTkpqTWZZapG+XwJVx8Mlp5oJ5ghXrF6s1
	MPbxdTFyckgImEg8/3uABcIWk7hwbz1bFyMXh5DAUkaJTY23GGGK5t3bzAqRmM4o0XN8LQuE
	08Mkcfr3KrB2NgEziYOLVrOD2CICMhJTr+wH62AWmM8kcejPWrCEsICfxLH+pWBjWQRUJZ71
	rgCzeQVcJSZ/+sQMsU5RovvZBDYQmxMo/vvVISYQW0jARWL3vh9gQyUE9rFLTH29khlikIDE
	t8mHgK7gAErISmw6ADVHUuLgihssExiFFzAyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQI
	jIvT/55N3MF4/4D1IcZkoHETmaVEk/OBcZVXEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxy8jfaDl5as7yZW8c44vvjd3WNrp/a7q2uWGwZ7z1B
	T9L/tujs/Vw84veW+2geZdeaNfv155BXOys279tT93CDZP7twvWRZfU/2+ZJfly862jtlR+y
	p2dtTzj0MV0zPEK+qpJX+Ob9LqHWY6ozgk7JFHduql23sF7q+/GrgX2+XmZZ2XddkvmUWIoz
	Eg21mIuKEwGXdpg2oQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQd1925cFGcz/rmLRcDXEYuOM9awW
	Lw9pWsw/co7VYs3+n0wWvQuusllc3jWHzeJz7xFGixnn9zFZLNr2n9niycM+Nov1M16zOPB4
	7Jx1l91j8Z6XTB59W1Yxehy/sZ3J4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hT
	MwNDXUNLC3MlhbzE3FRbJRefAF23zByg85QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYE
	wfUYGaCBhDWMGQefnGYumCdYsX6xWgNjH18XIyeHhICJxLx7m1khbDGJC/fWs3UxcnEICUxn
	lOg5vpYFwulhkjj9exULSBWbgJnEwUWr2UFsEQEZialX9rOCFDELzGeSOPRnLVhCWMBP4lj/
	UkYQm0VAVeJZ7wowm1fAVWLyp0/MEOsUJbqfTWADsTmB4r9fHWICsYUEXCR27/vBOoGRdwEj
	wypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Kh7JrWDcWWDxSFGAQ5GJR7eAoZlQUKsiWXF
	lbmHGCU4mJVEeD3rgEK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD0wIeSXxhsYm5qbGppYm
	FiZmlqQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA6D9T46RKVU31Nw5beYvM5Eehk3jV
	0uT11RfU7sxSfLjE901pXO8GviTtbKbp31bd+ZnDPql3sdHT9KaXr98dO9mY9mb5btvPSecm
	vxDksnh2/cEHgxWdW5eIbZzexdpVemHugj1fhfI99lvOW10qkmVg4tQXl3x2Q8TTCkEuh8kG
	VrsL6wsilFiKMxINtZiLihMB9MRHSf4CAAA=
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
+		clock-names = "tmu_apbif", "tmu_apbif_triminfo";
+	};
+
+	tmu_cpu3:tmu@1006c000 {
+		compatible = "samsung,exynos5420-tmu-ext-triminfo";
+		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
+		interrupts = <0 185 0>;
+		clocks = <&clock 318>, <&clock 319>;
+		clock-names = "tmu_apbif", "tmu_apbif_triminfo";
+	};
+
+	tmu_gpu:tmu@100a0000 {
+		compatible = "samsung,exynos5420-tmu-ext-triminfo";
+		reg = <0x100a0000 0x100>, <0x10068000 0x4>;
+		interrupts = <0 215 0>;
+		clocks = <&clock 319>, <&clock 318>;
+		clock-names = "tmu_apbif", "tmu_apbif_triminfo";
+	};
 };
-- 
1.7.10.4

