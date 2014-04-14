Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaDNJID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:08:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61911 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbaDNJHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:07:16 -0400
X-AuditID: cbfee68e-b7f566d000002344-bc-534ba54283e4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 2/2] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
Date: Mon, 14 Apr 2014 18:07:06 +0900
Message-id: <1397466426-13870-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397466426-13870-1-git-send-email-cw00.choi@samsung.com>
References: <1397466426-13870-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWyRsSkWNdpqXewwd4nnBZ3nx9mtLj+5Tmr
	xfwj51gt+t8sZLU492olo8WDplVMFr0LrrJZbHp8jdViYdsSFot5R96xWFzeNYfNYsb5fUwW
	S69fZLKYMH0ti8XbO9NZLFr3HmG3WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOoGM
	JfUefVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlfFp9inGgl3CFb3nJBsY+wS6GDk5JARMJO7N
	OMcIYYtJXLi3nq2LkYtDSGApo8TB19+AHA6wopWNjBDxRYwSb382sUI4TUwSq36fYwbpZhPQ
	ktj/4gYbiC0i4CTx89s9sEnMAp3MEv+674MVCQtESsx42cMKYrMIqErMPf4UzOYVcJVYN2Mf
	1BlyEh/2PGIH2cwp4CZxoF0RJCwEVPLu6R92kJkSAj/ZJU78vQo1R0Di2+RDLBCXykpsOsAM
	MUZS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiMsdP/nvXtYLx5wPoQ
	YzLQuInMUqLJ+cAYzSuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAhgfTEktTs1NSC1KL4otKc
	1OJDjEwcnFINjIl3/05YvqZwn6N/c3HwTW7HbY9/mbq1zorrbOmyN9g7d6Xmkycr8rXXv37o
	Kvn0rLGB8+sHW5UPRDjX1c5eGMP29mn+cW+7+wtmxi7UdXSeyvJ+vUrhwo+WjrEbZ9Q+nNL4
	Nd9lqzHTvazPt5Q91ZcaBSTt2eK+afKCsI8nl93vPCMoaHd5+VwlluKMREMt5qLiRAA+iAlE
	xwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAV3Hpd7BBpv/2VjcfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmsenxNVaLhW1LWCzmHXnHYnF51xw2ixnn9zFZ
	LL1+kcliwvS1LBZv70xnsWjde4TdYv2M1ywOgh5r5q1h9Ljc18vksXL5FzaPzSu0PDat6gQy
	ltR79G1ZxejxeZNcAEdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtAbSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMT7NP
	MRbsEq7oPSfZwNgn0MXIwSEhYCKxspGxi5ETyBSTuHBvPVsXIxeHkMAiRom3P5tYIZwmJolV
	v88xg1SxCWhJ7H9xgw3EFhFwkvj57R5YB7NAJ7PEv+77YEXCApESM172sILYLAKqEnOPPwWz
	eQVcJdbN2Ae1Tk7iw55H7CBXcAq4SRxoVwQJCwGVvHv6h30CI+8CRoZVjKKpBckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGMER/ExqB+PKBotDjAIcjEo8vB1zvIOFWBPLiitzDzFKcDArifBuy/AK
	FuJNSaysSi3Kjy8qzUktPsSYDHTURGYp0eR8YHLJK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1
	oJBAemJJanZqakFqEcwWJg5OqQZGj4rnExieRcR/WNctJsj9I/1E3N09B3RWniorrRHavUL6
	mdMErmYJ/6PX6sKDXq1+5DvXbO2S3BfpK18sZHisq/nlM+t3taqr2vL7bpycmKx8I/LtC8Yp
	2yq6wwvO3jmsPn9/SMZ2tYYr7U6n0xgenWhfcqzVjjN9f9XH/3+Xic7sKjz/e2+ZlhJLcUai
	oRZzUXEiAAfgM4ckAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add DT binding documentation for Exynos3250 ADC IP. Exynos3250 has
special clock ('sclk_tsadc') for ADC which provide clock to internal ADC.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt   | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index 5d49f2b..7532ec3 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -14,6 +14,8 @@ Required properties:
 				for exynos4412/5250 controllers.
 			Must be "samsung,exynos-adc-v2" for
 				future controllers.
+			Must be "samsung,exynos-adc-v3" for
+				for exynos3250 controllers.
 - reg:			Contains ADC register address range (base address and
 			length) and the address of the phy enable register.
 - interrupts: 		Contains the interrupt information for the timer. The
@@ -21,7 +23,11 @@ Required properties:
 			the Samsung device uses.
 - #io-channel-cells = <1>; As ADC has multiple outputs
 - clocks		From common clock binding: handle to adc clock.
+			From common clock binding: handle to sclk_tsadc clock
+			if using Exynos3250.
 - clock-names		From common clock binding: Shall be "adc".
+			From common clock binding: Shall be "sclk_tsadc"
+			if using Exynos3250.
 - vdd-supply		VDD input supply.
 
 Note: child nodes can be added for auto probing from device tree.
@@ -41,6 +47,20 @@ adc: adc@12D10000 {
 	vdd-supply = <&buck5_reg>;
 };
 
+If Exynos3250 uses ADC,
+adc: adc@126C0000 {
+	compatible = "samsung,exynos-adc-v3";
+	reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+	interrupts = <0 137 0>;
+	#io-channel-cells = <1>;
+	io-channel-ranges;
+
+	clock-names = "adc", "sclk_tsadc";
+	clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
+
+	vdd-supply = <&buck5_reg>;
+};
+
 
 Example: Adding child nodes in dts file
 
-- 
1.8.0

