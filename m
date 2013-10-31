Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3JaHqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:46:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14525 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3JaHqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:46:43 -0400
X-AuditID: cbfee691-b7f866d000001b8c-18-52720ae2e656
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        balbi@ti.com, jwerner@chromium.org, jg1.han@samsung.com
Subject: [PATCH 2/4] dt: exynos5250: Enable support for generic USB 3.0 phy
Date: Thu, 31 Oct 2013 13:15:42 +0530
Message-id: <1383205544-32244-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWyRsSkSvcRV1GQwZxj3BYH79dbzD9yjtWi
	efF6NovLCy+xWnQcesxk8eP1BTaL3gVX2SwuPO1hs9j0+BqrxcK2JSwWl3fNYbOYcX4fk8Wi
	Za3MFofftLNarJ/xmsWB32N2w0UWj/1z17B7bF5S79G3ZRWjx/Eb25k8Pm+SC2CL4rJJSc3J
	LEst0rdL4Mq4eX8PY8EjzorWGVeYGxjvsXcxcnJICJhIdMzohLLFJC7cW8/WxcjFISSwlFHi
	8qc2uKJzJ5tYIRKLGCUevfzFBOFMYZKYf30VI0gVm4CuRNPbXWC2iICDxJKld8BGMQscYpJY
	uncuC0hCWMBbYvrRDawgNouAqkTjrd1gNq+Ah8TGjw8YIdYpSLy5/Yy5i5GDg1PAU6KhiRck
	LARUcmPpfBaIklvsEqs+xUCMEZD4NvkQC0i5hICsxKYDzBAlkhIHV9xgmcAovICRYRWjaGpB
	ckFxUnqRqV5xYm5xaV66XnJ+7iZGYPSc/vds4g7G+wesDzEmA42byCwlmpwPjL68knhDYzMj
	C1MTU2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAM+9ixRbdC/P2J
	CZxT03bOqXyVet1HOFB8SfLCqfc5/5qXmTNsvcvK//qJ81q7tM+FF3T45c/zy8zYfNQqzc31
	ySdXpt+fXtVKZXre2HFRUIM1ZsXF445uC43K/n/nib10bXlS/fM/XDfs/x7rFKm6/ez8YsH5
	rz9v4/jQIsI6ce6+7DlFSU3nlViKMxINtZiLihMB5iCbMrQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jAd1HXEVBBh2zmC0O3q+3mH/kHKtF
	8+L1bBaXF15iteg49JjJ4sfrC2wWvQuusllceNrDZrHp8TVWi4VtS1gsLu+aw2Yx4/w+JotF
	y1qZLQ6/aWe1WD/jNYsDv8fshossHvvnrmH32Lyk3qNvyypGj+M3tjN5fN4kF8AW1cBok5Ga
	mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
	ILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4+b9PYwFjzgrWmdcYW5gvMfexcjJISFg
	InHuZBMrhC0mceHeerYuRi4OIYFFjBKPXv5ignCmMEnMv76KEaSKTUBXountLjBbRMBBYsnS
	O2AdzAKHmCSW7p3LApIQFvCWmH50A9hYFgFVicZbu8FsXgEPiY0fHzBCrFOQeHP7GXMXIwcH
	p4CnREMTL0hYCKjkxtL5LBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7OZ9I7
	GFc1WBxiFOBgVOLhZdAtDBJiTSwrrsw9xCjBwawkwrvtJFCINyWxsiq1KD++qDQntfgQYzLQ
	UROZpUST84GJI68k3tDYxNzU2NTSxMLEzJI0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUa
	GO1+TwvYdaYrvf3tRC0TuVttl+/91uIN0Vvm5RSUm331jrCfXblj7epntqwHTIq0TZ/wpu4x
	VSqW7Os0D6lY8On/Wr2Y2cFPnSemVd1pa7I/VMQj2CFQV75g4UnpDZv3iFTq1uttYzq2/t1G
	+XSeFcej1WsFW642J4UWHI52P9x97mjV6/tZSizFGYmGWsxFxYkAs4PwMBIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update device tree bindings for DWC3 controller and
USB 3.0 phy present on Exynos 5250 SoC, to start using
the phy driver based on generic phy framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index bbac42a..31a6595 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -472,22 +472,17 @@
 			compatible = "synopsys,dwc3";
 			reg = <0x12000000 0x10000>;
 			interrupts = <0 72 0>;
-			usb-phy = <&usb2_phy &usb3_phy>;
+			phys = <&usb3_phy>;
+			phy-names = "usb3-phy";
 		};
 	};
 
 	usb3_phy: usbphy@12100000 {
 		compatible = "samsung,exynos5250-usb3phy";
-		reg = <0x12100000 0x100>;
-		clocks = <&clock 1>, <&clock 286>;
-		clock-names = "ext_xtal", "usbdrd30";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		usbphy-sys {
-			reg = <0x10040704 0x8>;
-		};
+		reg = <0x12100000 0x100 0x10040704 0x4>;
+		clocks = <&clock 286>, <&clock 1>;
+		clock-names = "phy", "usb3drd";
+		#phy-cells = <0>;
 	};
 
 	usb@12110000 {
-- 
1.7.6.5

