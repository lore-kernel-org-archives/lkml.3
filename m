Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaFROxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:53:13 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42428 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaFROxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:53:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: [PATCH 2/7] ARM: stih416: Add Pinctrl settings for PWM
Date: Wed, 18 Jun 2014 15:52:47 +0100
Message-Id: <1403103172-19856-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply the Pinctrl configuration to enable PWM{0,1} lines on STiH416
based development boards.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 50 ++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index ee6c119..04e61d6 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -207,6 +207,29 @@
 					};
 				};
 			};
+
+			pwm1 {
+				pinctrl_pwm1_chan0_default: pwm1-0-default {
+					st,pins {
+						pwm-out    = <&PIO3 0 ALT1 OUT>;
+					};
+				};
+				pinctrl_pwm1_chan1_default: pwm1-1-default {
+					st,pins {
+						pwm-out    = <&PIO4 4 ALT1 OUT>;
+					};
+				};
+				pinctrl_pwm1_chan2_default: pwm1-2-default {
+					st,pins {
+						pwm-out    = <&PIO4 6 ALT3 OUT>;
+					};
+				};
+				pinctrl_pwm1_chan3_default: pwm1-3-default {
+					st,pins {
+						pwm-out    = <&PIO4 7 ALT3 OUT>;
+					};
+				};
+			};
 		};
 
 		pin-controller-front {
@@ -301,6 +324,14 @@
 				st,bank-name	= "PIO31";
 			};
 
+			pwm0 {
+				pinctrl_pwm0_chan0_default: pwm0-0-default {
+					st,pins {
+						pwm-out    = <&PIO9 7 ALT2 OUT>;
+					};
+				};
+			};
+
 			serial2-oe {
 				pinctrl_serial2_oe: serial2-1 {
 					st,pins {
@@ -467,6 +498,25 @@
 					};
 				};
 			};
+
+			pwm0 {
+				pinctrl_pwm0_chan1_default: pwm0-1-default {
+					st,pins {
+						pwm-out    = <&PIO13 2 ALT2 OUT>;
+					};
+				};
+				pinctrl_pwm0_chan2_default: pwm0-2-default {
+					st,pins {
+						pwm-out    = <&PIO15 2 ALT4 OUT>;
+					};
+				};
+				pinctrl_pwm0_chan3_default: pwm0-3-default {
+					st,pins {
+						pwm-out    = <&PIO17 4 ALT1 OUT>;
+					};
+				};
+			};
+
 		};
 
 		pin-controller-fvdp-fe {
-- 
1.8.3.2

