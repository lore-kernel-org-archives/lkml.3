Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab3IBPo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:44:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44504 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760Ab3IBPoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:44:25 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rogerq@ti.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] Documentation: dt bindings: move ..usb/usb-phy.txt to ..phy/omap-phy.txt
Date: Mon, 2 Sep 2013 21:13:08 +0530
Message-ID: <1378136591-7463-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378136591-7463-1-git-send-email-kishon@ti.com>
References: <1378136591-7463-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now we have a separate folder for phy, move the PHY dt binding
documentation of OMAP to that folder.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/{usb/usb-phy.txt => phy/omap-phy.txt}        |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 rename Documentation/devicetree/bindings/{usb/usb-phy.txt => phy/omap-phy.txt} (96%)

diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/phy/omap-phy.txt
similarity index 96%
rename from Documentation/devicetree/bindings/usb/usb-phy.txt
rename to Documentation/devicetree/bindings/phy/omap-phy.txt
index 36bdb17..2c485ee 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/phy/omap-phy.txt
@@ -1,4 +1,4 @@
-USB PHY
+OMAP PHY: DT DOCUMENTATION FOR PHYs in OMAP PLATFORM
 
 OMAP USB2 PHY
 
-- 
1.7.10.4

