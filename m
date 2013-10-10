Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3JJAad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:30:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33892 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3JJAa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:30:27 -0400
X-AuditID: cbfee68e-b7f756d000004512-dd-5255f50fdddb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/3] ARM: dts: exynos4x12: Add maudio/gps_alive power domain
 for exynos4x12
Date: Thu, 10 Oct 2013 09:30:07 +0900
Message-id: <1381365007-1782-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
References: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkRJf/a2iQwZxlahbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjigu
	m5TUnMyy1CJ9uwSujMt3XjIX9LJXrNp/nrmB8TdrFyMnh4SAicTn3pNsELaYxIV764FsLg4h
	gaWMEvenTgQq4gArurLBCyI+nVHiw/F/LBBOI5PEuf9f2UG62QS0JPa/uAHWLSLQziixunUB
	WBWzQCuTxNUtu5hBRgkLxEq0fQkCaWARUJWY8OkSM4jNK+AicWbJYnaIM+QkPux5BGZzCrhK
	vJnXBXaeEFBNQ/MJZoiaR+wSs5sdIeYISHybfIgF4lJZiU0HoEokJQ6uuMEygVF4ASPDKkbR
	1ILkguKk9CIjveLE3OLSvHS95PzcTYzAKDr971nfDsabB6wPMSYDjZvILCWanA+MwrySeENj
	MyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MFZf+W5vqv/+
	yzsXtZOfXmX9CgpTDXl85+X+aeuDtpX4Hb+/5I2ey0qhI79X7jlfwlvoqxPyffGs1+6fu7zK
	U7waSs6nBn7M0e89JcYidONCzKTjU0S8A9IXzdh9vdFpY9qMkKkqJ76qH2+eWxhuJNH8awNb
	9tfzBeEpVu2qJSFMyk+sG+p8jZVYijMSDbWYi4oTAfdyrce4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoC7/19Agg32N8hbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjqgG
	RpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLOVFMoS
	c0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmX77xkLuhlr1i1/zxzA+Nv1i5G
	Dg4JAROJKxu8uhg5gUwxiQv31rN1MXJxCAlMZ5T4cPwfC4TTyCRx7v9XdpAqNgEtif0vboBV
	iQi0M0qsbl0AVsUs0MokcXXLLmaQscICsRJtX4JAGlgEVCUmfLrEDGLzCrhInFmymB1inZzE
	hz2PwGxOAVeJN/O62EBsIaCahuYTzBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CI7SZ1I7GFc2WBxiFOBgVOLhrSgLDRJiTSwrrsw9xCjBwawkwjv9JFCINyWxsiq1KD++qDQn
	tfgQYzLQVROZpUST84EJJK8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJJanZqakFqUUw
	W5g4OKUaGI8VsN0w01xZVvP2Iud+h+ajZ7Zkr31jK9vWWrTvX/i2rNaN6dYTeibsm2FrIvFc
	71iEi7L2y91/1xyQ7jun4L/9wqJZGZLvte2MruWVa+y/0+c14fYTDhU2C0On1/e9hLzO/65S
	4TK0m/iuysfA5FaHe9xWudK6B6dTzvhH77l+qP/d3E+VfkosxRmJhlrMRcWJAJrihzAWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch maudio/gps_alive power domain to exynos4x12.dtsi.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index ad531fe..c04418e 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -35,6 +35,16 @@
 		reg = <0x10023CA0 0x20>;
 	};
 
+	pd_maudio: maudio-power-domain@10023CC0 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023CC0 0x20>;
+	};
+
+	pd_gps_alive: gps-alive-power-domain@10023D04 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023D00 0x20>;
+	};
+
 	clock: clock-controller@10030000 {
 		compatible = "samsung,exynos4412-clock";
 		reg = <0x10030000 0x20000>;
-- 
1.8.0

