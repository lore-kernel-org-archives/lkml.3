Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaLWDS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:18:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33717 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaLWDSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:18:22 -0500
X-AuditID: cbfee68e-f79b46d000002b74-56-5498defbd6ca
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv5 5/9] ARM: dts: Add PPMU dt node for Exynos3250 SoC
Date: Tue, 23 Dec 2014 12:18:13 +0900
Message-id: <1419304697-14789-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSrPv73owQg6W/zS0er1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZH3bNYSp4IVbx68RrpgbGF4JdjJwcEgImElcaZ7BB2GISF+6tB7K5OIQEljJK
	HP0wiR2mqP/NGSaIxCJGialTXrFDOE1MEn8PfWUCqWIT0JLY/+IG2CgRARmJqxu3s4AUMQs0
	Mkt8WfYfrEhYwEWiYektZhCbRUBV4t3tFrAGXgFXib7Wd1DrFCSWLZ/JCmJzCrhJ/Jn3FMwW
	AqqZ2HEd7AwJgVvsEt/332KEGCQg8W3yIaBtHEAJWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKp
	BckFxUnpRUZ6xYm5xaV56XrJ+bmbGIERdPrfs74djDcPWB9iFOBgVOLh/XluRogQa2JZcWXu
	IUZToA0TmaVEk/OBcZpXEm9obGZkYWpiamxkbmmmJM6bIPUzWEggPbEkNTs1tSC1KL6oNCe1
	+BAjEwenVANj786SMFNvv0eZKp0cJQ7fmtjnbdfcuMQm+MG1z18DJpyL1SziPS/UnD5FSnGD
	6bTqiIvzXjVK5T3YwDTHfLv+zedX3aJ67sh4Lg47dtXr7OfGmLPblrJum7COh+Os7M/3Ff2y
	N6Xefg/aGHJu1dMcK9lj0Wcmzlib1S76eKHB1xdzsvjdLu0IUmIpzkg01GIuKk4EAD2g5z6b	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd3f92aEGKx6qWfxeM1iJovrX56z
	Wsw/co7VYtL9CSwWr18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVbt+sPowO+xZt4aRo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgi2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOllJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPFh1xymghdiFb9OvGZqYHwh2MXIySEh
	YCLR/+YME4QtJnHh3nq2LkYuDiGBRYwSU6e8Yodwmpgk/h76ClbFJqAlsf/FDTYQW0RARuLq
	xu0sIEXMAo3MEl+W/QcrEhZwkWhYeosZxGYRUJV4d7sFrIFXwFWir/UdO8Q6BYlly2eygtic
	Am4Sf+Y9BbOFgGomdlxnmsDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcHw+k97B
	uKrB4hCjAAejEg/vgjMzQoRYE8uKK3MPMUpwMCuJ8Kq3AoV4UxIrq1KL8uOLSnNSiw8xmgJd
	NZFZSjQ5H5g68kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGKfo
	u1ouLWPvVg+3fPvBa2pDqh/jVddK6R3cexRmzIyxM2ezfnLy5e/djVYSa11c5asf3nd8Inih
	l+Gi23Jnhhd7LnCyJ6g++zpxr9IM7tCHZ0Q2/gu+2LdPlcmVvz39lcz7SxM1rLjZr/znXzRv
	p0De/59y4XvUHPlsEmb9u35l+ZHTM1+vv63EUpyRaKjFXFScCAA0U+Pm5QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU (Platform Performance Monitoring Unit) dt node
to estimate the utilization of each IP in Exynos SoC throught DEVFREQ Event
subsystem.

This patch adds following PPMU dt nodes:
- PPMU_DMC0     0x106a0000
- PPMU_DMC1     0x106b0000
- PPMU_RIGHTBUS 0x112A0000
- PPMU_LEFTBUS  0x116A0000
- PPMU_CAMIF    0x11AC0000
- PPMU_LCD0     0x11E40000
- PPMU_FSYS     0x12630000
- PPMU_3D       0x13220000
- PPMU_MFC      0x13660000
- PPMU_CPU      0x106c0000

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 72 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index c743f60..f0322f2 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -529,6 +529,78 @@
 			compatible = "arm,cortex-a7-pmu";
 			interrupts = <0 18 0>, <0 19 0>;
 		};
+
+		ppmu_dmc0: ppmu_dmc0@106a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106a0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_dmc1: ppmu_dmc1@106b0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106b0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_cpu: ppmu_cpu@106c0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106c0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_rightbus: ppmu_rightbus@112a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x112a0000 0x2000>;
+			clocks = <&cmu CLK_PPMURIGHT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_leftbus: ppmu_leftbus0@116a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x116a0000 0x2000>;
+			clocks = <&cmu CLK_PPMULEFT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_camif: ppmu_camif@11ac0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11ac0000 0x2000>;
+			clocks = <&cmu CLK_PPMUCAMIF>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_lcd0: ppmu_lcd0@11e40000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11e40000 0x2000>;
+			clocks = <&cmu CLK_PPMULCD0>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_fsys: ppmu_fsys@12630000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x12630000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_g3d: ppmu_g3d@13220000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13220000 0x2000>;
+			clocks = <&cmu CLK_PPMUG3D>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_mfc: ppmu_mfc@13660000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13660000 0x2000>;
+			clocks = <&cmu CLK_PPMUMFC_L>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
 	};
 };
 
-- 
1.8.5.5

