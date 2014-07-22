Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaGVCF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:05:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47213 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaGVCFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:05:10 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-d5-53cdc6cd2999
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv8 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
Date: Tue, 22 Jul 2014 11:04:55 +0900
Message-id: <1405994696-3117-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com>
References: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkSPfssbPBBrsniVn8nXSM3eLu88OM
	Fte/PGe1mH/kHKvFg6ZVTBa9C66yWZxtesNusenxNVaLhW1LWCzmHXnHYnF51xw2ixnn9zFZ
	rJ/xmsWB1+P3r0mMHptWdbJ5bF5S79G3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZtw81sxSs
	Ean4NeULcwPjfYEuRk4OCQETibn377JC2GISF+6tZ+ti5OIQEljKKNH84DgTTNGpTYuYQWwh
	gUWMEm9+m0EUNTFJXP81nw0kwSagJbH/xQ0wW0RAROLe6Q+MIEXMAleZJLbvWM8OkhAWiJSY
	/2sFI4jNIqAqcX7zJaDVHBy8Ai4S/x8VQCyTk/iw5xFYOaeAq8Tu1WdYIBa7SHy9e44JZKaE
	wDF2iY13T7NDzBGQ+Db5EAvIHAkBWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKpBckFxUnpRYZ6
	xYm5xaV56XrJ+bmbGIERcvrfs94djLcPWB9iTAYaN5FZSjQ5HxhheSXxhsZmRhamJqbGRuaW
	ZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA2PkgyE9rUd+7Jdv+XJbwZKsq
	Ln/9qdVkyTzV9CVZ5zsyuqMiHJbu63FKWntLI6Qsqfvf50NctTbmSuXPM19HLE5lqOb+Uqe6
	rt3O5r572vUIZ67GKY7ip+zLylYWS7/UOPLCl0m2Je3k1GqeNXEnjmonstYsVVVJ158qPc8y
	fY/su4kbdgsosRRnJBpqMRcVJwIASyFkb6YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jAd2zx84GGxxcwWfxd9Ixdou7zw8z
	Wlz/8pzVYv6Rc6wWD5pWMVn0LrjKZnG26Q27xabH11gtFrYtYbGYd+Qdi8XlXXPYLGac38dk
	sX7GaxYHXo/fvyYxemxa1cnmsXlJvUffllWMHp83yQWwRjUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzLh9qJmlYI1Ixa8pX5gbGO8LdDFyckgImEic2rSIGcIWk7hwbz0b
	iC0ksIhR4s1vsy5GLiC7iUni+q/5YAk2AS2J/S9ugNkiAiIS905/YAQpYha4yiSxfcd6dpCE
	sECkxPxfKxhBbBYBVYnzmy+xdjFycPAKuEj8f1QAsUxO4sOeR2DlnAKuErtXn2GBWOwi8fXu
	OaYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH3zPpHYyrGiwOMQpwMCrx8E5Q
	PBssxJpYVlyZe4hRgoNZSYS3fQ9QiDclsbIqtSg/vqg0J7X4EKMp0FETmaVEk/OBqSGvJN7Q
	2MTMyNLI3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVANjn2dB+vFwh+ozdlobr7Wp
	qcz4/eGgyi4BW6m6sI06/45aKvCuUDx2XPKQGudtdQ9ZEVmZ4xONA6qSA6Nslat3LP3AcO1G
	5cLTTt0NaaZ1HFUX77/Typ+cKlfOkG69Sk/cfYYPo+4U2zmR3C9vxns9bp0VGjY3uniOvHTq
	7f2PzOS+K/GLXlJiKc5INNRiLipOBABr/3Qb1QIAAA==
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
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt | 25 ++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index 832fe8c..adc61b0 100644
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
+	compatible = "samsung,exynos3250-adc", "samsung,exynos-adc-v2;
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

