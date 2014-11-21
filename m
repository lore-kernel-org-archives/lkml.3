Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaKUNxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:53:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15512 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbaKUNxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:53:37 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-2c-546f43df1aae
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 10/11] arm64: dts: Enable USB 3.0 controller on exynos7
Date: Fri, 21 Nov 2014 19:05:53 +0530
Message-id: <1416576954-11997-11-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSp3vfOT/E4NIOAYuD9+st5h85x2rR
	duUgu0Xz4vVsFr0LrrJZXHjaw2ZxedccNovZS/pZLGac38dksWhZK7NF694j7BaH37SzWkz4
	fYHNYtWuP4wOfB47Z91l99i0qpPNY//cNewes+/+YPTo27KK0eP4je1MHp83yQWwR3HZpKTm
	ZJalFunbJXBl7Pl0lqXgLW/F1WV7WRsY27m7GDk5JARMJD7+28QIYYtJXLi3nq2LkYtDSGAp
	o0Tf23WMMEWTXp9hAbGFBKYzSqw5bgtRNIFJ4t6+F2wgCTYBXYmmt7vAGkQEZjNKtB0UAili
	FrjHKPH5/Xegbg4OYQF3ic3v/EFqWARUJf7tPwRWzyvgKdG1sYMVpERCQEFiziQbkDAnULhl
	/WUmiL0eEmt27WYEGSkhcItd4lLzHBaIOQIS3yYfYoHolZXYdIAZ4mZJiYMrbrBMYBRewMiw
	ilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMwek7/ezZhB+O9A9aHGAU4GJV4eD9MzwsRYk0s
	K67MPcRoCrRhIrOUaHI+MEbzSuINjc2MLExNTI2NzC3NlMR5X0v9DBYSSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAWLH9gyCzjYOHm/ebL8GpbvxrZ7JWn69OyluUM3OmQq7DscvcBRqBNTai
	a561nUph5Zrpt4wp5OWF3p7ey8tvOWpMiLvAEDxRZbXJZ2bvq/9UNQS5HNOkVUvn3maJm+Ht
	vedslKBE+FW3eMNa7XP7zhZUcTJKBrb7dTxrqo+TOPWgX3b/QwclluKMREMt5qLiRAC3s1sZ
	mQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQd37zvkhBrP62CwO3q+3mH/kHKtF
	25WD7BbNi9ezWfQuuMpmceFpD5vF5V1z2CxmL+lnsZhxfh+TxaJlrcwWrXuPsFscftPOajHh
	9wU2i1W7/jA68HnsnHWX3WPTqk42j/1z17B7zL77g9Gjb8sqRo/jN7YzeXzeJBfAHtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLOSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPPp7MsBW95K64u28vawNjO3cXIySEh
	YCIx6fUZFghbTOLCvfVsILaQwHRGiTXHbbsYuYDsCUwS9/a9AEuwCehKNL3dxQhiiwjMZpRo
	OygEUsQscI9R4vP770CTODiEBdwlNr/zB6lhEVCV+Lf/EFg9r4CnRNfGDlaQEgkBBYk5k2xA
	wpxA4Zb1l5kg9npIrNm1m3ECI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGx+Ux6
	B+OqBotDjAIcjEo8vB+m54UIsSaWFVfmHmKU4GBWEuEtF84PEeJNSaysSi3Kjy8qzUktPsRo
	CnTURGYp0eR8YNrIK4k3NDYxNzU2tTSxMDGzVBLnvXEzN0RIID2xJDU7NbUgtQimj4mDU6qB
	Uc+qYEqNuNiG65MyPnEtt1p04YfrS7uMsMs/SoNXXGOJ2mShUqCzX/nHlYeRL7mcyjbcv8ji
	Hfz1sPbeXYoNayx3Ogcq/mmdV3XyygupRfNarNlV2W+miNhsLw/s9zkdxFyYseZU/BcJnSuW
	sTqC/4Puh7ElWPWujzJwWMBW/0Wn/YrgrVsGSizFGYmGWsxFxYkAutP6w+MCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding USB 3.0 DRD controller device node, with its clock
and phy information to enable using the same on Exynos7.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm64/boot/dts/exynos/exynos7.dtsi |   35 +++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 90048b2..e633b02 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -531,6 +531,41 @@
 			clocks = <&clock_peric0 PCLK_PWM>;
 			clock-names = "timers";
 		};
+
+		usbdrd3: usb@15400000 {
+			compatible = "samsung,exynos7-dwusb3";
+			clocks = <&clock_fsys0 ACLK_USBDRD300>,
+				 <&clock_fsys0 SCLK_USBDRD300_SUSPENDCLK>,
+				 <&clock_fsys0 ACLK_AXIUS_USBDRD30X_FSYS0X>;
+			clock-names = "usbdrd30", "usbdrd30_susp_clk",
+				      "usbdrd30_axius_clk";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			dwc3 {
+				compatible = "snps,dwc3";
+				reg = <0x15400000 0x10000>;
+				interrupts = <0 223 0>;
+				phys = <&usbdrd_phy 0>, <&usbdrd_phy 1>;
+				phy-names = "usb2-phy", "usb3-phy";
+			};
+		};
+
+		usbdrd_phy: phy@15500000 {
+			compatible = "samsung,exynos7-usbdrd-phy";
+			reg = <0x15500000 0x100>;
+			clocks =
+			  <&clock_fsys0 ACLK_USBDRD300>,
+			  <&clock_fsys0 OSCCLK_PHY_CLKOUT_USB30_PHY>,
+			  <&clock_fsys0 PHYCLK_USBDRD300_UDRD30_PIPE_PCLK_USER>,
+			  <&clock_fsys0 PHYCLK_USBDRD300_UDRD30_PHYCLK_USER>,
+			  <&clock_fsys0 SCLK_USBDRD300_REFCLK>;
+			clock-names = "phy", "ref", "phy_pipe", "phy_utmi",
+				      "itp";
+			samsung,pmu-syscon = <&pmu_system_controller>;
+			#phy-cells = <1>;
+		};
 	};
 };
 
-- 
1.7.10.4

