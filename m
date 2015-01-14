Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbbANQWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:22:49 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45284 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754072AbbANQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:22:23 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 11/12] usb: gadget: at91_udc: Update DT binding documentation
Date: Wed, 14 Jan 2015 17:22:03 +0100
Message-Id: <1421252524-24452-12-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

Three compatible strings have been added to the at91_udc driver.
Update the documentation accordingly.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 Documentation/devicetree/bindings/usb/atmel-usb.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/atmel-usb.txt b/Documentation/devicetree/bindings/usb/atmel-usb.txt
index 6007231e0adc..54a81219caae 100644
--- a/Documentation/devicetree/bindings/usb/atmel-usb.txt
+++ b/Documentation/devicetree/bindings/usb/atmel-usb.txt
@@ -33,7 +33,11 @@ usb1: ehci@00800000 {
 AT91 USB device controller
 
 Required properties:
- - compatible: Should be "atmel,at91rm9200-udc"
+ - compatible: Should be one of the following
+	       "atmel,at91rm9200-udc"
+	       "atmel,at91sam9260-udc"
+	       "atmel,at91sam9261-udc"
+	       "atmel,at91sam9263-udc"
  - reg: Address and length of the register set for the device
  - interrupts: Should contain macb interrupt
  - clocks: Should reference the peripheral and the AHB clocks
-- 
2.1.0

