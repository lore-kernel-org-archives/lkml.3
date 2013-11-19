Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3KSNEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:04:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57086 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3KSNEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:04:35 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-b4-528b61e2fb6d
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH 4/4 v4] ARM: dts: Exynos5420: Add device nodes for TMU blocks
Date: Tue, 19 Nov 2013 18:35:59 +0530
Message-id: <1384866359-16157-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
References: <1382004240-3282-1-git-send-email-l.krishna@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSrfsosTvIYOsic4uGqyEWG2esZ7V4
	eUjTYv6Rc6wWa/b/ZLLoXXCVzeLyrjlsFp97jzBazDi/j8li0bb/zBZPHvaxWayf8ZrFgcdj
	56y77B6L97xk8ujbsorR4/iN7UwenzfJBbBGcdmkpOZklqUW6dslcGWsPniYvWCJSMWSW+eZ
	GxgXCnQxcnJICJhInNh5nxXCFpO4cG89WxcjF4eQwFJGiZ8zzjLDFD0/8JkFIrGIUWLv6auM
	EE4Pk8S6qTdYQKrYBMwkDi5azQ5iiwjISEy9sp8VpIhZYD6TxKE/a8ESwgK+Ev9f/mIDsVkE
	VCU2L+4HKuLg4BVwlTj1Swhim6JE97MJYCWcQOHfrw4xgdhCAi4Su/f9AJspIXCIXeLtzFuM
	EHMEJL5NPsQCMkdCQFZi0wGoqyUlDq64wTKBUXgBI8MqRtHUguSC4qT0IkO94sTc4tK8dL3k
	/NxNjMC4OP3vWe8OxtsHrA8xJgONm8gsJZqcD4yrvJJ4Q2MzIwtTE1NjI3NLM9KElcR5kx4m
	BQkJpCeWpGanphakFsUXleakFh9iZOLglGpgtPl1eOe+Y75Cpxbfq9va5SCw2jze2urUglxm
	LuXgoB8/q7mmv/pqd+TI1ei94vcv6Ts+Y4iry7t867Gnv0hP6WsHnjArvUShTZ/D2mPrzpsu
	tD5uZZL57VCoWtqXNF2W2Hp+FbYtGvLeVw2s1k+78+Fm1z/uB29ZRfs+3615tj7LPNjrkk2H
	EktxRqKhFnNRcSIAt1Yg+6ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd1Hid1BBgt/6Fo0XA2x2DhjPavF
	y0OaFvOPnGO1WLP/J5NF74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzWL9jNcsDjwe
	O2fdZfdYvOclk0ffllWMHsdvbGfy+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxuqDh9kLlohULLl1nrmBcaFAFyMnh4SAicTzA59ZIGwxiQv31rN1MXJxCAks
	YpTYe/oqI4TTwySxbuoNsCo2ATOJg4tWs4PYIgIyElOv7GcFKWIWmM8kcejPWrCEsICvxP+X
	v9hAbBYBVYnNi/uBijg4eAVcJU79EoLYpijR/WwCWAknUPj3q0NMILaQgIvE7n0/WCcw8i5g
	ZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERx1z6R3MK5qsDjEKMDBqMTDO8G9K0iINbGs
	uDL3EKMEB7OSCK9xUHeQEG9KYmVValF+fFFpTmrxIcZkoKMmMkuJJucDE0JeSbyhsYm5qbGp
	pYmFiZklacJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTBGTvHVmVhcKxi2yH9XaXHSRXmu
	/M93Un/G9q5ZM2H9lGxJFoMbLpO4o1d3fufadbVbI7a8OSEjq3rt+iM7erPPfTrn4XWxTlxD
	ZWHQppcXbkyTlDGxkA8xVxAQ094Rnyb6uM1k1ZYS9pmLmD76NmsU73Wbt32jodHb48dXHXbR
	q2NTenHRmlWJpTgj0VCLuag4EQBx4rJa/gIAAA==
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
Changes since v3:
None, Just respinning

Changes since v2:
3. uses the new compatible strings introduced along with adding
   support for Exynso5420.

Changes since v1:
1. Nodes carry the misplaced second base address and the second
   clock to access the misplaced base address.
2. Correct the clock number for the TMU4

 arch/arm/boot/dts/exynos5420.dtsi |   48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 6ffefd1..d736b40 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -369,4 +369,52 @@
 		clock-names = "gscl";
 		samsung,power-domain = <&gsc_pd>;
 	};
+
+	/* tmu for CPU0 */
+	tmu@10060000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10060000 0x100>;
+		interrupts = <0 65 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	/* tmu for CPU1 */
+	tmu@10064000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10064000 0x100>;
+		interrupts = <0 183 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	/* tmu for CPU2 */
+	tmu@10068000 {
+		compatible = "samsung,exynos5420-tmu-triminfo";
+		/* 2nd reg is for the misplaced TRIMINFO register */
+		reg = <0x10068000 0x100>, <0x1006c000 0x4>;
+		interrupts = <0 184 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+	/* tmu for CPU3 */
+	tmu@1006c000 {
+		compatible = "samsung,exynos5420-tmu-triminfo-clk";
+		/* 2nd reg is for the misplaced TRIMINFO register */
+		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
+		interrupts = <0 185 0>;
+		clocks = <&clock 318>, <&clock 319>;
+		clock-names = "tmu_apbif", "tmu_apbif_triminfo";
+	};
+
+	/* tmu for GPU */
+	tmu@100a0000 {
+		compatible = "samsung,exynos5420-tmu-triminfo-clk";
+		/* 2nd reg is for the misplaced TRIMINFO register */
+		reg = <0x100a0000 0x100>, <0x10068000 0x4>;
+		interrupts = <0 215 0>;
+		clocks = <&clock 319>, <&clock 318>;
+		clock-names = "tmu_apbif", "tmu_apbif_triminfo";
+	};
 };
-- 
1.7.10.4

