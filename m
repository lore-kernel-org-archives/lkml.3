Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaLPX2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:28:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62174 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaLPX1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:27:08 -0500
X-AuditID: cbfee68e-f79b46d000002b74-b9-5490bfc5b78b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv4 5/8] ARM: dts: Add PPMU dt node for Exynos3250 SoC
Date: Wed, 17 Dec 2014 08:26:54 +0900
Message-id: <1418772417-5164-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
References: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSqHt0/4QQg2ePVS0er1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZH3bNYSp4IVbx68RrpgbGF4JdjJwcEgImEotOdTNC2GISF+6tZ+ti5OIQEljK
	KHH/8hPmLkYOsKIb31Uh4osYJW6tvcAG0iAk0MQkcfu6MojNJqAlsf/FDbC4iICMxNWN21lA
	GpgFGpklviz7zwQySFjAReLDlhAQk0VAVWL793SQcl6g6MO2U0wQNyhILFs+kxXE5hRwlWi5
	sZoJYpWLROfVnawgIyUE7rFL/NrfB7aLRUBA4tvkQywQd8pKbDrADDFHUuLgihssExiFFzAy
	rGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIjJzT/5717WC8ecD6EKMAB6MSD29gYX+IEGti
	WXFl7iFGU6ANE5mlRJPzgfGZVxJvaGxmZGFqYmpsZG5ppiTOmyD1M1hIID2xJDU7NbUgtSi+
	qDQntfgQIxMHp1QDI/vOVa/mh0/5nSDlHFi7d0qTEOvM6E/CwSEv9317UfTYfYLRx+Sp90uv
	qgXf2ZqoeOyzOMdrz2Nrs3au32Vfxe94dF/kVfOfyat9p2nFVjnx3Ge5elr7c+IXi9prMver
	Jt06K2iY9+SJMd8+5dxdda9ELA7NZHH8/iK/2nhzS2R9+MHbcmzsv5VYijMSDbWYi4oTATlu
	PnKXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jAd2j+yeEGGx4J2PxeM1iJovrX56z
	Wsw/co7VYtL9CSwWr18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVbt+sPowO+xZt4aRo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgi2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOllJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPFh1xymghdiFb9OvGZqYHwh2MXIwSEh
	YCJx47tqFyMnkCkmceHeerYuRi4OIYFFjBK31l5gA0kICTQxSdy+rgxiswloSex/cQMsLiIg
	I3F143YWkAZmgUZmiS/L/jOBDBUWcJH4sCUExGQRUJXY/j0dpJwXKPqw7RQTxC4FiWXLZ7KC
	2JwCrhItN1YzQaxykei8upN1AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBcflM
	egfjqgaLQ4wCHIxKPLyBhf0hQqyJZcWVuYcYJTiYlUR4LRZNCBHiTUmsrEotyo8vKs1JLT7E
	aAp01ERmKdHkfGDKyCuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRq
	YCyLvMzI32UQu+Xa90lZ3he73z/d9TjZbevtCf0uTXe3Mx81vvo6/+2yzv8i/gZLjNfJWvwK
	ZFo9dcaJM99OlmvMY3vd7LyaZ0KUicTEeIH0es+m6kzptadjkub+vqT0sOJYP6e3+94NXdMM
	2u69vmLy7u0Lfn3VCGu9UlNe6QU/zxwpmrJvSbsSS3FGoqEWc1FxIgD9eD454QIAAA==
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

