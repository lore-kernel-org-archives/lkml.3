Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbbASSIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:08:23 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56247 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbASSIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:08:20 -0500
From: Romain Perier <romain.perier@gmail.com>
To: peppe.cavallaro@st.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, heiko@sntech.de,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        roger.chen@rock-chips.com
Subject: [PATCH v1 4/4] ARM: dts: Convert gmac to phy-supply in rk3288-evb-rk808.dts
Date: Mon, 19 Jan 2015 18:08:09 +0000
Message-Id: <1421690889-11901-5-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421690889-11901-1-git-send-email-romain.perier@gmail.com>
References: <1421690889-11901-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces the property phy_regulator by the standard devicetree property
phy-supply and references the device_node vcc_phy from it.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 arch/arm/boot/dts/rk3288-evb-rk808.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
index 831a7aa..e1d3eeb 100644
--- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
+++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
@@ -161,7 +161,7 @@
 };
 
 &gmac {
-	phy_regulator = "vcc_phy";
+	phy-supply = <&vcc_phy>;
 	phy-mode = "rgmii";
 	clock_in_out = "input";
 	snps,reset-gpio = <&gpio4 7 0>;
-- 
1.9.1

