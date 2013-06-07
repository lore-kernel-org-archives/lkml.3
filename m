Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3FGQLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:11:51 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:51119 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3FGQLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:11:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/10] ARM: ux500: Provide a supply name for the AB8500 AUX regulators to use
Date: Fri,  7 Jun 2013 17:11:20 +0100
Message-Id: <1370621488-18130-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AB8500 AUX regulators are supplied by EXT3 on some boards. This supply
phandle lookup will enable the regulator core to search for and locate
the EXT3 supply at registration time.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index ea87fac..be63293 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -481,6 +481,7 @@
 
 				ab8500-regulators {
 					compatible = "stericsson,ab8500-regulator";
+					vin-supply = <&ab8500_ext3_reg>;
 
 					// supplies to the display/camera
 					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
-- 
1.7.10.4

