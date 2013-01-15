Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3AONdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:33:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40136 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab3AONdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:33:10 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-3c-50f55a927ec2
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com
Subject: [PATCH v4 1/4] ARM: Exynos5250: Enabling ehci-s5p driver
Date: Tue, 15 Jan 2013 19:08:29 +0530
Message-id: <1358257112-19595-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkRndS1NcAgzVtmhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZbxf38pcsFK44tKBO+wNjC/5uxg5OCQETCRu
	3TPpYuQEMsUkLtxbzwZiCwksZZS4dpIRIm4i8ftCE3MXIxdQfBGjxM6WX1DOZCaJHVOXMYFU
	sQnoSjS93QXWISKgKvG5bQE7iM0scIhR4tRUd5BlwgKOEt//8oOEWYBKDrT3soDYvAIeEq2P
	TkEtU5B4c/sZM0g5p4CnxIOpXiCmEFDJjMXOEJ0CEt8mH2KBuF5WYtMBsGMkBO6zSfy79Y8Z
	YoqkxMEVN1gmMAovYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREYjqf/PZPawbiyweIQ
	owAHoxIP703dLwFCrIllxZW5QJdzMCuJ8GoYfQ0Q4k1JrKxKLcqPLyrNSS0+xOgDdMlEZinR
	5HxgrOSVxBsam5ibGptaGhmZmZriEFYS52U89SRASCA9sSQ1OzW1ILUIZhwTB6dUA+PRfxpX
	/sUvt3pwSeytZ4nJ4sXhJhvMtgp+uLprlf261+cz+G/O8nbKCD61ak7C4aW9W33fGn7cs+B+
	q3+V7/oVmpGPr7baLAr9F959hS34uuxvH+d20TOFtg8qlhSuW7qpieX9VA+lznPP2Z0/i90L
	Kna0meZszfC76nCQpd18vW8r/0co2sYpsRRnJBpqMRcVJwIAdJJwyHQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAd1JUV8DDBZvlLO4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj/fpW
	5oKVwhWXDtxhb2B8yd/FyMkhIWAi8ftCEzOELSZx4d56ti5GLg4hgUWMEjtbfjFDOJOZJHZM
	XcYEUsUmoCvR9HYXI4gtIqAq8bltATuIzSxwiFHi1FT3LkYODmEBR4nvf8EWsACVHGjvZQGx
	eQU8JFofnWKEWKYg8eb2M2aQck4BT4kHU71ATCGgkhmLnScw8i5gZFjFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERzwz6R2MK5ssDjEKMDBqMTDe1P3S4AQa2JZcWUu0CUczEoivBpGXwOE
	eFMSK6tSi/Lji0pzUosPMfoA3TSRWUo0OR8YjXkl8YbGJuamxqaWJhYmZpY4hJXEeRlPPQkQ
	EkhPLEnNTk0tSC2CGcfEwSnVwGiRHr0oXf2BTo24ks3n/z2K+zpyXGr4zbQN03hWBa1eHxZX
	mvz4xXeGOMUZxmf226b+4Jt37+Qxjpjpv907zVmfX3FIe5/iIZm5Kqj709JVBbKpa7ye3H1q
	Ztso9aJyQ1YsS6Ub5/SqrJrCzT/WK3E33Kni4dd/wvlrpcD56RpHPMJv2tdsUGIpzkg01GIu
	Kk4EAA/wVxOlAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding EHCI device tree node for Exynos5250 along with
the device base adress and gpio line for vbus.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/usb/exynos-usb.txt         |   25 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 +++
 arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++
 3 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/exynos-usb.txt

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
new file mode 100644
index 0000000..e8bbb47
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -0,0 +1,25 @@
+Samsung Exynos SoC USB controller
+
+The USB devices interface with USB controllers on Exynos SOCs.
+The device node has following properties.
+
+EHCI
+Required properties:
+ - compatible: should be "samsung,exynos4210-ehci" for USB 2.0
+   EHCI controller in host mode.
+ - reg: physical base address of the controller and length of memory mapped
+   region.
+ - interrupts: interrupt number to the cpu.
+
+Optional properties:
+ - samsung,vbus-gpio:  if present, specifies the GPIO that
+   needs to be pulled up for the bus to be powered.
+
+Example:
+
+	usb@12110000 {
+		compatible = "samsung,exynos4210-ehci";
+		reg = <0x12110000 0x100>;
+		interrupts = <0 71 0>;
+		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
+	};
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 942d576..7363e14 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -204,4 +204,8 @@
 		samsung,mfc-r = <0x43000000 0x800000>;
 		samsung,mfc-l = <0x51000000 0x800000>;
 	};
+
+	usb@12110000 {
+		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 30485de..2cbe53e 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -275,6 +275,12 @@
 		#size-cells = <0>;
 	};
 
+	usb@12110000 {
+		compatible = "samsung,exynos4210-ehci";
+		reg = <0x12110000 0x100>;
+		interrupts = <0 71 0>;
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.6.5

