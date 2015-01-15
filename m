Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbbAOIwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:52:50 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:38655 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbbAOIwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:52:46 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: devicetree@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, linux-gpio@vger.kernel.org,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: gpio: fix bindings document
Date: Thu, 15 Jan 2015 17:52:40 +0900
Message-Id: <1421311960-4120-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Documentation/devicetree/bindings/gpio/gpio.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index b9bd1d6..f7a158d 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -69,7 +69,8 @@ GPIO pin number, and GPIO flags as accepted by the "qe_pio_e" gpio-controller.
 ----------------------------------
 
 A gpio-specifier should contain a flag indicating the GPIO polarity; active-
-high or active-low. If it does, the follow best practices should be followed:
+high or active-low. If it does, the following best practices should be
+followed:
 
 The gpio-specifier's polarity flag should represent the physical level at the
 GPIO controller that achieves (or represents, for inputs) a logically asserted
@@ -147,7 +148,7 @@ contains information structures as follows:
 	numeric-gpio-range ::=
 			<pinctrl-phandle> <gpio-base> <pinctrl-base> <count>
 	named-gpio-range ::= <pinctrl-phandle> <gpio-base> '<0 0>'
-	gpio-phandle : phandle to pin controller node.
+	pinctrl-phandle : phandle to pin controller node
 	gpio-base : Base GPIO ID in the GPIO controller
 	pinctrl-base : Base pinctrl pin ID in the pin controller
 	count : The number of GPIOs/pins in this range
-- 
1.9.1

