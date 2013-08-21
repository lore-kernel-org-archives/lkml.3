Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3HUPUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:20:09 -0400
Received: from smtp1-1.goneo.de ([212.90.139.81]:52127 "EHLO smtp1-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab3HUPUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:20:07 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.828
To: rob.herring@calxeda.com, Pawel Moll <Pawel.Moll@arm.com>,
        mark.rutland@arm.com, Stephen Warren <swarren@wwwdotorg.org>,
        ian.campbell@citrix.com, rob@landley.net,
        Grant Likely <grant.likely@linaro.org>, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] of: add vendor prefix for Microchip Technology Inc
From: Lars Poeschel <poeschel@lemonage.de>
Date: Wed, 21 Aug 2013 17:19:57 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308211719.57748.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch to add Microchip Technology Inc. to the list
of devicetree vendor prefixes, as it is already used in
Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt 
b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 366ce9b..b3b2ad7 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -36,6 +36,7 @@ linux	Linux-specific binding
 lsi	LSI Corp. (LSI Logic)
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
+mcp	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
 national	National Semiconductor
 nintendo	Nintendo
-- 
1.7.10.4

