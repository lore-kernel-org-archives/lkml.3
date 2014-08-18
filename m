Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaHRO7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:59:12 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61975 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaHRO7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:59:10 -0400
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
Subject: [PATCH v2 8/9] arm: dts: mediatek: Add compatible property for aquaris5
Date: Mon, 18 Aug 2014 16:58:36 +0200
Message-Id: <1408373917-10002-9-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408373917-10002-1-git-send-email-matthias.bgg@gmail.com>
References: <1408373917-10002-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing 'compatible' property to device tree root node of

 - mt6589-aquaris5.dts

and document the new values.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 Documentation/devicetree/bindings/arm/mediatek.txt |    6 ++++++
 arch/arm/boot/dts/mt6589-aquaris5.dts              |    1 +
 2 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/mediatek.txt b/Documentation/devicetree/bindings/arm/mediatek.txt
index d6ac71f..fa25226 100644
--- a/Documentation/devicetree/bindings/arm/mediatek.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek.txt
@@ -6,3 +6,9 @@ Required root node property:
 
 compatible: must contain "mediatek,mt6589"
 
+
+Supported boards:
+
+- bq Aquaris5 smart phone:
+    Required root node properties:
+      - compatible = "mundoreader,bq-aquaris5", "mediatek,mt6589";
diff --git a/arch/arm/boot/dts/mt6589-aquaris5.dts b/arch/arm/boot/dts/mt6589-aquaris5.dts
index 74cb1ba..0da0470 100644
--- a/arch/arm/boot/dts/mt6589-aquaris5.dts
+++ b/arch/arm/boot/dts/mt6589-aquaris5.dts
@@ -18,6 +18,7 @@
 
 / {
 	model = "bq Aquaris5";
+	compatible = "mundoreader,bq-aquaris5", "mediatek,mt6589";
 
 	chosen {
 		bootargs = "earlyprintk";
-- 
1.7.9.5

