Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbbAMM3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:29:32 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:34146 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbAMM3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:29:13 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: wim@iguana.be, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, heiko@sntech.de,
        yingjoe.chen@gmail.com, ibanezchen@gmail.com, matthias.bgg@gmail.com,
        greta.zhang@mediatek.com, eddie.huang@mediatek.com, wens@csie.org,
        linux@roeck-us.net, joe@perches.com
Subject: [PATCH v5 2/2] ARM: mediatek: dts: Add bindings for watchdog
Date: Tue, 13 Jan 2015 13:28:56 +0100
Message-Id: <1421152136-5007-3-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421152136-5007-1-git-send-email-matthias.bgg@gmail.com>
References: <1421152136-5007-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 Documentation/devicetree/bindings/watchdog/mtk-wdt.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/mtk-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt b/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
new file mode 100644
index 0000000..af9eb5b
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
@@ -0,0 +1,13 @@
+Mediatek SoCs Watchdog timer
+
+Required properties:
+
+- compatible : should be "mediatek,mt6589-wdt"
+- reg : Specifies base physical address and size of the registers.
+
+Example:
+
+wdt: watchdog@010000000 {
+	compatible = "mediatek,mt6589-wdt";
+	reg = <0x10000000 0x18>;
+};
-- 
1.9.1

