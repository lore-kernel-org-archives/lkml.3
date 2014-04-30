Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964880AbaD3M7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:59:46 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:37390 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912AbaD3M44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:56:56 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] ARM: dts: kirkwood: rename pin-controller nodes
Date: Wed, 30 Apr 2014 14:56:32 +0200
Message-Id: <1398862602-29595-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare pin-controller consolidation, first rename all pinctrl nodes
to a more appropriate name regarding ePAPR recommended names.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/kirkwood-6192.dtsi                   | 2 +-
 arch/arm/boot/dts/kirkwood-6281.dtsi                   | 2 +-
 arch/arm/boot/dts/kirkwood-6282.dtsi                   | 2 +-
 arch/arm/boot/dts/kirkwood-98dx4122.dtsi               | 2 +-
 arch/arm/boot/dts/kirkwood-b3.dts                      | 2 +-
 arch/arm/boot/dts/kirkwood-cloudbox.dts                | 2 +-
 arch/arm/boot/dts/kirkwood-db.dtsi                     | 2 +-
 arch/arm/boot/dts/kirkwood-dnskw.dtsi                  | 2 +-
 arch/arm/boot/dts/kirkwood-dockstar.dts                | 2 +-
 arch/arm/boot/dts/kirkwood-dreamplug.dts               | 2 +-
 arch/arm/boot/dts/kirkwood-goflexnet.dts               | 2 +-
 arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts    | 2 +-
 arch/arm/boot/dts/kirkwood-ib62x0.dts                  | 2 +-
 arch/arm/boot/dts/kirkwood-iconnect.dts                | 2 +-
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts          | 2 +-
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts             | 2 +-
 arch/arm/boot/dts/kirkwood-laplug.dts                  | 2 +-
 arch/arm/boot/dts/kirkwood-lsxl.dtsi                   | 2 +-
 arch/arm/boot/dts/kirkwood-mplcec4.dts                 | 2 +-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts         | 2 +-
 arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts | 2 +-
 arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts | 2 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi             | 2 +-
 arch/arm/boot/dts/kirkwood-nsa310.dts                  | 2 +-
 arch/arm/boot/dts/kirkwood-nsa310a.dts                 | 2 +-
 arch/arm/boot/dts/kirkwood-nsa320.dts                  | 2 +-
 arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi          | 2 +-
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts           | 2 +-
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts           | 2 +-
 arch/arm/boot/dts/kirkwood-rd88f6192.dts               | 2 +-
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi              | 2 +-
 arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi      | 2 +-
 arch/arm/boot/dts/kirkwood-synology.dtsi               | 2 +-
 arch/arm/boot/dts/kirkwood-t5325.dts                   | 2 +-
 arch/arm/boot/dts/kirkwood-topkick.dts                 | 2 +-
 arch/arm/boot/dts/kirkwood-ts219-6281.dts              | 2 +-
 arch/arm/boot/dts/kirkwood-ts219-6282.dts              | 2 +-
 arch/arm/boot/dts/kirkwood-ts419.dtsi                  | 2 +-
 38 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-6192.dtsi b/arch/arm/boot/dts/kirkwood-6192.dtsi
index 294a6fa0208c..4f1eef36a7ac 100644
--- a/arch/arm/boot/dts/kirkwood-6192.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6192.dtsi
@@ -35,7 +35,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			compatible = "marvell,88f6192-pinctrl";
 			reg = <0x10000 0x20>;
 
diff --git a/arch/arm/boot/dts/kirkwood-6281.dtsi b/arch/arm/boot/dts/kirkwood-6281.dtsi
index 2560cbbdb0b3..d95a7a9cfd1e 100644
--- a/arch/arm/boot/dts/kirkwood-6281.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6281.dtsi
@@ -35,7 +35,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			compatible = "marvell,88f6281-pinctrl";
 			reg = <0x10000 0x20>;
 
diff --git a/arch/arm/boot/dts/kirkwood-6282.dtsi b/arch/arm/boot/dts/kirkwood-6282.dtsi
index f4b4786b9a01..523d6feeaf19 100644
--- a/arch/arm/boot/dts/kirkwood-6282.dtsi
+++ b/arch/arm/boot/dts/kirkwood-6282.dtsi
@@ -56,7 +56,7 @@
 	};
 	ocp@f1000000 {
 
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			compatible = "marvell,88f6282-pinctrl";
 			reg = <0x10000 0x20>;
 
diff --git a/arch/arm/boot/dts/kirkwood-98dx4122.dtsi b/arch/arm/boot/dts/kirkwood-98dx4122.dtsi
index 3271e4c8ea07..c59e7b75b169 100644
--- a/arch/arm/boot/dts/kirkwood-98dx4122.dtsi
+++ b/arch/arm/boot/dts/kirkwood-98dx4122.dtsi
@@ -1,6 +1,6 @@
 / {
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			compatible = "marvell,98dx4122-pinctrl";
 			reg = <0x10000 0x20>;
 
diff --git a/arch/arm/boot/dts/kirkwood-b3.dts b/arch/arm/boot/dts/kirkwood-b3.dts
index 86073f4f31ac..c723ce7ad1b8 100644
--- a/arch/arm/boot/dts/kirkwood-b3.dts
+++ b/arch/arm/boot/dts/kirkwood-b3.dts
@@ -45,7 +45,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_button_power: pmx-button-power {
 				marvell,pins = "mpp39";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-cloudbox.dts b/arch/arm/boot/dts/kirkwood-cloudbox.dts
index 65ae6471d553..3f30475fea11 100644
--- a/arch/arm/boot/dts/kirkwood-cloudbox.dts
+++ b/arch/arm/boot/dts/kirkwood-cloudbox.dts
@@ -18,7 +18,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_cloudbox_sata0: pmx-cloudbox-sata0 {
 				marvell,pins = "mpp15";
 				marvell,function = "sata0";
diff --git a/arch/arm/boot/dts/kirkwood-db.dtsi b/arch/arm/boot/dts/kirkwood-db.dtsi
index 68dfb3ad57dd..9b62f78b516b 100644
--- a/arch/arm/boot/dts/kirkwood-db.dtsi
+++ b/arch/arm/boot/dts/kirkwood-db.dtsi
@@ -26,7 +26,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl@10000 {
+		pin-controller@10000 {
 			pmx_sdio_gpios: pmx-sdio-gpios {
 				marvell,pins = "mpp37", "mpp38";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-dnskw.dtsi b/arch/arm/boot/dts/kirkwood-dnskw.dtsi
index d5aa9564a287..bcc6e0f48571 100644
--- a/arch/arm/boot/dts/kirkwood-dnskw.dtsi
+++ b/arch/arm/boot/dts/kirkwood-dnskw.dtsi
@@ -50,7 +50,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 
 			pinctrl-0 = <&pmx_power_back_on &pmx_present_sata0
 				     &pmx_present_sata1 &pmx_fan_tacho
diff --git a/arch/arm/boot/dts/kirkwood-dockstar.dts b/arch/arm/boot/dts/kirkwood-dockstar.dts
index d703f3eeef1c..849736349511 100644
--- a/arch/arm/boot/dts/kirkwood-dockstar.dts
+++ b/arch/arm/boot/dts/kirkwood-dockstar.dts
@@ -18,7 +18,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_usb_power_enable: pmx-usb-power-enable {
 				marvell,pins = "mpp29";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-dreamplug.dts b/arch/arm/boot/dts/kirkwood-dreamplug.dts
index 8ed737e9aa2f..dd8d1a4611a8 100644
--- a/arch/arm/boot/dts/kirkwood-dreamplug.dts
+++ b/arch/arm/boot/dts/kirkwood-dreamplug.dts
@@ -18,7 +18,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_led_bluetooth: pmx-led-bluetooth {
 				marvell,pins = "mpp47";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-goflexnet.dts b/arch/arm/boot/dts/kirkwood-goflexnet.dts
index 5e39cc3ca95e..aa60a0b049a7 100644
--- a/arch/arm/boot/dts/kirkwood-goflexnet.dts
+++ b/arch/arm/boot/dts/kirkwood-goflexnet.dts
@@ -18,7 +18,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_usb_power_enable: pmx-usb-power-enable {
 				marvell,pins = "mpp29";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
index 3994a86f989e..871a5f8afb01 100644
--- a/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
+++ b/arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts
@@ -18,7 +18,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_led_health_r: pmx-led-health-r {
 				marvell,pins = "mpp46";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-ib62x0.dts b/arch/arm/boot/dts/kirkwood-ib62x0.dts
index 810818b2bff6..6804638eb87e 100644
--- a/arch/arm/boot/dts/kirkwood-ib62x0.dts
+++ b/arch/arm/boot/dts/kirkwood-ib62x0.dts
@@ -18,7 +18,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_led_os_red: pmx-led-os-red {
 				marvell,pins = "mpp22";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-iconnect.dts b/arch/arm/boot/dts/kirkwood-iconnect.dts
index 7c4cd7e7535b..38e31d15a62d 100644
--- a/arch/arm/boot/dts/kirkwood-iconnect.dts
+++ b/arch/arm/boot/dts/kirkwood-iconnect.dts
@@ -30,7 +30,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_button_reset: pmx-button-reset {
 				marvell,pins = "mpp12";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts b/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
index 9a8d40a17938..05291f3990d0 100644
--- a/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
+++ b/arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
@@ -18,7 +18,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-0 = < &pmx_led_sata_brt_ctrl_1
 				      &pmx_led_sata_brt_ctrl_2
 				      &pmx_led_backup_brt_ctrl_1
diff --git a/arch/arm/boot/dts/kirkwood-km_kirkwood.dts b/arch/arm/boot/dts/kirkwood-km_kirkwood.dts
index 2213a20e7871..db14bd03b86b 100644
--- a/arch/arm/boot/dts/kirkwood-km_kirkwood.dts
+++ b/arch/arm/boot/dts/kirkwood-km_kirkwood.dts
@@ -18,7 +18,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-0 = < &pmx_i2c_gpio_sda &pmx_i2c_gpio_scl >;
 			pinctrl-names = "default";
 
diff --git a/arch/arm/boot/dts/kirkwood-laplug.dts b/arch/arm/boot/dts/kirkwood-laplug.dts
index 6e83b13fc26a..4f7741184f98 100644
--- a/arch/arm/boot/dts/kirkwood-laplug.dts
+++ b/arch/arm/boot/dts/kirkwood-laplug.dts
@@ -55,7 +55,7 @@
 			};
 		};
 
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_usb_power_enable: pmx-usb-power-enable {
 				marvell,pins = "mpp14";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-lsxl.dtsi b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
index ed3cdfbb45bb..53484474df1f 100644
--- a/arch/arm/boot/dts/kirkwood-lsxl.dtsi
+++ b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
@@ -8,7 +8,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_power_hdd: pmx-power-hdd {
 				marvell,pins = "mpp10";
 				marvell,function = "gpo";
diff --git a/arch/arm/boot/dts/kirkwood-mplcec4.dts b/arch/arm/boot/dts/kirkwood-mplcec4.dts
index b23abfe08d2f..414024c578e8 100644
--- a/arch/arm/boot/dts/kirkwood-mplcec4.dts
+++ b/arch/arm/boot/dts/kirkwood-mplcec4.dts
@@ -28,7 +28,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_led_health: pmx-led-health {
 				marvell,pins = "mpp7";
 				marvell,function = "gpo";
diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
index 444257c08a0c..52b80b108f8e 100644
--- a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
+++ b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
@@ -42,7 +42,7 @@
         };
 
 	ocp@f1000000 {
-		pinctrl@10000 {
+		pin-controller@10000 {
 			pmx_usb_led: pmx-usb-led {
 				marvell,pins = "mpp12";
 				marvell,function = "gpo";
diff --git a/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts b/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
index b29cab304fd0..c4741699605c 100644
--- a/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
+++ b/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
@@ -39,7 +39,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_button_power: pmx-button-power {
 				marvell,pins = "mpp47";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts b/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
index 4ef494231b78..8437f3e3b8d7 100644
--- a/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
+++ b/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
@@ -41,7 +41,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_button_power: pmx-button-power {
 				marvell,pins = "mpp47";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
index da8891bbeec8..46eb8f6b6243 100644
--- a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
@@ -8,7 +8,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_ns2_sata0: pmx-ns2-sata0 {
 				marvell,pins = "mpp21";
 				marvell,function = "sata0";
diff --git a/arch/arm/boot/dts/kirkwood-nsa310.dts b/arch/arm/boot/dts/kirkwood-nsa310.dts
index cd68210b9f11..78bdf9c7f16b 100644
--- a/arch/arm/boot/dts/kirkwood-nsa310.dts
+++ b/arch/arm/boot/dts/kirkwood-nsa310.dts
@@ -26,7 +26,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-0 = <&pmx_unknown>;
 			pinctrl-names = "default";
 
diff --git a/arch/arm/boot/dts/kirkwood-nsa310a.dts b/arch/arm/boot/dts/kirkwood-nsa310a.dts
index 8fd72d49e43f..0788473f0447 100644
--- a/arch/arm/boot/dts/kirkwood-nsa310a.dts
+++ b/arch/arm/boot/dts/kirkwood-nsa310a.dts
@@ -21,7 +21,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-names = "default";
 
 			pmx_led_esata_green: pmx-led-esata-green {
diff --git a/arch/arm/boot/dts/kirkwood-nsa320.dts b/arch/arm/boot/dts/kirkwood-nsa320.dts
index 817eaf02a346..24f686d1044d 100644
--- a/arch/arm/boot/dts/kirkwood-nsa320.dts
+++ b/arch/arm/boot/dts/kirkwood-nsa320.dts
@@ -38,7 +38,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-names = "default";
 
 			/* SATA Activity and Present pins are not connected */
diff --git a/arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi b/arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi
index b88810df7ca2..2075a2e828f1 100644
--- a/arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi
@@ -15,7 +15,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 
 			pmx_usb_power: pmx-usb-power {
 				marvell,pins = "mpp21";
diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
index 557b824f9c43..fd1c8b535e28 100644
--- a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
+++ b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
@@ -46,7 +46,7 @@
 			};
 		};
 
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-0 = <&pmx_dip_switches &pmx_gpio_header>;
 			pinctrl-names = "default";
 
diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
index b1f5e1180803..8c3d50c57fa0 100644
--- a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
+++ b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
@@ -58,7 +58,7 @@
 			};
 		};
 
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-0 = <&pmx_dip_switches &pmx_gpio_header>;
 			pinctrl-names = "default";
 
diff --git a/arch/arm/boot/dts/kirkwood-rd88f6192.dts b/arch/arm/boot/dts/kirkwood-rd88f6192.dts
index 8df800757175..30087b19efae 100644
--- a/arch/arm/boot/dts/kirkwood-rd88f6192.dts
+++ b/arch/arm/boot/dts/kirkwood-rd88f6192.dts
@@ -40,7 +40,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-0 = <&pmx_usb_power>;
 			pinctrl-names = "default";
 
diff --git a/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi b/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
index c573c204dbdb..26cf0e0ccefd 100644
--- a/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
+++ b/arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
@@ -36,7 +36,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-0 = <&pmx_sdio_cd>;
 			pinctrl-names = "default";
 
diff --git a/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi b/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
index bd01d306a754..a015af4da9a2 100644
--- a/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
@@ -21,7 +21,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 
 			pmx_usb_power_enable: pmx-usb-power-enable {
 				marvell,pins = "mpp29";
diff --git a/arch/arm/boot/dts/kirkwood-synology.dtsi b/arch/arm/boot/dts/kirkwood-synology.dtsi
index 4227c974729d..e137bd4e26fd 100644
--- a/arch/arm/boot/dts/kirkwood-synology.dtsi
+++ b/arch/arm/boot/dts/kirkwood-synology.dtsi
@@ -25,7 +25,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pmx_alarmled_12: pmx-alarmled-12 {
 				marvell,pins = "mpp12";
 				marvell,function = "gpio";
diff --git a/arch/arm/boot/dts/kirkwood-t5325.dts b/arch/arm/boot/dts/kirkwood-t5325.dts
index df53176c9354..ae102abcab04 100644
--- a/arch/arm/boot/dts/kirkwood-t5325.dts
+++ b/arch/arm/boot/dts/kirkwood-t5325.dts
@@ -41,7 +41,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-0 = <&pmx_i2s &pmx_sysrst>;
 			pinctrl-names = "default";
 
diff --git a/arch/arm/boot/dts/kirkwood-topkick.dts b/arch/arm/boot/dts/kirkwood-topkick.dts
index a85025ef4c52..5bc57efbee99 100644
--- a/arch/arm/boot/dts/kirkwood-topkick.dts
+++ b/arch/arm/boot/dts/kirkwood-topkick.dts
@@ -18,7 +18,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			/*
 			 * Switch positions
 			 *
diff --git a/arch/arm/boot/dts/kirkwood-ts219-6281.dts b/arch/arm/boot/dts/kirkwood-ts219-6281.dts
index c17ae45e19be..9767d73f3857 100644
--- a/arch/arm/boot/dts/kirkwood-ts219-6281.dts
+++ b/arch/arm/boot/dts/kirkwood-ts219-6281.dts
@@ -6,7 +6,7 @@
 
 / {
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 
 			pinctrl-0 = <&pmx_ram_size &pmx_board_id>;
 			pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/kirkwood-ts219-6282.dts b/arch/arm/boot/dts/kirkwood-ts219-6282.dts
index 0713d072758a..bfc1a32d4e42 100644
--- a/arch/arm/boot/dts/kirkwood-ts219-6282.dts
+++ b/arch/arm/boot/dts/kirkwood-ts219-6282.dts
@@ -16,7 +16,7 @@
 	};
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 
 			pinctrl-0 = <&pmx_ram_size &pmx_board_id>;
 			pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/kirkwood-ts419.dtsi b/arch/arm/boot/dts/kirkwood-ts419.dtsi
index 1a9c624c7a92..30ab93bfb1e4 100644
--- a/arch/arm/boot/dts/kirkwood-ts419.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ts419.dtsi
@@ -14,7 +14,7 @@
 	compatible = "qnap,ts419", "marvell,kirkwood";
 
 	ocp@f1000000 {
-		pinctrl: pinctrl@10000 {
+		pinctrl: pin-controller@10000 {
 			pinctrl-names = "default";
 
 			pmx_USB_copy_button: pmx-USB-copy-button {
-- 
1.9.1

