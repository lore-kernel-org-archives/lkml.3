Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaGTORy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:17:54 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:62960 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbaGTORx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:17:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKALLOy1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBScvIxBROR4ZiEYBsDGQcBeFe4hsZAcWhDAFmyWUL4NGOy+BAw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org
Subject: [PATCH 01/30] dlci: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:16:09 +0200
Message-Id: <1405865801-18806-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405865801-18806-1-git-send-email-fabf@skynet.be>
References: <1405865801-18806-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wan/dlci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 19f7cb2..7ebfafe 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -255,7 +255,6 @@ static int dlci_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				return -EINVAL;
 
 			return dlci_config(dev, ifr->ifr_data, cmd == DLCI_GET_CONF);
-			break;
 
 		default: 
 			return -EOPNOTSUPP;
-- 
1.9.1

