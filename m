Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbbANQYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:24:24 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45299 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753978AbbANQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:22:20 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 07/12] usb: gadget: at91_udc: Document DT clocks and clock-names property
Date: Wed, 14 Jan 2015 17:21:59 +0100
Message-Id: <1421252524-24452-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

The at91_udc driver request 2 clocks, and thus need them to be defined in
the device tree.
Document the clocks and clock-names properties so that everybody use the
correct names.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 Documentation/devicetree/bindings/usb/atmel-usb.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/atmel-usb.txt b/Documentation/devicetree/bindings/usb/atmel-usb.txt
index bc2222ca3f2a..6007231e0adc 100644
--- a/Documentation/devicetree/bindings/usb/atmel-usb.txt
+++ b/Documentation/devicetree/bindings/usb/atmel-usb.txt
@@ -36,6 +36,10 @@ Required properties:
  - compatible: Should be "atmel,at91rm9200-udc"
  - reg: Address and length of the register set for the device
  - interrupts: Should contain macb interrupt
+ - clocks: Should reference the peripheral and the AHB clocks
+ - clock-names: Should contains two strings
+		"pclk" for the peripheral clock
+		"hclk" for the AHB clock
 
 Optional properties:
  - atmel,vbus-gpio: If present, specifies a gpio that needs to be
-- 
2.1.0

