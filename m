Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3HWIIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:08:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9063 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3HWIIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:08:49 -0400
X-AuditID: cbfee68e-b7f756d000004512-80-521718909b07
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com, naveenkrishna.ch@gmail.com
Subject: [PATCH v2] arm: dts: fix NTC thermistor device nodes for cros5250
Date: Fri, 23 Aug 2013 13:33:15 +0530
Message-id: <1377244995-25568-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377172114-8312-1-git-send-email-ch.naveen@samsung.com>
References: <1377172114-8312-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkSneChHiQwa/F0hbzj5xjtehdcJXN
	YtPja6wWl3fNYbOYcX4fk8Wibf+ZLQ6vOMDkwO6x4PMVdo+ds+6ye2xeUu/Rt2UVo8fnTXIB
	rFFcNimpOZllqUX6dglcGacbtjMWnOGuOHrqD0sD4xTOLkZODgkBE4mJvR9YIWwxiQv31rN1
	MXJxCAksZZRYsaKBDaZo+b9WZojEdEaJbTsXM0I4PUwSl5tWM4FUsQmYSRxctJodJCEisIBR
	Yu7sLWDtzALmEj/eXAcrEhbwkrj0bg9YnEVAVeL4/eOMIDavgKvEufuzgGwOoHUKEnMm2YCE
	OYHC/76/ZgexhQRcJH5/Wgd2noTAInaJBz92s0LMEZD4NvkQC0SvrMSmA8wQV0tKHFxxg2UC
	o/ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIFhfvrfs74djDcPWB9iTAYaN5FZSjQ5
	HxgneSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg
	XLf46d3Tu/i2rtzwZFG76s5Zkq/TE6Ur+2t2/ftmMSUiIFy7/OoXa6mfv2f/UmH12m7Vc4Bv
	woqn38K/WUb3q/zVDPySFPux0WraqnKFwz57i558m5GiFPD46j3m1xwq6Ys60nXM7HcVZV0V
	KTGyEl91Ni/q54EPxhar7/yP/skwV8S+2u7yWiWW4oxEQy3mouJEAIaIJseJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQd0JEuJBBve+C1rMP3KO1aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBaLtv1ntji84gCTA7vHgs9X2D12zrrL7rF5Sb1H35ZVjB6fN8kF
	sEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2h
	pFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcw43bCdseAMd8XRU39YGhin
	cHYxcnJICJhILP/Xygxhi0lcuLeerYuRi0NIYDqjxLadixkhnB4mictNq5lAqtgEzCQOLlrN
	DpIQEVjAKDF39hY2kASzgLnEjzfXwYqEBbwkLr3bAxZnEVCVOH7/OCOIzSvgKnHu/iwgmwNo
	nYLEnEk2IGFOoPC/76/ZQWwhAReJ35/WsU1g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85
	P3cTIziKnkntYFzZYHGIUYCDUYmHd4KzWJAQa2JZcWXuIUYJDmYlEd4Df4FCvCmJlVWpRfnx
	RaU5qcWHGJOBjprILCWanA+M8LySeENjE3NTY1NLEwsTM0vShJXEeQ+0WgcKCaQnlqRmp6YW
	pBbBbGHi4JRqYLStS37w/LZPmcChmUmGhkIxyscufu1wuiX+aPvnCzd2rZoq+KzTnP+Jn+sM
	7a87HV9t8MnwtD1Qufnu8t77GafeXHHluWvcnPr95//sWYo14Wd2euhfub/m5rbvevOXfHi7
	I761ROPY55UvziqzTMzxOhUcoert6qHbclPn8pJNU4y/d671u52jxFKckWioxVxUnAgAyz7w
	H+YCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes NTC devices nodes connected to ADC channel 3, 4, 5 and 6
on exynos5250 based snow device.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---

Added recipients accordingly,
./scripts/get_maintainer.pl  -f of the modified files

 arch/arm/boot/dts/cros5250-common.dtsi |   33 ++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/cros5250-common.dtsi b/arch/arm/boot/dts/cros5250-common.dtsi
index dc259e8b..26bc25a 100644
--- a/arch/arm/boot/dts/cros5250-common.dtsi
+++ b/arch/arm/boot/dts/cros5250-common.dtsi
@@ -313,4 +313,37 @@
 			gpio-key,wakeup;
 		};
 	};
+
+	adc@12D10000 {
+		vdd-supply = <&buck5_reg>;
+
+		ncp15wb473@3 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 3>;
+		};
+		ncp15wb473@4 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 4>;
+		};
+		ncp15wb473@5 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 5>;
+		};
+		ncp15wb473@6 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;
+			pullup-ohm = <47000>;
+			pulldown-ohm = <0>;
+			io-channels = <&adc 6>;
+		};
+	};
 };
-- 
1.7.9.5

