Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbaDKNUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:20:44 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:45837 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757778AbaDKNUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:20:30 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: linux-kernel@vger.kernel.org, patrice.chotard@st.com,
        maxime.coquelin@st.com
Cc: kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        mturquette@linaro.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 2/9] ARM: STi: DT: STiH416: Remove unused CLK_S_ICN_REG_0 fixed clock
Date: Fri, 11 Apr 2014 15:19:49 +0200
Message-Id: <1397222396-30106-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397222396-30106-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1397222396-30106-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_04:2014-04-11,2014-04-11,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLK_S_ICN_REG_0 clock is no longer used.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih416-clock.dtsi | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
index 66693e4..47bbfd4 100644
--- a/arch/arm/boot/dts/stih416-clock.dtsi
+++ b/arch/arm/boot/dts/stih416-clock.dtsi
@@ -34,17 +34,6 @@
 			clock-frequency = <600000000>;
 		};
 
-		/*
-		 * Bootloader initialized system infrastructure clock for
-		 * serial devices.
-		 */
-		CLK_S_ICN_REG_0: clockgenA0@4 {
-			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <100000000>;
-			clock-output-names = "CLK_S_ICN_REG_0";
-		};
-
 		CLK_S_GMAC0_PHY: clockgenA1@7 {
 			#clock-cells = <0>;
 			compatible = "fixed-clock";
-- 
1.9.1

