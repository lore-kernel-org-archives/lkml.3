Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3JaHqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:46:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14546 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3JaHqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:46:47 -0400
X-AuditID: cbfee691-b7f866d000001b8c-6b-52720ae65b1b
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        balbi@ti.com, jwerner@chromium.org, jg1.han@samsung.com
Subject: [PATCH 4/4] dt: exynos5420: Enable support for DWC3 controller
Date: Thu, 31 Oct 2013 13:15:44 +0530
Message-id: <1383205544-32244-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWyRsSkSvc5V1GQQX+wxcH79Rbzj5xjtWhe
	vJ7N4vLCS6wWHYceM1n8eH2BzaJ3wVU2iwtPe9gsNj2+xmqxsG0Ji8XlXXPYLGac38dksWhZ
	K7PF4TftrBbrZ7xmceD3mN1wkcVj/9w17B6bl9R79G1Zxehx/MZ2Jo/Pm+QC2KK4bFJSczLL
	Uov07RK4Ml4cPsZScIG3Yv2iTYwNjPe4uhg5OSQETCS+rV/BDmGLSVy4t56ti5GLQ0hgKaPE
	ulPbmWCKbv/bxgiRWMQosejvbmYIZwqTxJ0pn8Da2QR0JZre7mIEsUUEHCSWLL0DNopZ4BCT
	xNK9c1lAEsIC7hKNS7aC2SwCqhJ/j/4Ds3kFPCSmbH/PCLFOQeLN7WdAGzg4OAU8JRqaeEHC
	QkAlN5bOZwGZKSFwi11i44EzbBBzBCS+TT7EAlIvISArsekAM8QYSYmDK26wTGAUXsDIsIpR
	NLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMHpO/3s2cQfj/QPWhxiTgcZNZJYSTc4HRl9eSbyh
	sZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCWpTYlaEZH
	6i/lXHPc8yL3/7YJ+ctdOyecMLmguX9x6i/fFxLdUbVV9dtl55ity4w/GB3+wN8lu+CGmaOV
	2a5fCmmH/4a/Tzrid/a2351Sla1X3x08+ODM1iNpGWym662/3RaI2ix+L4ol/qfWtXaRbYt2
	qeXdfLAxTPx8gd+OOr+IaeYb35YrsRRnJBpqMRcVJwIAFpEdYbQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jAd1nXEVBBm8WmVocvF9vMf/IOVaL
	5sXr2SwuL7zEatFx6DGTxY/XF9gsehdcZbO48LSHzWLT42usFgvblrBYXN41h81ixvl9TBaL
	lrUyWxx+085qsX7GaxYHfo/ZDRdZPPbPXcPusXlJvUffllWMHsdvbGfy+LxJLoAtqoHRJiM1
	MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoZCWFssScUqBQ
	QGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxovDx1gKLvBWrF+0ibGB8R5XFyMnh4SA
	icTtf9sYIWwxiQv31rN1MXJxCAksYpRY9Hc3M4QzhUnizpRP7CBVbAK6Ek1vd4F1iAg4SCxZ
	egesg1ngEJPE0r1zWUASwgLuEo1LtoLZLAKqEn+P/gOzeQU8JKZsfw+1TkHize1nQBs4ODgF
	PCUamnhBwkJAJTeWzmeZwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwdD6T3sG4
	qsHiEKMAB6MSDy+DbmGQEGtiWXFl7iFGCQ5mJRHebSeBQrwpiZVVqUX58UWlOanFhxiTgY6a
	yCwlmpwPTBx5JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCo
	eP60UmJONr9H2WYuo/J9zV+qGMy/FN+/vPV3dsZf+UST1d+Ff9kVPZU+zJ57bkJEbulCt5O2
	LGuXnfnIPo39FHfW0b9LjP+b9m3e9i//0JcJZz7KXjlnPLvXSl5Dxtd5SXhY5mb9pMSyJE6H
	fcoz6+fMPBPEFeKdU86+1vz3T+c1b57Ih3grsRRnJBpqMRcVJwIAE4310RIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree nodes for DWC3 controller present on
Exynos 5420 SoC, to enable support for USB 3.0.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |   38 +++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 5df3308..4f676c1 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -236,7 +236,24 @@
 		status = "disabled";
 	};
 
-	usbphy@12100000 {
+	usb@12000000 {
+		compatible = "samsung,exynos5250-dwusb3";
+		clocks = <&clock 366>;
+		clock-names = "usbdrd30";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dwc3 {
+			compatible = "synopsys,dwc3";
+			reg = <0x12000000 0x10000>;
+			interrupts = <0 72 0>;
+			phys = <&usb3_phy0>;
+			phy-names = "usb3-phy";
+		};
+	};
+
+	usb3_phy0: usbphy@12100000 {
 		compatible = "samsung,exynos5420-usb3phy";
 		reg = <0x12100000 0x100 0x10040704 0x4>;
 		clocks = <&clock 366>, <&clock 1>, <&clock 152>;
@@ -244,7 +261,24 @@
 		#phy-cells = <0>;
 	};
 
-	usbphy@12500000 {
+	usb@12400000 {
+		compatible = "samsung,exynos5250-dwusb3";
+		clocks = <&clock 367>;
+		clock-names = "usbdrd30";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dwc3 {
+			compatible = "synopsys,dwc3";
+			reg = <0x12400000 0x10000>;
+			interrupts = <0 73 0>;
+			phys = <&usb3_phy1>;
+			phy-names = "usb3-phy";
+		};
+	};
+
+	usb3_phy1: usbphy@12500000 {
 		compatible = "samsung,exynos5420-usb3phy";
 		reg = <0x12500000 0x100 0x10040708 0x4>;
 		clocks = <&clock 367>, <&clock 1>, <&clock 153>;
-- 
1.7.6.5

