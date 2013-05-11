Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3EKIJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 04:09:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9237 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab3EKIJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 04:09:13 -0400
X-AuditID: cbfee68d-b7f016d000007930-f0-518dfca7f374
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: add pin state information for DP HPD support to
 Exynos5250
Date: Sat, 11 May 2013 17:09:11 +0900
Message-id: <000001ce4e1e$d1cc5de0$756519a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5OHsUc0NHAD9xSRqu01P08e4ifqA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zI93lf3oDDbpemlicXXaQzeLywkus
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsjh1/TObxbEZSxgdODxmN1xk8bhzbQ+bx+Yl9R5XTjSx
	evRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfG6Rlt7AWzuSpubvvO2MC4haOLkZNDQsBE4sOT
	98wQtpjEhXvr2boYuTiEBJYxSlxYtpUNpmjX3rusEIlFjBL7ujZCOb8YJd6+nsIKUsUmoCbx
	5cthdhBbREBD4unuI4wgRcwC3UwSR49AjBIWCJfo+dsFZrMIqEpMnvuQCcTmFbCUeDblGDuE
	LSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvoW5VkNhx9jUjxDI9idvnGtghakQk9r14xwhRc49d
	YtfPCohdAhLfJh8CmskBFJeV2HQAaoykxMEVN1gmMIrNQrJ5FpLNs5BsnoVkwwJGllWMoqkF
	yQXFSelFhnrFibnFpXnpesn5uZsYITHau4Px9gHrQ4zJQOsnMkuJJucDYzyvJN7Q2MzIwtTE
	1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYy7dDvMA+41hX1i5Mh7
	2r5mxeO5EgfNlKzmVy3hYlDcsp43LbbkRNKv9p/d3rpHLrtw5257sebZPsEv6QLL3ySt4f+n
	deHwS/YFzsdNj7KLN9Usna00ZW9TguO6gAsOYWU60uve7Gte9lKxasOctL+/HlQ0X3L99Pa9
	16aLj4/ea16zqGNV/u0YJZbijERDLeai4kQASz450OcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAd3lf3oDDTZsMbA4u+wgm8XlhZdY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHHq+mc2i2MzljA6cHjMbrjI4nHn2h42j81L6j2unGhi
	9ejbsorR4/MmuQC2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGadntLEX
	zOaquLntO2MD4xaOLkZODgkBE4lde++yQthiEhfurWfrYuTiEBJYxCixr2sjK4Tzi1Hi7esp
	YFVsAmoSX74cZgexRQQ0JJ7uPsIIUsQs0M0kcfTIVjaQhLBAuETP3y4wm0VAVWLy3IdMIDav
	gKXEsynH2CFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHGSgsSOs68ZIZbpSdw+18AOUSMi
	se/FO8YJjAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOAU8
	k9rBuLLB4hCjAAejEg+vgkBvoBBrYllxZe4hRgkOZiUR3mcPgEK8KYmVValF+fFFpTmpxYcY
	k4E+ncgsJZqcD0xPeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAGDrLMnLDuqhvqzST/D0X9Fs4WvH3uad/+P967zmlsm2xhx6x2uQd36tzOm35xKRdC099
	f5TMbTTJTpNx8fy8Mk6uAkOxpQzL0lZayJ2qeuhXf+Npwq9LlY+esAUZal07wB2eXiMWW/qN
	M7JuwgKpVIH8K0w/XjGZd57p3yEyX/113tndL16yKbEUZyQaajEXFScCADWQ+yBFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pin state information for DP HPD support that requires
pin configuration support using pinctrl interface.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on Exynos5250

 arch/arm/boot/dts/exynos5250-pinctrl.dtsi |    7 +++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
index d1650fb..e9cdee3 100644
--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -553,6 +553,13 @@
 			samsung,pin-pud = <0>;
 			samaung,pin-drv = <0>;
 		};
+
+		dp_hpd: dp_hpd {
+			samsung,pins = "gpx0-7";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samaung,pin-drv = <0>;
+		};
 	};
 
 	pinctrl@13400000 {
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 3e0c792..d53ea34 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -224,6 +224,9 @@
 		samsung,color-depth = <1>;
 		samsung,link-rate = <0x0a>;
 		samsung,lane-count = <4>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&dp_hpd>;
 	};
 
 	display-timings {
-- 
1.7.2.5


