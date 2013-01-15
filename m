Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3AONdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:33:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31544 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab3AONdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:33:43 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-99-50f55ab53b77
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com
Subject: [PATCH v4 2/4] ARM: Exynos5250: Enabling ohci-exynos driver
Date: Tue, 15 Jan 2013 19:08:30 +0530
Message-id: <1358257112-19595-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkRndb1NcAg38nmSwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgyji7dz9LwWzeits3epkaGB9zdTFyckgImEjc
	/jCFEcIWk7hwbz1bFyMXh5DAUkaJfzcnM8MUXbrVwgqRWMQosfzgaXYIZzKTxJTTl1hBqtgE
	dCWa3u4CGyUioCrxuW0BO4jNLHCIUeLUVHcQW1jARaJvzgGwehagmjktn9hAbF4BD4nODU0s
	ENsUJN7cfga0mYODU8BT4sFULxBTCKhkxmJniE4BiW+TD7GAhCUEZCU2HWAGuUZC4DGbxKET
	7VBTJCUOrrjBMoFReAEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MwKA8/e+Z1A7GlQ0W
	hxgFOBiVeHhv6n4JEGJNLCuuzAU6nYNZSYRXw+hrgBBvSmJlVWpRfnxRaU5q8SFGH6BLJjJL
	iSbnAyMmryTe0NjE3NTY1NLIyMzUFIewkjgv46knAUIC6YklqdmpqQWpRTDjmDg4pRoYtx6c
	VpG+5eAvcZY4VkaOiWtdK81uRmfGz9A6ktiV+ehUdv6lgJ3iYT9Lp/w7aqF88Ffx4qMTLnQ9
	KzXo2d6UvfP5rooVEQudFQ53L26898jPTuLlrAm68eGyFv3veq1OXYw0XmqaqHN0+f+CLv3n
	y2ebaU7Wvhx/4bmXlc5Chw6Niomq51amKLEUZyQaajEXFScCAHwEPSt3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd2tUV8DDGatMLW4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj7N79
	LAWzeStu3+hlamB8zNXFyMkhIWAicelWCyuELSZx4d56ti5GLg4hgUWMEssPnmaHcCYzSUw5
	fQmsik1AV6Lp7S5GEFtEQFXic9sCdhCbWeAQo8Spqe4gtrCAi0TfnANg9SxANXNaPrGB2LwC
	HhKdG5pYILYpSLy5/Yy5i5GDg1PAU+LBVC8QUwioZMZi5wmMvAsYGVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBIf8M6kdjCsbLA4xCnAwKvHw3tT9EiDEmlhWXJkLdAoHs5IIr4bR1wAh
	3pTEyqrUovz4otKc1OJDjD5AN01klhJNzgfGY15JvKGxibmpsamliYWJmSUOYSVxXsZTTwKE
	BNITS1KzU1MLUotgxjFxcEo1MG46GnH528RNER93Pl1UGrutWszyVFNfxpyDTg8kpn52es7G
	96/y+d8Kk4TXKaVFTWw/tK8tPXnxZ/Vl3SO7bUXePZWxPKQdP/H5xYarIYwVn1nzb8jeTM5Y
	uWJqKOuTDw+u9vuunPNV/sG37reHrXIm/Fw9sS55u4PcspYmBwH55cFiU/7Jr52sxFKckWio
	xVxUnAgATgEkFqYCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding OHCI device tree node for Exynos5250 along with
the device base address.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/usb/exynos-usb.txt         |   15 +++++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index e8bbb47..f66fcdd 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -23,3 +23,18 @@ Example:
 		interrupts = <0 71 0>;
 		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
 	};
+
+OHCI
+Required properties:
+ - compatible: should be "samsung,exynos4210-ohci" for USB 2.0
+   OHCI companion controller in host mode.
+ - reg: physical base address of the controller and length of memory mapped
+   region.
+ - interrupts: interrupt number to the cpu.
+
+Example:
+	usb@12120000 {
+		compatible = "samsung,exynos4210-ohci";
+		reg = <0x12120000 0x100>;
+		interrupts = <0 71 0>;
+	};
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 2cbe53e..ebb0907 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -281,6 +281,12 @@
 		interrupts = <0 71 0>;
 	};
 
+	usb@12120000 {
+		compatible = "samsung,exynos4210-ohci";
+		reg = <0x12120000 0x100>;
+		interrupts = <0 71 0>;
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.6.5

