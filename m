Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab3GQC0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:26:02 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48689 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751308Ab3GQC0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:26:00 -0400
Message-ID: <1374027959.1949.65.camel@joe-AO722>
Subject: [PATCH] xhci: Correct misplaced newlines
From: Joe Perches <joe@perches.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 16 Jul 2013 19:25:59 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging messages end in newlines, not have
them put in the middle of messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/host/xhci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2c49f00..87b5e65 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3075,8 +3075,8 @@ static u32 xhci_calculate_no_streams_bitmask(struct xhci_hcd *xhci,
 		/* Are streams already being freed for the endpoint? */
 		if (ep_state & EP_GETTING_NO_STREAMS) {
 			xhci_warn(xhci, "WARN Can't disable streams for "
-					"endpoint 0x%x\n, "
-					"streams are being disabled already.",
+					"endpoint 0x%x, "
+					"streams are being disabled already\n",
 					eps[i]->desc.bEndpointAddress);
 			return 0;
 		}
@@ -3084,8 +3084,8 @@ static u32 xhci_calculate_no_streams_bitmask(struct xhci_hcd *xhci,
 		if (!(ep_state & EP_HAS_STREAMS) &&
 				!(ep_state & EP_GETTING_STREAMS)) {
 			xhci_warn(xhci, "WARN Can't disable streams for "
-					"endpoint 0x%x\n, "
-					"streams are already disabled!",
+					"endpoint 0x%x, "
+					"streams are already disabled!\n",
 					eps[i]->desc.bEndpointAddress);
 			xhci_warn(xhci, "WARN xhci_free_streams() called "
 					"with non-streams endpoint\n");
@@ -4353,7 +4353,7 @@ static u16 xhci_get_timeout_no_hub_lpm(struct usb_device *udev,
 				state_name, sel);
 	else
 		dev_dbg(&udev->dev, "Device-initiated %s disabled "
-				"due to long PEL %llu\n ms",
+				"due to long PEL %llu ms\n",
 				state_name, pel);
 	return USB3_LPM_DISABLED;
 }


