Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3AVRv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:51:27 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:55448 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3AVRvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:51:23 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 6/6] ARM: at91/dts: add macb mii pinctrl config for kizbox
Date: Tue, 22 Jan 2013 18:50:46 +0100
Message-ID: <8d600dfd82031ca9c9bde5e11ac89c66b1f87787.1358876553.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1358876553.git.nicolas.ferre@atmel.com>
References: <cover.1358876553.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <linux-arm@overkiz.com>

This patch overrides default macb pinctrl config defined in
at91sam9260.dtsi (pinctrl_macb_rmii) with kizbox board config
(pinctrl_macb_rmii + pinctrl_macb_rmii_mii_alt).

Signed-off-by: Boris BREZILLON <linux-arm@overkiz.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/kizbox.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/kizbox.dts b/arch/arm/boot/dts/kizbox.dts
index e8814fe..b4dc3ed 100644
--- a/arch/arm/boot/dts/kizbox.dts
+++ b/arch/arm/boot/dts/kizbox.dts
@@ -48,6 +48,8 @@
 
 			macb0: ethernet@fffc4000 {
 				phy-mode = "mii";
+				pinctrl-0 = <&pinctrl_macb_rmii
+				             &pinctrl_macb_rmii_mii_alt>;
 				status = "okay";
 			};
 
-- 
1.8.0

