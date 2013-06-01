Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab3FAJ7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:59:22 -0400
Received: from www17.your-server.de ([213.133.104.17]:33049 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3FAJ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:59:16 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Jun 2013 05:59:16 EDT
Message-ID: <1370080751.29224.37.camel@localhost.localdomain>
Subject: [PATCH] netdev: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:59:11 +0200
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

diff -u -p a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/smsc/smc9194.c
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -1571,9 +1571,7 @@ int __init init_module(void)
 
 	/* copy the parameters from insmod into the device structure */
 	devSMC9194 = smc_init(-1);
-	if (IS_ERR(devSMC9194))
-		return PTR_ERR(devSMC9194);
-	return 0;
+	return PTR_RET(devSMC9194);
 }
 
 void __exit cleanup_module(void)


