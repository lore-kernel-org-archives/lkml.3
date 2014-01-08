Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaAHGR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:17:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51245 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaAHGQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:16:20 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <arnd@arndb.de>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
Date: Wed, 8 Jan 2014 11:45:38 +0530
Message-ID: <1389161742-10533-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389161742-10533-1-git-send-email-rogerq@ti.com>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap-usb-host driver expects the 60MHz functional clock
of the USB host module to be named as "init_60m_fclk".
Add this information in the DT binding document.

CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/mfd/omap-usb-host.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
index b381fa6..5635202 100644
--- a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
+++ b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
@@ -32,6 +32,10 @@ Optional properties:
 - single-ulpi-bypass: Must be present if the controller contains a single
   ULPI bypass control bit. e.g. OMAP3 silicon <= ES2.1
 
+- clocks: phandle to 60MHz functional clock to the USB Host module.
+
+- clock-names: must be "init_60m_fclk"
+
 Required properties if child node exists:
 
 - #address-cells: Must be 1
-- 
1.8.3.2

