Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3COH6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:58:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44210 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3COH60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:58:26 -0400
X-AuditID: cbfee68e-b7f946d000001e37-b3-5142d4a0a6d6
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com,
        p.paneri@samsung.com
Subject: [PATCH v4 1/2] ARM: Exynos5250: Enabling samsung-usb2phy driver
Date: Fri, 15 Mar 2013 13:26:10 +0530
Message-id: <1363334171-21812-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1363334171-21812-1-git-send-email-gautam.vivek@samsung.com>
References: <1363334171-21812-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWyRsSkWnfBFadAg+O3lSwO3q+3ODD7IavF
	2WUH2SxendnIZnF54SVWi94FV4GsXXPYLGac38dksWhZK7PF+S2dTBaHVxxgsjg2YwmjA4/H
	gs9X2D1mN1xk8bhzbQ+bx/kZCxk9+rasYvT4+VLH4/iN7UwenzfJBXBEcdmkpOZklqUW6dsl
	cGVc2n2WqWABe8WTh78ZGxgfs3YxcnJICJhIfLm8CMoWk7hwbz1bFyMXh5DAUkaJmzPmssMU
	7Xz6lBEiMZ1Rov34C2YIZwqTxP+5TcwgVWwCuhJNb3cxgtgiAukS/+/2g3UwC9xilNgy8y4T
	SEJYwEPidd9isLEsAqoSN68cAtvNCxQ/s7KfDWKdgsSb28/AhnIKeEpMXPqOBcQWAqq507ES
	bLOEwCV2ief7jjFBDBKQ+Db5EFARB1BCVmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6
	kZFecWJucWleul5yfu4mRmDcnP73rG8H480D1ocYk4HGTWSWEk3OB8ZdXkm8obGZkYWpiamx
	kbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYUyO7vQJNmWZbXT3CLvBf
	aodl9xE1ibftEQcTvnjM0JGb9/lp+v9Tu+49O7DztJtrjLXIJmmtN2mK2mx7FwhXRabNNfa8
	pK9wjMn9JeuZKrN/ewO+h1Qta5Y+5y1cL1o0u6d8fd3C/3lN3Hl/l2v4c6x83nr01GOvyiXK
	4dt8C6TMXrEKu29UYinOSDTUYi4qTgQAf0oIxrECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd0FV5wCDU59lLA4eL/e4sDsh6wW
	Z5cdZLN4dWYjm8XlhZdYLXoXXAWyds1hs5hxfh+TxaJlrcwW57d0MlkcXnGAyeLYjCWMDjwe
	Cz5fYfeY3XCRxePOtT1sHudnLGT06NuyitHj50sdj+M3tjN5fN4kF8AR1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rZJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsIYx49Lus0wFC9grnjz8zdjA+Ji1i5GTQ0LARGLn06eM
	ELaYxIV769m6GLk4hASmM0q0H3/BDOFMYZL4P7eJGaSKTUBXountLrAOEYF0if93+xlBipgF
	bjFKbJl5lwkkISzgIfG6bzE7iM0ioCpx88ohsHW8QPEzK/vZINYpSLy5/QxsKKeAp8TEpe9Y
	QGwhoJo7HSuZJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHJXPpHYwrmywOMQo
	wMGoxMN7oN8hUIg1say4MvcQowQHs5IIr6eXY6AQb0piZVVqUX58UWlOavEhxmSgqyYyS4km
	5wMTRl5JvKGxibmpsamliYWJmSVpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MDKwJpy3
	WvhB30pvi9+Xbvv+FHEhXqF3vjzx2bMCb5aHr5nAkXWssL7T2n1xm1e061nHF7peUi3Z6TtP
	bljM92+2IaPM8sdrrNd01l7Rb3JrTtoQ+Th+ye+nBovcvLOz3BviZwsUPbhZJ/jtvNlbiQMR
	IfX2jgZ1HFy2s16p7nl06FanLftmJZbijERDLeai4kQASqUiZA4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding usbphy node for Exynos5250 along with the
necessary device data to be parsed.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 59be603..5ef9c1e 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -416,6 +416,21 @@
 		clock-names = "usbhost";
 	};
 
+	usbphy@12130000 {
+		compatible = "samsung,exynos5250-usb2phy";
+		reg = <0x12130000 0x100>;
+		clocks = <&clock 1>, <&clock 285>;
+		clock-names = "ext_xtal", "usbhost";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		usbphy-sys {
+			reg = <0x10040704 0x8>,
+			      <0x10050230 0x4>;
+		};
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.6.5

