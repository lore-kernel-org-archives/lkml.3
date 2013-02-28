Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab3B1OsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:48:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42113 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab3B1Orz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 052/139] USB: ehci-omap: Fix autoloading of module
Date: Thu, 28 Feb 2013 14:43:22 +0000
Message-Id: <1362062689-2567-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 04753523266629b1cd0518091da1658755787198 upstream.

The module alias should be "ehci-omap" and not
"omap-ehci" to match the platform device name.
The omap-ehci module should now autoload correctly.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/ehci-omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 30f8b24..5d407fd 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -365,7 +365,7 @@ static const struct hc_driver ehci_omap_hc_driver = {
 	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
 };
 
-MODULE_ALIAS("platform:omap-ehci");
+MODULE_ALIAS("platform:ehci-omap");
 MODULE_AUTHOR("Texas Instruments, Inc.");
 MODULE_AUTHOR("Felipe Balbi <felipe.balbi@nokia.com>");
 
-- 
1.8.1.2

