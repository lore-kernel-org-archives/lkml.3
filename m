Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbaEFAOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:14:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41504 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757203AbaEFAOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:14:37 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 07/20] xhci-platform: Add a new controller using xhci: Armada 38x
Date: Tue,  6 May 2014 02:14:02 +0200
Message-Id: <1399335255-589-8-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the compatible string list with armada-380-xhci. It is used to
describe xhci controller which is in the Armada 38x SoCs.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 Documentation/devicetree/bindings/usb/usb-xhci.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-xhci.txt b/Documentation/devicetree/bindings/usb/usb-xhci.txt
index 90f8f607d125..a0915941fc25 100644
--- a/Documentation/devicetree/bindings/usb/usb-xhci.txt
+++ b/Documentation/devicetree/bindings/usb/usb-xhci.txt
@@ -1,7 +1,8 @@
 USB xHCI controllers
 
 Required properties:
-  - compatible: should be "generic-xhci" (deprecated: "xhci-platform").
+  - compatible: should be one of "generic-xhci",
+    "marvell,armada-380-xhci" (deprecated: "xhci-platform").
   - reg: should contain address and length of the standard XHCI
     register set for the device.
   - interrupts: one XHCI interrupt should be described here.
-- 
1.8.1.2

