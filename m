Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaGRGAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:00:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37909 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbaGRF76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:59:58 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-13-53c8b7d7d556
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv6 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
Date: Fri, 18 Jul 2014 14:59:45 +0900
Message-id: <1405663186-26464-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkQPf69hPBBvvm61ncfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmcbbpDbvFpsfXWC0Wti1hsZh35B2LxeVdc9gs
	Zpzfx2Sx9PpFJosJ09eyWLy9M53FonXvEXaL9TNeszgIeayZt4bR43JfL5PHyuVf2Dw2r9Dy
	2LSqE8hYUu/Rt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGRN6dAr+Clec+HqNsYFxk0AXIyeH
	hICJxN+mx8wQtpjEhXvr2UBsIYGljBLtJ41hat483gFUwwUUX8QosfbuQRYIp4lJ4vDszUwg
	VWwCWhL7X9wA6xYR0JaYsLCDDaSIWWAvs8T29e/BVggLREr0/NzBDmKzCKhK/Fg8E8zmFXCV
	eNrXygKxTk7iw55HYHFOATeJf71XWSFOcpWY1HeeCWSohMBPdokvrafYIAYJSHybfAiomQMo
	ISux6QDUO5ISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRmC8nf73bOIO
	xvsHrA8xJgONm8gsJZqcD4zXvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJpCeWpGanphak
	FsUXleakFh9iZOLglGpgDFB4+LP+WOaJ7Ye9j1tP5JLKmF8swTxvn726z67dkfZxWxW3VFxN
	Xylea6fwMZE5W+eh87YbXRm6/qtnOTOs+rC0ti+0lTM67eMiAyW72Q7zSrifN6e9PZyR6T37
	8/FC/R2b8gX3zVgiOnHl/8qd8a5B3gps9txat7/WOztx32TZXqkdmK2oxFKckWioxVxUnAgA
	FAZJnc0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd3r208EG3y9p2px9/lhRovrX56z
	Wsw/co7Vov/NQlaLc69WMlo8aFrFZNG74CqbxdmmN+wWmx5fY7VY2LaExWLekXcsFpd3zWGz
	mHF+H5PF0usXmSwmTF/LYvH2znQWi9a9R9gt1s94zeIg5LFm3hpGj8t9vUweK5d/YfPYvELL
	Y9OqTiBjSb1H35ZVjB6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqY
	KynkJeam2iq5+AToumXmAP2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSs
	YcyY0KNT8Fe44sTXa4wNjJsEuhg5OSQETCTePN7BDGGLSVy4t56ti5GLQ0hgEaPE2rsHWSCc
	JiaJw7M3M4FUsQloSex/cYMNxBYR0JaYsLADrINZYC+zxPb178FGCQtESvT83MEOYrMIqEr8
	WDwTzOYVcJV42tfKArFOTuLDnkdgcU4BN4l/vVdZQWwhoJpJfeeZJjDyLmBkWMUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRHM/PpHYwrmywOMQowMGoxMNrcfN4sBBrYllxZe4hRgkOZiUR
	3uz7QCHelMTKqtSi/Pii0pzU4kOMpkBXTWSWEk3OB6aavJJ4Q2MTMyNLI3NDCyNjcyVx3gOt
	1oFCAumJJanZqakFqUUwfUwcnFINjHvYE99m//q6faVvk9+f0MmmKrM5u6t3dSw+FhqWZyyy
	V3AdnxPrzT+NX9W8ft3ZWHAgbANbnnZOyEElz41p2+ZMfap42UbixJrny6xeGbMfNPvXM1H1
	Ym9KyBlvncpQk8iFi491dz5mfiB2bruY6n2hrSv6YxpC1Y5bZ/6/vn/vUYZvGT43FJRYijMS
	DbWYi4oTAf0jyp39AgAA
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
index 832fe8c..26232f9 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -14,14 +14,21 @@ Required properties:
 				for exynos4412/5250 controllers.
 			Must be "samsung,exynos-adc-v2" for
 				future controllers.
+			Must be "samsung,exynos3250-adc-v2" for
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
+			- "sclk_adc" : ADC special clock (only for Exynos3250
+				       and compatible ADC block)
 - vdd-supply		VDD input supply.
 
 Note: child nodes can be added for auto probing from device tree.
@@ -41,6 +48,20 @@ adc: adc@12D10000 {
 	vdd-supply = <&buck5_reg>;
 };
 
+Example: adding device info in dtsi file for Exynos3250 with additional sclk
+
+adc: adc@126C0000 {
+	compatible = "samsung,exynos3250-adc-v2";
+	reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+	interrupts = <0 137 0>;
+	#io-channel-cells = <1>;
+	io-channel-ranges;
+
+	clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
+	clock-names = "adc", "sclk_adc";
+
+	vdd-supply = <&buck5_reg>;
+};
 
 Example: Adding child nodes in dts file
 
-- 
1.8.0

