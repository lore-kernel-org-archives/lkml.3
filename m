Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3FLOg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:36:57 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36452 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3FLOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:36:55 -0400
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 2/2] ARM: u8540: DT: Set pinctrl mapping to i2c0,1,2,4 & 5
Date: Wed, 12 Jun 2013 16:35:35 +0200
Message-Id: <1371047735-14851-2-git-send-email-gabriel.fernandez.st@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1371047735-14851-1-git-send-email-gabriel.fernandez.st@gmail.com>
References: <1371047735-14851-1-git-send-email-gabriel.fernandez.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

This patch configures pin map in device tree of i2c0,
1,2,4 & 5 for ccu8540 board.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 arch/arm/boot/dts/ccu8540-pinctrl.dtsi | 115 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/ccu8540.dts          |  34 ++++++++++
 2 files changed, 149 insertions(+)

diff --git a/arch/arm/boot/dts/ccu8540-pinctrl.dtsi b/arch/arm/boot/dts/ccu8540-pinctrl.dtsi
index 644b189..e079996 100644
--- a/arch/arm/boot/dts/ccu8540-pinctrl.dtsi
+++ b/arch/arm/boot/dts/ccu8540-pinctrl.dtsi
@@ -76,6 +76,121 @@
 					};
 				};
 			};
+
+			i2c0 {
+				i2c0_default_mux: i2c_mux {
+					default_mux {
+						ste,function = "i2c0";
+						ste,pins = "i2c0_a_1";
+					};
+				};
+
+				i2c0_default_mode: i2c_default {
+					default_cfg1 {
+						ste,pins = "GPIO147", "GPIO148";
+						ste,config = <&in_pu>;
+					};
+				};
+
+				i2c0_sleep_mode: i2c_sleep {
+					sleep_cfg1 {
+						ste,pins = "GPIO147", "GPIO148";
+						ste,config = <&slpm_in_pu>;
+					};
+				};
+			};
+
+			i2c1 {
+				i2c1_default_mux: i2c_mux {
+					default_mux {
+						ste,function = "i2c1";
+						ste,pins = "i2c1_b_2";
+					};
+				};
+
+				i2c1_default_mode: i2c_default {
+					default_cfg1 {
+						ste,pins = "GPIO16", "GPIO17";
+						ste,config = <&in_pu>;
+					};
+				};
+
+				i2c1_sleep_mode: i2c_sleep {
+					sleep_cfg1 {
+						ste,pins = "GPIO16", "GPIO17";
+						ste,config = <&slpm_in_pu>;
+					};
+				};
+			};
+
+			i2c2 {
+				i2c2_default_mux: i2c_mux {
+					default_mux {
+						ste,function = "i2c2";
+						ste,pins = "i2c2_b_2";
+					};
+				};
+
+				i2c2_default_mode: i2c_default {
+					default_cfg1 {
+						ste,pins = "GPIO10", "GPIO11";
+						ste,config = <&in_pu>;
+					};
+				};
+
+				i2c2_sleep_mode: i2c_sleep {
+					sleep_cfg1 {
+						ste,pins = "GPIO11", "GPIO11";
+						ste,config = <&slpm_in_pu>;
+					};
+				};
+			};
+
+			i2c4 {
+				i2c4_default_mux: i2c_mux {
+					default_mux {
+						ste,function = "i2c4";
+						ste,pins = "i2c4_b_2";
+					};
+				};
+
+				i2c4_default_mode: i2c_default {
+					default_cfg1 {
+						ste,pins = "GPIO122", "GPIO123";
+						ste,config = <&in_pu>;
+					};
+				};
+
+				i2c4_sleep_mode: i2c_sleep {
+					sleep_cfg1 {
+						ste,pins = "GPIO122", "GPIO123";
+						ste,config = <&slpm_in_pu>;
+					};
+				};
+			};
+
+			i2c5 {
+				i2c5_default_mux: i2c_mux {
+					default_mux {
+						ste,function = "i2c5";
+						ste,pins = "i2c5_c_2";
+					};
+				};
+
+				i2c5_default_mode: i2c_default {
+					default_cfg1 {
+						ste,pins = "GPIO118", "GPIO119";
+						ste,config = <&in_pu>;
+					};
+				};
+
+				i2c5_sleep_mode: i2c_sleep {
+					sleep_cfg1 {
+						ste,pins = "GPIO118", "GPIO119";
+						ste,config = <&slpm_in_pu>;
+					};
+				};
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
index 3065fe4..7df65f0 100644
--- a/arch/arm/boot/dts/ccu8540.dts
+++ b/arch/arm/boot/dts/ccu8540.dts
@@ -48,5 +48,39 @@
 			pinctrl-1 = <&uart2_sleep_mode>;
 			status = "okay";
 		};
+
+		i2c0: i2c@80004000 {
+			pinctrl-names = "default","sleep";
+			pinctrl-0 = <&i2c0_default_mux>, <&i2c0_default_mode>;
+			pinctrl-1 = <&i2c0_sleep_mode>;
+		};
+
+		i2c1: i2c@80122000 {
+			pinctrl-names = "default","sleep";
+			pinctrl-0 = <&i2c1_default_mux>, <&i2c1_default_mode>;
+			pinctrl-1 = <&i2c1_sleep_mode>;
+		};
+
+		i2c2: i2c@80128000 {
+			pinctrl-names = "default","sleep";
+			pinctrl-0 = <&i2c2_default_mux>, <&i2c2_default_mode>;
+			pinctrl-1 = <&i2c2_sleep_mode>;
+		};
+
+		i2c3: i2c@80110000 {
+			status = "disabled";
+		};
+
+		i2c4: i2c@8012a000 {
+			pinctrl-names = "default","sleep";
+			pinctrl-0 = <&i2c4_default_mux>, <&i2c4_default_mode>;
+			pinctrl-1 = <&i2c4_sleep_mode>;
+		};
+
+		i2c5: i2c@80001000 {
+			pinctrl-names = "default","sleep";
+			pinctrl-0 = <&i2c5_default_mux>, <&i2c5_default_mode>;
+			pinctrl-1 = <&i2c5_sleep_mode>;
+		};
 	};
 };
-- 
1.8.1.1

