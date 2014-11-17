Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaKQQss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:48:48 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33788 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaKQQso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:48:44 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v3 11/11] ARM: STi: DT: STiH416: Change miphy356 node name to phy@fe382000
Date: Mon, 17 Nov 2014 16:48:04 +0000
Message-Id: <1416242884-5261-12-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416242884-5261-1-git-send-email-peter.griffin@linaro.org>
References: <1416242884-5261-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following Arnds review comments, update the miphy365 to follow the
common convention of naming the phy node names as phy@addr.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/stih416-b2020.dts  | 2 +-
 arch/arm/boot/dts/stih416-b2020e.dts | 2 +-
 arch/arm/boot/dts/stih416.dtsi       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
index 5d1543b..200a818 100644
--- a/arch/arm/boot/dts/stih416-b2020.dts
+++ b/arch/arm/boot/dts/stih416-b2020.dts
@@ -20,7 +20,7 @@
 			non-removable;
 		};
 
-		miphy365x_phy: miphy365x@fe382000 {
+		miphy365x_phy: phy@fe382000 {
 			phy_port0: port@fe382000 {
 				st,sata-gen = <3>;
 			};
diff --git a/arch/arm/boot/dts/stih416-b2020e.dts b/arch/arm/boot/dts/stih416-b2020e.dts
index 956fab8..961799e 100644
--- a/arch/arm/boot/dts/stih416-b2020e.dts
+++ b/arch/arm/boot/dts/stih416-b2020e.dts
@@ -38,7 +38,7 @@
 			non-removable;
 		};
 
-		miphy365x_phy: miphy365x@fe382000 {
+		miphy365x_phy: phy@fe382000 {
 			phy_port0: port@fe382000 {
 				st,sata-gen = <3>;
 			};
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 2bdda52..fad9073 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -281,7 +281,7 @@
 			clocks		= <&clk_s_a1_ls 8>;
 		};
 
-		miphy365x_phy: miphy365x@fe382000 {
+		miphy365x_phy: phy@fe382000 {
 			compatible      = "st,miphy365x-phy";
 			st,syscfg  	= <&syscfg_rear>;
 			#address-cells	= <1>;
-- 
1.9.1

