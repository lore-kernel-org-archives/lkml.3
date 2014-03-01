Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaCAOBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 09:01:01 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42297 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaCAN7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 08:59:36 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, NeilBrown <neilb@suse.de>,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 4/7] ARM: dts: omap3-gta04: Add twl4030 charger
Date: Sat,  1 Mar 2014 14:58:51 +0100
Message-Id: <1393682334-26805-5-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393682334-26805-1-git-send-email-marek@goldelico.com>
References: <1393682334-26805-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

Define twl4030 charger node used for charging.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index 7f29315..42fc12e 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -186,3 +186,7 @@
 	pinctrl-0 = <&uart3_pins>;
 };
 
+&charger {
+	bb_uvolt = <3200000>;
+	bb_uamp = <150>;
+};
-- 
1.8.3.2

