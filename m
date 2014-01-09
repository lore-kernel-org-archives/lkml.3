Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaAIK42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:56:28 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:27522 "EHLO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbaAIKzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:55:24 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH 5/6] usb: gadget: gr_udc: Add ep.maxpacket_limit to debugfs information
Date: Thu,  9 Jan 2014 11:54:17 +0100
Message-Id: <1389264858-32664-6-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
References: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information on ep.maxpacket_limit for each endpoint in the debugfs
information.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/usb/gadget/gr_udc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index 8df35fc..55757fc 100644
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

