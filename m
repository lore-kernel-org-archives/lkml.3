Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935424AbaDJKG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:06:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24362 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935283AbaDJKGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:25 -0400
X-AuditID: cbfee68e-b7f566d000002344-c2-53466d1dddc4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/27] ARM: dts: exynos3250: Add device tree nodes for clock
 controllers
Date: Thu, 10 Apr 2014 19:06:04 +0900
Message-id: <1397124377-16969-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkWFc21y3Y4Ptxc4vrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mo4P/cKe0Erd0XXojVsDYxLOLsYOTkkBEwkrh6a
	xAxhi0lcuLeerYuRi0NIYCmjxLbZ21hgiiY93g5mCwksYpS4uo4DoqiJSWLJji2sIAk2AS2J
	/S9usIHYIgIBEj+OvwOzmQVuMkocex8GYgsLREncmL+RHcRmEVCV2PN/Blgvr4CrxPG1n6Gu
	kJP4sOcRWA2ngJvEzEUn2SAWu0r0PLrIDLJYQmAZu8TrQ7tYIQYJSHybfAjoOg6ghKzEpgNQ
	cyQlDq64wTKBUXgBI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMDAP/3vWd8OxpsHrA8x
	JgONm8gsJZqcD4ycvJJ4Q2MzIwtTE1NjI3NLM9KElcR5Fz1MChISSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXAqHyPw3CW+bSaWjvZgwWONxpLA9UyrtaqW/589eC18fdvK5c0nltR/S3J1X3q
	ceFux+mSWk4cHB2v/VlmSDe9sQ94lSk/902d2ZuEtsapbmKGEyIf+wR8yM94oiM9fdmCr4Vr
	uf5FSotKfTpw4XmkCEP3lpt3fZdcXW+xh2+N8rsNidbsLmXxSizFGYmGWsxFxYkA4PjYM5IC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV3ZXLdgg92f9Cyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvm5V9gL
	WrkruhatYWtgXMLZxcjJISFgIjHp8XYWCFtM4sK99WwgtpDAIkaJq+s4uhi5gOwmJoklO7aw
	giTYBLQk9r+4AVYkIhAg8eP4OzCbWeAmo8Sx92EgtrBAlMSN+RvZQWwWAVWJPf9ngPXyCrhK
	HF/7mRlimZzEhz2PwGo4BdwkZi46CbXYVaLn0UXmCYy8CxgZVjGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIEx9Uz6R2MqxosDjEKcDAq8fAeWOYaLMSaWFZcmXuIUYKDWUmEd3emW7AQb0pi
	ZVVqUX58UWlOavEhxmSgqyYyS4km5wNjPq8k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGGszU5WPCkl8r66Xui/7xG2H0PUp55Tui+vxKln8+p72xF6zvoXx
	VoJ00ZHfvikdDzLdT8yd9pDLxOzxudNZuuV52xeuSvVYa8OouvaQ2kLmuubvHrsmVC83MnS+
	5H9b9I9rpJBSUmxc5MLjukpVa67ExXVeyBC4UHS++pnK+ydytvEKJemhSizFGYmGWsxFxYkA
	C92Cze8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch add dt node of clock controllers to support Exynos3250 SoC.
Exynos3250's clock drvier divide into two scope for clock controller as following:
- 'cmu' clock-controller includes CMU_LEFTBUS/RIGHTBUS/TOP/CPU/ISP/ACP clocks

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[Modify base address of clock and remove unnecessary dt node by Chanwoo Choi]
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[Include exynos3250 clock header file by Hyunhee Kim]
Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index dba3218..758913e 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -19,6 +19,7 @@
 
 #include "skeleton.dtsi"
 #include "exynos3250-pinctrl.dtsi"
+#include <dt-bindings/clock/exynos3250.h>
 
 / {
 	compatible = "samsung,exynos3250";
@@ -39,6 +40,12 @@
 		reg = <0x10010000 0x400>;
 	};
 
+	cmu: clock-controller@10030000 {
+		compatible = "samsung,exynos3250-cmu";
+		reg = <0x10030000 0x20000>;
+		#clock-cells = <1>;
+	};
+
 	gic: interrupt-controller@10481000 {
 		compatible = "arm,cortex-a7-gic";
 		#interrupt-cells = <3>;
-- 
1.8.0

