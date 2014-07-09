Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaGIPHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:07:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48306 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752523AbaGIPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:07:16 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 01/34] Documentation: dt: document all the atmel pmc compatibles
Date: Wed,  9 Jul 2014 17:06:29 +0200
Message-Id: <1404918422-7562-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404918422-7562-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation for atmel-pmc only list one compatible, add the remaining
compatible strings.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 Documentation/devicetree/bindings/arm/atmel-pmc.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/atmel-pmc.txt b/Documentation/devicetree/bindings/arm/atmel-pmc.txt
index 389bed5056e8..795cc78543fe 100644
--- a/Documentation/devicetree/bindings/arm/atmel-pmc.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-pmc.txt
@@ -1,7 +1,10 @@
 * Power Management Controller (PMC)
 
 Required properties:
-- compatible: Should be "atmel,at91rm9200-pmc"
+- compatible: Should be "atmel,<chip>-pmc".
+	<chip> can be: at91rm9200, at91sam9260, at91sam9g45, at91sam9n12,
+	at91sam9x5, sama5d3
+
 - reg: Should contain PMC registers location and length
 
 Examples:
-- 
1.9.1

