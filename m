Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3BCPTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:19:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34198 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab3BCOzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:36 -0500
Message-Id: <20130203144647.616094602@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Denis N Ladin <denladin@gmail.com>,
        Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 040/128] USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis N Ladin <denladin@gmail.com>

commit 036915a7a402753c05b8d0529f5fd08805ab46d0 upstream.

Adding support "PSC Scanning, Magellan 800i" in cdc-acm

Very simple, but very necessary.
Suitable for all versions of the kernel > 2.6

Signed-off-by: Denis N Ladin <denladin@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8d809a8..2d92cce 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1602,6 +1602,9 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0572, 0x1340), /* Conexant CX93010-2x UCMxx */
 	.driver_info = NO_UNION_NORMAL,
 	},
+	{ USB_DEVICE(0x05f9, 0x4002), /* PSC Scanning, Magellan 800i */
+	.driver_info = NO_UNION_NORMAL,
+	},
 	{ USB_DEVICE(0x1bbb, 0x0003), /* Alcatel OT-I650 */
 	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
 	},


