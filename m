Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689Ab3BNPIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:08:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36251 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760338Ab3BNPIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:08:21 -0500
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <sameo@linux.intel.com>,
        <tony@atomide.com>, <rogerq@ti.com>, <stable@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] USB: ehci-omap: Fix autoloading of module
Date: Thu, 14 Feb 2013 17:08:09 +0200
Message-ID: <1360854489-9972-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360854489-9972-1-git-send-email-rogerq@ti.com>
References: <1360854489-9972-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module alias should be "ehci-omap" and not
"omap-ehci" to match the platform device name.
The omap-ehci module should now autoload correctly.

CC: stable@vger.kernel.org

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-omap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index e9d9b09..99899e8 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -364,7 +364,7 @@ static const struct hc_driver ehci_omap_hc_driver = {
 	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
 };
 
-MODULE_ALIAS("platform:omap-ehci");
+MODULE_ALIAS("platform:ehci-omap");
 MODULE_AUTHOR("Texas Instruments, Inc.");
 MODULE_AUTHOR("Felipe Balbi <felipe.balbi@nokia.com>");
 
-- 
1.7.4.1

