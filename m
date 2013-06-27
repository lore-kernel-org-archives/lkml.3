Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3F0JS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:18:58 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42458 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3F0JS5 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 27 Jun 2013 05:18:57 -0400
From: David Chang <dchang@suse.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jlee@suse.com,
        David Chang <dchang@suse.com>
Subject: [PATCH 1/2 net-next] usbnet: ax88179_178a: Correct a typo in description
Date: Thu, 27 Jun 2013 17:16:42 +0800
Message-Id: <1372324603-4556-1-git-send-email-dchang@suse.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct a typo in description of driver_info, it should be Gigabit

Signed-off-by: David Chang <dchang@suse.com>
---
 drivers/net/usb/ax88179_178a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index bd8758f..7ce243b 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1371,7 +1371,7 @@ static int ax88179_stop(struct usbnet *dev)
 }
 
 static const struct driver_info ax88179_info = {
-	.description = "ASIX AX88179 USB 3.0 Gigibit Ethernet",
+	.description = "ASIX AX88179 USB 3.0 Gigabit Ethernet",
 	.bind = ax88179_bind,
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
@@ -1384,7 +1384,7 @@ static const struct driver_info ax88179_info = {
 };
 
 static const struct driver_info ax88178a_info = {
-	.description = "ASIX AX88178A USB 2.0 Gigibit Ethernet",
+	.description = "ASIX AX88178A USB 2.0 Gigabit Ethernet",
 	.bind = ax88179_bind,
 	.unbind = ax88179_unbind,
 	.status = ax88179_status,
-- 
1.8.1.4

