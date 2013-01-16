Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3APFiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 00:38:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36062 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3APFiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 00:38:50 -0500
X-AuditID: cbfee61b-b7f616d00000319b-38-50f63ce85663
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com
Subject: [PATCH v5 1/4] ARM: Exynos5250: Enabling ehci-s5p driver
Date: Wed, 16 Jan 2013 11:15:43 +0530
Message-id: <1358315143-16620-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <CAFp+6iFgaT9D2hR0pX34jo2g+GHftmA0Mw3y96-oKe0KakZOxA@mail.gmail.com>
References: <CAFp+6iFgaT9D2hR0pX34jo2g+GHftmA0Mw3y96-oKe0KakZOxA@mail.gmail.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkVvelzbcAgz3/GS0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgyvi9+SdTwWzxiubVW1kaGN8KdTFyckgImEg8
	3D6LBcIWk7hwbz1bFyMXh5DAUkaJKb9mMsEUtU+ewgKRWMQocfnbSkYIZzKTxIEXP1lBqtgE
	dCWa3u5iBLFFBFQlPrctYAexmQUOMUqcmuoOYgsLOErsm/IArJ4FqGbuoWnMIDavgIfEg32z
	WCG2KUi8uf0MKM7BwSkQLPGkXxDEFBIIkHj/IxCiU0Di2+RDLCBhCQFZiU0HmEGukRB4zCbx
	fc0CqJslJQ6uuMEygVF4ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzAoDz975n0DsZV
	DRaHGAU4GJV4eD0LvwYIsSaWFVfmAp3Owawkwvv1C1CINyWxsiq1KD++qDQntfgQow/QJROZ
	pUST84ERk1cSb2hsYm5qbGppZGRmaopDWEmcl/HUkwAhgfTEktTs1NSC1CKYcUwcnFINjIr3
	Rd7+0BM5x3qMbef17VvrGM63TnKqWpF4i2uRj9K6S99MPshdKF81mcnHZfcf0ZfHpKLv//++
	gtv1OfPVhc7m81LfpxQkzj6trZkeu+hD82Nrv7+Ck1gjbeLFXp7e8OwcA7P4rAeLajTzIhjn
	K178rvNIbP/brb6fU5lD97WdSP638Jfi2VYlluKMREMt5qLiRADPowoNdwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd0XNt8CDBpXGltc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxe/NP
	poLZ4hXNq7eyNDC+Fepi5OSQEDCRaJ88hQXCFpO4cG89WxcjF4eQwCJGicvfVjJCOJOZJA68
	+MkKUsUmoCvR9HYXI4gtIqAq8bltATuIzSxwiFHi1FR3EFtYwFFi35QHYPUsQDVzD01jBrF5
	BTwkHuybxQqxTUHize1nQHEODk6BYIkn/YIgppBAgMT7H4ETGHkXMDKsYhRNLUguKE5KzzXS
	K07MLS7NS9dLzs/dxAgO+WfSOxhXNVgcYhTgYFTi4fUs/BogxJpYVlyZC3QKB7OSCO/XL0Ah
	3pTEyqrUovz4otKc1OJDjD5AN01klhJNzgfGY15JvKGxibmpsamliYWJmSUOYSVxXsZTTwKE
	BNITS1KzU1MLUotgxjFxcEo1MCqn1rVzH0n/e+e1Z/vVb8ey3xxeZNMkJtR3MvzKMX+JzbZM
	f7dZNE3XypqzY/thpUTWlyUKBRrfm9eyvJs5bXt2zcdK9xMxXPO2+c+zyxIKmiazY6Lt8VsL
	l67b3iZp8mgr08tTxZbFgY+3Fa+UYThZLeKc+HXRRK0Y5cbAyhpf96PPnik8z1ViKc5INNRi
	LipOBACCCStCpgIAAA==
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

Changes from v4:
 - Added gpio line for VBUS of USB2.0 on snow board.

 .../devicetree/bindings/usb/exynos-usb.txt         |   25 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 +++
 arch/arm/boot/dts/exynos5250-snow.dts              |    4 +++
 arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++
 4 files changed, 39 insertions(+), 0 deletions(-)
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
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 17dd951..47b6b84 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -40,4 +40,8 @@
 				<&gpc4 5 2 3 0>, <&gpc4 6 2 3 0>;
 		};
 	};
+
+	usb@12110000 {
+		samsung,vbus-gpio = <&gpx1 1 1 3 3>;
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

