Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaKQQs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:48:26 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51918 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaKQQsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:48:23 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v3 02/11] ARM: STi: DT: STiH416: Add DT node for the stih415/6 usb2 phy
Date: Mon, 17 Nov 2014 16:47:55 +0000
Message-Id: <1416242884-5261-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416242884-5261-1-git-send-email-peter.griffin@linaro.org>
References: <1416242884-5261-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This usb picophy is found on stih415/6 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih416.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 1137bdf..ff2ad35 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -316,5 +316,13 @@
 
 			status	        = "disabled";
 		};
+
+		usb2_phy: phy@0 {
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

