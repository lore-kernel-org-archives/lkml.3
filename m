Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaGUCSH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:18:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41198 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaGUCR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:17:59 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-f1-53cc78549a61
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com
Cc: arnd@arndb.de, kgene.kim@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv7 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
Date: Mon, 21 Jul 2014 11:17:47 +0900
Message-id: <1405909068-22539-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
References: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWyRsSkRDek4kywwcRl6hZ/Jx1jt7j7/DCj
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLR40rWKy6F1wlc3ibNMbdotNj6+xWixsW8JiMe/IOxaL
	y7vmsFnMOL+PyWLp9YtMFhOmr2WxeHtnOotF694j7BbrZ7xmcRD2WDNvDaPH71+TGD0u9/Uy
	eaxc/oXNY/MKLY9NqzqBjCX1Hn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJVx5+BH1oLXwhX3
	V21kamBcItDFyMkhIWAi0d7VygJhi0lcuLeerYuRi0NIYCmjxNzz/5lhiu5s28gKkVjEKPF6
	8X8op4lJ4sinJewgVWwCWhL7X9xgA7FFBLQlJizsABvFLHCGWaK3bSVQEQeHsECkxKS2cJAa
	FgFViZfvfoGt5hVwlTi4fjkbxDY5iQ97HoHN5BRwk2h/3MYKYgsB1fybdIcRZKaEQC+HxPTv
	09khBglIfJt8iAVkvoSArMSmA1BXS0ocXHGDZQKj8AJGhlWMoqkFyQXFSelFRnrFibnFpXnp
	esn5uZsYgVF4+t+zvh2MNw9YH2JMBho3kVlKNDkfGMV5JfGGxmZGFqYmpsZG5pZmpAkrifMu
	epgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxktbbvQbRMQcYwyUvcItZM/8XeX1YwKGi
	t1FxacmesJy9UjmXXFiZQ25vr1Ge1HVgy9Y33UfOW2x3SZ6fmddf/skz0rW6ifHm/meCJt8u
	rYvLct+cGnzR98bi2dn6gs0vWNeubbvC6ib1dsERlYLjzcJLDT7lLJzNkX0tePnJelNvq1o/
	aQUlluKMREMt5qLiRABGl/qJ2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd2QijPBBj/WyVn8nXSM3eLu88OM
	Fte/PGe1mH/kHKtF/5uFrBbnXq1ktHjQtIrJonfBVTaLs01v2C02Pb7GarGwbQmLxbwj71gs
	Lu+aw2Yx4/w+Joul1y8yWUyYvpbF4u2d6SwWrXuPsFusn/GaxUHYY828NYwev39NYvS43NfL
	5LFy+Rc2j80rtDw2reoEMpbUe/RtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
	c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QV0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0
	fUOC4HqMDNBAwhrGjDsHP7IWvBauuL9qI1MD4xKBLkZODgkBE4k72zayQthiEhfurWfrYuTi
	EBJYxCjxevF/VginiUniyKcl7CBVbAJaEvtf3GADsUUEtCUmLOwA62AWOMMs0du2EqiIg0NY
	IFJiUls4SA2LgKrEy3e/WEBsXgFXiYPrl7NBbJOT+LDnEdhMTgE3ifbHbWBXCAHV/Jt0h3EC
	I+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEx/kxqB+PKBotDjAIcjEo8vB6MZ4KF
	WBPLiitzDzFKcDArifCeyAAK8aYkVlalFuXHF5XmpBYfYjQFumois5Rocj4w/eSVxBsam5gZ
	WRqZG1oYGZsrifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamCM2TUjT3a7c8KNbVtnNt5a+1RD
	5OyMfMZD/xXq79mtbHz0VkVJ78x/K0XDqruR0z3+37F1f2Pc1ap0l+140uTpv/Trt16++03h
	5fTYEg3HzSy3u9w2PXd/Me22hx7TXIdvm48cLYqQnBYpuPPlTI0TxYcjlC5fqY2Z/blXtPnA
	Hq2IRS4CCzJ+KrEUZyQaajEXFScCALeRkSkHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add DT binding documentation for Exynos3250 ADC IP. Exynos3250 has
special clock ('sclk_adc') for ADC which provide clock to internal ADC.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt | 25 ++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index 832fe8c..6d34891 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -14,14 +14,21 @@ Required properties:
 				for exynos4412/5250 controllers.
 			Must be "samsung,exynos-adc-v2" for
 				future controllers.
+			Must be "samsung,exynos3250-adc" for
+				controllers compatible with ADC of Exynos3250.
 - reg:			Contains ADC register address range (base address and
 			length) and the address of the phy enable register.
 - interrupts: 		Contains the interrupt information for the timer. The
 			format is being dependent on which interrupt controller
 			the Samsung device uses.
 - #io-channel-cells = <1>; As ADC has multiple outputs
-- clocks		From common clock binding: handle to adc clock.
-- clock-names		From common clock binding: Shall be "adc".
+- clocks		From common clock bindings: handles to clocks specified
+			in "clock-names" property, in the same order.
+- clock-names		From common clock bindings: list of clock input names
+			used by ADC block:
+			- "adc" : ADC bus clock
+			- "sclk" : ADC special clock (only for Exynos3250 and
+				   compatible ADC block)
 - vdd-supply		VDD input supply.
 
 Note: child nodes can be added for auto probing from device tree.
@@ -41,6 +48,20 @@ adc: adc@12D10000 {
 	vdd-supply = <&buck5_reg>;
 };
 
+Example: adding device info in dtsi file for Exynos3250 with additional sclk
+
+adc: adc@126C0000 {
+	compatible = "samsung,exynos3250-adc";
+	reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+	interrupts = <0 137 0>;
+	#io-channel-cells = <1>;
+	io-channel-ranges;
+
+	clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
+	clock-names = "adc", "sclk";
+
+	vdd-supply = <&buck5_reg>;
+};
 
 Example: Adding child nodes in dts file
 
-- 
1.8.0

