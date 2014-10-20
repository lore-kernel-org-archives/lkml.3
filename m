Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaJTDYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:24:03 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52536 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaJTDX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:23:58 -0400
From: Howard Chen <ibanezchen@gmail.com>
To: matthias.bgg@gmail.com
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek
	SoC...)
Subject: [PATCH v4 3/3] dt-bindings: add documentation for Mediatek SoC
Date: Mon, 20 Oct 2014 11:23:19 +0800
Message-Id: <1413775401-4501-3-git-send-email-ibanezchen@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413775401-4501-1-git-send-email-ibanezchen@gmail.com>
References: <1413775401-4501-1-git-send-email-ibanezchen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a DT binding documentation for the MT6592 SoC from Mediatek.

Signed-off-by: Howard Chen <ibanezchen@gmail.com>
---
 Documentation/devicetree/bindings/arm/mediatek.txt    | 7 +++++--
 Documentation/devicetree/bindings/serial/mtk-uart.txt | 3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/mediatek.txt b/Documentation/devicetree/bindings/arm/mediatek.txt
index fa25226..1d2d151 100644
--- a/Documentation/devicetree/bindings/arm/mediatek.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek.txt
@@ -1,10 +1,10 @@
 Mediatek MT6589 Platforms Device Tree Bindings
 
-Boards with a SoC of the Mediatek MT6589 shall have the following property:
+Boards with a SoC from Mediatek shall have the following property:
 
 Required root node property:
 
-compatible: must contain "mediatek,mt6589"
+compatible: must contain one of "mediatek,mt6589", "mediatek,mt6592"
 
 
 Supported boards:
@@ -12,3 +12,6 @@ Supported boards:
 - bq Aquaris5 smart phone:
     Required root node properties:
       - compatible = "mundoreader,bq-aquaris5", "mediatek,mt6589";
+
+- Evaluation board for MT6592:
+      - compatible = "mediatek,mt6592-evb", "mediatek,mt6592";
diff --git a/Documentation/devicetree/bindings/serial/mtk-uart.txt b/Documentation/devicetree/bindings/serial/mtk-uart.txt
index 48358a3..e2864b7 100644
--- a/Documentation/devicetree/bindings/serial/mtk-uart.txt
+++ b/Documentation/devicetree/bindings/serial/mtk-uart.txt
@@ -2,9 +2,10 @@
 
 Required properties:
 - compatible should contain:
+  * "mediatek,mt6592-uart" for MT6592 compatible UARTS
   * "mediatek,mt6589-uart" for MT6589 compatible UARTS
   * "mediatek,mt6582-uart" for MT6582 compatible UARTS
-  * "mediatek,mt6577-uart" for all compatible UARTS (MT6589, MT6582, MT6577)
+  * "mediatek,mt6577-uart" for all compatible UARTS on MT65xx
 
 - reg: The base address of the UART register bank.
 
-- 
1.9.1

