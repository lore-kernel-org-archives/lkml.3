Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbbA0EqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:46:25 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:49876 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbbA0EqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:46:22 -0500
From: Rob Herring <robh@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH 2/3] dt/bindings: gpio: add compatible string for marvell,pxa1928-gpio
Date: Mon, 26 Jan 2015 22:46:05 -0600
Message-Id: <1422333966-18338-3-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422333966-18338-1-git-send-email-robh@kernel.org>
References: <1422333966-18338-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new compatible string for PXA1928 GPIO controller. The IP block is
same as prior chips with a 6th bank added.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/gpio/mrvl-gpio.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/mrvl-gpio.txt b/Documentation/devicetree/bindings/gpio/mrvl-gpio.txt
index b2afdb2..67a2e4e 100644
--- a/Documentation/devicetree/bindings/gpio/mrvl-gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/mrvl-gpio.txt
@@ -3,8 +3,8 @@
 Required properties:
 - compatible : Should be "intel,pxa25x-gpio", "intel,pxa26x-gpio",
 		"intel,pxa27x-gpio", "intel,pxa3xx-gpio",
-		"marvell,pxa93x-gpio", "marvell,mmp-gpio" or
-		"marvell,mmp2-gpio".
+		"marvell,pxa93x-gpio", "marvell,mmp-gpio",
+		"marvell,mmp2-gpio" or marvell,pxa1928-gpio.
 - reg : Address and length of the register set for the device
 - interrupts : Should be the port interrupt shared by all gpio pins.
   There're three gpio interrupts in arch-pxa, and they're gpio0,
-- 
2.1.0

