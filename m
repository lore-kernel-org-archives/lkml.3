Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaKQQs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:48:28 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65182 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaKQQsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:48:22 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v3 01/11] ARM: STi: DT: STiH416: Add pinctl setup for usb controllers.
Date: Mon, 17 Nov 2014 16:47:54 +0000
Message-Id: <1416242884-5261-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416242884-5261-1-git-send-email-peter.griffin@linaro.org>
References: <1416242884-5261-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the required pin config for all usb controllers
on the stih416.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index c2025bc..9cccf2d 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -147,6 +147,15 @@
 				};
 			};
 
+			usb {
+				pinctrl_usb3: usb3 {
+					st,pins {
+						oc-detect = <&pio40 0 ALT1 IN>;
+						pwr-enable = <&pio40 1 ALT1 OUT>;
+					};
+				};
+			};
+
 			sbc_i2c1 {
 				pinctrl_sbc_i2c1_default: sbc_i2c1-default {
 					st,pins {
@@ -318,6 +327,16 @@
 				};
 			};
 
+			usb {
+				pinctrl_usb0: usb0 {
+					st,pins {
+						oc-detect = <&pio9 4 ALT1 IN>;
+						pwr-enable = <&pio9 5 ALT1 OUT>;
+					};
+				};
+			};
+
+
 			i2c1 {
 				pinctrl_i2c1_default: i2c1-default {
 					st,pins {
@@ -506,6 +525,21 @@
 					};
 				};
 			};
+
+			usb {
+				pinctrl_usb1: usb1 {
+					st,pins {
+						oc-detect = <&pio18 0 ALT1 IN>;
+						pwr-enable = <&pio18 1 ALT1 OUT>;
+					};
+				};
+				pinctrl_usb2: usb2 {
+					st,pins {
+						oc-detect = <&pio18 2 ALT1 IN>;
+						pwr-enable = <&pio18 3 ALT1 OUT>;
+					};
+				};
+			};
 		};
 
 		pin-controller-fvdp-fe {
-- 
1.9.1

