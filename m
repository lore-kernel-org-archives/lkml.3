Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaKXNNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:13:53 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13607 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaKXNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:13:35 -0500
X-AuditID: cbfee691-f79b86d000004a5a-48-54732efdc26d
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        linus.walleij@linaro.org, kgene@kernel.org, alim.akhtar@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH V2 2/2] arm64: exynos: Add bus1 pinctrl node on exynos7
Date: Mon, 24 Nov 2014 18:36:21 +0530
Message-id: <1416834381-11314-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <CAGOxZ53TUvZhSDLfeCuyvBwVcrkQhFnftQzk1DbkU_krdoFbZA@mail.gmail.com>
References: <CAGOxZ53TUvZhSDLfeCuyvBwVcrkQhFnftQzk1DbkU_krdoFbZA@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkWvevXnGIwfcLOhYP5m1js5h/5Byr
	RduVg+wW/Y9fM1tM+bOcyeLyrjlsFjPO72OyWLSsldmide8RdovDb9pZLVbt+sPowO2xc9Zd
	do9NqzrZPO5c28Pm0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBnnT71gKTgpXrF95nSWBsZz
	Ql2MHBwSAiYSC1e5dzFyApliEhfurWfrYuTiEBJYyijxcvdPZoiEicSjvhOMEIlFjBJXrqxl
	gnAmMEl0LHnGAlLFJqAr0fR2FyOILSJQIzHl1hV2kCJmge2MEut2XWYCSQgLuEtMXbAYrIhF
	QFWi4dUcVhCbV8BD4tvEp4wQJylIzJlkAxLmFAiWeDF3AxuILSQQIHH82S4WkJkSAvvYJV48
	vcwCMUdA4tvkQywQvbISmw5AXS0pcXDFDZYJjMILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl
	5+duYgTGw+l/zybuYLx/wPoQowAHoxIP74z1RSFCrIllxZW5hxhNgTZMZJYSTc4HRl1eSbyh
	sZmRhamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MmcypPosjM/zW
	1C7znHpnj7virJKi7fobC22V82b9c4ud/K2U86nJZdMb+n+7+YyEVZgSDS7s6+1y5r1w1eiE
	LXPCIe3nsV4nDE+dL1PsnDS1ZdN8Zrffhwr38J/pKVVozLraxv5ntSjjXpNM3/zjXulmF0qm
	Vl+uO38p5/zh2Y1ztaRm8J9TYinOSDTUYi4qTgQAZmHgmYICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd2/esUhBv1rlC0ezNvGZjH/yDlW
	i7YrB9kt+h+/ZraY8mc5k8XlXXPYLGac38dksWhZK7NF694j7BaH37SzWqza9YfRgdtj56y7
	7B6bVnWyedy5tofNo2/LKkaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
	DS0tzJUU8hJzU22VXHwCdN0yc4BuU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12Nk
	gAYS1jBmnD/1gqXgpHjF9pnTWRoYzwl1MXJySAiYSDzqO8EIYYtJXLi3nq2LkYtDSGARo8SV
	K2uZIJwJTBIdS56xgFSxCehKNL3dBdYhIlAjMeXWFXaQImaB7YwS63ZdZgJJCAu4S0xdsBis
	iEVAVaLh1RxWEJtXwEPi28SnQHEOoHUKEnMm2YCEOQWCJV7M3cAGYgsJBEgcf7aLZQIj7wJG
	hlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwfH2TGoH48oGi0OMAhyMSjy8HzYWhQixJpYV
	V+YeYpTgYFYS4RUTKw4R4k1JrKxKLcqPLyrNSS0+xGgKdNREZinR5HxgKsgriTc0NjE3NTa1
	NLEwMbNUEue9cTM3REggPbEkNTs1tSC1CKaPiYNTqoExZPqG0wkvY263Ndf1yvokP/xhc2b9
	w7sBDSeCLAx9P0ftSP8v8Mby5jYPDh9Nl4Sk4/xvFWX4z08WzRadeebv6omxzyYfq1Xvj5t+
	8xZjpIq3+aG928P8WOdrNwo9CT7N6zF9x6FAS6GJUzXZ49QuRPxg8fIJE71qov3p0/y1Oq0z
	xea13fVSYinOSDTUYi4qTgQA5pC8IM0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUS1 pinctrl provides gpios for usb and power regulator
available on exynos7-espresso board. So add relevant device
node for pinctrl-bus1.

Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

This patch was part of series:
"[PATCH 00/11] Exynos7: Adding USB 3.0 support"
 https://lkml.org/lkml/2014/11/21/247

Changes since V1:
 - Added support for all pin banks which are part of BUS1 pin controller.

 arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi |   82 +++++++++++++++++++++++
 arch/arm64/boot/dts/exynos/exynos7.dtsi         |    7 ++
 2 files changed, 89 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi b/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
index 2eef4a2..c367f0a 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
@@ -335,6 +335,88 @@
 	};
 };
 
+&pinctrl_bus1 {
+	gpf0: gpf0 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf1: gpf1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf2: gpf2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf3: gpf3 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf4: gpf4 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpf5: gpf5 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg1: gpg1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpg2: gpg2 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gph1: gph1 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	gpv6: gpv6 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+};
+
 &pinctrl_nfc {
 	gpj0: gpj0 {
 		gpio-controller;
diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 1d9e4c9..e633b02 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -26,6 +26,7 @@
 		pinctrl5 = &pinctrl_ese;
 		pinctrl6 = &pinctrl_fsys0;
 		pinctrl7 = &pinctrl_fsys1;
+		pinctrl8 = &pinctrl_bus1;
 	};
 
 	cpus {
@@ -242,6 +243,12 @@
 			interrupts = <0 383 0>;
 		};
 
+		pinctrl_bus1: pinctrl@14870000 {
+			compatible = "samsung,exynos7-pinctrl";
+			reg = <0x14870000 0x1000>;
+			interrupts = <0 384 0>;
+		};
+
 		pinctrl_nfc: pinctrl@14cd0000 {
 			compatible = "samsung,exynos7-pinctrl";
 			reg = <0x14cd0000 0x1000>;
-- 
1.7.10.4

