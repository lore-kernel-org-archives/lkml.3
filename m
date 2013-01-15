Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab3AOXhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:37:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:46452 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933433Ab3AOWvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:51:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Denis N Ladin <denladin@gmail.com>, Oliver Neukum <oneukum@suse.de>
Subject: [ 096/171] USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"
Date: Tue, 15 Jan 2013 14:44:21 -0800
Message-Id: <20130115224320.294738407@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis N Ladin <denladin@gmail.com>

commit 036915a7a402753c05b8d0529f5fd08805ab46d0 upstream.

Adding support "PSC Scanning, Magellan 800i" in cdc-acm

Very simple, but very necessary.
Suitable for all versions of the kernel > 2.6

Signed-off-by: Denis N Ladin <denladin@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1602,6 +1602,9 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x0572, 0x1340), /* Conexant CX93010-2x UCMxx */
 	.driver_info = NO_UNION_NORMAL,
 	},
+	{ USB_DEVICE(0x05f9, 0x4002), /* PSC Scanning, Magellan 800i */
+	.driver_info = NO_UNION_NORMAL,
+	},
 	{ USB_DEVICE(0x1bbb, 0x0003), /* Alcatel OT-I650 */
 	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
 	},


