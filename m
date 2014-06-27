Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaF0Eaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:30:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65270 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaF0EaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:30:16 -0400
X-AuditID: cbfee68f-b7fef6d000003970-fd-53acf3554ac1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
Date: Fri, 27 Jun 2014 13:30:05 +0900
Message-id: <1403843406-28229-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWyRsSkQDf085pgg0nL1S3uPj/MaHH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWzONv0ht1i3pF3LBaXd81hs5hxfh+TxdLrF5ks
	Jkxfy2Lx9s50FovWvUfYLU7+6WW0WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbw+bRt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGe833WQsWCVc0fe0la2B8TF/FyMnh4SA
	icT3B/vZIWwxiQv31rN1MXJxCAksZZTof/6ECabo/JI37BCJ6YwSv568ZoZwmpgkWjvXMINU
	sQloSex/cYMNxBYRiJCYv3kHE0gRs8AzoKIXfYwgCWGBSImvC88DNXBwsAioStxb6wcS5hVw
	lbjRcYUFYpucxIc9j9hBSjgF3CQmPikACQsBlbz4voUVZKSEwE92ic1XboNdxyIgIPFt8iEW
	kHoJAVmJTQeYIcZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBcXb6
	37P+HYx3D1gfYkwGGjeRWUo0OR8Yp3kl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgTFwk5bvdZmfewxlri+zehbRtJ6xLK5gcnPHXqOzj29P48p3
	uj9rZl5hZ7jHg9ogbqYKn9s+4g4M8RZH1bKfS5heXH3/iv0bfbNfX1jP+iXKrjdMu79In/vr
	3vY8x/Ic02lGZ3gP9qRxa2/beOqQO8PhqZWC4dOFuPWldS+LWSZxXDTZu43xgxJLcUaioRZz
	UXEiAL/yg9jJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd3Qz2uCDVb3ylncfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmcbbpDbvFvCPvWCwu75rDZjHj/D4mi6XXLzJZ
	TJi+lsXi7Z3pLBate4+wW5z808tosX7GaxYHQY8189Ywelzu62XyWLn8C5vH5hVaHptWdbJ5
	3Lm2h82jb8sqRo/Pm+QCOKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
	EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGa8
	33STsWCVcEXf01a2BsbH/F2MnBwSAiYS55e8YYewxSQu3FvP1sXIxSEkMJ1R4teT18wQThOT
	RGvnGmaQKjYBLYn9L26wgdgiAhES8zfvYAIpYhZ4BlT0oo8RJCEsECnxdeF5oAYODhYBVYl7
	a/1AwrwCrhI3Oq6wQGyTk/iw5xE7SAmngJvExCcFIGEhoJIX37ewTmDkXcDIsIpRNLUguaA4
	KT3XSK84Mbe4NC9dLzk/dxMjOIqfSe9gXNVgcYhRgINRiYe3w2tNsBBrYllxZe4hRgkOZiUR
	3pf3gEK8KYmVValF+fFFpTmpxYcYTYFumsgsJZqcD0wweSXxhsYmZkaWRuaGFkbG5krivAdb
	rQOFBNITS1KzU1MLUotg+pg4OKUaGI3Y+K2kXyzlvN8dckg2zcrDvMJcs3etf6nSFPn20+/i
	OPZLOLOed2d2vnRjSYSC/mLTX98nl3+w7HGae3mrdeV29q3vb3vvMntnfKbvWtKs/oPW+rPn
	vgw1KLVYclvd0enWqsCz/at+zFz8OPZUU1Xq4pnvWDdpTfdf8/2drUDh/6d27ud0u5RYijMS
	DbWYi4oTAXzXyRX4AgAA
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
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt | 26 ++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index 5d49f2b..b87749a 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -14,14 +14,22 @@ Required properties:
 				for exynos4412/5250 controllers.
 			Must be "samsung,exynos-adc-v2" for
 				future controllers.
+			Must be "samsung,exynos3250-adc-v2" for
+				for controllers compatible with ADC of
+				Exynos3250.
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
@@ -41,6 +49,20 @@ adc: adc@12D10000 {
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

