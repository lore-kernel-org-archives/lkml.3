Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaJ0Qlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:41:47 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54498 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaJ0Qlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:41:44 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: wim@iguana.be, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, heiko@sntech.de,
        yingjoe.chen@gmail.com, ibanezchen@gmail.com, matthias.bgg@gmail.com
Subject: [PATCH 2/2] ARM: mediatek: dts: Add bindings for watchdog
Date: Mon, 27 Oct 2014 17:41:32 +0100
Message-Id: <1414428092-20725-3-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414428092-20725-1-git-send-email-matthias.bgg@gmail.com>
References: <1414428092-20725-1-git-send-email-matthias.bgg@gmail.com>
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

