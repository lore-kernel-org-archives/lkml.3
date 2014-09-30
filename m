Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaI3R1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:27:06 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62270 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaI3R1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:27:04 -0400
From: Romain Perier <romain.perier@gmail.com>
To: devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        heiko@sntech.de
Subject: [RFC][PATCH 3/4] ARM: dts: rockchip: Enable power off in pmic for Radxa Rock
Date: Tue, 30 Sep 2014 17:29:45 +0000
Message-Id: <1412098186-5042-3-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412098186-5042-1-git-send-email-romain.perier@gmail.com>
References: <1412098186-5042-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "poweroff-source" property to act8846 node.
shutdown/poweroff commands are now handled for this board.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 arch/arm/boot/dts/rk3188-radxarock.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index e04bf8f..1217481 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -115,6 +115,8 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&act8846_dvs0_ctl>;
 
+		poweroff-source;
+
 		regulators {
 			vcc_ddr: REG1 {
 				regulator-name = "VCC_DDR";
-- 
1.9.1

