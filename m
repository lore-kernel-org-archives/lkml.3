Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbaFRCVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:21:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46719 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbaFRCVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:21:13 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-0e-53a0f79636ee
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 4/4] ARM: dts: Fix wrong compatible string for Exynos3250 ADC
Date: Wed, 18 Jun 2014 11:21:01 +0900
Message-id: <1403058061-24271-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkRHfa9wXBBu2XtS3uPj/MaHH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWzWNi2hMVi3pF3LBaXd81hs5hxfh+TxdLrF5ks
	Jkxfy2Lx9s50FovWvUfYLU7+6WW0WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbw+bRt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGatPn2MqeMJRcW7XHuYGxvnsXYycHBIC
	JhJ/N/5jhLDFJC7cW88GYgsJLGWUWPXNAKbm0uXzQPVcQPHpjBLvjr2EcpqYJLas2gLWzSag
	JbH/xQ2wbhGBCIn5m3cwgRQxC7xgknh09wFYkbCAv8Ttd+0sIDaLgKrErbWdYHFeAVeJvd/u
	s0Gsk5P4sOcR2HmcAm4SPzfMYIE4yVVi2oM5LCBDJQT+skscudXIBjFIQOLb5ENACQ6ghKzE
	pgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYzASDv971nfDsab
	B6wPMSYDjZvILCWanA+M1LySeENjMyMLUxNTYyNzSzPShJXEeRc9TAoSEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwFjr+o7FabukTcOmfetjf5VVlSxLDe3YYsRQeGo9Y4rL2tu//po+mVN8
	kf2byNLLzB9f9U7efXf16ao9u0O8bm3WKWC3tm/4zxjx7sks5a7dAnIc7x2zT4h7mOTe+RRi
	1KG6pFxN21ZwSeK/ftWbLuVtEy1nPVENY137beL82soDE3n4n24rZFRiKc5INNRiLipOBAA/
	zuoTygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd1p3xcEG7y+oWxx9/lhRovrX56z
	Wsw/co7Vov/NQlaLc69WMlo8aFrFZNG74CqbxcK2JSwW8468Y7G4vGsOm8WM8/uYLJZev8hk
	MWH6WhaLt3ems1i07j3CbnHyTy+jxfoZr1kcBD3WzFvD6HG5r5fJY+XyL2wem1doeWxa1cnm
	cefaHjaPvi2rGD0+b5IL4IhqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LI
	S8xNtVVy8QnQdcvMAfpDSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix
	+vQ5poInHBXndu1hbmCcz97FyMkhIWAicenyeShbTOLCvfVsXYxcHEIC0xkl3h17yQ7hNDFJ
	bFm1hRGkik1AS2L/ixtsILaIQITE/M07mECKmAVeMEk8uvsArEhYwF/i9rt2FhCbRUBV4tba
	TrA4r4CrxN5v99kg1slJfNjzCGw1p4CbxM8NM8DqhYBqpj2YwzKBkXcBI8MqRtHUguSC4qT0
	XCO94sTc4tK8dL3k/NxNjOBIfia9g3FVg8UhRgEORiUeXo7cBcFCrIllxZW5hxglOJiVRHhV
	zgGFeFMSK6tSi/Lji0pzUosPMSYDXTWRWUo0OR+YZPJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Y
	ah0oJJCeWJKanZpakFoEs4WJg1OqgZFjHWvA9NoDa01v9U+dWMOVGsnpFvYlnkOpp+D9st9z
	r902XM4mfr1ou5Zfy+fLyp/+fjd8G3lvhlmMoc7SwL99pxQf2CTHupR1+ZuG3NgZtlCoIilk
	3gfeeXOm8jyxsJsbvFBrQXW1ysPz9x6G9lrXtLzfeOzGWjeb2EaD1Pu5MfY6h+cvF1ZiKc5I
	NNRiLipOBACYX/8tKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix wrong compatible string for Exynos3250 ADC. Exynos3250 SoC
need to control only special clock for ADC. Exynos SoC except for Exynos3250
has not included special clock for ADC. The exynos ADC driver can control
special clock if compatible string is 'exynos3250-adc-v2'.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 6c1fb67..107dc44 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -414,10 +414,10 @@
 		};
 
 		adc: adc@126C0000 {
-			compatible = "samsung,exynos-adc-v3";
+			compatible = "samsung,exynos3250-adc-v2";
 			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
 			interrupts = <0 137 0>;
-			clock-names = "adc", "sclk_tsadc";
+			clock-names = "adc", "sclk_adc";
 			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
 			#io-channel-cells = <1>;
 			io-channel-ranges;
-- 
1.8.0

