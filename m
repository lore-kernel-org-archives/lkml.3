Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaILPnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:43:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55612 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752238AbaILPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:43:31 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 8/8] ARM: at91: document Atmel SMART compatibles
Date: Fri, 12 Sep 2014 17:43:07 +0200
Message-Id: <1410536587-24607-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document all the available compatibles for Atmel "SMART" SoCs.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 .../devicetree/bindings/arm/atmel-at91.txt         | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
index 6e3e3e5c611f..2ef92e04ed10 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
@@ -1,6 +1,46 @@
 Atmel AT91 device tree bindings.
 ================================
 
+Boards with a SoC of the Atmel AT91 or SMART family shall have the following
+properties:
+
+Required root node properties:
+compatible: must be one of:
+ * "atmel,rm9200"
+ * "atmel,at91sam9260"
+ * "atmel,at91sam9261"
+ * "atmel,at91sam9263"
+ * "atmel,at91sam9x5" for the x5 family, shall be extended with the specific SoC
+   compatible:
+    o "atmel,at91sam9g15"
+    o "atmel,at91sam9g25"
+    o "atmel,at91sam9g35"
+    o "atmel,at91sam9x25"
+    o "atmel,at91sam9x35"
+ * "atmel,at91sam9g20"
+ * "atmel,at91sam9g45"
+ * "atmel,at91sam9n12"
+ * "atmel,at91sam9rl"
+ * "atmel,sama5" for the cortexA5 family, shall be extended with the specific
+   SoC family:
+    o "atmel,sama5d3" shal be exteneded with the specific SoC compatible:
+       - "atmel,samad31"
+       - "atmel,samad33"
+       - "atmel,samad34"
+       - "atmel,samad35"
+       - "atmel,samad36"
+    o "atmel,sama5d4"
+
+
+In addition, the above compatible shall be extended with the specific
+SoC and board used. Currently known SoC compatibles are:
+    "marvell,berlin2"      for Marvell Armada 1500 (BG2, 88DE3100),
+    "marvell,berlin2cd"    for Marvell Armada 1500-mini (BG2CD, 88DE3005)
+    "marvell,berlin2ct"    for Marvell Armada ? (BG2CT, 88DE????)
+    "marvell,berlin2q"     for Marvell Armada 1500-pro (BG2Q, 88DE3114)
+    "marvell,berlin3"      for Marvell Armada ? (BG3, 88DE????)
+
+
 PIT Timer required properties:
 - compatible: Should be "atmel,at91sam9260-pit"
 - reg: Should contain registers location and length
-- 
1.9.1

