Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaLPX2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:28:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43913 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaLPX1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:27:08 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-3a-5490bfc5a731
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCHv4 7/8] ARM: dts: Add PPMU dt node for Exynos5260 SoC
Date: Wed, 17 Dec 2014 08:26:56 +0900
Message-id: <1418772417-5164-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
References: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSrHt0/4QQg/O7TSwer1nMZHH9y3NW
	i/lHzrFaTLo/gcViSTO3xesXhha9C66yWZxtesNusenxNVaLy7vmsFl87j3CaDHj/D4mi6XX
	LzJZ3G5cwWbxeMVbdotVu/4wOgh4rJm3htFj56y77B6L97xk8ti8pN6jb8sqRo/Pm+QC2KK4
	bFJSczLLUov07RK4MjbMmMJSsF264mrfHtYGxuOiXYwcHBICJhLzXzh2MXICmWISF+6tZ+ti
	5OIQEljKKHH81gI2iISJxO/tUxkhEosYJaY9Pg2WEBJoYpK4fV0ZxGYT0JLY/+IGWFxEQEbi
	6sbtLCANzAKrmCVaj69gAkkIC7hIPLl5gx3EZhFQlXjfe5wZxOYFiv+4txxqm4LEsuUzWUFs
	TgFXiZYbq5kglrlIdF7dyQoyVELgEbvEseYPbBCDBCS+TT7EAvGOrMSmA8wQcyQlDq64wTKB
	UXgBI8MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMAoOv3v2YQdjPcOWB9iFOBgVOLhDSjs
	DxFiTSwrrsw9xGgKtGEis5Rocj4wVvNK4g2NzYwsTE1MjY3MLc2UxHlfS/0MFhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cDoLiaxkE9LJOrZc7driby7rP88W2aQYzbpYP1Ft1NprwM6nvJf
	Tw6XvrKrMf383O7aCJ1XxoVNfIef7FYo9HbcFOu9UJ2xpCC+VE116uyFTDau/IfDv7W5LNh0
	RJLb63rgNq6L1d0dP2XnLdu3M+rNM75Im+Nfd7TfPDhti39nu5y52JGAXw1KLMUZiYZazEXF
	iQCuuFxSnQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAd2j+yeEGFw/pm3xeM1iJovrX56z
	Wsw/co7VYtL9CSwWS5q5LV6/MLToXXCVzeJs0xt2i02Pr7FaXN41h83ic+8RRosZ5/cxWSy9
	fpHJ4nbjCjaLxyveslus2vWH0UHAY828NYweO2fdZfdYvOclk8fmJfUefVtWMXp83iQXwBbV
	wGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S2kkJZ
	Yk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjw4wpLAXbpSuu9u1hbWA8LtrF
	yMkhIWAi8Xv7VEYIW0ziwr31bF2MXBxCAosYJaY9Ps0GkhASaGKSuH1dGcRmE9CS2P/iBlhc
	REBG4urG7SwgDcwCq5glWo+vYAJJCAu4SDy5eYMdxGYRUJV433ucGcTmBYr/uLecDWKbgsSy
	5TNZQWxOAVeJlhurmSCWuUh0Xt3JOoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M
	4Ch9Jr2DcVWDxSFGAQ5GJR7ewML+ECHWxLLiytxDjBIczEoivBaLJoQI8aYkVlalFuXHF5Xm
	pBYfYjQFumois5Rocj4wgeSVxBsam5gZWRqZG1oYGZsrifMq2beFCAmkJ5akZqemFqQWwfQx
	cXBKNTAmMvnMmrqvy+20susjuzytgvWd9n/U3kWISE+UvLZlxpwPt+vmqAlMXHN3UqXs+5AV
	bMITTI+GH1pyt4zJM5dRP19c5KnfhdRZykuv/vvp+ejAFP+4nGn72iZ5VIRfdGIV0wyf/FS3
	5Ku+3IE8H4cLPA8l7AoEZqVcsyt8IfPy6IldC79P95mvxFKckWioxVxUnAgAKyE/kugCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds PPMU (Performance Profiling Monitoring Unit) dt node
Exynos5260 SoC.

Exynos5260 SoC has following PPMU IPs:
- PPMU_DREX0_S0 0x10c60000
- PPMU_DREX0_S1 0x10c70000
- PPMU_DREX1_S0 0x10c80000
- PPMU_DREX1_S1 0x10c90000
- PPMU_EAGLE    0x10cc0000
- PPMU_KFC      0x10cd0000
- PPMU_MFC      0x11040000
- PPMU_G3D      0x11880000
- PPMU_FSYS     0x12220000
- PPMU_ISP      0x13370000
- PPMU_FICM     0x13cb0000
- PPMU_GSCL     0x13e60000
- PPMU_MSCL     0x13ee0000
- PPMU_FIMD0X   0x145b0000
- PPMU_FIMD1X   0x145c0000

The drivers/devfreq/exynos/exynos5_bus.c supports the memory bus frequency/
voltage scaling of Exynos5260 SoC with DEVFREQ framework.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos5260.dtsi | 90 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5260.dtsi b/arch/arm/boot/dts/exynos5260.dtsi
index 36da38e..26f3074 100644
--- a/arch/arm/boot/dts/exynos5260.dtsi
+++ b/arch/arm/boot/dts/exynos5260.dtsi
@@ -307,6 +307,96 @@
 			fifo-depth = <64>;
 			status = "disabled";
 		};
+
+		ppmu_drex0_s0: ppmu_drex0_s0@10c60000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c60000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_drex0_s1: ppmu_drex0_s1@10c70000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c70000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_drex1_s0: ppmu_drex1_s0@10c80000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c80000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_drex1_s1: ppmu_drex1_s1@10c90000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c90000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_eagle: ppmu_eagle@10cc0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10cc0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_kfc: ppmu_kfc@10cd0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10cd0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_mfc: ppmu_mfc@11040000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11040000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_g3d: ppmu_g3d@11880000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11880000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fsys: ppmu_fsys@12220000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x12220000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_isp: ppmu_isp@13370000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13370000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fimc: ppmu_fimc@13cb0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13cb0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_gscl: ppmu_gscl@13e60000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13e60000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_mscl: ppmu_gscl@13ee0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13ee0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fimd0x: ppmu_fimd0x@145b0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x145b0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fimd1x: ppmu_fimd1x@145c0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x145c0000 0x2000>;
+			status = "disabled";
+		};
 	};
 };
 
-- 
1.8.5.5

