Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaCMPNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:13:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55096 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCMPNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:13:12 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v4 1/5] doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue
Date: Thu, 13 Mar 2014 20:41:12 +0530
Message-ID: <1394723476-8580-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394723476-8580-1-git-send-email-george.cherian@ti.com>
References: <1394723476-8580-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the compatible "ti,am437x-dwc3" for dwc3 glue driver.

Signed-off-by: George Cherian <george.cherian@ti.com>
Acked-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 38b2fae..38d9bb8 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -44,7 +44,9 @@ Board specific device node entry
 };
 
 OMAP DWC3 GLUE
- - compatible : Should be "ti,dwc3"
+ - compatible : Should be
+	* "ti,dwc3" for OMAP5 and DRA7
+	* "ti,am437x-dwc3" for AM437x
  - ti,hwmods : Should be "usb_otg_ss"
  - reg : Address and length of the register set for the device.
  - interrupts : The irq number of this device that is used to interrupt the
-- 
1.8.3.1

