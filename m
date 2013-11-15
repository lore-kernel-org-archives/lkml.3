Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab3KOKKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:10:47 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:29495 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab3KOKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:10:36 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/dt: binding: add missing compatibility string in SDRAM/DDR documentation
Date: Fri, 15 Nov 2013 11:10:35 +0100
Message-ID: <1384510235-16083-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "atmel,at91rm9200-sdramc" was missing from binding documentation.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 Documentation/devicetree/bindings/arm/atmel-at91.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
index 1196290..d2170e7 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
@@ -50,7 +50,8 @@ Example:
 	};
 
 RAMC SDRAM/DDR Controller required properties:
-- compatible: Should be "atmel,at91sam9260-sdramc",
+- compatible: Should be "atmel,at91rm9200-sdramc",
+			"atmel,at91sam9260-sdramc",
 			"atmel,at91sam9g45-ddramc",
 - reg: Should contain registers location and length
   For at91sam9263 and at91sam9g45 you must specify 2 entries.
-- 
1.8.2.2

