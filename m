Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaLBIxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:53:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaLBIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:10 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-ce-547d7d3741ac
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/19] arm64: dts: exynos: Add MSHC dt node for Exynos5433
Date: Tue, 02 Dec 2014 17:49:52 +0900
Message-id: <1417510196-6714-16-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkWNeitjbE4NVTRovHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGV8mvCA
	reCPUEVH51v2BsZ+/i5GTg4JAROJEyeeMkPYYhIX7q1nA7GFBJYySszuCoOpOf5lJnsXIxdQ
	fDpQfAOM08Qk8eDGBkaQKjYBLYn9L26AdYsIOEs0TG1kAiliFnjDLLHn/m4WkISwgJfEiduH
	mEBsFgFViSOLdrGC2LwCrhKr729jh1inILFs+UywOCdQvOtMHzvESS4Sv1o/gm2WEJjIIfG+
	7z8jxCABiW+TDwEt4ABKyEpsOgD1jqTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKJXnJhbXJqX
	rpecn7uJERiPp/89m7CD8d4B60OMAhyMSjy8J87XhAixJpYVV+YeYjQF2jCRWUo0OR8Y9Xkl
	8YbGZkYWpiamxkbmlmZK4ryvpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBM3/m9qzCq
	9YK6Q573ka6i1IKjN46oOGUIi311E/9pw3jF+YFczpUpii0xjSq9cn9m3X/HnBv3pjWyLLW8
	PV5JpezTDt2jNyoq7y1aymjU9Ik92OhUf+u5NcvDj8wL3pX99Z5a+BNmJXEZe/fIz2E1i1gm
	ptbblx558KFMn+XDVHEBF07NuUosxRmJhlrMRcWJALU7Sa3CAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQV3z2toQg+9tRhaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYv6Rc6wWfya0sllMuj+BxeLGrzZWi94FV9kszja9YbfY9Pgaq8Xl
	XXPYLGac3wfUf+cfm8XS6xeZLE5d/8xmsWjrF3aLw2/aWS1mTH7JZrFq1x9Gi5cfT7A4iHms
	mbeG0eP3r0mMHjtn3WX32Lyk3uPKiSZWj74tqxg9Pm+SC2CPamC0yUhNTEktUkjNS85PycxL
	t1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAF6TUmhLDGnFCgUkFhcrKRvh2lCaIib
	rgVMY4Sub0gQXI+RARpIWMOY8WnCA7aCP0IVHZ1v2RsY+/m7GDk5JARMJI5/mckOYYtJXLi3
	nq2LkYtDSGA6o8TsDSAJEKeJSeLBjQ2MIFVsAloS+1/cYAOxRQScJRqmNjKBFDELvGGW2HN/
	NwtIQljAS+LE7UNMIDaLgKrEkUW7WEFsXgFXidX3t0GtU5BYtnwmWJwTKN51pg8sLiTgIvGr
	9SP7BEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC4/2Z1A7GlQ0WhxgFOBiVeHhP
	nK8JEWJNLCuuzD3EKMHBrCTC+8u4NkSINyWxsiq1KD++qDQntfgQoynQVROZpUST84GpKK8k
	3tDYxMzI0sjc0MLI2FxJnPfGzdwQIYH0xJLU7NTUgtQimD4mDk6pBkbnnBUC4mxKKZoPW0us
	Cr5fO8voxDupd2fUrsKgfqm4iexKG/e8veJode2lu1x77qHTm6SmpSjPUJ/D28L1XeZLre++
	bSomBZb7Dbz/G2lOuf7B93Bv1KOSycaXrI9XaOw92eFUWbL+wUqLruOLJraFxe9dbhPfOS3t
	o2VD0mWrcNfu29LpVUosxRmJhlrMRcWJAOVuudENAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaehoon Chung <jh80.chung@samsung.com>

This patch adds MSHC (Mobile Storage Host Controller) dt node for Exynos5433
SoC. MSHC is an interface between the system the SD/MMC card.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos5433.dtsi | 42 ++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
index 5637086..fef9bbc 100644
--- a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
@@ -52,6 +52,9 @@
 		i2c9 = &hsi2c_9;
 		i2c10 = &hsi2c_10;
 		i2c11 = &hsi2c_11;
+		mshc0 = &mshc_0;
+		mshc1 = &mshc_1;
+		mshc2 = &mshc_2;
 	};
 
 	cpus {
@@ -502,6 +505,45 @@
 			status = "disabled";
 		};
 
+		mshc_0: mshc@15540000 {
+			compatible = "samsung,exynos7-dw-mshc-smu";
+			interrupts = <0 225 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x15540000 0x2000>;
+			clocks = <&cmu_fsys CLK_ACLK_MMC0>,
+				 <&cmu_fsys CLK_SCLK_MMC0>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x40>;
+			status = "disabled";
+		};
+
+		mshc_1: mshc@15550000 {
+			compatible = "samsung,exynos7-dw-mshc-smu";
+			interrupts = <0 226 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x15550000 0x2000>;
+			clocks = <&cmu_fsys CLK_ACLK_MMC1>,
+				 <&cmu_fsys CLK_SCLK_MMC1>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x40>;
+			status = "disabled";
+		};
+
+		mshc_2: mshc@15560000 {
+			compatible = "samsung,exynos7-dw-mshc-smu";
+			interrupts = <0 227 0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x15560000 0x2000>;
+			clocks = <&cmu_fsys CLK_ACLK_MMC2>,
+				 <&cmu_fsys CLK_SCLK_MMC2>;
+			clock-names = "biu", "ciu";
+			fifo-depth = <0x40>;
+			status = "disabled";
+		};
+
 		timer {
 			compatible = "arm,armv8-timer";
 			interrupts = <4 13 0xff01>,
-- 
1.8.5.5

