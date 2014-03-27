Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbaC0PUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:20:37 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:30355 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756045AbaC0PRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:17:11 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 5/7] usb: gadget: gr_udc: Add ep.maxpacket_limit to debugfs information
Date: Thu, 27 Mar 2014 16:15:57 +0100
Message-Id: <1395933359-7109-6-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395933359-7109-1-git-send-email-andreas@gaisler.com>
References: <1395933359-7109-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information on ep.maxpacket_limit for each endpoint in the debugfs
information.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
Differences since v1: none

 drivers/usb/gadget/gr_udc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index 0f3a953..253e608 100644
--- a/drivers/usb/gadget/gr_udc.c
+++ b/drivers/usb/gadget/gr_udc.c
@@ -143,6 +143,7 @@ static void gr_seq_ep_show(struct seq_file *seq, struct gr_ep *ep)
 	seq_printf(seq, "  wedged = %d\n", ep->wedged);
 	seq_printf(seq, "  callback = %d\n", ep->callback);
 	seq_printf(seq, "  maxpacket = %d\n", ep->ep.maxpacket);
+	seq_printf(seq, "  maxpacket_limit = %d\n", ep->ep.maxpacket_limit);
 	seq_printf(seq, "  bytes_per_buffer = %d\n", ep->bytes_per_buffer);
 	if (mode == 1 || mode == 3)
 		seq_printf(seq, "  nt = %d\n",
-- 
1.7.10.4

