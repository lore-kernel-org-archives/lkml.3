Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbaKUNyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:54:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56642 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbaKUNyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:54:37 -0500
X-AuditID: cbfee68e-f79b46d000002b74-f9-546f441bc700
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 11/11] arm64: dts: exynos7-espresso: Add regulators for Vbus
 and Vbus-Boost
Date: Fri, 21 Nov 2014 19:05:54 +0530
Message-id: <1416576954-11997-12-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSoyvtkh9i8PWhsMXB+/UW84+cY7Vo
	u3KQ3aJ58Xo2i94FV9ksLjztYbO4vGsOm8XsJf0sFjPO72OyWLSsldmide8RdovDb9pZLSb8
	vsBmsWrXH0YHPo+ds+6ye2xa1cnmsX/uGnaP2Xd/MHr0bVnF6HH8xnYmj8+b5ALYo7hsUlJz
	MstSi/TtErgyVuz+yFrQxF/x47xIA+Ncni5GTg4JAROJa2dWs0DYYhIX7q1n62Lk4hASWMoo
	sf/EXKYuRg6wolP7XSDi0xklzh47xgjhTGCSOHp0IiNIN5uArkTT211gtojAbEaJtoNCIEXM
	AvcYJT6//w62QlggVmLe1OlsIDaLgKrE22OPWUE28Ap4Slx8pACxTEFiziQbkApOoGjL+stM
	ILaQgIfEml27wfZKCNxjl2hv38QIMUZA4tvkQywQvbISmw4wQzwjKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpRcZ6RUn5haX5qXrJefnbmIExs7pf8/6djDePGB9iFGAg1GJh3fG1LwQIdbEsuLK
	3EOMpkAbJjJLiSbnAyM0ryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGxvxVMcKy/PVl17dZf+JXkZ0645nO/DN73DldW1zKtJZa3PxyxuHOWsN9e7h3
	zv9/+wU/n1OS8s+ciOeabcJZKtEzHJ2rCpblbAhwupAc2ed6vS7SiPvyxEZOQ8O36ev+9NuU
	Mtx69bns2wPtxZPPhi+QuDQ3YXFCzO2776J+vhFmcd3xo+RfghJLcUaioRZzUXEiABZ9jKKY	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jQV1pl/wQg1nruSwO3q+3mH/kHKtF
	25WD7BbNi9ezWfQuuMpmceFpD5vF5V1z2CxmL+lnsZhxfh+TxaJlrcwWrXuPsFscftPOajHh
	9wU2i1W7/jA68HnsnHWX3WPTqk42j/1z17B7zL77g9Gjb8sqRo/jN7YzeXzeJBfAHtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLOSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPF7o+sBU38FT/OizQwzuXpYuTgkBAw
	kTi136WLkRPIFJO4cG89WxcjF4eQwHRGibPHjjFCOBOYJI4encgIUsUmoCvR9HYXmC0iMJtR
	ou2gEEgRs8A9RonP77+zgCSEBWIl5k2dzgZiswioSrw99pgVZBuvgKfExUcKEIsVJOZMsgGp
	4ASKtqy/zARiCwl4SKzZtZtxAiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBkflM
	agfjygaLQ4wCHIxKPLwfpueFCLEmlhVX5h5ilOBgVhLhLRfODxHiTUmsrEotyo8vKs1JLT7E
	aAp000RmKdHkfGDSyCuJNzQ2MTc1NrU0sTAxs1QS571xMzdESCA9sSQ1OzW1ILUIpo+Jg1Oq
	gZF1Guua5Ob9lxT8rvUHH/5y5XFDT9avhX/9w0w0vnMal5gKJAQuOZf3diqXl0XUJD7uP8Vr
	TiQuNY5/xDz986bNeiEKv1kO3n7k+XhX5Kv6BQp6j5qid624Xbs7eYWE2sLSmhz1zw8mRjjt
	fXaKJ4lH7t+OAFXRBgGmPTu3vn3uvN5MadX/+eVKLMUZiYZazEXFiQAVd6GO4gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding fixed voltage regulators for Vbus and Vbus-boost required
by USB 3.0 DRD controller on Exynos7-espresso board.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts |   43 +++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
index 5424cc4..2dedd5e 100644
--- a/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
+++ b/arch/arm64/boot/dts/exynos/exynos7-espresso.dts
@@ -30,6 +30,28 @@
 		device_type = "memory";
 		reg = <0x0 0x40000000 0x0 0xC0000000>;
 	};
+
+	usb30_vbus_reg: regulator-usb30 {
+		compatible = "regulator-fixed";
+		regulator-name = "VBUS_5V";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gph1 1 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb30_vbus_en>;
+		enable-active-high;
+	};
+
+	usb3drd_vboost_5v: regulator-usb3drd-vboost {
+		compatible = "regulator-fixed";
+		regulator-name = "VUSB_VBUS_5V";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		gpio = <&gpf4 1 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb3drd_vboost_en>;
+		enable-active-high;
+	};
 };
 
 &fin_pll {
@@ -40,6 +62,22 @@
 	status = "okay";
 };
 
+&pinctrl_bus1 {
+	usb30_vbus_en: usb30-vbus-en {
+		samsung,pins = "gph1-1";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	usb3drd_vboost_en: usb3drd-vboost-en {
+		samsung,pins = "gpf4-1";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+};
+
 &rtc {
 	status = "okay";
 };
@@ -82,3 +120,8 @@
 	bus-width = <4>;
 	disable-wp;
 };
+
+&usbdrd_phy {
+	vbus-supply = <&usb30_vbus_reg>;
+	vbus-boost-supply = <&usb3drd_vboost_5v>;
+};
-- 
1.7.10.4

