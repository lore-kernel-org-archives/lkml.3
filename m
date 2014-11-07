Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaKGMA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:00:27 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:44997 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaKGL6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:58:37 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 09/13] ARM: STi: DT: STiH410:  Add pinctl config for usb controllers.
Date: Fri,  7 Nov 2014 11:57:51 +0000
Message-Id: <1415361475-6218-10-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the required pin configiguration for the extra usb
controllers found on the stih410 device.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih407-pinctrl.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-pinctrl.dtsi b/arch/arm/boot/dts/stih407-pinctrl.dtsi
index 402844c..fdaad5d 100644
--- a/arch/arm/boot/dts/stih407-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih407-pinctrl.dtsi
@@ -539,6 +539,24 @@
 				};
 			};
 
+			usb0 {
+				pinctrl_usb0: usb2-0 {
+					st,pins {
+						usb-oc-detect = <&pio35 0 ALT1 IN>;
+						usb-pwr-enable = <&pio35 1 ALT1 OUT>;
+					};
+				};
+			};
+
+			usb1 {
+				pinctrl_usb1: usb2-1 {
+					st,pins {
+						usb-oc-detect = <&pio35 2 ALT1 IN>;
+						usb-pwr-enable = <&pio35 3 ALT1 OUT>;
+					};
+				};
+			};
+
 			usb3 {
 				pinctrl_usb3: usb3-2 {
 					st,pins {
-- 
1.9.1

