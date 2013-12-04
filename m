Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3LDKKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:10:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43495 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab3LDKJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:09:52 -0500
X-AuditID: cbfee68d-b7f5c6d000004aff-4e-529eff6e50c7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, kishon@ti.com, jg1.han@samsung.com,
        s.nawrocki@samsung.com, t.figa@samsung.com, jwerner@chromium.org,
        k.debski@samsung.com
Subject: [PATCH v2 2/4] dt: exynos5250: Enable support for generic USB 3.0 phy
Date: Wed, 04 Dec 2013 15:39:05 +0530
Message-id: <1386151747-3209-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
References: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkVjfv/7wgg5kLJC0O3q+3ODD7IatF
	8+L1bBaXF15iteg49JjJ4sfrC2wWvQuusllceNrDZrGwbQmLxeVdc9gsZpzfx2SxaFkrs8Xh
	FQeYLA6/aWe1WD/jNYsDv8eCz1fYPWY3XGTx2D93DbvH+RkLGT36tqxi9Dh+YzuTx+dNcgHs
	UVw2Kak5mWWpRfp2CVwZt0//Yil4zlmx8UAvcwPjU/YuRk4OCQETielvVjBB2GISF+6tZ+ti
	5OIQEljKKNF78BZc0c3Xh5ggEtMZJS5fusII4UxhkpjQeJERpIpNQFei6e0uMFtEIF3i/91+
	MJtZYCaTxJTNkiC2sICfxKzjN1lBbBYBVYnvxy6AbeAVcJe40DudDWKbgsSb28+YQWxOAQ+J
	lRsngM0RAqrZ9fIFM8hiCYFH7BLNny4yQQwSkPg2+RBLFyMHUEJWYtMBZog5khIHV9xgmcAo
	vICRYRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYCyd/vesdwfj7QPWhxiTgcZNZJYSTc4H
	xmJeSbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBu
	FA+eNfldAFd0ltbD4tTMPu3GmOv6QbrnPH7WqXxRrZw3xXyF5f93IZccPbiKau7dMLtr4X/e
	jT+UeeGf9U13v9x6umHVpqqrVq/CHu9k5G3k3nenfE0+122dzSXRD8VrT3QLZRequ7ZZ+zim
	yDiXlmd0ZNzIfqyfIVpyrcZ/iULo/J+S+kosxRmJhlrMRcWJAALdUom7AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoG7e/3lBBo/uC1gcvF9vcWD2Q1aL
	5sXr2SwuL7zEatFx6DGTxY/XF9gsehdcZbO48LSHzWJh2xIWi8u75rBZzDi/j8li0bJWZovD
	Kw4wWRx+085qsX7GaxYHfo8Fn6+we8xuuMjisX/uGnaP8zMWMnr0bVnF6HH8xnYmj8+b5ALY
	oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADldS
	KEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZtw+/Yul4DlnxcYDvcwNjE/Z
	uxg5OSQETCRuvj7EBGGLSVy4t56ti5GLQ0hgOqPE5UtXGCGcKUwSExovMoJUsQnoSjS93QVm
	iwikS/y/2w9mMwvMZJKYslkSxBYW8JOYdfwmK4jNIqAq8f3YBbBtvALuEhd6p7NBbFOQeHP7
	GTOIzSngIbFy4wSwOUJANbtevmCewMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw
	pD6T3sG4qsHiEKMAB6MSD28C57wgIdbEsuLK3EOMEhzMSiK8mX+AQrwpiZVVqUX58UWlOanF
	hxiTga6ayCwlmpwPTCJ5JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJzU5NLUgtgtnC
	xMEp1cC4YkGqVfTyY4qvzT/tOz/dy7pger2r7dGXO/Vu1f/jkF+/9/ROJZuLJ20ONjl2xGeG
	q9oIX3TfeKJc/mut8QnLV63hD8KmLam333PU6pjXi4O6jV0K/TeKey55x91K0ap7oLyIOUnb
	9W+qqa38k+J+01fz5GKXLA9bl+l7djIT91Tl6wcWLZZVYinOSDTUYi4qTgQA9Of2GBgDAAA=
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
 arch/arm/boot/dts/exynos5250.dtsi |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 9db5047..7444717 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -475,22 +475,18 @@
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
 		reg = <0x12100000 0x100>;
-		clocks = <&clock 1>, <&clock 286>;
-		clock-names = "ext_xtal", "usbdrd30";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		usbphy-sys {
-			reg = <0x10040704 0x8>;
-		};
+		clocks = <&clock 286>, <&clock 1>;
+		clock-names = "phy", "usb3phy_refclk";
+		samsung,syscon-phandle = <&pmu_syscon>;
+		#phy-cells = <0>;
 	};
 
 	usb@12110000 {
-- 
1.7.6.5

