Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030236AbaFTUmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:42:13 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:39884 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967247AbaFTUmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:42:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHAPSbpFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYQxLyOBAhg3iC4DFQHDVg2GSxeFYoZxgT9kHYQtBJhLgXmLMIIohgKDRDuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Emil Goode <emilgoode@gmail.com>, linux-usb@vger.kernel.org
Subject: [PATCH 2/2] drivers/net/usb/asix_devices.c: inline ax88772_unbind
Date: Fri, 20 Jun 2014 22:40:52 +0200
Message-Id: <1403296852-6376-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inline this one line function used in driver_info structure

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Emil Goode <emilgoode@gmail.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/usb/asix_devices.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 8a7582b..a41926a 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -497,7 +497,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	return 0;
 }
 
-static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
+static inline void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
 	kfree(dev->driver_priv);
 }
-- 
1.8.4.5

