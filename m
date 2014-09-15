Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaIOQQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:16:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39532 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752224AbaIOQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:16:16 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 7/7] ARM: at91: document Atmel SMART compatibles
Date: Mon, 15 Sep 2014 18:15:59 +0200
Message-Id: <1410797759-18675-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document all the available compatibles for Atmel "SMART" SoCs.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 .../devicetree/bindings/arm/atmel-at91.txt         | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
index 6e3e3e5c611f..562cda9d86d9 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
@@ -1,6 +1,43 @@
 Atmel AT91 device tree bindings.
 ================================
 
+Boards with a SoC of the Atmel AT91 or SMART family shall have the following
+properties:
+
+Required root node properties:
+compatible: must be one of:
+ * "atmel,at91rm9200"
+
+ * "atmel,at91sam9" for SoCs using an ARM926EJ-S core, shall be extended with
+   the specific SoC family or compatible:
+    o "atmel,at91sam9260"
+    o "atmel,at91sam9261"
+    o "atmel,at91sam9263"
+    o "atmel,at91sam9x5" for the 5 series, shall be extended with the specific
+      SoC compatible:
+       - "atmel,at91sam9g15"
+       - "atmel,at91sam9g25"
+       - "atmel,at91sam9g35"
+       - "atmel,at91sam9x25"
+       - "atmel,at91sam9x35"
+    o "atmel,at91sam9g20"
+    o "atmel,at91sam9g45"
+    o "atmel,at91sam9n12"
+    o "atmel,at91sam9rl"
+ * "atmel,sama5" for SoCs using a Cortex-A5, shall be extended with the specific
+   SoC family:
+    o "atmel,sama5d3" shall be extended with the specific SoC compatible:
+       - "atmel,sama5d31"
+       - "atmel,sama5d33"
+       - "atmel,sama5d34"
+       - "atmel,sama5d35"
+       - "atmel,sama5d36"
+    o "atmel,sama5d4" shall be extended with the specific SoC compatible:
+       - "atmel,sama5d41"
+       - "atmel,sama5d42"
+       - "atmel,sama5d43"
+       - "atmel,sama5d44"
+
 PIT Timer required properties:
 - compatible: Should be "atmel,at91sam9260-pit"
 - reg: Should contain registers location and length
-- 
1.9.1

