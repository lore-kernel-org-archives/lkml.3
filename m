Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbaIIQwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:52:31 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:65279 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294AbaIIQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:51:20 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, olof@lixom.net, arnd@arndb.de,
        jason@lakedaemon.net, thomas.petazzoni@free-electrons.com,
        swarren@nvidia.com, sebastian.hesselbarth@gmail.com, stefan@agner.ch,
        maxime.ripard@free-electrons.com, matthias.bgg@gmail.com,
        anders.berg@lsi.com, linus.walleij@linaro.org, lee.jones@linaro.org,
        heiko@sntech.de, srv_yingjoe.chen@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 3/7] arm: dts: mt6589: Fix typo in GIC unit address
Date: Tue,  9 Sep 2014 18:51:00 +0200
Message-Id: <1410281464-9587-4-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410281464-9587-1-git-send-email-matthias.bgg@gmail.com>
References: <1410281464-9587-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the unit address of the gic node to it's first register area.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/arm/boot/dts/mt6589.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/mt6589.dtsi b/arch/arm/boot/dts/mt6589.dtsi
index d0297a0..742c9bd 100644
--- a/arch/arm/boot/dts/mt6589.dtsi
+++ b/arch/arm/boot/dts/mt6589.dtsi
@@ -81,7 +81,7 @@
 			clock-names = "system-clk", "rtc-clk";
 		};
 
-		gic: interrupt-controller@10212000 {
+		gic: interrupt-controller@10211000 {
 			compatible = "arm,cortex-a15-gic";
 			interrupt-controller;
 			#interrupt-cells = <3>;
-- 
1.9.1

