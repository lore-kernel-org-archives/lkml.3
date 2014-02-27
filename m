Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaB0PpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:45:17 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45729 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752829AbaB0PpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:45:15 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Felipe Balbi <balbi@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] Doc: USB: gadget: atmel_usba correct atmel,vbus-gpio meaning
Date: Thu, 27 Feb 2014 16:45:10 +0100
Message-Id: <1393515910-15837-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atmel,at91sam9rl-udc is a USB gadget, it has now means to control vbus.
atmel,vbus-gpio is in fact used to detect the presence of vbus.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 Documentation/devicetree/bindings/usb/atmel-usb.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/atmel-usb.txt b/Documentation/devicetree/bindings/usb/atmel-usb.txt
index 55f51af08bc7..bc2222ca3f2a 100644
--- a/Documentation/devicetree/bindings/usb/atmel-usb.txt
+++ b/Documentation/devicetree/bindings/usb/atmel-usb.txt
@@ -57,8 +57,8 @@ Required properties:
  - ep childnode: To specify the number of endpoints and their properties.
 
 Optional properties:
- - atmel,vbus-gpio: If present, specifies a gpio that needs to be
-   activated for the bus to be powered.
+ - atmel,vbus-gpio: If present, specifies a gpio that allows to detect whether
+   vbus is present (USB is connected).
 
 Required child node properties:
  - name: Name of the endpoint.
-- 
1.8.3.2

