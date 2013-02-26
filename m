Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab3B0AkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:40:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144Ab3BZX6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: [ 145/150] USB: ehci-omap: Fix autoloading of module
Date: Tue, 26 Feb 2013 15:56:42 -0800
Message-Id: <20130226235539.599783910@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 04753523266629b1cd0518091da1658755787198 upstream.

The module alias should be "ehci-omap" and not
"omap-ehci" to match the platform device name.
The omap-ehci module should now autoload correctly.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -364,7 +364,7 @@ static const struct hc_driver ehci_omap_
 	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
 };
 
-MODULE_ALIAS("platform:omap-ehci");
+MODULE_ALIAS("platform:ehci-omap");
 MODULE_AUTHOR("Texas Instruments, Inc.");
 MODULE_AUTHOR("Felipe Balbi <felipe.balbi@nokia.com>");
 


