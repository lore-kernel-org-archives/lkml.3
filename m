Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaJGTmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:42:49 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37701 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbaJGTmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:42:19 -0400
From: Romain Perier <romain.perier@gmail.com>
To: devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        heiko@sntech.de, sameo@linux.intel.com, lee.jones@linaro.org,
        grant.likely@linaro.org, robh@kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        ldewangan@nvidia.com, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [RFC PATCH v1 3/4] ARM: dts: rockchip: Enable power off in pmic for Radxa Rock
Date: Tue,  7 Oct 2014 19:45:03 +0000
Message-Id: <1412711104-15902-3-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412711104-15902-1-git-send-email-romain.perier@gmail.com>
References: <1412711104-15902-1-git-send-email-romain.perier@gmail.com>
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
index 15910c9..2affff0 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -141,6 +141,8 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&act8846_dvs0_ctl>;
 
+		poweroff-source;
+
 		regulators {
 			vcc_ddr: REG1 {
 				regulator-name = "VCC_DDR";
-- 
1.9.1

