Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaEOKS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:18:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54500 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754828AbaEOKS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:18:56 -0400
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
Subject: [PATCH v6 05/17] Documentation: dt-bindings: update ehci-orion binding documentation
Date: Thu, 15 May 2014 12:17:30 +0200
Message-Id: <1400149062-32661-6-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

This commit updates the Device Tree binding documentation of
ehci-orion to take into account the fact that we can now optionally
pass a clock and a PHY reference.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 Documentation/devicetree/bindings/usb/ehci-orion.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/ehci-orion.txt b/Documentation/devicetree/bindings/usb/ehci-orion.txt
index 6bc09ec14c4d..17c3bc858b86 100644
--- a/Documentation/devicetree/bindings/usb/ehci-orion.txt
+++ b/Documentation/devicetree/bindings/usb/ehci-orion.txt
@@ -6,6 +6,11 @@ Required properties:
   region.
 - interrupts: The EHCI interrupt
 
+Optional properties:
+- clocks: reference to the clock
+- phys: reference to the USB PHY
+- phy-names: name of the USB PHY, should be "usb"
+
 Example:
 
 	ehci@50000 {
-- 
1.8.1.2

