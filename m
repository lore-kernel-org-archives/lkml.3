Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbbAGXyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:54:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14581 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbbAGXvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:51:22 -0500
X-AuditID: cbfee691-f79b86d000004a5a-89-54adc678db05
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv7 06/10] ARM: dts: Add PPMU dt node for Exynos3250 SoC
Date: Thu, 08 Jan 2015 08:51:13 +0900
Message-id: <1420674677-3077-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
References: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSqFtxbG2IwakpfBaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgyth5tYOxYKF4xbL3lg2Mk4S6GDk5JARMJF50vWOFsMUkLtxb
	zwZiCwksZZTY8aAYpuZYx3bGLkYuoPgiRoktE1+yQDhNTBJTF89gB6liE9CS2P/iBli3iICe
	ROexPWBxZoE/TBJNm1hAbGEBN4kX1w6C2SwCqhLr554GquHg4BVwkZjSB3WEgsSy5TPBbE4B
	V4mlmxcyQxzkIvGy5xfYERICL9klru+cwwQxR0Di2+RDLCBzJARkJTYdYIaYIylxcMUNlgmM
	wgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBEbT6X/PJu5gvH/A+hCjAAejEg9vQd+a
	ECHWxLLiytxDjKZAGyYyS4km5wNjNq8k3tDYzMjC1MTU2Mjc0kxJnFdH+mewkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBkbXZ3bvPysmmfhcZZS7lPme9XtVzY7f8Y3sK1U5mKTSrFex3PfW
	OlITuWzVfgOBnXqb5jfI5i3+XrU95vummj/hCjuy97OH1OZFfInSWrTmxuMQ7tKDZt/s4lq6
	tc6EvN1/8qZcqWLGQ4/Ha206351ZOnn2X62qG59y2Q4VTzQpavZqvndY8aUSS3FGoqEWc1Fx
	IgAumFx/oQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAd2KY2tDDG72s1o8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGzqsdjAULxSuWvbds
	YJwk1MXIySEhYCJxrGM7I4QtJnHh3nq2LkYuDiGBRYwSWya+ZIFwmpgkpi6ewQ5SxSagJbH/
	xQ02EFtEQE+i89gesDizwB8miaZNLCC2sICbxItrB8FsFgFVifVzTwPVcHDwCrhITOljhVim
	ILFs+Uwwm1PAVWLp5oXMILYQUMnLnl+MExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P
	3cQIjtZnUjsYVzZYHGIU4GBU4uEt6FsTIsSaWFZcmXuIUYKDWUmEd23b2hAh3pTEyqrUovz4
	otKc1OJDjKZAR01klhJNzgcmkrySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU7NTUgtQi
	mD4mDk6pBkb+NVtmv1EP6PR1ZM5RMKloCMn47x1fdGuKeAz3quRvIo37zwbI3Vc6VS+/0e3I
	Do1N696y/db88FrS+dHfxVoF/r0fxfsevhTasf5nXv6Rf/fveiW/+Xq+Y1L9gSDjpluHWpyK
	uXm6Ft8zE81JuR2T/3Wvl8bD31cvzfne12qySWbNtYaAzHtKLMUZiYZazEXFiQBWeOnq7AIA	AA==
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

Cc: Kukjin Kim <kgene@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 74 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 2246549..9ed1260 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -515,6 +515,80 @@
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
+			clocks = <&cmu CLK_PPMUFILE>;
+			clock-names = "ppmu";
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

