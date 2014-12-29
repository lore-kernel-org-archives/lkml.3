Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaL2AFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 19:05:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36389 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaL2AEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 19:04:30 -0500
X-AuditID: cbfee691-f79b86d000004a5a-72-54a09a870b72
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
Subject: [PATCHv6 7/9] ARM: dts: Add PPMU dt node for Exynos5260 SoC
Date: Mon, 29 Dec 2014 09:04:11 +0900
Message-id: <1419811453-16160-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
References: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSrNs+a0GIwdNNyhaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGKxpJnb4vULQ4veBVfZLM42vWG32PT4GqvF5V1z2Cw+9x5htJhxfh+TxdLr
	F5ksbjeuYLN4vOItu8WqXX8YHQQ81sxbw+ixc9Zddo/Fe14yeWxeUu/Rt2UVo8fnTXIBbFFc
	NimpOZllqUX6dglcGRtmTGEp2C5dcbVvD2sD43HRLkZODgkBE4kvLf+ZIWwxiQv31rN1MXJx
	CAksZZT48OoMC0zR1cnTmCAS0xklbi5+zQzhNDFJ7N0yjRWkik1AS2L/ixtsILaIgIzE1Y3b
	WUCKmAVWMUu0Hl/BBJIQFnCRaJi8HWwfi4CqxJblL8HivAKuEgs3XmaDWKcgsWz5TLChnAJu
	EntO3ACrFwKqOf//ICvIUAmBR+wSC35OZoMYJCDxbfIhoG0cQAlZiU0HoP6RlDi44gbLBEbh
	BYwMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzECI+n0v2cTdzDeP2B9iFGAg1GJh3fCsfkh
	QqyJZcWVuYcYTYE2TGSWEk3OB8ZrXkm8obGZkYWpiamxkbmlmZI4r470z2AhgfTEktTs1NSC
	1KL4otKc1OJDjEwcnFINjJ4Vs7bEqMhx7DCKPPVz19v3GWX932yPfvypeCxoAZNMmGHhYQ9X
	VePzX70Us/9fkGz6Wvx26vpdx95XCYt+bfsQd9GtfNnmSVYVN/o9p90Qz+XO67+9bt3DbcFR
	M6VfvNEQ37up/pDniT7xLVw1FuGd7f4bTlgUzXPT//buvPxh1038SUvbJyqxFGckGmoxFxUn
	AgDqmweUnwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQd32WQtCDF5NkrJ4vGYxk8X1L89Z
	LeYfOcdqMen+BBaLJc3cFq9fGFr0LrjKZnG26Q27xabH11gtLu+aw2bxufcIo8WM8/uYLJZe
	v8hkcbtxBZvF4xVv2S1W7frD6CDgsWbeGkaPnbPusnss3vOSyWPzknqPvi2rGD0+b5ILYItq
	YLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpbSaEs
	MacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixYcYUloLt0hVX+/awNjAeF+1i
	5OSQEDCRuDp5GhOELSZx4d56ti5GLg4hgemMEjcXv2aGcJqYJPZumcYKUsUmoCWx/8UNNhBb
	REBG4urG7SwgRcwCq5glWo+vABslLOAi0TB5OzOIzSKgKrFl+UuwOK+Aq8TCjZfZINYpSCxb
	PhNsKKeAm8SeEzfA6oWAas7/P8g6gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg
	OH0mvYNxVYPFIUYBDkYlHt4Jx+aHCLEmlhVX5h5ilOBgVhLhNSpbECLEm5JYWZValB9fVJqT
	WnyI0RToqonMUqLJ+cAUklcSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fE
	wSnVwFigmKSR5i17QMqn/qvdvmeCMgeOLXj07lHmcs2uHwuM1BdrSYa6cO6fkXDD4dR6H4Ef
	h2yKxE/ay+psN2WMUfiafiirN3pFzfPCa4b3M/e7qUya8F5sX8XfqTW5HWWdV83Xqx2ZdHqu
	0O+W/Xvdi5R2pzgcnlC574r0Dss3lZ5PlQWeeTMXVyqxFGckGmoxFxUnAgDWrKow6QIAAA==
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

