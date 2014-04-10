Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965802AbaDJKG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:06:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53305 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965754AbaDJKGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:53 -0400
X-AuditID: cbfee68e-b7f566d000002344-e1-53466d1fd06d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 17/27] ARM: dts: exynos3250: Add ADC dt node to read analog raw
 data
Date: Thu, 10 Apr 2014 19:06:07 +0900
Message-id: <1397124377-16969-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkSFc+1y3Y4P1EK4vrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mo4NX0HU8ETjop/++eyNzDOYe9i5OSQEDCReLWo
	nRHCFpO4cG89G4gtJLCUUeJFB1ANB1jNvz0yXYxcQOFFjBK7uucxQThNTBKrlvezgjSwCWhJ
	7H9xA6xZRCBA4sfxd2A2s8BNRolj78NAbGGBMIl9qxrAlrEIqEosmL4a7AheAVeJDX2zmCGO
	kJP4sOcRWJxTwE1i5qKTUAe5SvQ8usgMslhCYB27xNIjH5ggBglIfJt8iAXiUlmJTQeg5khK
	HFxxg2UCo/ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIFhf/rfs74djDcPWB9iTAYa
	N5FZSjQ5Hxg3eSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBsbtz1rds70zLIFXPPDaTE6b8224FTuBwOqQx88Qn6f7d3+Rr9eZaxP1Li95kmdnH
	d7VKsXf2HsVTtXnt8ow/WpdtWPI7MGHrFyteZq092k8LeM9e29rud5d1jcHpXdOKL71dFqX+
	LHvSs6AXd+Q7/vsF7XOxm3RccMGNJXopoRZ/7pWmJ8z9oMRSnJFoqMVcVJwIABMt4TiRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV35XLdgg++7jCyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxqnpO5gK
	nnBU/Ns/l72BcQ57FyMHh4SAicS/PTJdjJxAppjEhXvr2boYuTiEBBYxSuzqnscE4TQxSaxa
	3s8KUsUmoCWx/8UNNhBbRCBA4sfxd2A2s8BNRolj78NAbGGBMIl9qxoYQWwWAVWJBdNXs4PY
	vAKuEhv6ZjFDbJOT+LDnEVicU8BNYuaik2BzhIBqeh5dZJ7AyLuAkWEVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnBcPZPawbiyweIQowAHoxIP74FlrsFCrIllxZW5hxglOJiVRHh3Z7oF
	C/GmJFZWpRblxxeV5qQWH2JMBrpqIrOUaHI+MObzSuINjU3MjCyNzA0tjIzNSRNWEuc90God
	KCSQnliSmp2aWpBaBLOFiYNTqoHR5eX70jLTfRr1di9MbcOanyqxW8k8uVYX9Vd62YSFc968
	m2z0jYOHzaUuem3PiVsNtuzt3pazW2ru6r5smvH1DItuw+ppCR8/T8m79mxmdsc+kwtT9oSf
	njRzQsuOCWJd1xM+371+7+IPtlbPsGmz8rcXGk22k99xcW9N/hGdHcwfZM+WlS88psRSnJFo
	qMVcVJwIAKQWhaDvAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add ADC (Analog to Digital Converter) dt node to get raw data with
IIO subsystem. Usually, ADC is used to check temperature, jack type and so on.
Exynos3250 includes ADCv2 which is different from ADCv1 for Exynos4 SoC.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 2013d0d..c5e6917 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -84,6 +84,17 @@
 		interrupts = <0 240 0>;
 	};
 
+	adc: adc@126C0000 {
+		compatible = "samsung,exynos-adc-v2";
+		reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+		interrupts = <0 137 0>;
+		clock-names = "adc", "sclk_tsadc";
+		clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
+		#io-channel-cells = <1>;
+		io-channel-ranges;
+		status = "disabled";
+	};
+
 	serial@13800000 {
 		compatible = "samsung,exynos4210-uart";
 		reg = <0x13800000 0x100>;
-- 
1.8.0

