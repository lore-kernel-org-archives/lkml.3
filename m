Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaAGLw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:52:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21919 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaAGLvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:51:44 -0500
X-AuditID: cbfee690-b7f266d00000287c-a0-52cbea49c293
From: Naveen Krishna Ch <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 5/5] ARM: exynos5420: add dt node for sss module
Date: Tue, 07 Jan 2014 17:21:49 +0530
Message-id: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkTtfz1ekggyc/tSzuPj/MaPHykKZF
	9ysZi94FV9ks7t/7yWRxedccNosZ5/cxWSza9p/Z4uycQ0wOnB47Z91l99h2QNWjb8sqRo/P
	m+QCWKK4bFJSczLLUov07RK4Mg6tvsVWcJq94tT6VWwNjMvZuhg5OSQETCROHDzMDGGLSVy4
	tx4ozsUhJLCUUeLA8T4WmKIXsy+yQCQWMUqcf7MFyulnkjjXOp8RpIpNQF9i2fXFYLaIgLPE
	7+Y1rCBFzAJ3GSXuXfkMlhAWcJC4Ou0p2FgWAVWJxzduA8U5OHgFXCU2XGEFMSUEFCTmTLIB
	qeAUcJM4fegiO0hYCKji8JE0kIkSAovYJVrvTIGaIiDxbfIhFohWWYlNB6CekZQ4uOIGywRG
	4QWMDKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAgP99L9nE3Yw3jtgfYgxGWjcRGYp0eR8
	YKTklcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPj
	PIYa7t3XtvTfauLIFvBV7/r8JE77/S+xg4HT7ZYF3hF475wp9nzRc0HG8Lnq+9OVivk0p7GU
	PjscHTXx4ML6lY6b1pt9PnG98RIPI1PfiT++hz5dPXG975ZJvLPG0WbhticHLB6/u69pI2Ja
	GG5z+tqvfffb7t9xEnQ5plK/Pn7W37XliyaaKbEUZyQaajEXFScCAMNrEpOKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAV3PV6eDDNb/kbe4+/wwo8XLQ5oW
	3a9kLHoXXGWzuH/vJ5PF5V1z2CxmnN/HZLFo239mi7NzDjE5cHrsnHWX3WPbAVWPvi2rGD0+
	b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	AbpESaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxaPUttoLT7BWn1q9i
	a2BcztbFyMkhIWAi8WL2RRYIW0ziwr31QHEuDiGBRYwS599sYYFw+pkkzrXOZwSpYhPQl1h2
	fTGYLSLgLPG7eQ0rSBGzwF1GiXtXPoMlhAUcJK5Oewo2lkVAVeLxjdtAcQ4OXgFXiQ1XWEFM
	CQEFiTmTbEAqOAXcJE4fusgOEhYCqjh8JG0CI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGMFx9Ex6B+OqBotDjAIcjEo8vC/2ngoSYk0sK67MPcQowcGsJMLLfON0kBBvSmJlVWpR
	fnxRaU5q8SHGZKCTJjJLiSbnA2M8ryTe0NjE3NTY1NLEwsTMkjRhJXHeg63WgUIC6Yklqdmp
	qQWpRTBbmDg4pRoYvfZsXDvvwsWKLqaXq9QenNdYPeWVfIwKDyeHjqTipbfX90evk857ctht
	wY1lDisqqkymrPzEeDlNXFj48awz1d0ZmXPyavtPbOq/MvWtQDWb+muTtR7PLl90Ebp26uTN
	ZXE3hAIE5i4U3DuX5ZfdMgfTK98rfsZ8mVPU7aTh6z3ZO+3TDOXTmUosxRmJhlrMRcWJAHCN
	BETnAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

this patch adds the device tree nodes for SSS module found on Exynos5420

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
 arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 11dd202..97045f9 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -652,4 +652,14 @@
 		clocks = <&clock 319>, <&clock 318>;
 		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
 	};
+
+	sss: sss {
+		compatible = "samsung,exynos-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+		samsung,power-domain = <&g2d_pd>;
+	};
+
 };
-- 
1.7.9.5

