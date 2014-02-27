Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaB0OUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:20:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37812 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaB0OTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:19:21 -0500
From: Roger Quadros <rogerq@ti.com>
To: <lee.jones@linaro.org>, <tony@atomide.com>, <bcousson@baylibre.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v9 6/9] mfd: omap-usb-tll: Update DT clock binding information
Date: Thu, 27 Feb 2014 16:18:28 +0200
Message-ID: <1393510711-4697-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393510711-4697-1-git-send-email-rogerq@ti.com>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap-usb-tll driver needs one clock for each TLL channel.
Add this information to the DT binding document.

CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/mfd/omap-usb-tll.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt b/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
index 62fe697..c58d704 100644
--- a/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
+++ b/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
@@ -7,6 +7,16 @@ Required properties:
 - interrupts : should contain the TLL module's interrupt
 - ti,hwmod : must contain "usb_tll_hs"
 
+Optional properties:
+
+- clocks: a list of phandles and clock-specifier pairs, one for each entry in
+  clock-names.
+
+- clock-names: should include:
+  * "usb_tll_hs_usb_ch0_clk" - USB TLL channel 0 clock
+  * "usb_tll_hs_usb_ch1_clk" - USB TLL channel 1 clock
+  * "usb_tll_hs_usb_ch2_clk" - USB TLL channel 2 clock
+
 Example:
 
 	usbhstll: usbhstll@4a062000 {
-- 
1.8.3.2

