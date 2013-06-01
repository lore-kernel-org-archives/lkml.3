Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab3FAJ7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:59:41 -0400
Received: from www17.your-server.de ([213.133.104.17]:33167 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561Ab3FAJ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:59:30 -0400
Message-ID: <1370080765.29224.38.camel@localhost.localdomain>
Subject: [PATCH] usb: gadget: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:59:25 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
--- a/drivers/usb/gadget/f_subset.c
+++ b/drivers/usb/gadget/f_subset.c
@@ -274,7 +274,7 @@ static int geth_set_alt(struct usb_funct
 	}
 
 	net = gether_connect(&geth->port);
-	return IS_ERR(net) ? PTR_ERR(net) : 0;
+	return PTR_RET(net);
 }
 
 static void geth_disable(struct usb_function *f)


