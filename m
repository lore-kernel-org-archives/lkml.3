Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbaKMLAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:00:53 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34409 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaKMLAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:00:47 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 02/14] ARM: STi: DT: STiH416: Add DT node for the stih415/6 usb2 phy
Date: Thu, 13 Nov 2014 11:00:05 +0000
Message-Id: <1415876417-28728-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This usb picophy is found on stih415/6 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih416.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 1137bdf..321763b 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -316,5 +316,13 @@
 
 			status	        = "disabled";
 		};
+
+		usb2_phy: usb2phy@0 {
+			compatible = "st,stih416-usb-phy";
+			#phy-cells = <0>;
+			st,syscfg = <&syscfg_rear>;
+			clocks = <&clk_sysin>;
+			clock-names = "osc_phy";
+		};
 	};
 };
-- 
1.9.1

