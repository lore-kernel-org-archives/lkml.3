Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3FGQOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:14:37 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:50747 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab3FGQLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:11:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/10] ARM: ux500: Supply external regulator names for Snowball's DT
Date: Fri,  7 Jun 2013 17:11:21 +0100
Message-Id: <1370621488-18130-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator names are platform independent, so they need to be applied to
the base level platform DTS files *.dts. Here we're supplying the names
for the newly described AB8500 external regulators.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index fb9dce5..f1f6903 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -309,6 +309,20 @@
 					compatible = "stericsson,ab8500-gpio";
 				};
 
+				ext_regulators: ab8500-ext-regulators {
+					ab8500_ext1_reg: ab8500_ext1 {
+						regulator-name = "ab8500-ext-supply1";
+					};
+
+					ab8500_ext2_reg_reg: ab8500_ext2 {
+						regulator-name = "ab8500-ext-supply2";
+					};
+
+					ab8500_ext3_reg_reg: ab8500_ext3 {
+						regulator-name = "ab8500-ext-supply3";
+					};
+				};
+
 				ab8500-regulators {
 					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
 						regulator-name = "V-DISPLAY";
-- 
1.7.10.4

