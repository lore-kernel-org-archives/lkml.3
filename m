Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaDPKNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:13:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34590 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaDPKL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:11:58 -0400
X-AuditID: cbfee68f-b7f156d00000276c-bd-534e576c0760
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, t.figa@samsung.com, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 2/2] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
Date: Wed, 16 Apr 2014 19:11:58 +0900
Message-id: <1397643118-6934-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397643118-6934-1-git-send-email-cw00.choi@samsung.com>
References: <1397643118-6934-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkWDc33C/YYFoDs8Xd54cZLa5/ec5q
	Mf/IOVaL/jcLWS3OvVrJaPGgaRWTRe+Cq2wWmx5fY7VY2LaExWLekXcsFpd3zWGzmHF+H5PF
	0usXmSwmTF/LYvH2znQWi9a9R9gtTv7pZbRYP+M1i4OQx5p5axg9Lvf1MnmsXP6FzWPzCi2P
	Tas62TzuXNsD5C2p9+jbsorR4/MmuQDOKC6blNSczLLUIn27BK6MT7NPMRbsEq7oPSfZwNgn
	0MXIySEhYCIxf80JFghbTOLCvfVsXYxcHEICSxklzvWtYIcperj5ChNEYjqjxOqpk1ggnCYm
	iVU3l4NVsQloSex/cYMNxBYRcJL4+e0e2ChmgUXMErNXnwNLCAtESqz7sIsVxGYRUJX4tGkm
	M4jNK+Ai8eDLbzaIdXISH/Y8AhvKKeAq0XDqJFi9EFDN+Yf/GEGGSgh0ckgsv/SIGWKQgMS3
	yYeATuIASshKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQI
	jL3T/57172C8e8D6EGMy0LiJzFKiyfnA2M0riTc0NjOyMDUxNTYytzQjTVhJnPf+w6QgIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYz2um67Zs17do7HtetekpftmqSKE9KS7LFXP2VHhzhH
	N17qfetTYRY3I3Pe2SUXjr8W+uT5infjhujJ9y+78H946Lj987wsjxvcoUGu7pePLmsXmyB/
	oT58u+fbUy9+cYcppv54meVx36Juvqyu3QlVn+iVqTX3/ncf8lkio+tx7a5xyg3LDROVWIoz
	Eg21mIuKEwE6tf2W0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd2ccL9gg0NPzCzuPj/MaHH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWz2PT4GqvFwrYlLBbzjrxjsbi8aw6bxYzz+5gs
	ll6/yGQxYfpaFou3d6azWLTuPcJucfJPL6PF+hmvWRyEPNbMW8Pocbmvl8lj5fIvbB6bV2h5
	bFrVyeZx59oeIG9JvUffllWMHp83yQVwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAPaSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxhzPg0+xRjwS7hit5zkg2MfQJdjJwcEgImEg83X2GCsMUkLtxbz9bFyMUhJDCdUWL1
	1EksEE4Tk8Sqm8vZQarYBLQk9r+4wQZiiwg4Sfz8dg+sg1lgEbPE7NXnwBLCApES6z7sYgWx
	WQRUJT5tmskMYvMKuEg8+PKbDWKdnMSHPY/AhnIKuEo0nDoJVi8EVHP+4T/GCYy8CxgZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIER/YzqR2MKxssDjEKcDAq8fDOyPENFmJNLCuuzD3E
	KMHBrCTCuzDQL1iINyWxsiq1KD++qDQntfgQYzLQVROZpUST84FJJ68k3tDYxMzI0sjc0MLI
	2Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGI9e/LIhVcX10I+TjatOZpyti5/sOyE1
	/euEsCVGP2Sf8er2Pn/NUih9W0B1Jm/AMk7nF2q3Y9dztmzKXXGXo+DyyUnsR26ram6yX3tI
	333B49R3FXkTmDYEbN+R6rPZcqPeqRCBUv7sGPsvd48+eZJaPJ3v/Dq56kr3aVVPH8Su3r5P
	KPSAc7oSS3FGoqEWc1FxIgC2fPlHMAMAAA==
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

