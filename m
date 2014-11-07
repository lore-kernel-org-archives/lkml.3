Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaKGMBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:01:33 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60209 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaKGL6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:58:21 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 02/13] ARM: STi: DT: STiH416: Add DT node for the stih415/6 usb2 phy
Date: Fri,  7 Nov 2014 11:57:44 +0000
Message-Id: <1415361475-6218-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This usb picophy is found on stih415/6 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih416.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 1137bdf..0f3019a 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -316,5 +316,14 @@
 
 			status	        = "disabled";
 		};
+
+		usb2_phy: usb2phy@0 {
+			compatible = "st,stih416-usb-phy";
+			#phy-cells = <0>;
+			st,syscfg = <&syscfg_rear>;
+			clocks = <&clk_sysin>;
+			clock-names = "osc_phy";
+
+		};
 	};
 };
-- 
1.9.1

