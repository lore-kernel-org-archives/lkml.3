Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab3CLKsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:48:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51553 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab3CLKpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:45:17 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 06/12] USB: ehci-omap: Select NOP USB transceiver driver
Date: Tue, 12 Mar 2013 12:44:44 +0200
Message-ID: <1363085090-24676-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-1-git-send-email-rogerq@ti.com>
References: <1363085090-24676-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In PHY mode we need to have the nop-usb-xceiv transceiver
driver to operate, so select it in Kconfig.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 62f4e9a..2f68221 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -157,6 +157,7 @@ config USB_EHCI_MXC
 config USB_EHCI_HCD_OMAP
 	tristate "EHCI support for OMAP3 and later chips"
 	depends on USB_EHCI_HCD && ARCH_OMAP
+	select NOP_USB_XCEIV
 	default y
 	---help---
 	  Enables support for the on-chip EHCI controller on
-- 
1.7.4.1

