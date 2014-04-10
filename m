Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030205AbaDJKHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:07:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53304 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965752AbaDJKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:52 -0400
X-AuditID: cbfee68e-b7f566d000002344-d2-53466d1fabf3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/27] ARM: dts: exynos3250: Add MCT dt node
Date: Thu, 10 Apr 2014 19:06:06 +0900
Message-id: <1397124377-16969-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkWFc+1y3YYNJmPovrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MqYuKSBraCHq2LOwvdMDYwLOboYOTkkBEwkVs1Y
	wwxhi0lcuLeerYuRi0NIYCmjxMLnnUAOB1jR3INKEPFFjBKrT+5ngnCamCS2bLjLCtLNJqAl
	sf/FDTYQW0QgQOLH8XdgNrPATUaJY+/DQGxhARuJp3NWg21jEVCV+P1yGTuIzSvgKnGxdQ4L
	xBVyEh/2PAKLcwq4ScxcdBJsjhBQTc+ji8wgiyUE1rFLrDvawgYxSEDi2+RDLBCXykpsOgD1
	jaTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERj4p/8969vBePOA9SHG
	ZKBxE5mlRJPzgZGTVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWpRfFFpTmp
	xYcYmTg4pRoYhQzMG9jPO2oEi/x9ZfiBcS7HryN1nqduTiy7vsq8467a+q0sBiLSbX9Et9l+
	XL5zz9drdUbhPS57F70om1/3r+xJ+VJWJjubCLOrnyVzw45MW1U/fcby/ctdOznf3jmbZCwU
	WP8oSEJshY7Yk6Mfn5R0r1hgosCVxyzIcvmBeFud8EzZXdvWK7EUZyQaajEXFScCAHGgNXmS	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV35XLdggy0H2Cyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxsQlDWwF
	PVwVcxa+Z2pgXMjRxcjBISFgIjH3oFIXIyeQKSZx4d56ti5GLg4hgUWMEqtP7meCcJqYJLZs
	uMsKUsUmoCWx/8UNNhBbRCBA4sfxd2A2s8BNRolj78NAbGEBG4mnc1Yzg9gsAqoSv18uYwex
	eQVcJS62zmGB2CYn8WHPI7A4p4CbxMxFJ8HmCAHV9Dy6yDyBkXcBI8MqRtHUguSC4qT0XEO9
	4sTc4tK8dL3k/NxNjOC4eia1g3Flg8UhRgEORiUe3gPLXIOFWBPLiitzDzFKcDArifDuznQL
	FuJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YMznlcQbGpuYGVkamRtaGBmbkyasJM57oNU6
	UEggPbEkNTs1tSC1CGYLEwenVAOj6Onf12WNTnY+OnRum78rzweWLc3bHJWLlbckmq3wKgtM
	OLt8xqsJzr3rJ9yxFdrU3jTx0UmTj2v6eRT49pxZdyc8Vmh791nn5qApYhMY3vN4m71/FFx1
	xXdTiO+E64Wn/r0vPBI4yf2AWqXyuvSrWyUXLtz8Vuo3++V9G1L5Lm//fM29UnSNshJLcUai
	oRZzUXEiAFXrwk3vAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add MCT (Multi Core Timer) dt node with "samsung,exynos4210-mct"
compatible name bacause Exynos3250 uses SPI interrput type. And Exynos3250
provide one global timer and four local timers for Multi Core CPU.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[Fix incorrect irq number of MCT and remove unnecessary code by Tomasz Figa]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index d17ed54..2013d0d 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -57,6 +57,15 @@
 		      interrupts = <1 9 0xf04>;
 	};
 
+	mct@10050000 {
+		compatible = "samsung,exynos4210-mct";
+		reg = <0x10050000 0x800>;
+		interrupts = <0 218 0>, <0 219 0>, <0 220 0>, <0 221 0>,
+			     <0 223 0>, <0 226 0>, <0 227 0>, <0 228 0>;
+		clocks = <&cmu CLK_FIN_PLL>, <&cmu CLK_MCT>;
+		clock-names = "fin_pll", "mct";
+	};
+
 	pinctrl_1: pinctrl@11000000 {
 		compatible = "samsung,exynos3250-pinctrl";
 		reg = <0x11000000 0x1000>;
-- 
1.8.0

