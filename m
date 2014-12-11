Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbaLKMMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:12:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42613 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaLKMMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:12:46 -0500
X-AuditID: cbfee68e-f79b46d000002b74-8f-54898a3ba4c1
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, kishon@ti.com, k.debski@samsung.com, kgene@kernel.org,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 3/4] arm: dts: exynos5250: Use regulator for USB 2.0 VBUS supply
Date: Thu, 11 Dec 2014 17:32:46 +0530
Message-id: <1418299367-2412-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
References: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkRte6qzPE4P9eBYv5R86xWrRdOchu
	cXnhJVaLH68vsFn0P37NbHHhaQ+bxeVdc9gsZpzfx2SxaFkrs0Xr3iPsDlwem1Z1snn0bVnF
	6HH8xnYmj8+b5AJYorhsUlJzMstSi/TtErgydh7YwFrwQKhiwYbrbA2MU/m7GDk5JARMJHoa
	5zFD2GISF+6tZwOxhQSWMko0TXKGqek+dpm9i5ELKL6IUeLJvgssEM4EJome3y1g3WwCuhJN
	b3cxgtgiAjUSU25dAetgFuhllPj34RwrSEJYIEBiQ9drMJtFQFXi7rd/TCA2r4C7xOSDKxkh
	1slJbLn1iB3E5hTwkFjU8xNoGwfQNneJq72aIDMlBFaxS6z5t48ZYo6AxLfJh8BqJARkJTYd
	gPpGUuLgihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIDP3T/5717WC8ecD6
	EKMAB6MSD29GfGeIEGtiWXFl7iFGU6ANE5mlRJPzgRGWVxJvaGxmZGFqYmpsZG5ppiTOmyD1
	M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY3ZkiPre8AksvEU5HkL5D50VOf7W8oa0Lmaf
	+uBsikGS+lrnzw+7XrnzXF+8fd3sxZOyu33UFv0xNJVvWXtLmzum5G6pZ6runJonN99MWLt8
	zplZ3c0hvtLeG28YZStWc+dEZeQGO779IJO/Z+2/WSKpXWrmG1mfcH6Z8iRvQr8RV6zfRpOF
	SizFGYmGWsxFxYkAojqZwHgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAV3rrs4Qg89zJCzmHznHatF25SC7
	xeWFl1gtfry+wGbR//g1s8WFpz1sFpd3zWGzmHF+H5PFomWtzBate4+wO3B5bFrVyebRt2UV
	o8fxG9uZPD5vkgtgiWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
	VXLxCdB1y8wBukhJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLHzwAbW
	ggdCFQs2XGdrYJzK38XIySEhYCLRfewyO4QtJnHh3nq2LkYuDiGBRYwST/ZdYIFwJjBJ9Pxu
	YQapYhPQlWh6u4sRxBYRqJGYcusKO0gRs0Avo8S/D+dYQRLCAgESG7peg9ksAqoSd7/9YwKx
	eQXcJSYfXMkIsU5OYsutR2CrOQU8JBb1/ATaxgG0zV3iaq/mBEbeBYwMqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzGCY+uZ9A7GVQ0WhxgFOBiVeHgz4jtDhFgTy4orcw8xSnAwK4nwWkUA
	hXhTEiurUovy44tKc1KLDzGaAh01kVlKNDkfGPd5JfGGxibmpsamliYWJmaWSuK8SvZtIUIC
	6YklqdmpqQWpRTB9TBycUg2M818e+jjZ7GzWvRM53KcyQ9tul7OsD9DZLHPUOaHtZyOTtbEC
	X86/nq6lmXKRe78y3i/sfdIlNn/3rLcL/t55fGmny9p+3nTLYz06vzQfTrQsj8hTaVsnoBbb
	LnmPUX5Fov6j1WcKSpgkmjdMSFpVoqCbJdHw8dH9vSGCWd+DpRTftu3dy75LiaU4I9FQi7mo
	OBEA+5s3EMMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start using VBUS regulator for USB 2.0 phy, so that we can
remove the gpio property from host's node later.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts |   22 ++++++++++++++++++++++
 arch/arm/boot/dts/exynos5250-snow.dts     |   22 ++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index a759100..85e74df 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -361,6 +361,17 @@
 		samsung,audio-codec = <&wm8994>;
 	};
 
+	usb2_vbus_reg: regulator-usb2 {
+		compatible = "regulator-fixed";
+		regulator-name = "P5.0V_USB2";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gpx2 6 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb2_vbus_en>;
+		enable-active-high;
+	};
+
 	usb@12110000 {
 		samsung,vbus-gpio = <&gpx2 6 0>;
 	};
@@ -418,4 +429,15 @@
 		samsung,pin-pud = <0>;
 		samsung,pin-drv = <0>;
 	};
+
+	usb2_vbus_en: usb2-vbus-en {
+		samsung,pins = "gpx2-6";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
+
+&usb2_phy_gen {
+	vbus-supply = <&usb2_vbus_reg>;
 };
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 60429ad..8085750 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -285,6 +285,17 @@
 		vbus-supply = <&usb3_vbus_reg>;
 	};
 
+	usb2_vbus_reg: regulator-usb2 {
+		compatible = "regulator-fixed";
+		regulator-name = "P5.0V_USB2";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gpx1 1 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb2_vbus_en>;
+		enable-active-high;
+	};
+
 	usb@12110000 {
 		samsung,vbus-gpio = <&gpx1 1 0>;
 	};
@@ -616,6 +627,13 @@
 		samsung,pin-pud = <0>;
 		samsung,pin-drv = <0>;
 	};
+
+	usb2_vbus_en: usb2-vbus-en {
+		samsung,pins = "gpx1-1";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
 };
 
 &spi_1 {
@@ -628,4 +646,8 @@
 	dr_mode = "host";
 };
 
+&usb2_phy_gen {
+	vbus-supply = <&usb2_vbus_reg>;
+};
+
 #include "cros-ec-keyboard.dtsi"
-- 
1.7.10.4

