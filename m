Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbaBFMIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:08:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25449 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaBFMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:08:15 -0500
X-AuditID: cbfee68f-b7f156d00000276c-9a-52f37b2ebbe5
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, taeggyun.ko@samsung.com, balbi@ti.com,
        cpgs@samsung.com, t.figa@samsung.com
Subject: [PATCH] ARM: DTS: exynos5420: Rename hsi2c compatible to
 exynos5250-hsi2c
Date: Thu, 06 Feb 2014 17:37:57 +0530
Message-id: <1391688477-8124-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSratX/TnIoHcnu8XB+/UWLw9pWhyY
	/ZDV4tWZjWwWvQuusllsenyN1aLj7xdGi8u75rBZzDi/j8li0bb/zBbrZ7xmsXjyHyi27/VW
	Zgdej52z7rJ7bF5S73F+xkJGj/6/Bh59W1Yxevx8qeNx/MZ2Jo/Pm+QCOKK4bFJSczLLUov0
	7RK4MhZc3sVesESwYtOKrcwNjJd4uxg5OSQETCSOL5vCAmGLSVy4t56ti5GLQ0hgKaPEknnt
	jDBF5yYcYoFILGKUeDLvHyuE088k8WHSGVaQKjYBM4mDi1azg9giAg4S89Z+ZwcpYhZYzCSx
	8v5ZsFHCAiESiz9vACtiEVCVaLu9C6yZV8BF4smFFcxdjBxA6xQk5kyyAemVEDjELnFk7QJW
	iHoBiW+TQc4AqZGV2HSAGeI6SYmDK26wTGAUXMDIsIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/
	dxMjMBJO/3vWv4Px7gHrQ4zJQOMmMkuJJucDIymvJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OC
	hATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAKegv9ZivY4xB/T9lsTrrCkVNHDt995l2ufnbf
	igtuHsWJXyZPeX3MrfLlMels9m9PGhnVo37JiJdrbeJad9o+iTH9x8TtyvbVrKqvl75OUT9d
	2v51RafbBv/Q0z9cHtz907eNVb9pSr32B+uXWqa3JNklPvtaT6v38TS//mTf6QMfZFuNp4gq
	sRRnJBpqMRcVJwIApPLzXZoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAV3d6s9BBseuWVkcvF9v8fKQpsWB
	2Q9ZLV6d2chm0bvgKpvFpsfXWC06/n5htLi8aw6bxYzz+5gsFm37z2yxfsZrFosn/4Fi+15v
	ZXbg9dg56y67x+Yl9R7nZyxk9Oj/a+DRt2UVo8fPlzoex29sZ/L4vEkugCOqgdEmIzUxJbVI
	ITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+heJYWyxJxSoFBAYnGx
	kr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGgsu72AuWCFZsWrGVuYHxEm8XIyeHhICJxLkJ
	h1ggbDGJC/fWs3UxcnEICSxilHgy7x8rhNPPJPFh0hlWkCo2ATOJg4tWs4PYIgIOEvPWfmcH
	KWIWWMwksfL+WUaQhLBAiMTizxvAilgEVCXabu8Ca+YVcJF4cmEFcxcjB9A6BYk5k2wmMHIv
	YGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcZ8+kdjCubLA4xCjAwajEw7th/acgIdbE
	suLK3EOMEhzMSiK8YgWfg4R4UxIrq1KL8uOLSnNSiw8xJgMtn8gsJZqcD0wBeSXxhsYm5qbG
	ppYmFiZmlqQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA2MUaPimkQfiZx+Ovf34ril5e
	8fuR6ZzDr1XybD7lODKf2PJrK2fxlue1GyQlH6/LnOluOX+qpMHikJDSvrfK6WxLGfruLHd7
	b27xI29Syr/KQ0yHnUQUGByEe6fM4ftcf+L+0qwDHxKfqEhKxu8/eaCU+WOu5lrGxFWizAyL
	/q8qn7+g7F6StBJLcUaioRZzUXEiALpkRF33AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the changes submitted for the i2c-exynos5.c driver with the
compatible string being named after the first SoC it is observed on.
This patch modifes the existing hsi2c compatible strings in
arch/arm/boot/dts.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 11dd202..c5187d1 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -486,7 +486,7 @@
 	};
 
 	hsi2c_4: i2c@12CA0000 {
-		compatible = "samsung,exynos5-hsi2c";
+		compatible = "samsung,exynos5250-hsi2c";
 		reg = <0x12CA0000 0x1000>;
 		interrupts = <0 60 0>;
 		#address-cells = <1>;
@@ -499,7 +499,7 @@
 	};
 
 	hsi2c_5: i2c@12CB0000 {
-		compatible = "samsung,exynos5-hsi2c";
+		compatible = "samsung,exynos5250-hsi2c";
 		reg = <0x12CB0000 0x1000>;
 		interrupts = <0 61 0>;
 		#address-cells = <1>;
@@ -512,7 +512,7 @@
 	};
 
 	hsi2c_6: i2c@12CC0000 {
-		compatible = "samsung,exynos5-hsi2c";
+		compatible = "samsung,exynos5250-hsi2c";
 		reg = <0x12CC0000 0x1000>;
 		interrupts = <0 62 0>;
 		#address-cells = <1>;
@@ -525,7 +525,7 @@
 	};
 
 	hsi2c_7: i2c@12CD0000 {
-		compatible = "samsung,exynos5-hsi2c";
+		compatible = "samsung,exynos5250-hsi2c";
 		reg = <0x12CD0000 0x1000>;
 		interrupts = <0 63 0>;
 		#address-cells = <1>;
@@ -538,7 +538,7 @@
 	};
 
 	hsi2c_8: i2c@12E00000 {
-		compatible = "samsung,exynos5-hsi2c";
+		compatible = "samsung,exynos5250-hsi2c";
 		reg = <0x12E00000 0x1000>;
 		interrupts = <0 87 0>;
 		#address-cells = <1>;
@@ -551,7 +551,7 @@
 	};
 
 	hsi2c_9: i2c@12E10000 {
-		compatible = "samsung,exynos5-hsi2c";
+		compatible = "samsung,exynos5250-hsi2c";
 		reg = <0x12E10000 0x1000>;
 		interrupts = <0 88 0>;
 		#address-cells = <1>;
@@ -564,7 +564,7 @@
 	};
 
 	hsi2c_10: i2c@12E20000 {
-		compatible = "samsung,exynos5-hsi2c";
+		compatible = "samsung,exynos5250-hsi2c";
 		reg = <0x12E20000 0x1000>;
 		interrupts = <0 203 0>;
 		#address-cells = <1>;
-- 
1.7.9.5

