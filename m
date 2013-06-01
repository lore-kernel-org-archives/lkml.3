Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab3FAJz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:55:56 -0400
Received: from www17.your-server.de ([213.133.104.17]:60626 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3FAJzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:55:48 -0400
Message-ID: <1370080542.29224.28.camel@localhost.localdomain>
Subject: [PATCH] netdev: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:55:42 +0200
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

diff -u -p a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1527,9 +1527,7 @@ int __init init_module(void)
 	if (debug >= 0)
 		i596_debug = debug;
 	dev_82596 = i82596_probe(-1);
-	if (IS_ERR(dev_82596))
-		return PTR_ERR(dev_82596);
-	return 0;
+	return PTR_RET(dev_82596);
 }
 
 void __exit cleanup_module(void)


